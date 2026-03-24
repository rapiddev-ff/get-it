import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(Supabase.instance.client);
});

class OrderRepository {
  final SupabaseClient _client;

  OrderRepository(this._client);

  /// Fetches seller orders with buyer info and product details.
  /// [statusFilter] - 'to_ship' (paid only) or 'shipped' (shipped + delivered).
  Future<List<Map<String, dynamic>>> getSellerOrders({
    required String sellerId,
    String? statusFilter,
    int? limit,
  }) async {
    final baseQuery = _client
        .from('orders')
        .select('''
          *,
          order_items(product_id, product_title, product_price, quantity, products(main_image_url)),
          buyer:users!orders_buyer_id_fkey(id, username, photo_url)
        ''')
        .eq('seller_id', sellerId)
        .isFilter('deleted_at', null)
        .isFilter('cancelled_at', null);

    List<Map<String, dynamic>> response;

    if (statusFilter == 'to_ship') {
      if (limit != null) {
        response = await baseQuery
            .inFilter('status', ['sale_pending', 'paid'])
            .order('created_at', ascending: false)
            .limit(limit);
      } else {
        response = await baseQuery
            .inFilter('status', ['sale_pending', 'paid']).order('created_at',
                ascending: false);
      }
    } else if (statusFilter == 'shipped') {
      if (limit != null) {
        response = await baseQuery
            .inFilter('status', ['shipped', 'delivered'])
            .order('created_at', ascending: false)
            .limit(limit);
      } else {
        response = await baseQuery
            .inFilter('status', ['shipped', 'delivered']).order('created_at',
                ascending: false);
      }
    } else {
      if (limit != null) {
        response =
            await baseQuery.order('created_at', ascending: false).limit(limit);
      } else {
        response = await baseQuery.order('created_at', ascending: false);
      }
    }

    return List<Map<String, dynamic>>.from(response);
  }

  /// Returns counts: {to_ship: int, shipped: int}
  Future<Map<String, int>> getSellerOrderCounts({
    required String sellerId,
  }) async {
    final results = await _client
        .from('orders')
        .select('status')
        .eq('seller_id', sellerId)
        .isFilter('deleted_at', null)
        .isFilter('cancelled_at', null)
        .inFilter('status', ['sale_pending', 'paid', 'shipped', 'delivered']);

    final list = List<Map<String, dynamic>>.from(results);

    int toShip = 0;
    int shipped = 0;

    for (final row in list) {
      final status = row['status'] as String?;
      if (status == 'sale_pending' || status == 'paid') {
        toShip++;
      } else if (status == 'shipped' || status == 'delivered') {
        shipped++;
      }
    }

    return {'to_ship': toShip, 'shipped': shipped};
  }

  /// Marks an order as shipped with tracking info.
  /// Returns null on success, or an error message on failure.
  Future<String?> markOrderShipped({
    required String orderId,
    required String sellerId,
    String? trackingNumber,
    String? shippingCarrier,
  }) async {
    try {
      final orderData = await _client
          .from('orders')
          .select('status, total_amount')
          .eq('id', orderId)
          .eq('seller_id', sellerId)
          .single();

      final status = orderData['status'] as String?;
      if (status == 'sale_pending') {
        return 'Order is still pending confirmation. Please wait for the 5-minute buyer cancellation window to expire.';
      }
      if (status != 'paid') {
        return 'Order is not in a shippable state';
      }

      final totalAmount =
          (orderData['total_amount'] as num?)?.toDouble() ?? 0.0;

      if (totalAmount > 15.0 &&
          (trackingNumber == null || trackingNumber.trim().isEmpty)) {
        return 'Tracking number is required for orders over \$15.00';
      }

      final updateData = <String, dynamic>{
        'status': 'shipped',
        'shipped_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

      if (trackingNumber != null && trackingNumber.trim().isNotEmpty) {
        updateData['tracking_number'] = trackingNumber.trim();
      }

      final carrier = shippingCarrier?.trim().isNotEmpty == true
          ? shippingCarrier!.trim()
          : (trackingNumber != null
              ? _detectCarrier(trackingNumber.trim())
              : null);
      if (carrier != null) {
        updateData['shipping_carrier'] = carrier;
      }

      await _client
          .from('orders')
          .update(updateData)
          .eq('id', orderId)
          .eq('seller_id', sellerId);

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Updates tracking number for an already-shipped order.
  Future<String?> updateTrackingNumber({
    required String orderId,
    required String sellerId,
    required String trackingNumber,
    String? shippingCarrier,
  }) async {
    try {
      final orderData = await _client
          .from('orders')
          .select('status')
          .eq('id', orderId)
          .eq('seller_id', sellerId)
          .single();

      final status = orderData['status'] as String?;
      if (status != 'shipped') {
        return 'Tracking can only be edited for shipped orders';
      }

      final updateData = <String, dynamic>{
        'tracking_number': trackingNumber.trim(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

      final carrier = shippingCarrier?.trim().isNotEmpty == true
          ? shippingCarrier!.trim()
          : _detectCarrier(trackingNumber.trim());
      if (carrier != null) {
        updateData['shipping_carrier'] = carrier;
      }

      await _client
          .from('orders')
          .update(updateData)
          .eq('id', orderId)
          .eq('seller_id', sellerId);

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Manually marks a shipped order as delivered.
  Future<String?> markOrderDelivered({
    required String orderId,
    required String sellerId,
  }) async {
    try {
      final orderData = await _client
          .from('orders')
          .select('status')
          .eq('id', orderId)
          .eq('seller_id', sellerId)
          .single();

      final status = orderData['status'] as String?;
      if (status != 'shipped') {
        return 'Only shipped orders can be marked as delivered';
      }

      final now = DateTime.now().toUtc().toIso8601String();

      await _client.from('orders').update({
        'status': 'delivered',
        'delivered_at': now,
        'updated_at': now,
      }).eq('id', orderId).eq('seller_id', sellerId);

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Buyer-initiated cancellation (within 5-minute window).
  Future<String?> cancelOrder(String orderId) async {
    try {
      final orderData = await _client
          .from('orders')
          .select('status, created_at')
          .eq('id', orderId)
          .single();

      final status = orderData['status'] as String?;
      if (status != 'sale_pending') {
        return 'Order can only be cancelled within 5 minutes of purchase';
      }

      final response = await _client.functions.invoke(
        'stripe-create-refund',
        body: {
          'order_id': orderId,
          'reason': 'requested_by_customer',
        },
      );

      if (response.status != 200) {
        final data = response.data;
        if (data is Map && data['error'] != null) {
          return data['error'].toString();
        }
        return 'Failed to cancel order';
      }

      return null;
    } on FunctionException catch (e) {
      if (e.details != null && e.details is Map) {
        final details = e.details as Map;
        if (details['error'] != null) return details['error'].toString();
        if (details['message'] != null) return details['message'].toString();
      }
      return e.reasonPhrase ?? 'Error: ${e.status}';
    } catch (e) {
      return e.toString();
    }
  }

  /// Seller-initiated order cancellation with reason.
  Future<String?> cancelOrderSeller({
    required String orderId,
    required String sellerId,
    required String reason,
    String? reasonText,
  }) async {
    try {
      const validReasons = ['item_sold_out', 'double_sold', 'other'];
      if (!validReasons.contains(reason)) {
        return 'Invalid cancellation reason';
      }

      if (reason == 'other' &&
          (reasonText == null || reasonText.trim().isEmpty)) {
        return 'Please provide a reason for cancellation';
      }

      final orderData = await _client
          .from('orders')
          .select('status, order_items(product_id)')
          .eq('id', orderId)
          .eq('seller_id', sellerId)
          .single();

      final status = orderData['status'] as String?;
      if (status != 'paid') {
        return 'Order can only be cancelled before shipping';
      }

      await _client.from('orders').update({
        'status': 'cancelled',
        'cancelled_at': DateTime.now().toUtc().toIso8601String(),
        'updated_at': DateTime.now().toUtc().toIso8601String(),
        'seller_cancel_reason': reason,
        'seller_cancel_reason_text': reasonText?.trim(),
      }).eq('id', orderId).eq('seller_id', sellerId);

      try {
        await _client.functions.invoke(
          'stripe-create-refund',
          body: {
            'order_id': orderId,
            'reason': 'requested_by_seller',
          },
        );
      } catch (_) {}

      final items = orderData['order_items'];
      if (items is List) {
        for (final item in items) {
          final productId = item['product_id']?.toString();
          if (productId != null) {
            await _client.from('products').update({
              'deleted_at': DateTime.now().toUtc().toIso8601String(),
              'updated_at': DateTime.now().toUtc().toIso8601String(),
            }).eq('id', productId);
          }
        }
      }

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  /// Fetches buyer orders with seller info and product details.
  /// [statusFilter] - 'active' (sale_pending/paid/shipped), 'delivered', 'cancelled', or null for all.
  Future<List<Map<String, dynamic>>> getBuyerOrders({
    required String buyerId,
    String? statusFilter,
    int? limit,
  }) async {
    var query = _client
        .from('orders')
        .select('''
          *,
          order_items(product_id, product_title, product_price, quantity, products(main_image_url)),
          seller:users!orders_seller_id_fkey(id, username, photo_url)
        ''')
        .eq('buyer_id', buyerId)
        .isFilter('deleted_at', null);

    if (statusFilter == 'active') {
      query = query.inFilter('status', ['sale_pending', 'paid', 'shipped']);
    } else if (statusFilter == 'delivered') {
      query = query.eq('status', 'delivered');
    } else if (statusFilter == 'cancelled') {
      query = query.inFilter('status', ['cancelled', 'refunded']);
    }

    final ordered = query.order('created_at', ascending: false);

    List<Map<String, dynamic>> response;
    if (limit != null) {
      response = await ordered.limit(limit);
    } else {
      response = await ordered;
    }

    return List<Map<String, dynamic>>.from(response);
  }

  /// Returns buyer order counts by status group.
  Future<Map<String, int>> getBuyerOrderCounts({
    required String buyerId,
  }) async {
    final results = await _client
        .from('orders')
        .select('status')
        .eq('buyer_id', buyerId)
        .isFilter('deleted_at', null);

    final list = List<Map<String, dynamic>>.from(results);

    int active = 0;
    int delivered = 0;
    int cancelled = 0;

    for (final row in list) {
      final status = row['status'] as String?;
      if (status == 'sale_pending' || status == 'paid' || status == 'shipped') {
        active++;
      } else if (status == 'delivered') {
        delivered++;
      } else if (status == 'cancelled' || status == 'refunded') {
        cancelled++;
      }
    }

    return {'active': active, 'delivered': delivered, 'cancelled': cancelled};
  }

  /// Fetches a single order with full details for buyer order detail page.
  Future<Map<String, dynamic>?> getBuyerOrderDetail({
    required String orderId,
    required String buyerId,
  }) async {
    try {
      final result = await _client.from('orders').select('''
            *,
            order_items(product_id, product_title, product_price, quantity, products(main_image_url)),
            seller:users!orders_seller_id_fkey(id, username, photo_url)
          ''').eq('id', orderId).eq('buyer_id', buyerId).single();
      return result;
    } catch (_) {
      return null;
    }
  }

  /// Detects shipping carrier from tracking number format.
  static String? _detectCarrier(String trackingNumber) {
    final tn = trackingNumber.replaceAll(RegExp(r'\s'), '').toUpperCase();

    if (RegExp(r'^1Z[A-Z0-9]{16}$').hasMatch(tn)) return 'ups';

    if (RegExp(r'^\d{12}$').hasMatch(tn) ||
        RegExp(r'^\d{15}$').hasMatch(tn) ||
        RegExp(r'^\d{20}$').hasMatch(tn) ||
        RegExp(r'^\d{22}$').hasMatch(tn)) {
      return 'fedex';
    }

    if (RegExp(r'^\d{20,22}$').hasMatch(tn)) return 'usps';
    if (RegExp(r'^(94|93|92|91|90)\d{18,20}$').hasMatch(tn)) return 'usps';
    if (RegExp(r'^[A-Z]{2}\d{9}US$', caseSensitive: false).hasMatch(tn)) {
      return 'usps';
    }

    return null;
  }
}

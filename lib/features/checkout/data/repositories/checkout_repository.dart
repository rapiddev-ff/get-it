import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/features/checkout/domain/models/checkout_totals_model.dart';
import '/features/checkout/domain/models/checkout_order_result_model.dart';

final checkoutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  return CheckoutRepository(Supabase.instance.client);
});

class CheckoutRepository {
  final SupabaseClient _client;

  CheckoutRepository(this._client);

  /// Calculates checkout totals (price, shipping, tax, fees) for a product.
  Future<CheckoutTotals?> calculateTotals(
    String productId,
    int quantity,
  ) async {
    try {
      final response = await _client.rpc(
        'calculate_checkout_totals',
        params: {
          'p_product_id': productId,
          'p_quantity': quantity,
        },
      );

      if (response == null) return null;

      final json = (response is Map<String, dynamic>)
          ? response
          : (response is List && response.isNotEmpty)
              ? response[0] as Map<String, dynamic>
              : null;

      if (json == null || json['success'] != true) return null;

      return CheckoutTotals(
        effectivePrice: _toDouble(json['effective_price']),
        originalPrice: _toDouble(json['original_price']),
        isFlashSale: json['is_flash_sale'] == true,
        subtotal: _toDouble(json['subtotal']),
        shippingCost: _toDouble(json['shipping_cost']),
        freeShipping: json['free_shipping'] == true,
        taxAmount: _toDouble(json['tax_amount']),
        platformFee: _toDouble(json['platform_fee']),
        totalAmount: _toDouble(json['total_amount']),
        availableQuantity: _toInt(json['available_quantity']),
      );
    } catch (e) {
      return null;
    }
  }

  /// Calculates tax for an order.
  Future<double> calculateOrderTax(
    double subtotal,
    double shippingCost,
    String? stateCode,
  ) async {
    try {
      final response = await _client.rpc(
        'calculate_order_tax',
        params: {
          'p_subtotal': subtotal,
          'p_shipping_cost': shippingCost,
          'p_state_code': stateCode,
        },
      );

      if (response is num) return response.toDouble();
      if (response is Map && response['tax_amount'] != null) {
        return _toDouble(response['tax_amount']);
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  /// Creates a checkout order via RPC.
  Future<CheckoutOrderResult?> createOrder(
    String productId,
    int quantity,
    String? shippingAddressId,
    String? paymentMethodId,
    String? buyerNotes,
    String? shortlistId,
  ) async {
    try {
      final response = await _client.rpc(
        'create_checkout_order',
        params: {
          'p_product_id': productId,
          'p_quantity': quantity,
          'p_shipping_address_id':
              (shippingAddressId != null && shippingAddressId.isNotEmpty)
                  ? shippingAddressId
                  : null,
          'p_payment_method_id':
              (paymentMethodId != null && paymentMethodId.isNotEmpty)
                  ? paymentMethodId
                  : null,
          'p_buyer_notes':
              (buyerNotes != null && buyerNotes.isNotEmpty) ? buyerNotes : null,
          'p_shortlist_id':
              (shortlistId != null && shortlistId.isNotEmpty)
                  ? shortlistId
                  : null,
        },
      );

      if (response == null) return null;

      final json = response as Map<String, dynamic>;
      if (json['success'] != true) {
        debugPrint('[createOrder] RPC returned success=false: $json');
        return null;
      }

      return CheckoutOrderResult(
        success: true,
        orderId: json['order_id'] ?? '',
        orderNumber: json['order_number'] ?? '',
        subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
        shippingCost: (json['shipping_cost'] as num?)?.toDouble() ?? 0,
        taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0,
        platformFee: (json['platform_fee'] as num?)?.toDouble() ?? 0,
        totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
        sellerId: json['seller_id'] ?? '',
        productTitle: json['product_title'] ?? '',
      );
    } catch (e) {
      debugPrint('[createOrder] Error: $e');
      return null;
    }
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }
}

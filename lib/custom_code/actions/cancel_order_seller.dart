import 'package:supabase_flutter/supabase_flutter.dart';

/// Seller-initiated order cancellation.
/// Allowed only for orders in 'paid' status (before shipping).
/// Requires a reason: 'item_sold_out', 'double_sold', or 'other'.
/// Returns null on success, or an error message string on failure.
Future<String?> cancelOrderSeller({
  required String orderId,
  required String reason,
  String? reasonText,
}) async {
  final client = Supabase.instance.client;

  try {
    // Validate reason
    const validReasons = ['item_sold_out', 'double_sold', 'other'];
    if (!validReasons.contains(reason)) {
      return 'Invalid cancellation reason';
    }

    if (reason == 'other' &&
        (reasonText == null || reasonText.trim().isEmpty)) {
      return 'Please provide a reason for cancellation';
    }

    // Verify order is in cancellable state
    final orderData = await client
        .from('orders')
        .select('status, order_items(product_id)')
        .eq('id', orderId)
        .single();

    final status = orderData['status'] as String?;
    if (status != 'paid') {
      return 'Order can only be cancelled before shipping';
    }

    // Cancel the order + set reason (validate_order_update trigger allows paid->cancelled for sellers)
    await client.from('orders').update({
      'status': 'cancelled',
      'cancelled_at': DateTime.now().toUtc().toIso8601String(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
      'seller_cancel_reason': reason,
      'seller_cancel_reason_text': reasonText?.trim(),
    }).eq('id', orderId);

    // Issue refund via edge function
    try {
      await client.functions.invoke(
        'stripe-create-refund',
        body: {
          'order_id': orderId,
          'reason': 'requested_by_seller',
        },
      );
    } catch (_) {
      // Refund failure is non-blocking — order is already cancelled
    }

    // Soft-delete the product from seller's inventory
    final items = orderData['order_items'];
    if (items is List) {
      for (final item in items) {
        final productId = item['product_id']?.toString();
        if (productId != null) {
          await client.from('products').update({
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

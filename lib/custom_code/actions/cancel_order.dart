import 'package:supabase_flutter/supabase_flutter.dart';

/// Cancel an order within the 5-minute cancellation window (buyer-initiated).
/// Only works for orders in 'sale_pending' status.
/// Returns null on success, or an error message string on failure.
Future<String?> cancelOrder(String orderId) async {
  final supabase = Supabase.instance.client;

  try {
    // Verify order is in cancellable state (sale_pending = within 5 min window)
    final orderData = await supabase
        .from('orders')
        .select('status, created_at')
        .eq('id', orderId)
        .single();

    final status = orderData['status'] as String?;
    if (status != 'sale_pending') {
      return 'Order can only be cancelled within 5 minutes of purchase';
    }

    final response = await supabase.functions.invoke(
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
      if (details['error'] != null) {
        return details['error'].toString();
      }
      if (details['message'] != null) {
        return details['message'].toString();
      }
    }
    return e.reasonPhrase ?? 'Error: ${e.status}';
  } catch (e) {
    return e.toString();
  }
}

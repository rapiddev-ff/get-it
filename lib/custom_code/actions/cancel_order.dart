import 'package:supabase_flutter/supabase_flutter.dart';

/// Cancel an order within the 5-minute cancellation window.
/// Returns null on success, or an error message string on failure.
Future<String?> cancelOrder(String orderId) async {
  final supabase = Supabase.instance.client;

  try {
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

import '/backend/supabase/supabase.dart';

/// Manually marks a shipped order as delivered.
/// Primarily for non-tracked items (≤ $15) that won't auto-transition via carrier tracking.
/// Returns null on success, or an error message string on failure.
Future<String?> markOrderDelivered({
  required String orderId,
}) async {
  final client = SupaFlow.client;

  try {
    // Verify order is in shipped state
    final orderData = await client
        .from('orders')
        .select('status')
        .eq('id', orderId)
        .single();

    final status = orderData['status'] as String?;
    if (status != 'shipped') {
      return 'Only shipped orders can be marked as delivered';
    }

    final now = DateTime.now().toUtc().toIso8601String();

    await client.from('orders').update({
      'status': 'delivered',
      'delivered_at': now,
      'updated_at': now,
    }).eq('id', orderId);

    return null;
  } catch (e) {
    return e.toString();
  }
}

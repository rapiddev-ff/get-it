import '/features/home/data/repositories/order_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _repository = OrderRepository(Supabase.instance.client);

/// Manually marks a shipped order as delivered.
/// Returns null on success, or an error message string on failure.
Future<String?> markOrderDelivered({
  required String orderId,
  required String sellerId,
}) async {
  return _repository.markOrderDelivered(orderId: orderId, sellerId: sellerId);
}

import '/features/home/data/repositories/order_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _repository = OrderRepository(Supabase.instance.client);

/// Cancel an order within the 5-minute cancellation window (buyer-initiated).
/// Returns null on success, or an error message string on failure.
Future<String?> cancelOrder(String orderId) async {
  return _repository.cancelOrder(orderId);
}

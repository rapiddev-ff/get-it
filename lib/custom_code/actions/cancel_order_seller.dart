import '/features/home/data/repositories/order_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _repository = OrderRepository(Supabase.instance.client);

/// Seller-initiated order cancellation.
/// Returns null on success, or an error message string on failure.
Future<String?> cancelOrderSeller({
  required String orderId,
  required String sellerId,
  required String reason,
  String? reasonText,
}) async {
  return _repository.cancelOrderSeller(
    orderId: orderId,
    sellerId: sellerId,
    reason: reason,
    reasonText: reasonText,
  );
}

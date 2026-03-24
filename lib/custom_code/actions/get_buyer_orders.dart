import '/features/home/data/repositories/order_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _repository = OrderRepository(Supabase.instance.client);

/// Fetches buyer orders with seller info and product details.
/// [statusFilter] - 'active', 'delivered', 'cancelled', or null for all.
Future<List<Map<String, dynamic>>> getBuyerOrders({
  required String buyerId,
  String? statusFilter,
  int? limit,
}) async {
  return _repository.getBuyerOrders(
    buyerId: buyerId,
    statusFilter: statusFilter,
    limit: limit,
  );
}

/// Returns buyer order counts: {active: int, delivered: int, cancelled: int}
Future<Map<String, int>> getBuyerOrderCounts({
  required String buyerId,
}) async {
  return _repository.getBuyerOrderCounts(buyerId: buyerId);
}

/// Fetches a single order with full details for buyer order detail page.
Future<Map<String, dynamic>?> getBuyerOrderDetail({
  required String orderId,
  required String buyerId,
}) async {
  return _repository.getBuyerOrderDetail(orderId: orderId, buyerId: buyerId);
}

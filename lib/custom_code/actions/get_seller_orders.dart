import '/features/home/data/repositories/order_repository.dart';
import '/features/auth/data/supabase_auth/auth_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _repository = OrderRepository(Supabase.instance.client);

/// Fetches seller orders with buyer info and product details.
/// [statusFilter] - 'to_ship' (paid only) or 'shipped' (shipped + delivered).
/// [limit] - max number of orders to return (null = all).
Future<List<Map<String, dynamic>>> getSellerOrders({
  String? statusFilter,
  int? limit,
}) async {
  return _repository.getSellerOrders(
    sellerId: currentUserUid,
    statusFilter: statusFilter,
    limit: limit,
  );
}

/// Returns counts: {to_ship: int, shipped: int}
Future<Map<String, int>> getSellerOrderCounts() async {
  return _repository.getSellerOrderCounts(sellerId: currentUserUid);
}

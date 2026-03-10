import '/backend/supabase/supabase.dart';
import '/features/auth/data/supabase_auth/auth_util.dart';

/// Fetches seller orders with buyer info and product details.
/// [statusFilter] - 'to_ship' (paid only) or 'shipped' (shipped + delivered).
/// [limit] - max number of orders to return (null = all).
Future<List<Map<String, dynamic>>> getSellerOrders({
  String? statusFilter,
  int? limit,
}) async {
  final client = SupaFlow.client;
  final sellerId = currentUserUid;

  final baseQuery = client
      .from('orders')
      .select('''
        *,
        order_items(product_id, product_title, product_price, quantity, products(main_image_url)),
        buyer:users!orders_buyer_id_fkey(id, username, photo_url)
      ''')
      .eq('seller_id', sellerId)
      .isFilter('deleted_at', null)
      .isFilter('cancelled_at', null);

  List<Map<String, dynamic>> response;

  if (statusFilter == 'to_ship') {
    if (limit != null) {
      response = await baseQuery
          .inFilter('status', ['sale_pending', 'paid'])
          .order('created_at', ascending: false)
          .limit(limit);
    } else {
      response = await baseQuery
          .inFilter('status', ['sale_pending', 'paid'])
          .order('created_at', ascending: false);
    }
  } else if (statusFilter == 'shipped') {
    if (limit != null) {
      response = await baseQuery
          .inFilter('status', ['shipped', 'delivered'])
          .order('created_at', ascending: false)
          .limit(limit);
    } else {
      response = await baseQuery
          .inFilter('status', ['shipped', 'delivered'])
          .order('created_at', ascending: false);
    }
  } else {
    if (limit != null) {
      response = await baseQuery
          .order('created_at', ascending: false)
          .limit(limit);
    } else {
      response = await baseQuery
          .order('created_at', ascending: false);
    }
  }

  return List<Map<String, dynamic>>.from(response);
}

/// Returns counts: {to_ship: int, shipped: int}
Future<Map<String, int>> getSellerOrderCounts() async {
  final client = SupaFlow.client;
  final sellerId = currentUserUid;

  final results = await client
      .from('orders')
      .select('status')
      .eq('seller_id', sellerId)
      .isFilter('deleted_at', null)
      .isFilter('cancelled_at', null)
      .inFilter('status', ['sale_pending', 'paid', 'shipped', 'delivered']);

  final list = List<Map<String, dynamic>>.from(results);

  int toShip = 0;
  int shipped = 0;

  for (final row in list) {
    final status = row['status'] as String?;
    if (status == 'sale_pending' || status == 'paid') {
      toShip++;
    } else if (status == 'shipped' || status == 'delivered') {
      shipped++;
    }
  }

  return {'to_ship': toShip, 'shipped': shipped};
}

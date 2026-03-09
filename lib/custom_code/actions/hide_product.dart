import '/backend/supabase/supabase.dart';

/// Hides a product permanently from the current user's feed.
/// Calls the `hide_product` RPC which inserts into `hidden_products` table.
Future<bool> hideProduct(String userId, String productId) async {
  try {
    await SupaFlow.client.rpc(
      'hide_product',
      params: {
        'p_user_id': userId,
        'p_product_id': productId,
      },
    );
    return true;
  } catch (_) {
    return false;
  }
}

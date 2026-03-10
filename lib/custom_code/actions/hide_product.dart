import 'package:supabase_flutter/supabase_flutter.dart';

/// Hides a product permanently from the current user's feed.
Future<bool> hideProduct(String userId, String productId) async {
  try {
    await Supabase.instance.client.rpc(
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

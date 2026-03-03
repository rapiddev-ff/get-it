import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import 'index.dart';
import 'package:flutter/material.dart';

Future<bool> toggleWishlist(
  String userId,
  String productId,
) async {
  try {
    final response = await SupaFlow.client.rpc(
      'toggle_wishlist',
      params: {
        'p_user_id': userId,
        'p_product_id': productId,
      },
    );

    if (response != null && response['success'] == true) {
      return response['is_in_wishlist'] ?? false;
    }
    return false;
  } catch (e) {
    print('toggleWishlist error: $e');
    return false;
  }
}

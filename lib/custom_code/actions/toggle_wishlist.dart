// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

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

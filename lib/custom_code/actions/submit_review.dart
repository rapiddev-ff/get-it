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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

// Custom Action: submitReview
// Return Type: JSON (dynamic)
// Arguments:
//   orderId (String, required)
//   productId (String, required)
//   reviewRole (String, required) — 'as_seller' or 'as_buyer'
//   rating (int, required)
//   content (String?, optional)
//   title (String?, optional)
//   wouldRecommend (bool?, optional)
//   imageUrls (List<String>?, optional)
//

Future<dynamic> submitReview(
  String orderId,
  String productId,
  String reviewRole,
  int rating,
  String? content,
  String? title,
  List<String>? imageUrls,
) async {
  try {
    final params = {
      'p_order_id': orderId,
      'p_product_id': productId,
      'p_review_role': reviewRole,
      'p_rating': rating,
      if (content != null && content.trim().isNotEmpty)
        'p_content': content.trim(),
      if (title != null && title.trim().isNotEmpty) 'p_title': title.trim(),
      if (imageUrls != null && imageUrls.isNotEmpty) 'p_image_urls': imageUrls,
    };

    print('📤 submitReview params: $params');

    final response = await SupaFlow.client.rpc(
      'submit_review',
      params: params,
    );

    print('📥 response type: ${response.runtimeType}');
    print('📥 response: $response');

    return response ?? {'success': false, 'error': 'No response'};
  } catch (e) {
    print('❌ submitReview error: $e');
    return {'success': false, 'error': e.toString()};
  }
}

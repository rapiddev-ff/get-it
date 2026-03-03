import '/backend/supabase/supabase.dart';

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

    final response = await SupaFlow.client.rpc(
      'submit_review',
      params: params,
    );

    return response ?? {'success': false, 'error': 'No response'};
  } catch (e) {
    return {'success': false, 'error': e.toString()};
  }
}

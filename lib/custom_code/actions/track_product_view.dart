import '/backend/supabase/supabase.dart';

Future<bool> trackProductView(
  String productId,
  String? viewerId,
  String? source,
) async {
  try {
    final response = await SupaFlow.client.rpc(
      'track_product_view',
      params: {
        'p_product_id': productId,
        'p_viewer_id': viewerId,
        'p_source': source ?? 'feed',
      },
    );

    return response == true;
  } catch (e) {
    return false;
  }
}

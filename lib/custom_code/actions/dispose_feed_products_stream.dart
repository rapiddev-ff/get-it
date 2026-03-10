import 'package:supabase_flutter/supabase_flutter.dart';

Future disposeFeedProductsStream() async {
  try {
    await Supabase.instance.client.removeChannel(
      Supabase.instance.client.channel('products_feed_channel'),
    );
  } catch (_) {
    // Channel may already be removed
  }
}

import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import 'index.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future disposeFeedProductsStream() async {
  try {
    await Supabase.instance.client.removeChannel(
      Supabase.instance.client.channel('products_feed_channel'),
    );
  } catch (e) {
    print('disposeFeedProductsStream: $e');
  }
}

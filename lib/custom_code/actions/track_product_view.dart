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
    print('trackProductView error: $e');
    return false;
  }
}

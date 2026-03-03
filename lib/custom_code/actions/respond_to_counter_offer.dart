// Automatic FlutterFlow imports
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Custom Action: respondToCounterOffer
// Return Type: bool
// Arguments:
//   - counterOfferId (String)
//   - accept (bool)

import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> respondToCounterOffer(
  String counterOfferId,
  bool accept,
) async {
  final client = Supabase.instance.client;

  try {
    final response = await client.rpc(
      'respond_to_counter_offer',
      params: {
        'p_counter_offer_id': counterOfferId,
        'p_accept': accept,
      },
    );

    print('✅ Counter offer ${accept ? "accepted" : "rejected"}');
    return true;
  } catch (e) {
    print('❌ Error responding to counter offer: $e');
    return false;
  }
}

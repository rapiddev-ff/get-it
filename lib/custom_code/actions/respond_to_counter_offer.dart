import '/backend/supabase/supabase.dart';

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
    await client.rpc(
      'respond_to_counter_offer',
      params: {
        'p_counter_offer_id': counterOfferId,
        'p_accept': accept,
      },
    );

    return true;
  } catch (e) {
    return false;
  }
}

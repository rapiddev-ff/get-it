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

// Custom Action: getTotalUnreadCount
// Return Type: int
// Arguments: none

import 'package:supabase_flutter/supabase_flutter.dart';

Future<int> getTotalUnreadCount() async {
  final client = Supabase.instance.client;

  try {
    final response = await client.rpc('get_total_unread_count');
    return response as int? ?? 0;
  } catch (e) {
    print('❌ Error getting unread count: $e');
    return 0;
  }
}

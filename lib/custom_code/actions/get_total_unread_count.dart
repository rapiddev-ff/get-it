import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import 'index.dart';
import 'package:flutter/material.dart';

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

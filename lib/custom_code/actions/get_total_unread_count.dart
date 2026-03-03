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
    return 0;
  }
}

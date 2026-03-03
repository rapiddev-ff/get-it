import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import 'index.dart';
import 'package:flutter/material.dart';

// Custom Action: unsubscribeFromConversations
// Return Type: void

import '/custom_code/realtime_service.dart';

Future unsubscribeFromConversations() async {
  await RealtimeService.instance.unsubscribeFromConversations();
}

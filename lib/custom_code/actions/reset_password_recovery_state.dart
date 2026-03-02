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

import 'package:shared_preferences/shared_preferences.dart';
import 'init_password_reset_deep_link.dart' show resetDeepLinkState;

Future<void> resetPasswordRecoveryState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('last_processed_reset_link');
  await prefs.remove('last_used_reset_code');
  await prefs.remove('pending_reset_code');
  print('🔄 Password reset state cleared');
}

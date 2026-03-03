import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import 'index.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'init_password_reset_deep_link.dart' show resetDeepLinkState;

Future<void> resetPasswordRecoveryState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('last_processed_reset_link');
  await prefs.remove('last_used_reset_code');
  await prefs.remove('pending_reset_code');
  print('🔄 Password reset state cleared');
}

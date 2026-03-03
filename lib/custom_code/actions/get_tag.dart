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

Future<String?> getTag(String? text) async {
  // Add your function code here!
  if (text == null || text.isEmpty) return null;

  if (text.contains(' ') || text.contains(',')) {
    return text.replaceAll(' ', '').replaceAll(',', '');
  }

  return null;
}

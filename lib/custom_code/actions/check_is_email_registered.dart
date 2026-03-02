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

Future<bool> checkIsEmailRegistered(String? email) async {
  if (email == null || email.isEmpty) return false;

  try {
    final response = await SupaFlow.client
        .rpc('is_email_registered', params: {'email_input': email});

    if (response != null) {
      return response;
    }
    return false;
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

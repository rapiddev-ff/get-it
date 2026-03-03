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

Future<dynamic> permanentlyDeleteAccount() async {
  try {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      return {
        'success': false,
        'error': 'Not authenticated',
      };
    }

    final response = await Supabase.instance.client
        .rpc('permanently_delete_user_account')
        .single();

    final result = Map<String, dynamic>.from(response);

    if (result['success'] == true) {
      await Supabase.instance.client.auth.signOut();
    }
    print(result);
    return result;
  } catch (e) {
    print(e.toString());
    return {
      'success': false,
      'error': e.toString(),
    };
  }
}

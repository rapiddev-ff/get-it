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

Future<dynamic> requestPasswordReset(String email) async {
  final supabase = SupaFlow.client;

  try {
    final response = await supabase.functions.invoke(
      'send-password-reset',
      body: {'email': email.trim().toLowerCase()},
    );

    if (response.status == 200) {
      final data = response.data as Map<String, dynamic>;
      return {
        'success': data['success'] ?? false,
        'message': data['message'] ?? '',
      };
    } else if (response.status == 404) {
      return {
        'success': false,
        'message': 'No account found with this email address.',
        'notFound': true,
      };
    } else {
      return {
        'success': false,
        'message': 'Something went wrong. Please try again.',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Network error. Please check your connection.',
    };
  }
}

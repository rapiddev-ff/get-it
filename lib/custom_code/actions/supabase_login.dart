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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<dynamic> supabaseLogin(
  String email,
  String password,
) async {
  try {
    final AuthResponse response = await Supabase.instance.client.auth
        .signInWithPassword(email: email, password: password);

    if (response.user != null) {
      return {
        'success': true,
        'message': 'Login successful',
        'userId': response.user!.id,
      };
    } else {
      return {
        'success': false,
        'message': 'Login failed: No user returned',
      };
    }
  } on AuthException catch (e) {
    String errorMessage;

    switch (e.message) {
      case 'Invalid login credentials':
        errorMessage = 'Email or password incorrect';
        break;
      case 'Email not confirmed':
        errorMessage = 'Please verify your email first';
        break;
      case 'Invalid email or password':
        errorMessage = 'Email or password incorrect';
        break;
      default:
        if (e.message.contains('invalid')) {
          errorMessage = 'Invalid credentials';
        } else {
          errorMessage = e.message;
        }
    }

    return {
      'success': false,
      'message': errorMessage,
    };
  } catch (e) {
    return {
      'success': false,
      'message': 'An unexpected error occurred: ${e.toString()}',
    };
  }
}

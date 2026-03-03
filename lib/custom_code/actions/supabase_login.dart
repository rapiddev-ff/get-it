import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import 'index.dart';
import 'package:flutter/material.dart';

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

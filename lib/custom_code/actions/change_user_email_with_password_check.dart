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

Future<dynamic> changeUserEmailWithPasswordCheck(
  BuildContext context,
  String currentEmail,
  String newEmail,
  String password,
) async {
  try {
    // 1. Validate inputs
    if (newEmail.isEmpty || !_isValidEmail(newEmail)) {
      return {"success": false, "error": "Please enter a valid email address"};
    }

    if (newEmail.toLowerCase() == currentEmail.toLowerCase()) {
      return {
        "success": false,
        "error": "New email must be different from current email"
      };
    }

    if (password.isEmpty) {
      return {"success": false, "error": "Please enter your current password"};
    }

    final supabase = Supabase.instance.client;

    // 2. Verify current password by reauthenticating
    try {
      await supabase.auth.signInWithPassword(
        email: currentEmail,
        password: password,
      );
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        return {"success": false, "error": "Incorrect password"};
      }
      return {"success": false, "error": e.message};
    }

    // 3. Check if new email is already registered
    final existingUser = await supabase
        .rpc('is_email_registered', params: {'email_input': newEmail});

    if (existingUser == true) {
      return {"success": false, "error": "This email is already in use"};
    }

    // 4. Update email (Supabase sends confirmation to NEW email)
    const redirectUrl =
        "getit://getit.app/email-changed"; // Update for your app

    await supabase.auth.updateUser(
      UserAttributes(email: newEmail),
      emailRedirectTo: redirectUrl,
    );

    return {
      "success": true,
      "error": "",
      "message": "Confirmation email sent to $newEmail"
    };
  } on AuthException catch (e) {
    return {"success": false, "error": e.message};
  } catch (e) {
    return {"success": false, "error": "An unexpected error occurred"};
  }
}

bool _isValidEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}

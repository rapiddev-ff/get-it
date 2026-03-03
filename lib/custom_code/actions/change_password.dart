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

import 'package:supabase_flutter/supabase_flutter.dart';

// Returns null if successful, otherwise returns an error message.
Future<String?> changePassword(
  String? currentPassword,
  String? newPassword,
) async {
  final supabase = Supabase.instance.client;

  try {
    // Check if user is authenticated
    final user = supabase.auth.currentUser;
    if (user == null) {
      return "User not authenticated";
    }

    // 1. Verify current password by re-authentication
    final signInRes = await supabase.auth.signInWithPassword(
      email: user.email ?? "",
      password: currentPassword ?? "",
    );

    if (signInRes.user == null) {
      return "Incorrect current password";
    }

    // 2. Update password
    final updateRes = await supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );

    if (updateRes.user == null) {
      return "Failed to update password";
    }

    // Success → return null
    return null;
  } catch (e) {
    print("Error updating password: $e");

    // Supabase AuthException has a message field
    if (e is AuthException) {
      return e.message;
    }

    // Fallback for any other error type
    return e.toString();
  }
}

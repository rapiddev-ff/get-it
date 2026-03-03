import '/backend/supabase/supabase.dart';

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
    // Supabase AuthException has a message field
    if (e is AuthException) {
      return e.message;
    }

    // Fallback for any other error type
    return e.toString();
  }
}

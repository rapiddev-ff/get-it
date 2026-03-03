import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import 'index.dart';
import 'package:flutter/material.dart';

Future<bool> checkIsUsernameAvailable(String? username) async {
  if (username == null || username.isEmpty) return false;

  try {
    final response = await SupaFlow.client
        .rpc('check_username_available', params: {'p_username': username});

    if (response != null) {
      return response;
    }
    return false;
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

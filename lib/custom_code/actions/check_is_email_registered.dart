import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import 'index.dart';
import 'package:flutter/material.dart';

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

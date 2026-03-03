import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import 'index.dart';
import 'package:flutter/material.dart';

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

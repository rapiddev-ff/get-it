import '/backend/supabase/supabase.dart';

Future<Map<String, dynamic>> permanentlyDeleteAccount() async {
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
    return result;
  } catch (e) {
    return {
      'success': false,
      'error': e.toString(),
    };
  }
}

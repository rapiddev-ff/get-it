import '/backend/supabase/supabase.dart';

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
    return false;
  }
}

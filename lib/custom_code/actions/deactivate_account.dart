import '/backend/supabase/supabase.dart';

Future<Map<String, dynamic>> deactivateAccount() async {
  try {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      return {'success': false, 'error': 'Not authenticated'};
    }

    await UserProfilesTable().update(
      data: {'is_deactivated': true},
      matchingRows: (rows) => rows.eqOrNull('user_id', userId),
    );

    await Supabase.instance.client.auth.signOut();
    return {'success': true};
  } catch (e) {
    return {'success': false, 'error': e.toString()};
  }
}

Future<Map<String, dynamic>> reactivateAccount() async {
  try {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      return {'success': false, 'error': 'Not authenticated'};
    }

    await UserProfilesTable().update(
      data: {'is_deactivated': false},
      matchingRows: (rows) => rows.eqOrNull('user_id', userId),
    );

    return {'success': true};
  } catch (e) {
    return {'success': false, 'error': e.toString()};
  }
}

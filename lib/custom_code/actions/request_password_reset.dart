import '/backend/supabase/supabase.dart';

Future<dynamic> requestPasswordReset(String email) async {
  final supabase = SupaFlow.client;

  try {
    final response = await supabase.functions.invoke(
      'send-password-reset',
      body: {'email': email.trim().toLowerCase()},
    );

    if (response.status == 200) {
      final data = response.data as Map<String, dynamic>;
      return {
        'success': data['success'] ?? false,
        'message': data['message'] ?? '',
      };
    } else if (response.status == 404) {
      return {
        'success': false,
        'message': 'No account found with this email address.',
        'notFound': true,
      };
    } else {
      return {
        'success': false,
        'message': 'Something went wrong. Please try again.',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Network error. Please check your connection.',
    };
  }
}

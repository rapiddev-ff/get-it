import '/backend/supabase/supabase.dart';

Future<Map<String, dynamic>> requestPasswordReset(String email) async {
  final supabase = SupaFlow.client;

  try {
    final response = await supabase.functions.invoke(
      'send-password-reset',
      body: {'email': email.trim().toLowerCase()},
    );

    final data = response.data;
    if (response.status == 200 && data is Map<String, dynamic>) {
      return {
        'success': data['success'] ?? false,
        'message': data['message'] ?? '',
      };
    }
    return {
      'success': false,
      'message': 'Something went wrong. Please try again.',
    };
  } on FunctionException catch (e) {
    final details = e.details;
    if (e.status == 404) {
      final message = (details is Map ? details['message'] : null)?.toString()
          ?? 'No account found with this email address.';
      return {
        'success': false,
        'message': message,
        'notFound': true,
      };
    }
    final message =
        (details is Map ? (details['error'] ?? details['message']) : null)
            ?.toString() ??
        'Something went wrong. Please try again.';
    return {
      'success': false,
      'message': message,
    };
  } catch (e) {
    final errorStr = e.toString().toLowerCase();
    if (errorStr.contains('socketexception') ||
        errorStr.contains('timeout') ||
        errorStr.contains('network')) {
      return {
        'success': false,
        'message': 'Network error. Please check your connection.',
      };
    }
    return {
      'success': false,
      'message': 'Something went wrong. Please try again later.',
    };
  }
}

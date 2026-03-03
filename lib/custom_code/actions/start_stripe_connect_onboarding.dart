import '/backend/supabase/supabase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<dynamic> startStripeConnectOnboarding() async {
  try {
    final supabase = Supabase.instance.client;

    // Check and refresh session
    final session = supabase.auth.currentSession;
    final user = supabase.auth.currentUser;

    if (user == null || session == null) {
      return {'success': false, 'error': 'Not authenticated - no session'};
    }

    // Force refresh to get a fresh token
    final refreshResult = await supabase.auth.refreshSession();
    final freshSession = refreshResult.session;

    if (freshSession == null) {
      return {'success': false, 'error': 'Failed to refresh session'};
    }

    final accessToken = freshSession.accessToken;

    // Get Supabase URL
    final supabaseUrl = SupaFlow.client.rest.url.replaceAll('/rest/v1', '');
    final functionUrl = '$supabaseUrl/functions/v1/stripe-connect-onboarding';

    // ========================================
    // ПРАВИЛЬНЫЕ HTTPS URLs для Stripe
    // Используем Supabase Edge Function как redirect handler
    // ========================================
    final String refreshUrl =
        '$supabaseUrl/functions/v1/stripe-redirect?type=refresh&user_id=${user.id}';
    final String returnUrl =
        '$supabaseUrl/functions/v1/stripe-redirect?type=success&user_id=${user.id}';

    // Make direct HTTP call
    final response = await http.post(
      Uri.parse(functionUrl),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'refresh_url': refreshUrl,
        'return_url': returnUrl,
        'country': 'US',
      }),
    );

    if (response.statusCode != 200) {
      final errorData = jsonDecode(response.body);
      return {
        'success': false,
        'error': errorData['error'] ?? 'Request failed',
        'error_code': errorData['code'] ?? 'UNKNOWN_ERROR',
        'details': errorData,
      };
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final url = data['url'] as String?;

    if (url != null) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        return {
          'success': true,
          'url': url,
          'account_id': data['account_id'],
          'is_new_account': data['is_new_account'] ?? false,
          'is_dashboard_link': data['is_dashboard_link'] ?? false,
          'message': 'Opening Stripe onboarding...',
        };
      } else {
        return {
          'success': false,
          'error': 'Cannot launch URL: $url',
          'error_code': 'LAUNCH_FAILED',
        };
      }
    }

    return {
      'success': false,
      'error': 'No URL returned from Stripe',
      'error_code': 'NO_URL',
    };
  } catch (e) {
    return {
      'success': false,
      'error': e.toString(),
      'error_code': 'EXCEPTION',
    };
  }
}

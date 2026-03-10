import '/backend/supabase/supabase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> startStripeConnectOnboarding() async {
  try {
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;

    if (session == null) {
      return {'success': false, 'error': 'Not authenticated - no session'};
    }

    // Only refresh if token expires within 60 seconds
    String accessToken = session.accessToken;
    final expiresAt = session.expiresAt;
    if (expiresAt != null &&
        DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000)
                .difference(DateTime.now())
                .inSeconds <
            60) {
      final refreshResult = await supabase.auth.refreshSession();
      accessToken = refreshResult.session?.accessToken ?? accessToken;
    }

    final userId = supabase.auth.currentUser!.id;
    final supabaseUrl = SupaFlow.client.rest.url.replaceAll('/rest/v1', '');
    final functionUrl = '$supabaseUrl/functions/v1/stripe-connect-onboarding';

    final String refreshUrl =
        '$supabaseUrl/functions/v1/stripe-redirect?type=refresh&user_id=$userId';
    final String returnUrl =
        '$supabaseUrl/functions/v1/stripe-redirect?type=success&user_id=$userId';

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
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      return {
        'success': true,
        'url': url,
        'account_id': data['account_id'],
        'is_new_account': data['is_new_account'] ?? false,
        'is_dashboard_link': data['is_dashboard_link'] ?? false,
      };
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

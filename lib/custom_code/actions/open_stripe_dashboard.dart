// Automatic FlutterFlow imports
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Future<dynamic> openStripeDashboard() async {
  try {
    final supabase = Supabase.instance.client;

    final response = await supabase.functions.invoke(
      'stripe-dashboard-link',
    );

    if (response.status != 200) {
      return {
        'success': false,
        'error': response.data?['error'] ?? 'Unknown error',
        'needs_onboarding': response.data?['needs_onboarding'] ?? false,
      };
    }

    final data = response.data as Map<String, dynamic>;
    final url = data['url'] as String?;

    if (url != null) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }

    return {
      'success': true,
      'url': url,
      'is_onboarding_link': data['is_onboarding_link'] ?? false,
      'is_dashboard_link': data['is_dashboard_link'] ?? false,
    };
  } catch (e) {
    print('Error in openStripeDashboard: $e');
    return {'success': false, 'error': e.toString()};
  }
}

// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<dynamic> getSellerEarnings(
  DateTime? startDate,
  DateTime? endDate,
) async {
  try {
    final supabase = Supabase.instance.client;

    final params = <String, dynamic>{};
    if (startDate != null) {
      params['p_start_date'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      params['p_end_date'] = endDate.toIso8601String();
    }

    final response = await supabase.rpc(
      'get_seller_stripe_earnings',
      params: params.isEmpty ? null : params,
    );

    if (response != null && response is List && response.isNotEmpty) {
      return {
        'success': true,
        ...response.first as Map<String, dynamic>,
      };
    }

    return {
      'success': true,
      'total_earnings': 0.0,
      'total_orders': 0,
      'pending_amount': 0.0,
      'available_amount': 0.0,
      'avg_order_value': 0.0,
    };
  } catch (e) {
    print('Error in getSellerEarnings: $e');
    return {
      'success': false,
      'error': e.toString(),
    };
  }
}

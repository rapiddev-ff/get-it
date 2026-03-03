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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

Future<dynamic> createStripeCustomer(
  String? email,
  String? name,
  String? phone,
) async {
  try {
    final supabase = Supabase.instance.client;

    String? nonEmpty(String? value) {
      if (value == null || value.trim().isEmpty) return null;
      return value.trim();
    }

    final emailVal = nonEmpty(email);
    final nameVal = nonEmpty(name);
    final phoneVal = nonEmpty(phone);

    final response = await supabase.functions.invoke(
      'stripe-create-customer',
      body: {
        if (emailVal != null) 'email': emailVal,
        if (nameVal != null) 'name': nameVal,
        if (phoneVal != null) 'phone': phoneVal,
      },
    );

    if (response.status != 200) {
      return {
        'success': false,
        'error': response.data?['error'] ?? 'Failed to create customer',
      };
    }

    final data = response.data as Map<String, dynamic>;

    return {
      'success': true,
      'customer_id': data['customer_id'],
    };
  } catch (e) {
    print('Error creating Stripe customer: $e');
    return {'success': false, 'error': e.toString()};
  }
}

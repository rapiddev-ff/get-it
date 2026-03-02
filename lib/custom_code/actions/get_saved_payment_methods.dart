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

import 'package:supabase_flutter/supabase_flutter.dart';

Future<dynamic> getSavedPaymentMethods() async {
  try {
    final supabase = Supabase.instance.client;

    final response = await supabase.functions.invoke(
      'stripe-get-payment-methods',
    );

    if (response.status != 200) {
      return {
        'success': false,
        'payment_methods': [],
        'error': response.data?['error'] ?? 'Unknown error',
      };
    }

    return {
      'success': true,
      ...response.data as Map<String, dynamic>,
    };
  } catch (e) {
    print('Error in getSavedPaymentMethods: $e');
    return {
      'success': false,
      'payment_methods': [],
      'error': e.toString(),
    };
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!

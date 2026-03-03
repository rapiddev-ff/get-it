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

Future<double> calculateOrderTax(
  double subtotal,
  double shippingCost,
  String street,
  String city,
  String state,
  String zip,
) async {
  try {
    final response = await SupaFlow.client.functions.invoke(
      'calculate-order-tax',
      body: {
        'subtotal': subtotal,
        'shipping_cost': shippingCost,
        'shipping_address': {
          'street': street,
          'city': city,
          'state': state,
          'zip': zip,
        },
      },
    );

    if (response.data['success'] == true) {
      return (response.data['tax_amount'] as num).toDouble();
    }
    return 0.0;
  } catch (e) {
    return 0.0;
  }
}

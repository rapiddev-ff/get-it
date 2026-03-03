// Automatic FlutterFlow imports
import '/backend/schema/enums/enums.dart';
import '/features/checkout/domain/models/checkout_order_result_model.dart';
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

// Custom Action: createCheckoutOrder
// Return Type: CheckoutOrderResult? (nullable)
// Arguments:
//   productId (String)
//   quantity (int)
//   shippingAddressId (String?)
//   paymentMethodId (String?)
//   buyerNotes (String?)
//   shortlistId (String?)

import 'package:supabase_flutter/supabase_flutter.dart';

Future<CheckoutOrderResult?> createCheckoutOrder(
  String productId,
  int quantity,
  String? shippingAddressId,
  String? paymentMethodId,
  String? buyerNotes,
  String? shortlistId,
) async {
  final client = Supabase.instance.client;

  try {
    final response = await client.rpc(
      'create_checkout_order',
      params: {
        'p_product_id': productId,
        'p_quantity': quantity,
        'p_shipping_address_id': shippingAddressId,
        'p_payment_method_id': paymentMethodId,
        'p_buyer_notes': buyerNotes,
        'p_shortlist_id': shortlistId,
      },
    );

    if (response == null) return null;

    final json = response as Map<String, dynamic>;

    if (json['success'] != true) {
      print('❌ Order creation failed: ${json['error']}');
      return null;
    }

    return CheckoutOrderResult(
      success: true,
      orderId: json['order_id'] ?? '',
      orderNumber: json['order_number'] ?? '',
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      shippingCost: (json['shipping_cost'] as num?)?.toDouble() ?? 0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0,
      platformFee: (json['platform_fee'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
      sellerId: json['seller_id'] ?? '',
      productTitle: json['product_title'] ?? '',
    );
  } catch (e) {
    print('❌ Error creating order: $e');
    return null;
  }
}

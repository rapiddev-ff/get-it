import '/backend/supabase/supabase.dart';

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

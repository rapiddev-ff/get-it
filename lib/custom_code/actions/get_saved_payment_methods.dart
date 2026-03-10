import 'package:supabase_flutter/supabase_flutter.dart';

Future<Map<String, dynamic>> getSavedPaymentMethods() async {
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
    return {
      'success': false,
      'payment_methods': [],
      'error': e.toString(),
    };
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!

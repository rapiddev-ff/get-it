import '/backend/supabase/supabase.dart';

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
    return {'success': false, 'error': e.toString()};
  }
}

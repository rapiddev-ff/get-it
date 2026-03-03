import '/backend/supabase/supabase.dart';

Future<bool> deletePaymentMethod(String paymentMethodId) async {
  try {
    final response = await SupaFlow.client.functions.invoke(
      'delete-payment-method',
      body: {
        'payment_method_id': paymentMethodId,
      },
    );

    if (response.status == 200) {
      final data = response.data as Map<String, dynamic>;
      return data['success'] == true;
    }
    return false;
  } catch (e) {
    return false;
  }
}

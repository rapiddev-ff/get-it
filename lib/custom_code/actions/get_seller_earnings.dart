import '/backend/supabase/supabase.dart';

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
    return {
      'success': false,
      'error': e.toString(),
    };
  }
}

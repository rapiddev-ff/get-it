import '/features/checkout/domain/models/checkout_totals_model.dart';
import '/backend/supabase/supabase.dart';

Future<CheckoutTotals?> calculateCheckoutTotals(
  String productId,
  int quantity,
) async {
  final client = Supabase.instance.client;

  try {
    final response = await client.rpc(
      'calculate_checkout_totals',
      params: {
        'p_product_id': productId,
        'p_quantity': quantity,
      },
    );

    if (response == null) return null;

    // RPC returns a single jsonb object, not a list
    final json = (response is Map<String, dynamic>)
        ? response
        : (response is List && response.isNotEmpty)
            ? response[0] as Map<String, dynamic>
            : null;

    if (json == null || json['success'] != true) {
      return null;
    }

    return CheckoutTotals(
      effectivePrice: _toDouble(json['effective_price']),
      originalPrice: _toDouble(json['original_price']),
      isFlashSale: json['is_flash_sale'] == true,
      subtotal: _toDouble(json['subtotal']),
      shippingCost: _toDouble(json['shipping_cost']),
      freeShipping: json['free_shipping'] == true,
      taxAmount: _toDouble(json['tax_amount']),
      platformFee: _toDouble(json['platform_fee']),
      totalAmount: _toDouble(json['total_amount']),
      availableQuantity: _toInt(json['available_quantity']),
    );
  } catch (e) {
    return null;
  }
}

double _toDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0.0;
}

int _toInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

import '/features/checkout/domain/models/checkout_order_result_model.dart';
import '/features/checkout/data/repositories/checkout_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _repository = CheckoutRepository(Supabase.instance.client);

Future<CheckoutOrderResult?> createCheckoutOrder(
  String productId,
  int quantity,
  String? shippingAddressId,
  String? paymentMethodId,
  String? buyerNotes,
  String? shortlistId,
) async {
  return _repository.createOrder(
    productId,
    quantity,
    shippingAddressId,
    paymentMethodId,
    buyerNotes,
    shortlistId,
  );
}

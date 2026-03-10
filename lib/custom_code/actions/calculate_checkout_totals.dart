import '/features/checkout/domain/models/checkout_totals_model.dart';
import '/features/checkout/data/repositories/checkout_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _repository = CheckoutRepository(Supabase.instance.client);

Future<CheckoutTotals?> calculateCheckoutTotals(
  String productId,
  int quantity,
) async {
  return _repository.calculateTotals(productId, quantity);
}

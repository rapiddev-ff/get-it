import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/checkout/domain/models/payment_method_model.dart';

class CheckoutNotifier extends Notifier<PaymentMethod> {
  @override
  PaymentMethod build() => PaymentMethod();

  void setPaymentMethod(PaymentMethod method) {
    state = method;
  }

  void updatePaymentMethod(Function(PaymentMethod) updateFn) {
    updateFn(state);
    state = state;
  }

  void clear() {
    state = PaymentMethod();
  }
}

final checkoutProvider =
    NotifierProvider<CheckoutNotifier, PaymentMethod>(
  CheckoutNotifier.new,
);

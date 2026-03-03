import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/backend/schema/structs/index.dart';

class CheckoutNotifier extends Notifier<PaymentMethodStruct> {
  @override
  PaymentMethodStruct build() => PaymentMethodStruct();

  void setPaymentMethod(PaymentMethodStruct method) {
    state = method;
  }

  void updatePaymentMethod(Function(PaymentMethodStruct) updateFn) {
    updateFn(state);
    state = state;
  }

  void clear() {
    state = PaymentMethodStruct();
  }
}

final checkoutProvider =
    NotifierProvider<CheckoutNotifier, PaymentMethodStruct>(
  CheckoutNotifier.new,
);

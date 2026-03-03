import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'billing_details_model.dart';
import 'payment_card_model.dart';

part 'payment_method_model.freezed.dart';
part 'payment_method_model.g.dart';

@freezed
class PaymentMethod with _$PaymentMethod {
  const PaymentMethod._();

  const factory PaymentMethod({
    @Default('') String id,
    @Default('') String type,
    PaymentCard? card,
    BillingDetails? billingDetails,
    @Default(false) bool isDefault,
    @Default(0) int created,
  }) = _PaymentMethod;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);

  String serialize() => jsonEncode(toJson());

  static PaymentMethod fromSerializableMap(Map<String, dynamic> data) =>
      PaymentMethod.fromJson(data);
}

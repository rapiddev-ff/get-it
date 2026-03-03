import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_card_model.freezed.dart';
part 'payment_card_model.g.dart';

@freezed
class PaymentCard with _$PaymentCard {
  const PaymentCard._();

  const factory PaymentCard({
    @Default('') String brand,
    @Default('') String last4,
    @Default(0) int expMonth,
    @Default(0) int expYear,
    @Default('') String funding,
  }) = _PaymentCard;

  factory PaymentCard.fromJson(Map<String, dynamic> json) =>
      _$PaymentCardFromJson(json);

  String serialize() => jsonEncode(toJson());

  static PaymentCard fromSerializableMap(Map<String, dynamic> data) =>
      PaymentCard.fromJson(data);
}

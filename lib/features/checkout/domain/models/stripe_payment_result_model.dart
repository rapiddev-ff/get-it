import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stripe_payment_result_model.freezed.dart';
part 'stripe_payment_result_model.g.dart';

@freezed
class StripePaymentResult with _$StripePaymentResult {
  const StripePaymentResult._();
  const factory StripePaymentResult({
    @Default(false) bool success,
    @Default('') String paymentIntentId,
    @Default('') String clientSecret,
    @Default('') String error,
  }) = _StripePaymentResult;

  factory StripePaymentResult.fromJson(Map<String, dynamic> json) =>
      _$StripePaymentResultFromJson(json);

  String serialize() => jsonEncode(toJson());
  static StripePaymentResult fromSerializableMap(Map<String, dynamic> data) =>
      StripePaymentResult.fromJson(data);
}

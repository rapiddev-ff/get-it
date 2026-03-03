import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkout_order_result_model.freezed.dart';
part 'checkout_order_result_model.g.dart';

@freezed
class CheckoutOrderResult with _$CheckoutOrderResult {
  const CheckoutOrderResult._();

  const factory CheckoutOrderResult({
    @Default(false) bool success,
    @Default('') String orderId,
    @Default('') String orderNumber,
    @Default('') String error,
    @Default('') String paymentIntentId,
    @Default(0.0) double subtotal,
    @Default(0.0) double shippingCost,
    @Default(0.0) double taxAmount,
    @Default(0.0) double platformFee,
    @Default(0.0) double totalAmount,
    @Default('') String sellerId,
    @Default('') String productTitle,
  }) = _CheckoutOrderResult;

  factory CheckoutOrderResult.fromJson(Map<String, dynamic> json) =>
      _$CheckoutOrderResultFromJson(json);

  String serialize() => jsonEncode(toJson());

  static CheckoutOrderResult fromSerializableMap(Map<String, dynamic> data) =>
      CheckoutOrderResult.fromJson(data);
}

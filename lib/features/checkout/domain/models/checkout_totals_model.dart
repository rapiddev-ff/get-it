import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkout_totals_model.freezed.dart';
part 'checkout_totals_model.g.dart';

@freezed
class CheckoutTotals with _$CheckoutTotals {
  const CheckoutTotals._();
  const factory CheckoutTotals({
    @Default(0.0) double effectivePrice,
    @Default(0.0) double originalPrice,
    @Default(false) bool isFlashSale,
    @Default(0.0) double subtotal,
    @Default(0.0) double shippingCost,
    @Default(false) bool freeShipping,
    @Default(0.0) double taxAmount,
    @Default(0.0) double platformFee,
    @Default(0.0) double totalAmount,
    @Default(0) int availableQuantity,
  }) = _CheckoutTotals;

  factory CheckoutTotals.fromJson(Map<String, dynamic> json) =>
      _$CheckoutTotalsFromJson(json);

  String serialize() => jsonEncode(toJson());
  static CheckoutTotals fromSerializableMap(Map<String, dynamic> data) =>
      CheckoutTotals.fromJson(data);
}

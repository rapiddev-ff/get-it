import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'billing_details_model.freezed.dart';
part 'billing_details_model.g.dart';

@freezed
class BillingDetails with _$BillingDetails {
  const BillingDetails._();
  const factory BillingDetails({
    @Default('') String name,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String addressLine1,
    @Default('') String addressLine2,
    @Default('') String city,
    @Default('') String state,
    @Default('') String postalCode,
    @Default('') String country,
  }) = _BillingDetails;

  factory BillingDetails.fromJson(Map<String, dynamic> json) =>
      _$BillingDetailsFromJson(json);

  String serialize() => jsonEncode(toJson());
  static BillingDetails fromSerializableMap(Map<String, dynamic> data) =>
      BillingDetails.fromJson(data);
}

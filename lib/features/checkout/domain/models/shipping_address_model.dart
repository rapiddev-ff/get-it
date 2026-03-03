import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shipping_address_model.freezed.dart';
part 'shipping_address_model.g.dart';

@freezed
class ShippingAddress with _$ShippingAddress {
  const ShippingAddress._();
  const factory ShippingAddress({
    @Default('') String id,
    @Default('') String fullName,
    @Default('') String addressLine1,
    @Default('') String addressLine2,
    @Default('') String city,
    @Default('') String state,
    @Default('') String zipCode,
    @Default('') String country,
    @Default('') String phone,
    @Default(false) bool isDefault,
  }) = _ShippingAddress;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressFromJson(json);

  String serialize() => jsonEncode(toJson());
  static ShippingAddress fromSerializableMap(Map<String, dynamic> data) =>
      ShippingAddress.fromJson(data);
}

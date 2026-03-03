import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_address_model.freezed.dart';
part 'business_address_model.g.dart';

@freezed
class BusinessAddress with _$BusinessAddress {
  const BusinessAddress._();
  const factory BusinessAddress({
    @Default('') String addressLine1,
    @Default('') String addressLine2,
    @Default('') String city,
    @Default('') String state,
    @Default('') String zipCode,
    @Default('') String country,
  }) = _BusinessAddress;

  factory BusinessAddress.fromJson(Map<String, dynamic> json) =>
      _$BusinessAddressFromJson(json);

  String serialize() => jsonEncode(toJson());
  static BusinessAddress fromSerializableMap(Map<String, dynamic> data) =>
      BusinessAddress.fromJson(data);
}

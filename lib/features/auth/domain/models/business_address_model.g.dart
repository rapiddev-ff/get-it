// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusinessAddressImpl _$$BusinessAddressImplFromJson(
        Map<String, dynamic> json) =>
    _$BusinessAddressImpl(
      addressLine1: json['addressLine1'] as String? ?? '',
      addressLine2: json['addressLine2'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      zipCode: json['zipCode'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );

Map<String, dynamic> _$$BusinessAddressImplToJson(
        _$BusinessAddressImpl instance) =>
    <String, dynamic>{
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'city': instance.city,
      'state': instance.state,
      'zipCode': instance.zipCode,
      'country': instance.country,
    };

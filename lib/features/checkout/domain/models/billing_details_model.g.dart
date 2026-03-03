// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BillingDetailsImpl _$$BillingDetailsImplFromJson(Map<String, dynamic> json) =>
    _$BillingDetailsImpl(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      addressLine1: json['addressLine1'] as String? ?? '',
      addressLine2: json['addressLine2'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      postalCode: json['postalCode'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );

Map<String, dynamic> _$$BillingDetailsImplToJson(
        _$BillingDetailsImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'addressLine1': instance.addressLine1,
      'addressLine2': instance.addressLine2,
      'city': instance.city,
      'state': instance.state,
      'postalCode': instance.postalCode,
      'country': instance.country,
    };

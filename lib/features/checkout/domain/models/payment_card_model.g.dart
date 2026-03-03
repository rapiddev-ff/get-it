// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentCardImpl _$$PaymentCardImplFromJson(Map<String, dynamic> json) =>
    _$PaymentCardImpl(
      brand: json['brand'] as String? ?? '',
      last4: json['last4'] as String? ?? '',
      expMonth: (json['expMonth'] as num?)?.toInt() ?? 0,
      expYear: (json['expYear'] as num?)?.toInt() ?? 0,
      funding: json['funding'] as String? ?? '',
    );

Map<String, dynamic> _$$PaymentCardImplToJson(_$PaymentCardImpl instance) =>
    <String, dynamic>{
      'brand': instance.brand,
      'last4': instance.last4,
      'expMonth': instance.expMonth,
      'expYear': instance.expYear,
      'funding': instance.funding,
    };

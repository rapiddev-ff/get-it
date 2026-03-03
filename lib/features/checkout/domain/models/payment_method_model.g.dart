// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentMethodImpl _$$PaymentMethodImplFromJson(Map<String, dynamic> json) =>
    _$PaymentMethodImpl(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      card: json['card'] == null
          ? null
          : PaymentCard.fromJson(json['card'] as Map<String, dynamic>),
      billingDetails: json['billingDetails'] == null
          ? null
          : BillingDetails.fromJson(
              json['billingDetails'] as Map<String, dynamic>),
      isDefault: json['isDefault'] as bool? ?? false,
      created: (json['created'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PaymentMethodImplToJson(_$PaymentMethodImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'card': instance.card,
      'billingDetails': instance.billingDetails,
      'isDefault': instance.isDefault,
      'created': instance.created,
    };

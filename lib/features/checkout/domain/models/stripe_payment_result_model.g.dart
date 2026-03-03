// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_payment_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StripePaymentResultImpl _$$StripePaymentResultImplFromJson(
        Map<String, dynamic> json) =>
    _$StripePaymentResultImpl(
      success: json['success'] as bool? ?? false,
      paymentIntentId: json['paymentIntentId'] as String? ?? '',
      clientSecret: json['clientSecret'] as String? ?? '',
      error: json['error'] as String? ?? '',
    );

Map<String, dynamic> _$$StripePaymentResultImplToJson(
        _$StripePaymentResultImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'paymentIntentId': instance.paymentIntentId,
      'clientSecret': instance.clientSecret,
      'error': instance.error,
    };

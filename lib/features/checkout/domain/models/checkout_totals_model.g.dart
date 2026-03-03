// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_totals_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckoutTotalsImpl _$$CheckoutTotalsImplFromJson(Map<String, dynamic> json) =>
    _$CheckoutTotalsImpl(
      effectivePrice: (json['effectivePrice'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      isFlashSale: json['isFlashSale'] as bool? ?? false,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      shippingCost: (json['shippingCost'] as num?)?.toDouble() ?? 0.0,
      freeShipping: json['freeShipping'] as bool? ?? false,
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
      platformFee: (json['platformFee'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      availableQuantity: (json['availableQuantity'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CheckoutTotalsImplToJson(
        _$CheckoutTotalsImpl instance) =>
    <String, dynamic>{
      'effectivePrice': instance.effectivePrice,
      'originalPrice': instance.originalPrice,
      'isFlashSale': instance.isFlashSale,
      'subtotal': instance.subtotal,
      'shippingCost': instance.shippingCost,
      'freeShipping': instance.freeShipping,
      'taxAmount': instance.taxAmount,
      'platformFee': instance.platformFee,
      'totalAmount': instance.totalAmount,
      'availableQuantity': instance.availableQuantity,
    };

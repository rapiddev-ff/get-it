// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_order_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckoutOrderResultImpl _$$CheckoutOrderResultImplFromJson(
        Map<String, dynamic> json) =>
    _$CheckoutOrderResultImpl(
      success: json['success'] as bool? ?? false,
      orderId: json['orderId'] as String? ?? '',
      orderNumber: json['orderNumber'] as String? ?? '',
      error: json['error'] as String? ?? '',
      paymentIntentId: json['paymentIntentId'] as String? ?? '',
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      shippingCost: (json['shippingCost'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['taxAmount'] as num?)?.toDouble() ?? 0.0,
      platformFee: (json['platformFee'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      sellerId: json['sellerId'] as String? ?? '',
      productTitle: json['productTitle'] as String? ?? '',
    );

Map<String, dynamic> _$$CheckoutOrderResultImplToJson(
        _$CheckoutOrderResultImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'orderId': instance.orderId,
      'orderNumber': instance.orderNumber,
      'error': instance.error,
      'paymentIntentId': instance.paymentIntentId,
      'subtotal': instance.subtotal,
      'shippingCost': instance.shippingCost,
      'taxAmount': instance.taxAmount,
      'platformFee': instance.platformFee,
      'totalAmount': instance.totalAmount,
      'sellerId': instance.sellerId,
      'productTitle': instance.productTitle,
    };

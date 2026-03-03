// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CounterOfferImpl _$$CounterOfferImplFromJson(Map<String, dynamic> json) =>
    _$CounterOfferImpl(
      id: json['id'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      offeredPrice: (json['offeredPrice'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String?,
      fromUserId: json['fromUserId'] as String? ?? '',
      toUserId: json['toUserId'] as String? ?? '',
      createdAt: const DateTimeConverter().fromJson(json['createdAt']),
      expiresAt: const DateTimeConverter().fromJson(json['expiresAt']),
    );

Map<String, dynamic> _$$CounterOfferImplToJson(_$CounterOfferImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'originalPrice': instance.originalPrice,
      'offeredPrice': instance.offeredPrice,
      'status': instance.status,
      'fromUserId': instance.fromUserId,
      'toUserId': instance.toUserId,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'expiresAt': const DateTimeConverter().toJson(instance.expiresAt),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewProductImpl _$$ReviewProductImplFromJson(Map<String, dynamic> json) =>
    _$ReviewProductImpl(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      mainImageUrl: json['mainImageUrl'] as String? ?? '',
    );

Map<String, dynamic> _$$ReviewProductImplToJson(_$ReviewProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'mainImageUrl': instance.mainImageUrl,
    };

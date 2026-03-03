// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortlist_cover_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShortlistCoverImageImpl _$$ShortlistCoverImageImplFromJson(
        Map<String, dynamic> json) =>
    _$ShortlistCoverImageImpl(
      id: json['id'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ShortlistCoverImageImplToJson(
        _$ShortlistCoverImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'imageUrl': instance.imageUrl,
      'sortOrder': instance.sortOrder,
    };

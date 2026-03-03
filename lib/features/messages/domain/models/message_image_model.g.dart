// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImageImpl _$$MessageImageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImageImpl(
      id: json['id'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      width: json['width'] as String? ?? '',
      height: json['height'] as String? ?? '',
    );

Map<String, dynamic> _$$MessageImageImplToJson(_$MessageImageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'width': instance.width,
      'height': instance.height,
    };

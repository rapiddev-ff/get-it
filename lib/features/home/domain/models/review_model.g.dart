// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
      id: json['id'] as String? ?? '',
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      wouldRecommend: json['wouldRecommend'] as bool? ?? false,
      createdAt: const DateTimeConverter().fromJson(json['createdAt']),
      reviewer: json['reviewer'] == null
          ? null
          : Reviewer.fromJson(json['reviewer'] as Map<String, dynamic>),
      product: json['product'] == null
          ? null
          : ReviewProduct.fromJson(json['product'] as Map<String, dynamic>),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ReviewImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rating': instance.rating,
      'title': instance.title,
      'content': instance.content,
      'wouldRecommend': instance.wouldRecommend,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'reviewer': instance.reviewer,
      'product': instance.product,
      'images': instance.images,
    };

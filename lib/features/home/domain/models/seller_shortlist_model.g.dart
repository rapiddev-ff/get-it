// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seller_shortlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SellerShortlistImpl _$$SellerShortlistImplFromJson(
        Map<String, dynamic> json) =>
    _$SellerShortlistImpl(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
      discountPercentage:
          (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      eventName: json['eventName'] as String? ?? '',
      shareCode: json['shareCode'] as String? ?? '',
      status: json['status'] as String? ?? '',
      isPublic: json['isPublic'] as bool? ?? false,
      startDate: const DateTimeConverter().fromJson(json['startDate']),
      endDate: const DateTimeConverter().fromJson(json['endDate']),
      createdAt: const DateTimeConverter().fromJson(json['createdAt']),
      coverImages: (json['coverImages'] as List<dynamic>?)
              ?.map((e) =>
                  ShortlistCoverImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$SellerShortlistImplToJson(
        _$SellerShortlistImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'totalItems': instance.totalItems,
      'discountPercentage': instance.discountPercentage,
      'eventName': instance.eventName,
      'shareCode': instance.shareCode,
      'status': instance.status,
      'isPublic': instance.isPublic,
      'startDate': const DateTimeConverter().toJson(instance.startDate),
      'endDate': const DateTimeConverter().toJson(instance.endDate),
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'coverImages': instance.coverImages,
      'tags': instance.tags,
    };

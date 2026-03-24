// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_scan_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AiScanResultImpl _$$AiScanResultImplFromJson(Map<String, dynamic> json) =>
    _$AiScanResultImpl(
      suggestedTitle: json['suggestedTitle'] as String? ?? '',
      suggestedDescription: json['suggestedDescription'] as String? ?? '',
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      subcategoryId: json['subcategoryId'] as String?,
      subcategoryName: json['subcategoryName'] as String?,
      suggestedTags: (json['suggestedTags'] as List<dynamic>?)
              ?.map((e) => AiScanTag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      labels: (json['labels'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      detectedText: json['detectedText'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$AiScanResultImplToJson(_$AiScanResultImpl instance) =>
    <String, dynamic>{
      'suggestedTitle': instance.suggestedTitle,
      'suggestedDescription': instance.suggestedDescription,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'subcategoryId': instance.subcategoryId,
      'subcategoryName': instance.subcategoryName,
      'suggestedTags': instance.suggestedTags,
      'labels': instance.labels,
      'detectedText': instance.detectedText,
      'confidence': instance.confidence,
    };

_$AiScanTagImpl _$$AiScanTagImplFromJson(Map<String, dynamic> json) =>
    _$AiScanTagImpl(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );

Map<String, dynamic> _$$AiScanTagImplToJson(_$AiScanTagImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };

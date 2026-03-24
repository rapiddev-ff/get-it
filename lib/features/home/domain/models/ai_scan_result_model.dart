import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import '/features/browse/domain/models/tag_model.dart';

part 'ai_scan_result_model.freezed.dart';
part 'ai_scan_result_model.g.dart';

@freezed
class AiScanResult with _$AiScanResult {
  const AiScanResult._();
  const factory AiScanResult({
    @Default('') String suggestedTitle,
    @Default('') String suggestedDescription,
    String? categoryId,
    String? categoryName,
    String? subcategoryId,
    String? subcategoryName,
    @Default([]) List<AiScanTag> suggestedTags,
    @Default([]) List<String> labels,
    String? detectedText,
    @Default(0.0) double confidence,
  }) = _AiScanResult;

  factory AiScanResult.fromJson(Map<String, dynamic> json) =>
      _$AiScanResultFromJson(json);

  String serialize() => jsonEncode(toJson());
  static AiScanResult fromSerializableMap(Map<String, dynamic> data) =>
      AiScanResult.fromJson(data);

  List<Tag> toTags() => suggestedTags
      .map((t) => Tag(id: t.id, name: t.name, slug: t.slug))
      .toList();
}

@freezed
class AiScanTag with _$AiScanTag {
  const factory AiScanTag({
    @Default('') String id,
    @Default('') String name,
    @Default('') String slug,
  }) = _AiScanTag;

  factory AiScanTag.fromJson(Map<String, dynamic> json) =>
      _$AiScanTagFromJson(json);
}

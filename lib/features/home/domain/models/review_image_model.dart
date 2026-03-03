import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_image_model.freezed.dart';
part 'review_image_model.g.dart';

@freezed
class ReviewImage with _$ReviewImage {
  const ReviewImage._();
  const factory ReviewImage({
    @Default('') String id,
    @Default('') String imageUrl,
    @Default('') String thumbnailUrl,
  }) = _ReviewImage;

  factory ReviewImage.fromJson(Map<String, dynamic> json) =>
      _$ReviewImageFromJson(json);

  String serialize() => jsonEncode(toJson());
  static ReviewImage fromSerializableMap(Map<String, dynamic> data) =>
      ReviewImage.fromJson(data);
}

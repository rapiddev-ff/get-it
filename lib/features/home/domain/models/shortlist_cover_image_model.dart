import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shortlist_cover_image_model.freezed.dart';
part 'shortlist_cover_image_model.g.dart';

@freezed
class ShortlistCoverImage with _$ShortlistCoverImage {
  const ShortlistCoverImage._();
  const factory ShortlistCoverImage({
    @Default('') String id,
    @Default('') String productId,
    @Default('') String imageUrl,
    @Default(0) int sortOrder,
  }) = _ShortlistCoverImage;

  factory ShortlistCoverImage.fromJson(Map<String, dynamic> json) =>
      _$ShortlistCoverImageFromJson(json);

  String serialize() => jsonEncode(toJson());
  static ShortlistCoverImage fromSerializableMap(Map<String, dynamic> data) =>
      ShortlistCoverImage.fromJson(data);
}

import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_image_model.freezed.dart';
part 'product_image_model.g.dart';

@freezed
class ProductImage with _$ProductImage {
  const ProductImage._();
  const factory ProductImage({
    @Default('') String id,
    @Default('') String imageUrl,
    @Default('') String thumbnailUrl,
    @Default(false) bool isMain,
    @Default(0) int sortOrder,
    @Default(0) int width,
    @Default(0) int height,
  }) = _ProductImage;

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$ProductImageFromJson(json);

  String serialize() => jsonEncode(toJson());
  static ProductImage fromSerializableMap(Map<String, dynamic> data) =>
      ProductImage.fromJson(data);
}

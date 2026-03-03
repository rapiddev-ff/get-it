import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_product_model.freezed.dart';
part 'review_product_model.g.dart';

@freezed
class ReviewProduct with _$ReviewProduct {
  const ReviewProduct._();
  const factory ReviewProduct({
    @Default('') String id,
    @Default('') String title,
    @Default(0.0) double price,
    @Default('') String mainImageUrl,
  }) = _ReviewProduct;

  factory ReviewProduct.fromJson(Map<String, dynamic> json) =>
      _$ReviewProductFromJson(json);

  String serialize() => jsonEncode(toJson());
  static ReviewProduct fromSerializableMap(Map<String, dynamic> data) =>
      ReviewProduct.fromJson(data);
}

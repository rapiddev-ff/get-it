import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '/core/utils/json_converters.dart';
import 'review_image_model.dart';
import 'review_product_model.dart';
import 'reviewer_model.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
class Review with _$Review {
  const Review._();

  const factory Review({
    @Default('') String id,
    @Default(0) int rating,
    @Default('') String title,
    @Default('') String content,
    @Default(false) bool wouldRecommend,
    @DateTimeConverter() DateTime? createdAt,
    Reviewer? reviewer,
    ReviewProduct? product,
    @Default([]) List<ReviewImage> images,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  String serialize() => jsonEncode(toJson());

  static Review fromSerializableMap(Map<String, dynamic> data) =>
      Review.fromJson(data);
}

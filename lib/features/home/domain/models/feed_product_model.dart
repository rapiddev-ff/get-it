import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '/core/utils/json_converters.dart';

part 'feed_product_model.freezed.dart';
part 'feed_product_model.g.dart';

@freezed
class FeedProduct with _$FeedProduct {
  const FeedProduct._();

  const factory FeedProduct({
    @Default('') String id,
    @Default('') String sellerId,
    @Default('') String title,
    @Default('') String description,
    @Default(0.0) double price,
    double? originalPrice,
    @Default(false) bool flashSaleEnabled,
    double? flashSalePrice,
    @DateTimeConverter() DateTime? flashSaleEndsAt,
    @Default('') String mainImageUrl,
    @Default('') String categoryName,
    @Default('') String conditionName,
    @Default('') String sellerUsername,
    String? sellerAvatarUrl,
    @Default(0.0) double sellerRating,
    @Default(0) int sellerTotalReviews,
    @Default(false) bool isInWishlist,
    @DateTimeConverter() DateTime? createdAt,
    @Default(0.0) double shippingPrice,
    @Default(false) bool freeShipping,
    @Default(false) bool useSellerShipping,
    double? customFlatRate,
    double? customAdditionalItemFee,
  }) = _FeedProduct;

  factory FeedProduct.fromJson(Map<String, dynamic> json) =>
      _$FeedProductFromJson(json);

  String serialize() => jsonEncode(toJson());

  static FeedProduct fromSerializableMap(Map<String, dynamic> data) =>
      FeedProduct.fromJson(data);
}

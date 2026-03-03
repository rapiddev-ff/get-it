import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '/core/utils/json_converters.dart';

part 'browse_product_model.freezed.dart';
part 'browse_product_model.g.dart';

@freezed
class BrowseProduct with _$BrowseProduct {
  const BrowseProduct._();

  const factory BrowseProduct({
    @Default('') String id,
    @Default('') String title,
    @Default(0.0) double price,
    @Default(0.0) double originalPrice,
    @Default('') String mainImageUrl,
    @Default('') String conditionName,
    @Default('') String categoryName,
    @Default(false) bool isInWishlist,
    @Default('') String sellerUsername,
    @DateTimeConverter() DateTime? createdAt,
  }) = _BrowseProduct;

  factory BrowseProduct.fromJson(Map<String, dynamic> json) =>
      _$BrowseProductFromJson(json);

  String serialize() => jsonEncode(toJson());

  static BrowseProduct fromSerializableMap(Map<String, dynamic> data) =>
      BrowseProduct.fromJson(data);
}

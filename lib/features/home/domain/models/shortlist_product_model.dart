import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '/core/utils/json_converters.dart';

part 'shortlist_product_model.freezed.dart';
part 'shortlist_product_model.g.dart';

/// Product as shown in the "Add Products to Shortlist" page.
/// Returned by the get_seller_products_for_shortlist RPC.
@freezed
class ShortlistProduct with _$ShortlistProduct {
  const ShortlistProduct._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ShortlistProduct({
    @Default('') String id,
    @Default('') String title,
    @Default(0.0) double price,
    @Default(0.0) double originalPrice,
    @Default(false) bool flashSaleEnabled,
    double? flashSalePrice,
    @DateTimeConverter() DateTime? flashSaleEndsAt,
    @Default(0) int quantity,
    @Default(0) int reservedQuantity,
    @Default(0) int availableQuantity,
    @Default('') String categoryId,
    @Default('') String categoryName,
    @Default('') String subcategoryId,
    @Default('') String subcategoryName,
    @Default('') String mainImageUrl,
    String? discountType,
    double? discountAmount,
  }) = _ShortlistProduct;

  factory ShortlistProduct.fromJson(Map<String, dynamic> json) =>
      _$ShortlistProductFromJson(json);

  String serialize() => jsonEncode(toJson());

  static ShortlistProduct fromSerializableMap(Map<String, dynamic> data) =>
      ShortlistProduct.fromJson(data);
}

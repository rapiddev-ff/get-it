import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '/core/utils/json_converters.dart';

part 'seller_product_model.freezed.dart';
part 'seller_product_model.g.dart';

@freezed
class SellerProduct with _$SellerProduct {
  const SellerProduct._();

  const factory SellerProduct({
    @Default('') String id,
    @Default('') String orderId,
    @Default('') String title,
    @Default(0.0) double price,
    @Default(0.0) double originalPrice,
    @Default('') String status,
    @Default(0) int viewsCount,
    @Default('') String conditionName,
    @Default('') String mainImageUrl,
    @Default(false) bool isInWishlist,
    @DateTimeConverter() DateTime? createdAt,
    @Default(0) int quantity,
    @Default('') String categoryId,
  }) = _SellerProduct;

  factory SellerProduct.fromJson(Map<String, dynamic> json) =>
      _$SellerProductFromJson(json);

  String serialize() => jsonEncode(toJson());

  static SellerProduct fromSerializableMap(Map<String, dynamic> data) =>
      SellerProduct.fromJson(data);
}

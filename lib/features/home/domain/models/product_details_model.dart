import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '/core/utils/json_converters.dart';
import '/features/browse/domain/models/category_model.dart';
import '/features/browse/domain/models/condition_model.dart';
import '/features/browse/domain/models/subcategory_model.dart';
import '/features/browse/domain/models/tag_model.dart';
import 'product_image_model.dart';
import 'seller_model.dart';

part 'product_details_model.freezed.dart';
part 'product_details_model.g.dart';

@freezed
class ProductDetails with _$ProductDetails {
  const ProductDetails._();

  const factory ProductDetails({
    @Default('') String id,
    @Default('') String sellerId,
    @Default('') String title,
    @Default('') String description,
    @Default(0.0) double price,
    double? originalPrice,
    @Default(false) bool flashSaleEnabled,
    double? flashSalePrice,
    @DateTimeConverter() DateTime? flashSaleEndsAt,
    String? discountType,
    double? discountAmount,
    @Default(0) int quantity,
    int? year,
    int? issueNumber,
    String? sku,
    String? skuNumber,
    String? shippingInfo,
    @Default(0.0) double shippingPrice,
    @Default(false) bool freeShipping,
    @Default(false) bool useSellerShipping,
    double? customFlatRate,
    double? customAdditionalItemFee,
    String? shortlistId,
    @Default(0) int viewsCount,
    @Default('') String status,
    @Default('') String mainImageUrl,
    @Default('') String categoryId,
    @Default('') String categoryName,
    @Default('') String subcategoryId,
    @Default('') String subcategoryName,
    @Default('') String conditionId,
    @Default('') String conditionName,
    @Default('') String sellerUsername,
    @Default('') String sellerAvatarUrl,
    @DateTimeConverter() DateTime? createdAt,
    @Default([]) List<ProductImage> images,
    @Default([]) List<Condition> conditions,
    Category? category,
    Subcategory? subcategory,
    Seller? seller,
    @Default([]) List<Tag> tags,
    @Default(false) bool isInWishlist,
    @Default(false) bool isOwnProduct,
  }) = _ProductDetails;

  factory ProductDetails.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsFromJson(json);

  String serialize() => jsonEncode(toJson());

  static ProductDetails fromSerializableMap(Map<String, dynamic> data) =>
      ProductDetails.fromJson(data);
}

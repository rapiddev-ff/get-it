import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '/core/utils/json_converters.dart';

part 'shortlist_item_detail_model.freezed.dart';
part 'shortlist_item_detail_model.g.dart';

/// Detailed shortlist item for display on the Shortlist page (Step 2).
/// Returned by the get_shortlist_items_detail RPC.
@freezed
class ShortlistItemDetail with _$ShortlistItemDetail {
  const ShortlistItemDetail._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ShortlistItemDetail({
    @Default('') String id,
    @Default('') String productId,
    @Default(1) int quantity,
    @Default('active') String itemStatus,
    @Default(0) int sortOrder,
    @DateTimeConverter() DateTime? reservedAt,
    @Default('') String title,
    @Default(0.0) double price,
    @Default(0.0) double originalPrice,
    @Default(false) bool flashSaleEnabled,
    double? flashSalePrice,
    @DateTimeConverter() DateTime? flashSaleEndsAt,
    String? discountType,
    double? discountAmount,
    @Default('') String productStatus,
    @Default('') String categoryName,
    @Default('') String subcategoryName,
    @Default('') String mainImageUrl,
  }) = _ShortlistItemDetail;

  factory ShortlistItemDetail.fromJson(Map<String, dynamic> json) =>
      _$ShortlistItemDetailFromJson(json);

  String serialize() => jsonEncode(toJson());

  static ShortlistItemDetail fromSerializableMap(Map<String, dynamic> data) =>
      ShortlistItemDetail.fromJson(data);
}

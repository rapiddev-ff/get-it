import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '/core/utils/json_converters.dart';
import 'shortlist_cover_image_model.dart';

part 'seller_shortlist_model.freezed.dart';
part 'seller_shortlist_model.g.dart';

@freezed
class SellerShortlist with _$SellerShortlist {
  const SellerShortlist._();

  const factory SellerShortlist({
    @Default('') String id,
    @Default('') String name,
    @Default('') String description,
    @Default(0) int totalItems,
    @Default(0.0) double discountPercentage,
    @Default('') String eventName,
    @Default('') String shareCode,
    @Default('') String status,
    @Default(false) bool isPublic,
    @DateTimeConverter() DateTime? startDate,
    @DateTimeConverter() DateTime? endDate,
    @DateTimeConverter() DateTime? createdAt,
    @Default([]) List<ShortlistCoverImage> coverImages,
    @Default([]) List<String> tags,
  }) = _SellerShortlist;

  factory SellerShortlist.fromJson(Map<String, dynamic> json) =>
      _$SellerShortlistFromJson(json);

  String serialize() => jsonEncode(toJson());

  static SellerShortlist fromSerializableMap(Map<String, dynamic> data) =>
      SellerShortlist.fromJson(data);
}

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '/core/utils/json_converters.dart';
import 'review_model.dart';
import 'seller_product_model.dart';
import 'seller_shortlist_model.dart';

part 'seller_model.freezed.dart';
part 'seller_model.g.dart';

@freezed
class Seller with _$Seller {
  const Seller._();

  const factory Seller({
    @Default('') String id,
    @Default('') String userId,
    @Default('') String username,
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String avatarUrl,
    @Default('') String bio,
    @Default('') String businessName,
    @Default('') String businessEmail,
    @Default(0.0) double ratingAsSeller,
    @Default(0) int totalReviewsAsSeller,
    @Default(0.0) double ratingAsBuyer,
    @Default(0) int totalReviewsAsBuyer,
    @Default(0) int totalSales,
    @Default(0) int followersCount,
    @Default(0) int followingCount,
    @DateTimeConverter() DateTime? createdAt,
    @DateTimeConverter() DateTime? sellerSince,
    @Default(false) bool isPrivate,
    @Default(0) int totalProducts,
    @Default(0) int totalShortlists,
    @Default(false) bool isFollowing,
    @Default(false) bool isOwnProfile,
    @Default(false) bool isBlocked,
    @Default([]) List<Review> reviewsAsSeller,
    @Default([]) List<Review> reviewsAsBuyer,
    @Default([]) List<SellerProduct> purchasedProducts,
    @Default([]) List<SellerShortlist> shortlists,
  }) = _Seller;

  factory Seller.fromJson(Map<String, dynamic> json) => _$SellerFromJson(json);

  String serialize() => jsonEncode(toJson());

  static Seller fromSerializableMap(Map<String, dynamic> data) =>
      Seller.fromJson(data);
}

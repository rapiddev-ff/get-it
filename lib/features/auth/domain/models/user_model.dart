import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '/core/utils/json_converters.dart';
import '/features/checkout/domain/models/payment_method_model.dart';
import '/features/checkout/domain/models/shipping_address_model.dart';
import '/features/checkout/domain/models/stripe_account_status_model.dart';
import 'business_address_model.dart';
import 'user_settings_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserData with _$UserData {
  const UserData._();

  const factory UserData({
    @Default('') String id,
    @JsonKey(name: 'user_id') @Default('') String userId,
    @Default('') String username,
    @JsonKey(name: 'first_name') @Default('') String firstName,
    @JsonKey(name: 'last_name') @Default('') String lastName,
    @JsonKey(name: 'avatar_url') @Default('') String avatarUrl,
    @Default('') String bio,
    @Default('') String phone,
    @JsonKey(name: 'phone_verified') @Default(false) bool phoneVerified,
    @JsonKey(name: 'is_seller') @Default(false) bool isSeller,
    @JsonKey(name: 'seller_since') @DateTimeConverter() DateTime? sellerSince,
    @JsonKey(name: 'business_name') @Default('') String businessName,
    @JsonKey(name: 'business_address') BusinessAddress? businessAddress,
    @JsonKey(name: 'business_email') @Default('') String businessEmail,
    @JsonKey(name: 'rating_as_seller') @Default(0.0) double ratingAsSeller,
    @JsonKey(name: 'rating_as_buyer') @Default(0.0) double ratingAsBuyer,
    @JsonKey(name: 'total_reviews_as_seller')
    @Default(0)
    int totalReviewsAsSeller,
    @JsonKey(name: 'total_reviews_as_buyer')
    @Default(0)
    int totalReviewsAsBuyer,
    @JsonKey(name: 'total_sales') @Default(0) int totalSales,
    @JsonKey(name: 'total_purchases') @Default(0) int totalPurchases,
    @JsonKey(name: 'total_refunds') @Default(0) int totalRefunds,
    @JsonKey(name: 'total_cancelled') @Default(0) int totalCancelled,
    @JsonKey(name: 'followers_count') @Default(0) int followersCount,
    @JsonKey(name: 'following_count') @Default(0) int followingCount,
    @JsonKey(name: 'is_private') @Default(false) bool isPrivate,
    @JsonKey(name: 'referral_code') @Default('') String referralCode,
    @JsonKey(name: 'referred_by') @Default('') String referredBy,
    @JsonKey(name: 'created_at') @DateTimeConverter() DateTime? createdAt,
    @JsonKey(name: 'updated_at') @DateTimeConverter() DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') @DateTimeConverter() DateTime? deletedAt,
    @JsonKey(name: 'total_referrals') @Default(0) int totalReferrals,
    @Default('') String email,
    StripeAccountStatus? stripe,
    @Default([]) List<PaymentMethod> paymentMethod,
    @Default(false) bool hasStripeCustomer,
    @Default('') String defaultPaymentMethodId,
    UserSettings? userSettings,
    ShippingAddress? shippingAddress,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  String serialize() => jsonEncode(toJson());

  static UserData fromSerializableMap(Map<String, dynamic> data) =>
      UserData.fromJson(data);
}

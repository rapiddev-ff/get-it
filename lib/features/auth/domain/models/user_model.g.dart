// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDataImpl _$$UserDataImplFromJson(Map<String, dynamic> json) =>
    _$UserDataImpl(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      phoneVerified: json['phone_verified'] as bool? ?? false,
      isSeller: json['is_seller'] as bool? ?? false,
      sellerSince: const DateTimeConverter().fromJson(json['seller_since']),
      businessName: json['business_name'] as String? ?? '',
      businessAddress: json['business_address'] == null
          ? null
          : BusinessAddress.fromJson(
              json['business_address'] as Map<String, dynamic>),
      businessEmail: json['business_email'] as String? ?? '',
      ratingAsSeller: (json['rating_as_seller'] as num?)?.toDouble() ?? 0.0,
      ratingAsBuyer: (json['rating_as_buyer'] as num?)?.toDouble() ?? 0.0,
      totalReviewsAsSeller:
          (json['total_reviews_as_seller'] as num?)?.toInt() ?? 0,
      totalReviewsAsBuyer:
          (json['total_reviews_as_buyer'] as num?)?.toInt() ?? 0,
      totalSales: (json['total_sales'] as num?)?.toInt() ?? 0,
      totalPurchases: (json['total_purchases'] as num?)?.toInt() ?? 0,
      totalRefunds: (json['total_refunds'] as num?)?.toInt() ?? 0,
      totalCancelled: (json['total_cancelled'] as num?)?.toInt() ?? 0,
      followersCount: (json['followers_count'] as num?)?.toInt() ?? 0,
      followingCount: (json['following_count'] as num?)?.toInt() ?? 0,
      isPrivate: json['is_private'] as bool? ?? false,
      referralCode: json['referral_code'] as String? ?? '',
      referredBy: json['referred_by'] as String? ?? '',
      createdAt: const DateTimeConverter().fromJson(json['created_at']),
      updatedAt: const DateTimeConverter().fromJson(json['updated_at']),
      deletedAt: const DateTimeConverter().fromJson(json['deleted_at']),
      isDeactivated: json['is_deactivated'] as bool? ?? false,
      totalReferrals: (json['total_referrals'] as num?)?.toInt() ?? 0,
      email: json['email'] as String? ?? '',
      stripe: json['stripe'] == null
          ? null
          : StripeAccountStatus.fromJson(
              json['stripe'] as Map<String, dynamic>),
      paymentMethod: (json['paymentMethod'] as List<dynamic>?)
              ?.map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      hasStripeCustomer: json['hasStripeCustomer'] as bool? ?? false,
      defaultPaymentMethodId: json['defaultPaymentMethodId'] as String? ?? '',
      userSettings: json['userSettings'] == null
          ? null
          : UserSettings.fromJson(json['userSettings'] as Map<String, dynamic>),
      shippingAddress: json['shippingAddress'] == null
          ? null
          : ShippingAddress.fromJson(
              json['shippingAddress'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserDataImplToJson(_$UserDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'avatar_url': instance.avatarUrl,
      'bio': instance.bio,
      'phone': instance.phone,
      'phone_verified': instance.phoneVerified,
      'is_seller': instance.isSeller,
      'seller_since': const DateTimeConverter().toJson(instance.sellerSince),
      'business_name': instance.businessName,
      'business_address': instance.businessAddress,
      'business_email': instance.businessEmail,
      'rating_as_seller': instance.ratingAsSeller,
      'rating_as_buyer': instance.ratingAsBuyer,
      'total_reviews_as_seller': instance.totalReviewsAsSeller,
      'total_reviews_as_buyer': instance.totalReviewsAsBuyer,
      'total_sales': instance.totalSales,
      'total_purchases': instance.totalPurchases,
      'total_refunds': instance.totalRefunds,
      'total_cancelled': instance.totalCancelled,
      'followers_count': instance.followersCount,
      'following_count': instance.followingCount,
      'is_private': instance.isPrivate,
      'referral_code': instance.referralCode,
      'referred_by': instance.referredBy,
      'created_at': const DateTimeConverter().toJson(instance.createdAt),
      'updated_at': const DateTimeConverter().toJson(instance.updatedAt),
      'deleted_at': const DateTimeConverter().toJson(instance.deletedAt),
      'is_deactivated': instance.isDeactivated,
      'total_referrals': instance.totalReferrals,
      'email': instance.email,
      'stripe': instance.stripe,
      'paymentMethod': instance.paymentMethod,
      'hasStripeCustomer': instance.hasStripeCustomer,
      'defaultPaymentMethodId': instance.defaultPaymentMethodId,
      'userSettings': instance.userSettings,
      'shippingAddress': instance.shippingAddress,
    };

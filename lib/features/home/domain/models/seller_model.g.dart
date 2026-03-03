// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seller_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SellerImpl _$$SellerImplFromJson(Map<String, dynamic> json) => _$SellerImpl(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      username: json['username'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      businessName: json['businessName'] as String? ?? '',
      businessEmail: json['businessEmail'] as String? ?? '',
      ratingAsSeller: (json['ratingAsSeller'] as num?)?.toDouble() ?? 0.0,
      totalReviewsAsSeller:
          (json['totalReviewsAsSeller'] as num?)?.toInt() ?? 0,
      ratingAsBuyer: (json['ratingAsBuyer'] as num?)?.toDouble() ?? 0.0,
      totalReviewsAsBuyer: (json['totalReviewsAsBuyer'] as num?)?.toInt() ?? 0,
      totalSales: (json['totalSales'] as num?)?.toInt() ?? 0,
      followersCount: (json['followersCount'] as num?)?.toInt() ?? 0,
      followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
      createdAt: const DateTimeConverter().fromJson(json['createdAt']),
      sellerSince: const DateTimeConverter().fromJson(json['sellerSince']),
      isPrivate: json['isPrivate'] as bool? ?? false,
      totalProducts: (json['totalProducts'] as num?)?.toInt() ?? 0,
      totalShortlists: (json['totalShortlists'] as num?)?.toInt() ?? 0,
      isFollowing: json['isFollowing'] as bool? ?? false,
      isOwnProfile: json['isOwnProfile'] as bool? ?? false,
      isBlocked: json['isBlocked'] as bool? ?? false,
      reviewsAsSeller: (json['reviewsAsSeller'] as List<dynamic>?)
              ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      reviewsAsBuyer: (json['reviewsAsBuyer'] as List<dynamic>?)
              ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      purchasedProducts: (json['purchasedProducts'] as List<dynamic>?)
              ?.map((e) => SellerProduct.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      shortlists: (json['shortlists'] as List<dynamic>?)
              ?.map((e) => SellerShortlist.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SellerImplToJson(_$SellerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'avatarUrl': instance.avatarUrl,
      'bio': instance.bio,
      'businessName': instance.businessName,
      'businessEmail': instance.businessEmail,
      'ratingAsSeller': instance.ratingAsSeller,
      'totalReviewsAsSeller': instance.totalReviewsAsSeller,
      'ratingAsBuyer': instance.ratingAsBuyer,
      'totalReviewsAsBuyer': instance.totalReviewsAsBuyer,
      'totalSales': instance.totalSales,
      'followersCount': instance.followersCount,
      'followingCount': instance.followingCount,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'sellerSince': const DateTimeConverter().toJson(instance.sellerSince),
      'isPrivate': instance.isPrivate,
      'totalProducts': instance.totalProducts,
      'totalShortlists': instance.totalShortlists,
      'isFollowing': instance.isFollowing,
      'isOwnProfile': instance.isOwnProfile,
      'isBlocked': instance.isBlocked,
      'reviewsAsSeller': instance.reviewsAsSeller,
      'reviewsAsBuyer': instance.reviewsAsBuyer,
      'purchasedProducts': instance.purchasedProducts,
      'shortlists': instance.shortlists,
    };

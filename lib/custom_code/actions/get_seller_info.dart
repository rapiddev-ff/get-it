// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

List<ReviewStruct> _parseReviews(List? rawList) {
  final reviewsList = <ReviewStruct>[];
  if (rawList == null) return reviewsList;

  for (final r in rawList) {
    ReviewerStruct? reviewer;
    if (r['reviewer'] != null) {
      final rev = r['reviewer'];
      reviewer = ReviewerStruct(
        id: rev['id']?.toString() ?? '',
        username: rev['username']?.toString() ?? '',
        avatarUrl: rev['avatarUrl']?.toString() ?? '',
      );
    }

    ReviewProductStruct? product;
    if (r['product'] != null) {
      final prod = r['product'];
      product = ReviewProductStruct(
        id: prod['id']?.toString() ?? '',
        title: prod['title']?.toString() ?? '',
        price: (prod['price'] as num?)?.toDouble() ?? 0.0,
        mainImageUrl: prod['mainImageUrl']?.toString() ?? '',
      );
    }

    final imagesList = <ReviewImageStruct>[];
    if (r['images'] != null) {
      for (final img in (r['images'] as List)) {
        imagesList.add(ReviewImageStruct(
          id: img['id']?.toString() ?? '',
          imageUrl: img['imageUrl']?.toString() ?? '',
        ));
      }
    }

    reviewsList.add(ReviewStruct(
      id: r['id']?.toString() ?? '',
      rating: (r['rating'] as num?)?.toInt() ?? 0,
      title: r['title']?.toString() ?? '',
      content: r['content']?.toString() ?? '',
      wouldRecommend: r['wouldRecommend'] == true,
      createdAt: r['createdAt'] != null
          ? DateTime.tryParse(r['createdAt'].toString())
          : null,
      reviewer: reviewer,
      product: product,
      images: imagesList,
    ));
  }
  return reviewsList;
}

Future<SellerStruct?> getSellerInfo(
  String sellerId,
  String? userId,
) async {
  try {
    final response = await SupaFlow.client.rpc(
      'get_seller_info',
      params: {
        'p_seller_id': sellerId,
        if (userId != null && userId.isNotEmpty) 'p_user_id': userId,
      },
    );

    if (response == null || response['error'] != null) {
      return null;
    }

    final data = response;

    // Parse reviews (separate lists)
    final reviewsAsSeller = _parseReviews(data['reviews_as_seller'] as List?);
    final reviewsAsBuyer = _parseReviews(data['reviews_as_buyer'] as List?);

    // Parse purchased products
    final purchasedProducts = <SellerProductStruct>[];
    if (data['purchased_products'] != null) {
      for (final item in (data['purchased_products'] as List)) {
        purchasedProducts.add(SellerProductStruct(
          id: item['id']?.toString() ?? '',
          orderId: item['orderId']?.toString() ?? '',
          title: item['title']?.toString() ?? '',
          price: (item['price'] as num?)?.toDouble() ?? 0.0,
          originalPrice: (item['originalPrice'] as num?)?.toDouble() ?? 0.0,
          status: item['status']?.toString() ?? '',
          viewsCount: (item['viewsCount'] as num?)?.toInt() ?? 0,
          conditionName: item['conditionName']?.toString() ?? '',
          mainImageUrl: item['mainImageUrl']?.toString() ?? '',
          isInWishlist: item['isInWishlist'] == true,
          createdAt: item['createdAt'] != null
              ? DateTime.tryParse(item['createdAt'].toString())
              : null,
        ));
      }
    }

    // Parse shortlists
    final shortlistsList = <SellerShortlistStruct>[];
    if (data['shortlists'] != null) {
      for (final sl in (data['shortlists'] as List)) {
        final coverImages = <ShortlistCoverImageStruct>[];
        if (sl['coverImages'] != null) {
          for (final img in (sl['coverImages'] as List)) {
            coverImages.add(ShortlistCoverImageStruct(
              productId: img['productId']?.toString() ?? '',
              imageUrl: img['imageUrl']?.toString() ?? '',
              sortOrder: (img['sortOrder'] as num?)?.toInt() ?? 0,
            ));
          }
        }

        final tags = <String>[];
        if (sl['tags'] != null) {
          for (final tag in (sl['tags'] as List)) {
            tags.add(tag?.toString() ?? '');
          }
        }

        shortlistsList.add(SellerShortlistStruct(
          id: sl['id']?.toString() ?? '',
          name: sl['name']?.toString() ?? '',
          description: sl['description']?.toString() ?? '',
          totalItems: (sl['totalItems'] as num?)?.toInt() ?? 0,
          discountPercentage:
              (sl['discountPercentage'] as num?)?.toDouble() ?? 0.0,
          eventName: sl['eventName']?.toString() ?? '',
          shareCode: sl['shareCode']?.toString() ?? '',
          status: sl['status']?.toString() ?? '',
          isPublic: sl['isPublic'] == true,
          startDate: sl['startDate'] != null
              ? DateTime.tryParse(sl['startDate'].toString())
              : null,
          endDate: sl['endDate'] != null
              ? DateTime.tryParse(sl['endDate'].toString())
              : null,
          createdAt: sl['createdAt'] != null
              ? DateTime.tryParse(sl['createdAt'].toString())
              : null,
          coverImages: coverImages,
          tags: tags,
        ));
      }
    }

    return SellerStruct(
      id: data['id']?.toString() ?? '',
      username: data['username']?.toString() ?? '',
      avatarUrl: data['avatar_url']?.toString() ?? '',
      bio: data['bio']?.toString(),
      ratingAsSeller: (data['rating_as_seller'] as num?)?.toDouble() ?? 0.0,
      totalReviewsAsSeller:
          (data['total_reviews_as_seller'] as num?)?.toInt() ?? 0,
      ratingAsBuyer: (data['rating_as_buyer'] as num?)?.toDouble() ?? 0.0,
      totalReviewsAsBuyer:
          (data['total_reviews_as_buyer'] as num?)?.toInt() ?? 0,
      totalSales: (data['total_sales'] as num?)?.toInt() ?? 0,
      followersCount: (data['followers_count'] as num?)?.toInt() ?? 0,
      followingCount: (data['following_count'] as num?)?.toInt() ?? 0,
      sellerSince: data['seller_since'] != null
          ? DateTime.tryParse(data['seller_since'].toString())
          : null,
      isPrivate: data['is_private'] == true,
      totalProducts: (data['total_products'] as num?)?.toInt() ?? 0,
      totalShortlists: (data['total_shortlists'] as num?)?.toInt() ?? 0,
      isFollowing: data['is_following'] == true,
      isOwnProfile: data['is_own_profile'] == true,
      isBlocked: data['is_blocked'] == true,
      reviewsAsSeller: reviewsAsSeller,
      reviewsAsBuyer: reviewsAsBuyer,
      purchasedProducts: purchasedProducts,
      shortlists: shortlistsList,
    );
  } catch (e) {
    print('getSellerInfo error: $e');
    return null;
  }
}

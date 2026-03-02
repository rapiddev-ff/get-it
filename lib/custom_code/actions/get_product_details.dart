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

Future<ProductDetailsStruct?> getProductDetails(
  String productId,
  String? userId,
) async {
  try {
    final response = await SupaFlow.client.rpc(
      'get_product_details',
      params: {
        'p_product_id': productId,
        if (userId != null && userId.isNotEmpty) 'p_user_id': userId,
      },
    );

    if (response == null || response['error'] != null) {
      return null;
    }

    final data = response;

    // Parse conditions (array)
    List<ConditionStruct> conditions = [];
    if (data['conditions'] != null && data['conditions'] is List) {
      conditions = (data['conditions'] as List).map((c) {
        return ConditionStruct(
          id: c['id']?.toString() ?? '',
          name: c['name']?.toString() ?? '',
          code: c['code']?.toString() ?? '',
          description: c['description']?.toString() ?? '',
        );
      }).toList();
    }

    // Parse category
    CategoryStruct? category;
    if (data['category'] != null) {
      final cat = data['category'];
      category = CategoryStruct(
        id: cat['id']?.toString() ?? '',
        name: cat['name']?.toString() ?? '',
        slug: cat['slug']?.toString() ?? '',
      );
    }

    // Parse subcategory
    SubcategoryStruct? subcategory;
    if (data['subcategory'] != null) {
      final sub = data['subcategory'];
      subcategory = SubcategoryStruct(
        id: sub['id']?.toString() ?? '',
        name: sub['name']?.toString() ?? '',
        slug: sub['slug']?.toString() ?? '',
      );
    }

    // Parse seller
    SellerStruct? seller;
    if (data['seller'] != null) {
      final s = data['seller'];
      seller = SellerStruct(
        id: s['id']?.toString() ?? '',
        username: s['username']?.toString() ?? '',
        avatarUrl: s['avatar_url']?.toString() ?? '',
        ratingAsSeller: (s['rating'] as num?)?.toDouble() ?? 0.0,
        totalReviewsAsSeller: (s['total_reviews'] as num?)?.toInt() ?? 0,
        totalSales: (s['total_sales'] as num?)?.toInt() ?? 0,
        sellerSince: s['seller_since'] != null
            ? DateTime.tryParse(s['seller_since'].toString())
            : null,
      );
    }

    // Parse images
    List<ProductImageStruct> images = [];
    if (data['images'] != null && data['images'] is List) {
      images = (data['images'] as List).map((img) {
        return ProductImageStruct(
          id: img['id']?.toString() ?? '',
          imageUrl: img['image_url']?.toString() ?? '',
          isMain: img['is_main'] == true,
          sortOrder: (img['sort_order'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    }

    // Parse tags
    List<TagStruct> tags = [];
    if (data['tags'] != null && data['tags'] is List) {
      tags = (data['tags'] as List).map((tag) {
        return TagStruct(
          id: tag['id']?.toString() ?? '',
          name: tag['name']?.toString() ?? '',
          slug: tag['slug']?.toString() ?? '',
        );
      }).toList();
    }

    return ProductDetailsStruct(
      id: data['id']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (data['original_price'] as num?)?.toDouble(),
      flashSaleEnabled: data['flash_sale_enabled'] == true,
      flashSalePrice: (data['flash_sale_price'] as num?)?.toDouble(),
      flashSaleEndsAt: data['flash_sale_ends_at'] != null
          ? DateTime.tryParse(data['flash_sale_ends_at'].toString())
          : null,
      discountType: data['discount_type']?.toString(),
      discountAmount: (data['discount_amount'] as num?)?.toDouble(),
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
      year: (data['year'] as num?)?.toInt(),
      issueNumber: (data['issue_number'] as num?)?.toInt(),
      sku: data['sku']?.toString(),
      skuNumber: data['sku_number']?.toString(),
      shippingInfo: data['shipping_info']?.toString(),
      shippingPrice: (data['shipping_price'] as num?)?.toDouble() ?? 0.0,
      freeShipping: data['free_shipping'] == true,
      useSellerShipping: data['use_seller_shipping'] == true,
      customFlatRate: (data['custom_flat_rate'] as num?)?.toDouble(),
      customAdditionalItemFee:
          (data['custom_additional_item_fee'] as num?)?.toDouble(),
      shortlistId: data['shortlist_id']?.toString(),
      viewsCount: (data['views_count'] as num?)?.toInt() ?? 0,
      status: data['status']?.toString() ?? '',
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'].toString())
          : null,
      conditions: conditions,
      category: category,
      subcategory: subcategory,
      seller: seller,
      images: images,
      tags: tags,
      isInWishlist: data['is_in_wishlist'] == true,
      isOwnProduct: data['is_own_product'] == true,
    );
  } catch (e) {
    print('getProductDetails error: $e');
    return null;
  }
}

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/features/home/domain/models/feed_product_model.dart';
import '/features/home/domain/models/product_details_model.dart';
import '/features/home/domain/models/product_image_model.dart';
import '/features/home/domain/models/seller_model.dart';
import '/features/browse/domain/models/category_model.dart';
import '/features/browse/domain/models/subcategory_model.dart';
import '/features/browse/domain/models/condition_model.dart';
import '/features/browse/domain/models/tag_model.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository(Supabase.instance.client);
});

class ProductRepository {
  final SupabaseClient _client;

  ProductRepository(this._client);

  /// Fetches feed products via RPC, excluding already-seen products.
  Future<List<FeedProduct>> getFeedProducts(
    String userId,
    List<String> excludeIds,
  ) async {
    try {
      Map<String, dynamic> params = {};
      if (userId.isNotEmpty) {
        params['p_user_id'] = userId;
      }
      if (excludeIds.isNotEmpty) {
        params['p_exclude_ids'] = excludeIds;
      }

      final response =
          await _client.rpc('get_feed_products', params: params);

      if (response is List && response.isNotEmpty) {
        return response.map((item) => _parseFeedProduct(item)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Subscribes to realtime product changes and calls [onUpdate] when products change.
  RealtimeChannel subscribeFeedProducts(void Function() onUpdate) {
    return _client
        .channel('products_feed_channel')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'products',
          callback: (_) => onUpdate(),
        )
        .subscribe();
  }

  /// Fetches detailed product info including seller, images, tags, etc.
  Future<ProductDetails?> getProductDetails(
    String productId,
    String? userId,
  ) async {
    try {
      final response = await _client.rpc(
        'get_product_details',
        params: {
          'p_product_id': productId,
          if (userId != null && userId.isNotEmpty) 'p_user_id': userId,
        },
      );

      if (response == null || response['error'] != null) {
        return null;
      }

      return _parseProductDetails(response);
    } catch (e) {
      return null;
    }
  }

  /// Tracks a product view.
  Future<void> trackProductView(String productId, String? userId) async {
    try {
      await _client.rpc('track_product_view', params: {
        'p_product_id': productId,
        if (userId != null) 'p_user_id': userId,
      });
    } catch (_) {}
  }

  /// Hides a product (soft delete).
  Future<void> hideProduct(String productId) async {
    await _client.from('products').update({
      'deleted_at': DateTime.now().toUtc().toIso8601String(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('id', productId);
  }

  /// Fetches seller info with reviews and products.
  Future<Map<String, dynamic>?> getSellerInfo(
    String sellerId,
    String? currentUserId,
  ) async {
    try {
      final response = await _client.rpc(
        'get_user_profile_with_reviews',
        params: {
          'p_user_id': sellerId,
          if (currentUserId != null) 'p_current_user_id': currentUserId,
        },
      );
      return response is Map<String, dynamic> ? response : null;
    } catch (_) {
      return null;
    }
  }

  // -- Private parsers --

  FeedProduct _parseFeedProduct(dynamic item) {
    return FeedProduct(
      id: item['id']?.toString() ?? '',
      title: item['title']?.toString() ?? '',
      description: item['description']?.toString() ?? '',
      price: double.tryParse(item['price']?.toString() ?? '0') ?? 0.0,
      originalPrice:
          double.tryParse(item['original_price']?.toString() ?? '0'),
      flashSaleEnabled: item['flash_sale_enabled'] ?? false,
      flashSalePrice:
          double.tryParse(item['flash_sale_price']?.toString() ?? '0'),
      flashSaleEndsAt: item['flash_sale_ends_at'] != null
          ? DateTime.tryParse(item['flash_sale_ends_at'].toString())
          : null,
      conditionName: item['condition_name']?.toString() ?? '',
      mainImageUrl: item['main_image_url']?.toString() ?? '',
      sellerId: item['seller_id']?.toString() ?? '',
      sellerUsername: item['seller_username']?.toString() ?? '',
      sellerAvatarUrl: item['seller_avatar_url']?.toString(),
      sellerRating:
          double.tryParse(item['seller_rating']?.toString() ?? '0') ?? 0.0,
      sellerTotalReviews:
          int.tryParse(item['seller_total_reviews']?.toString() ?? '0') ?? 0,
      isInWishlist: item['is_in_wishlist'] ?? false,
      createdAt: item['created_at'] != null
          ? DateTime.tryParse(item['created_at'].toString())
          : null,
      shippingPrice:
          double.tryParse(item['shipping_price']?.toString() ?? '0') ?? 0.0,
      freeShipping: item['free_shipping'] ?? false,
      useSellerShipping: item['use_seller_shipping'] ?? false,
      customFlatRate:
          double.tryParse(item['custom_flat_rate']?.toString() ?? '0'),
      customAdditionalItemFee: double.tryParse(
          item['custom_additional_item_fee']?.toString() ?? '0'),
    );
  }

  ProductDetails _parseProductDetails(Map<String, dynamic> data) {
    List<Condition> conditions = [];
    if (data['conditions'] != null && data['conditions'] is List) {
      conditions = (data['conditions'] as List).map((c) {
        return Condition(
          id: c['id']?.toString() ?? '',
          name: c['name']?.toString() ?? '',
          code: c['code']?.toString() ?? '',
          description: c['description']?.toString() ?? '',
        );
      }).toList();
    }

    Category? category;
    if (data['category'] != null) {
      final cat = data['category'];
      category = Category(
        id: cat['id']?.toString() ?? '',
        name: cat['name']?.toString() ?? '',
        slug: cat['slug']?.toString() ?? '',
      );
    }

    Subcategory? subcategory;
    if (data['subcategory'] != null) {
      final sub = data['subcategory'];
      subcategory = Subcategory(
        id: sub['id']?.toString() ?? '',
        name: sub['name']?.toString() ?? '',
        categoryId: sub['category_id']?.toString() ?? '',
      );
    }

    Seller? seller;
    if (data['seller'] != null) {
      final s = data['seller'];
      seller = Seller(
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

    List<ProductImage> images = [];
    if (data['images'] != null && data['images'] is List) {
      images = (data['images'] as List).map((img) {
        return ProductImage(
          id: img['id']?.toString() ?? '',
          imageUrl: img['image_url']?.toString() ?? '',
          isMain: img['is_main'] == true,
          sortOrder: (img['sort_order'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    }

    List<Tag> tags = [];
    if (data['tags'] != null && data['tags'] is List) {
      tags = (data['tags'] as List).map((tag) {
        return Tag(
          id: tag['id']?.toString() ?? '',
          name: tag['name']?.toString() ?? '',
          slug: tag['slug']?.toString() ?? '',
        );
      }).toList();
    }

    return ProductDetails(
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
  }
}

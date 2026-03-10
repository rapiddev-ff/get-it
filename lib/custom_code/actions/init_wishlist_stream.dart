import '/features/home/domain/models/product_details_model.dart';
import '/features/home/domain/models/product_image_model.dart';
import '/features/home/domain/models/seller_model.dart';
import '/features/browse/domain/models/category_model.dart';
import '/features/browse/domain/models/subcategory_model.dart';
import '/features/browse/domain/models/condition_model.dart';
import '/features/browse/domain/models/tag_model.dart';
import '/features/wishlist/presentation/providers/wishlist_provider.dart';
import '/backend/supabase/supabase.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

RealtimeChannel? _wishlistSubscription;

Future<List<ProductDetails>> initWishlistStream(
  WidgetRef ref,
  String userId,
) async {
  final data = await _fetchWishlistProducts(userId);

  ref.read(wishlistProvider.notifier).setProducts(data);

  _wishlistSubscription?.unsubscribe();
  _wishlistSubscription = Supabase.instance.client
      .channel('wishlist_channel_$userId')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'wishlists',
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: 'user_id',
          value: userId,
        ),
        callback: (payload) async {
          final freshData = await _fetchWishlistProducts(userId);
          ref.read(wishlistProvider.notifier).setProducts(freshData);
        },
      )
      .subscribe();

  return data;
}

Future<List<ProductDetails>> _fetchWishlistProducts(String userId) async {
  try {
    final response = await SupaFlow.client.rpc(
      'get_wishlist_products',
      params: {'p_user_id': userId},
    );

    if (response is! List || response.isEmpty) return [];

    return response.map<ProductDetails>((item) {
      return ProductDetails(
        id: item['id']?.toString() ?? '',
        title: item['title']?.toString() ?? '',
        description: item['description']?.toString() ?? '',
        price: (item['price'] as num?)?.toDouble() ?? 0.0,
        originalPrice: (item['original_price'] as num?)?.toDouble(),
        flashSaleEnabled: item['flash_sale_enabled'] == true,
        flashSalePrice: (item['flash_sale_price'] as num?)?.toDouble(),
        flashSaleEndsAt: item['flash_sale_ends_at'] != null
            ? DateTime.tryParse(item['flash_sale_ends_at'].toString())
            : null,
        discountType: item['discount_type']?.toString(),
        discountAmount: (item['discount_amount'] as num?)?.toDouble(),
        quantity: (item['quantity'] as num?)?.toInt() ?? 0,
        year: (item['year'] as num?)?.toInt(),
        issueNumber: (item['issue_number'] as num?)?.toInt(),
        sku: item['sku']?.toString(),
        shippingInfo: item['shipping_info']?.toString(),
        shippingPrice: (item['shipping_price'] as num?)?.toDouble() ?? 0.0,
        freeShipping: item['free_shipping'] == true,
        useSellerShipping: item['use_seller_shipping'] == true,
        customFlatRate: (item['custom_flat_rate'] as num?)?.toDouble(),
        customAdditionalItemFee:
            (item['custom_additional_item_fee'] as num?)?.toDouble(),
        shortlistId: item['shortlist_id']?.toString(),
        viewsCount: (item['views_count'] as num?)?.toInt() ?? 0,
        status: item['status']?.toString() ?? '',
        createdAt: item['created_at'] != null
            ? DateTime.tryParse(item['created_at'].toString())
            : null,

        // Nested objects
        conditions: _parseConditions(item['conditions']),
        category: _parseCategory(item['category']),
        subcategory: _parseSubcategory(item['subcategory']),
        seller: _parseSeller(item['seller']),

        // Lists
        images: _parseImages(item['images']),
        tags: _parseTags(item['tags']),

        // Flags
        isInWishlist: item['is_in_wishlist'] ?? true,
        isOwnProduct: item['is_own_product'] ?? false,
      );
    }).toList();
  } catch (_) {
    return [];
  }
}

List<Condition> _parseConditions(dynamic json) {
  if (json == null || json is! List) return [];
  return json.map<Condition>((c) {
    return Condition(
      id: c['id']?.toString() ?? '',
      name: c['name']?.toString() ?? '',
      code: c['code']?.toString() ?? '',
      description: c['description']?.toString() ?? '',
    );
  }).toList();
}

Category? _parseCategory(dynamic json) {
  if (json == null) return null;
  final data = json as Map<String, dynamic>;
  return Category(
    id: data['id']?.toString() ?? '',
    name: data['name']?.toString() ?? '',
    slug: data['slug']?.toString() ?? '',
  );
}

Subcategory? _parseSubcategory(dynamic json) {
  if (json == null) return null;
  final data = json as Map<String, dynamic>;
  return Subcategory(
    id: data['id']?.toString() ?? '',
    name: data['name']?.toString() ?? '',
    categoryId: data['category_id']?.toString() ?? '',
  );
}

Seller? _parseSeller(dynamic json) {
  if (json == null) return null;
  final data = json as Map<String, dynamic>;
  return Seller(
    id: data['id']?.toString() ?? '',
    username: data['username']?.toString() ?? '',
    avatarUrl: data['avatar_url']?.toString() ?? '',
    ratingAsSeller: (data['rating'] as num?)?.toDouble() ?? 0.0,
    totalReviewsAsSeller: (data['total_reviews'] as num?)?.toInt() ?? 0,
    totalSales: (data['total_sales'] as num?)?.toInt() ?? 0,
    sellerSince: data['seller_since'] != null
        ? DateTime.tryParse(data['seller_since'].toString())
        : null,
  );
}

List<ProductImage> _parseImages(dynamic json) {
  if (json == null || json is! List) return [];
  return json.map<ProductImage>((item) {
    return ProductImage(
      id: item['id']?.toString() ?? '',
      imageUrl: item['image_url']?.toString() ?? '',
      isMain: item['is_main'] == true,
      sortOrder: (item['sort_order'] as num?)?.toInt() ?? 0,
    );
  }).toList();
}

List<Tag> _parseTags(dynamic json) {
  if (json == null || json is! List) return [];
  return json.map<Tag>((item) {
    return Tag(
      id: item['id']?.toString() ?? '',
      name: item['name']?.toString() ?? '',
      slug: item['slug']?.toString() ?? '',
    );
  }).toList();
}

Future disposeWishlistStream() async {
  _wishlistSubscription?.unsubscribe();
  _wishlistSubscription = null;
}

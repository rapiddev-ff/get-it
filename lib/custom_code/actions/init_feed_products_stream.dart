import '/features/home/domain/models/feed_product_model.dart';
import '/features/home/presentation/providers/feed_provider.dart';
import '/backend/supabase/supabase.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

RealtimeChannel? _feedProductsSubscription;

Future<List<FeedProduct>> initFeedProductsStream(
  WidgetRef ref,
  String userId,
  List<String> excludeIds,
) async {
  final data = await _fetchAllFeedProducts(userId, excludeIds);

  ref.read(feedProvider.notifier).setFeedProducts(data);

  _feedProductsSubscription?.unsubscribe();
  _feedProductsSubscription = Supabase.instance.client
      .channel('products_feed_channel')
      .onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'products',
        callback: (payload) async {
          final freshData = await _fetchAllFeedProducts(
            userId,
            ref.read(feedProvider).swipedProductIds,
          );
          ref.read(feedProvider.notifier).setFeedProducts(freshData);
        },
      )
      .subscribe();

  return data;
}

Future<List<FeedProduct>> _fetchAllFeedProducts(
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
        await SupaFlow.client.rpc('get_feed_products', params: params);

    if (response is List && response.isNotEmpty) {
      return response.map((item) {
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
              int.tryParse(item['seller_total_reviews']?.toString() ?? '0') ??
                  0,
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
      }).toList();
    }
    return [];
  } catch (_) {
    return [];
  }
}

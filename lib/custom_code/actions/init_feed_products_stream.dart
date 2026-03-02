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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

RealtimeChannel? _feedProductsSubscription;

Future<List<FeedProductStruct>> initFeedProductsStream(
  String userId,
  List<String> excludeIds,
) async {
  final data = await _fetchAllFeedProducts(userId, excludeIds);

  FFAppState().update(() {
    FFAppState().feedProducts = data;
  });

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
            FFAppState().swipedProductIds,
          );
          FFAppState().update(() {
            FFAppState().feedProducts = freshData;
          });
        },
      )
      .subscribe();

  return data;
}

Future<List<FeedProductStruct>> _fetchAllFeedProducts(
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
        return FeedProductStruct(
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
  } catch (e) {
    print('_fetchAllFeedProducts error: $e');
    return [];
  }
}

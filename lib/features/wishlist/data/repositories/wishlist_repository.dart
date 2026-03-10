import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  return WishlistRepository(Supabase.instance.client);
});

class WishlistRepository {
  final SupabaseClient _client;

  WishlistRepository(this._client);

  /// Toggles wishlist status for a product.
  /// Returns true if the product is now in the wishlist, false otherwise.
  Future<bool> toggleWishlist(String userId, String productId) async {
    try {
      final response = await _client.rpc(
        'toggle_wishlist',
        params: {
          'p_user_id': userId,
          'p_product_id': productId,
        },
      );

      if (response != null && response['success'] == true) {
        return response['is_in_wishlist'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Fetches wishlist products for a user.
  Future<List<Map<String, dynamic>>> getWishlistProducts(String userId) async {
    try {
      final response = await _client.rpc(
        'get_wishlist_products',
        params: {'p_user_id': userId},
      );

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Subscribes to wishlist changes and calls [onUpdate].
  RealtimeChannel subscribeWishlistChanges(
    String userId,
    void Function() onUpdate,
  ) {
    return _client
        .channel('wishlist_channel_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'wishlist',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (_) => onUpdate(),
        )
        .subscribe();
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:get_it/features/wishlist/data/repositories/wishlist_repository.dart';

import '../helpers/mock_supabase.dart';

void main() {
  late MockSupabaseClient mockClient;
  late WishlistRepository repository;

  setUp(() {
    mockClient = MockSupabaseClient();
    repository = WishlistRepository(mockClient);
  });

  // ---------------------------------------------------------------------------
  // toggleWishlist
  // ---------------------------------------------------------------------------
  group('toggleWishlist', () {
    test('returns true when RPC indicates item added to wishlist', () async {
      stubRpcSuccess(mockClient, 'toggle_wishlist', {
        'success': true,
        'is_in_wishlist': true,
      });

      final result = await repository.toggleWishlist('user-1', 'product-1');

      expect(result, isTrue);
    });

    test('returns false when RPC indicates item removed from wishlist',
        () async {
      stubRpcSuccess(mockClient, 'toggle_wishlist', {
        'success': true,
        'is_in_wishlist': false,
      });

      final result = await repository.toggleWishlist('user-1', 'product-1');

      expect(result, isFalse);
    });

    test('returns false when RPC success is false', () async {
      stubRpcSuccess(mockClient, 'toggle_wishlist', {
        'success': false,
        'is_in_wishlist': true,
      });

      final result = await repository.toggleWishlist('user-1', 'product-1');

      expect(result, isFalse);
    });

    test('returns false when RPC returns null', () async {
      stubRpcSuccess(mockClient, 'toggle_wishlist', null);

      final result = await repository.toggleWishlist('user-1', 'product-1');

      expect(result, isFalse);
    });

    test('returns false on exception', () async {
      stubRpcError(mockClient, 'toggle_wishlist', Exception('Network error'));

      final result = await repository.toggleWishlist('user-1', 'product-1');

      expect(result, isFalse);
    });

    test('passes userId and productId params', () async {
      stubRpcSuccess(mockClient, 'toggle_wishlist', {
        'success': true,
        'is_in_wishlist': true,
      });

      await repository.toggleWishlist('user-abc', 'product-xyz');

      final captured = verify(() => mockClient.rpc(
            'toggle_wishlist',
            params: captureAny(named: 'params'),
          )).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_user_id'], 'user-abc');
      expect(params['p_product_id'], 'product-xyz');
    });
  });

  // ---------------------------------------------------------------------------
  // getWishlistProducts
  // ---------------------------------------------------------------------------
  group('getWishlistProducts', () {
    final rawWishlistItems = [
      {
        'id': 'prod-1',
        'title': 'Amazing Spider-Man #1',
        'price': 120.0,
        'main_image_url': 'https://example.com/asm1.jpg',
      },
      {
        'id': 'prod-2',
        'title': 'X-Men #94',
        'price': 200.0,
        'main_image_url': 'https://example.com/xmen94.jpg',
      },
    ];

    test('returns list of maps on success', () async {
      stubRpcSuccess(mockClient, 'get_wishlist_products', rawWishlistItems);

      final result = await repository.getWishlistProducts('user-1');

      expect(result, hasLength(2));
      expect(result.first, isA<Map<String, dynamic>>());
      expect(result[0]['id'], 'prod-1');
      expect(result[0]['title'], 'Amazing Spider-Man #1');
      expect(result[1]['id'], 'prod-2');
    });

    test('returns empty list when RPC returns empty list', () async {
      stubRpcSuccess(mockClient, 'get_wishlist_products', <dynamic>[]);

      final result = await repository.getWishlistProducts('user-1');

      expect(result, isEmpty);
    });

    test('returns empty list when RPC returns null', () async {
      stubRpcSuccess(mockClient, 'get_wishlist_products', null);

      final result = await repository.getWishlistProducts('user-1');

      expect(result, isEmpty);
    });

    test('returns empty list on exception', () async {
      stubRpcError(
          mockClient, 'get_wishlist_products', Exception('Timeout'));

      final result = await repository.getWishlistProducts('user-1');

      expect(result, isEmpty);
    });

    test('passes userId param', () async {
      stubRpcSuccess(mockClient, 'get_wishlist_products', rawWishlistItems);

      await repository.getWishlistProducts('user-abc');

      final captured = verify(() => mockClient.rpc(
            'get_wishlist_products',
            params: captureAny(named: 'params'),
          )).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_user_id'], 'user-abc');
    });
  });
}

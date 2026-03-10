import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:get_it/features/home/data/repositories/product_repository.dart';
import 'package:get_it/features/home/domain/models/feed_product_model.dart';
import 'package:get_it/features/home/domain/models/product_details_model.dart';

import '../helpers/mock_supabase.dart';

void main() {
  late MockSupabaseClient mockClient;
  late ProductRepository repository;

  setUp(() {
    mockClient = MockSupabaseClient();
    repository = ProductRepository(mockClient);
  });

  // ---------------------------------------------------------------------------
  // getFeedProducts
  // ---------------------------------------------------------------------------
  group('getFeedProducts', () {
    final rawFeedList = [
      {
        'id': 'prod-1',
        'title': 'Amazing Spider-Man #1',
        'description': 'First appearance',
        'price': '120.00',
        'original_price': '150.00',
        'flash_sale_enabled': false,
        'flash_sale_price': null,
        'flash_sale_ends_at': null,
        'condition_name': 'Very Good',
        'main_image_url': 'https://example.com/asm1.jpg',
        'seller_id': 'seller-1',
        'seller_username': 'comicguy',
        'seller_avatar_url': null,
        'seller_rating': '4.8',
        'seller_total_reviews': '22',
        'is_in_wishlist': false,
        'created_at': '2024-01-15T12:00:00.000Z',
        'shipping_price': '5.00',
        'free_shipping': false,
        'use_seller_shipping': true,
        'custom_flat_rate': null,
        'custom_additional_item_fee': null,
      },
      {
        'id': 'prod-2',
        'title': 'X-Men #94',
        'description': 'New X-Men begin',
        'price': '200.00',
        'original_price': null,
        'flash_sale_enabled': true,
        'flash_sale_price': '180.00',
        'flash_sale_ends_at': '2025-06-30T00:00:00.000Z',
        'condition_name': 'Fine',
        'main_image_url': 'https://example.com/xmen94.jpg',
        'seller_id': 'seller-2',
        'seller_username': 'xfan',
        'seller_avatar_url': 'https://example.com/xfan.jpg',
        'seller_rating': '4.5',
        'seller_total_reviews': '10',
        'is_in_wishlist': true,
        'created_at': null,
        'shipping_price': '0.00',
        'free_shipping': true,
        'use_seller_shipping': false,
        'custom_flat_rate': '3.00',
        'custom_additional_item_fee': '1.00',
      },
    ];

    test('returns parsed FeedProduct list on success', () async {
      stubRpcSuccess(mockClient, 'get_feed_products', rawFeedList);

      final result = await repository.getFeedProducts('user-1', []);

      expect(result, hasLength(2));
      expect(result.first, isA<FeedProduct>());
      expect(result[0].id, 'prod-1');
      expect(result[0].title, 'Amazing Spider-Man #1');
      expect(result[0].price, 120.0);
      expect(result[0].originalPrice, 150.0);
      expect(result[0].flashSaleEnabled, isFalse);
      expect(result[0].conditionName, 'Very Good');
      expect(result[0].sellerId, 'seller-1');
      expect(result[0].sellerUsername, 'comicguy');
      expect(result[0].sellerRating, 4.8);
      expect(result[0].sellerTotalReviews, 22);
      expect(result[0].isInWishlist, isFalse);
      expect(result[0].freeShipping, isFalse);
      expect(result[0].useSellerShipping, isTrue);
    });

    test('parses second product fields including flash sale', () async {
      stubRpcSuccess(mockClient, 'get_feed_products', rawFeedList);

      final result = await repository.getFeedProducts('user-1', []);

      expect(result[1].id, 'prod-2');
      expect(result[1].price, 200.0);
      expect(result[1].flashSaleEnabled, isTrue);
      expect(result[1].flashSalePrice, 180.0);
      expect(result[1].flashSaleEndsAt,
          DateTime.parse('2025-06-30T00:00:00.000Z'));
      expect(result[1].isInWishlist, isTrue);
      expect(result[1].freeShipping, isTrue);
      expect(result[1].sellerAvatarUrl, 'https://example.com/xfan.jpg');
      expect(result[1].customFlatRate, 3.0);
      expect(result[1].customAdditionalItemFee, 1.0);
    });

    test('returns empty list when RPC returns empty list', () async {
      stubRpcSuccess(mockClient, 'get_feed_products', <dynamic>[]);

      final result = await repository.getFeedProducts('user-1', []);

      expect(result, isEmpty);
    });

    test('returns empty list when RPC returns null', () async {
      stubRpcSuccess(mockClient, 'get_feed_products', null);

      final result = await repository.getFeedProducts('user-1', []);

      expect(result, isEmpty);
    });

    test('returns empty list on network error', () async {
      stubRpcError(
          mockClient, 'get_feed_products', Exception('Network timeout'));

      final result = await repository.getFeedProducts('user-1', []);

      expect(result, isEmpty);
    });

    test('passes userId param when userId is not empty', () async {
      stubRpcSuccess(mockClient, 'get_feed_products', rawFeedList);

      await repository.getFeedProducts('user-abc', []);

      final captured = verify(() => mockClient.rpc(
            'get_feed_products',
            params: captureAny(named: 'params'),
          )).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_user_id'], 'user-abc');
    });

    test('omits userId param when userId is empty', () async {
      stubRpcSuccess(mockClient, 'get_feed_products', rawFeedList);

      await repository.getFeedProducts('', []);

      final captured = verify(() => mockClient.rpc(
            'get_feed_products',
            params: captureAny(named: 'params'),
          )).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params.containsKey('p_user_id'), isFalse);
    });

    test('passes excludeIds param when list is not empty', () async {
      stubRpcSuccess(mockClient, 'get_feed_products', rawFeedList);

      await repository.getFeedProducts('user-1', ['id-a', 'id-b']);

      final captured = verify(() => mockClient.rpc(
            'get_feed_products',
            params: captureAny(named: 'params'),
          )).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_exclude_ids'], containsAll(['id-a', 'id-b']));
    });

    test('omits excludeIds param when list is empty', () async {
      stubRpcSuccess(mockClient, 'get_feed_products', rawFeedList);

      await repository.getFeedProducts('user-1', []);

      final captured = verify(() => mockClient.rpc(
            'get_feed_products',
            params: captureAny(named: 'params'),
          )).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params.containsKey('p_exclude_ids'), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // getProductDetails
  // ---------------------------------------------------------------------------
  group('getProductDetails', () {
    final rawProductDetails = {
      'id': 'product-xyz',
      'title': 'Fantastic Four #1',
      'description': 'The first Marvel family',
      'price': 5000.0,
      'original_price': null,
      'flash_sale_enabled': false,
      'flash_sale_price': null,
      'flash_sale_ends_at': null,
      'discount_type': null,
      'discount_amount': null,
      'quantity': 1,
      'year': 1961,
      'issue_number': 1,
      'sku': 'FF-001',
      'sku_number': null,
      'shipping_info': 'Ships in 3-5 days',
      'shipping_price': 8.0,
      'free_shipping': false,
      'use_seller_shipping': false,
      'custom_flat_rate': null,
      'custom_additional_item_fee': null,
      'shortlist_id': null,
      'views_count': 142,
      'status': 'active',
      'created_at': '2024-02-01T08:00:00.000Z',
      'is_in_wishlist': false,
      'is_own_product': false,
      'conditions': [
        {
          'id': 'cond-1',
          'name': 'Fine',
          'code': 'FN',
          'description': 'Minimal wear',
        }
      ],
      'category': {
        'id': 'cat-1',
        'name': 'Comics',
        'slug': 'comics',
      },
      'subcategory': {
        'id': 'sub-1',
        'name': 'Silver Age',
        'category_id': 'cat-1',
      },
      'seller': {
        'id': 'seller-1',
        'username': 'comicvault',
        'avatar_url': 'https://example.com/vault.jpg',
        'rating': 4.9,
        'total_reviews': 300,
        'total_sales': 1200,
        'seller_since': '2020-01-01T00:00:00.000Z',
      },
      'images': [
        {
          'id': 'img-1',
          'image_url': 'https://example.com/ff1.jpg',
          'is_main': true,
          'sort_order': 0,
        }
      ],
      'tags': [
        {
          'id': 'tag-1',
          'name': 'Silver Age',
          'slug': 'silver-age',
        }
      ],
    };

    test('returns ProductDetails on success', () async {
      stubRpcSuccess(mockClient, 'get_product_details', rawProductDetails);

      final result =
          await repository.getProductDetails('product-xyz', 'user-1');

      expect(result, isA<ProductDetails>());
      expect(result!.id, 'product-xyz');
      expect(result.title, 'Fantastic Four #1');
      expect(result.price, 5000.0);
      expect(result.year, 1961);
      expect(result.issueNumber, 1);
      expect(result.viewsCount, 142);
      expect(result.status, 'active');
    });

    test('parses nested seller correctly', () async {
      stubRpcSuccess(mockClient, 'get_product_details', rawProductDetails);

      final result =
          await repository.getProductDetails('product-xyz', 'user-1');

      expect(result!.seller, isNotNull);
      expect(result.seller!.id, 'seller-1');
      expect(result.seller!.username, 'comicvault');
      expect(result.seller!.ratingAsSeller, 4.9);
      expect(result.seller!.totalSales, 1200);
    });

    test('parses conditions list', () async {
      stubRpcSuccess(mockClient, 'get_product_details', rawProductDetails);

      final result =
          await repository.getProductDetails('product-xyz', 'user-1');

      expect(result!.conditions, hasLength(1));
      expect(result.conditions.first.name, 'Fine');
      expect(result.conditions.first.code, 'FN');
    });

    test('parses category and subcategory', () async {
      stubRpcSuccess(mockClient, 'get_product_details', rawProductDetails);

      final result =
          await repository.getProductDetails('product-xyz', 'user-1');

      expect(result!.category, isNotNull);
      expect(result.category!.name, 'Comics');
      expect(result.subcategory, isNotNull);
      expect(result.subcategory!.name, 'Silver Age');
    });

    test('parses images and tags', () async {
      stubRpcSuccess(mockClient, 'get_product_details', rawProductDetails);

      final result =
          await repository.getProductDetails('product-xyz', 'user-1');

      expect(result!.images, hasLength(1));
      expect(result.images.first.isMain, isTrue);
      expect(result.tags, hasLength(1));
      expect(result.tags.first.name, 'Silver Age');
    });

    test('returns null when RPC response contains error key', () async {
      stubRpcSuccess(mockClient, 'get_product_details', {'error': 'not found'});

      final result =
          await repository.getProductDetails('nonexistent', 'user-1');

      expect(result, isNull);
    });

    test('returns null when RPC returns null', () async {
      stubRpcSuccess(mockClient, 'get_product_details', null);

      final result = await repository.getProductDetails('any-id', null);

      expect(result, isNull);
    });

    test('returns null on exception', () async {
      stubRpcError(
          mockClient, 'get_product_details', Exception('Connection refused'));

      final result =
          await repository.getProductDetails('product-xyz', 'user-1');

      expect(result, isNull);
    });

    test('passes productId and userId params correctly', () async {
      stubRpcSuccess(mockClient, 'get_product_details', rawProductDetails);

      await repository.getProductDetails('product-xyz', 'user-99');

      final captured = verify(() => mockClient.rpc(
            'get_product_details',
            params: captureAny(named: 'params'),
          )).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_product_id'], 'product-xyz');
      expect(params['p_user_id'], 'user-99');
    });

    test('omits p_user_id when userId is null', () async {
      stubRpcSuccess(mockClient, 'get_product_details', rawProductDetails);

      await repository.getProductDetails('product-xyz', null);

      final captured = verify(() => mockClient.rpc(
            'get_product_details',
            params: captureAny(named: 'params'),
          )).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params.containsKey('p_user_id'), isFalse);
    });

    test('omits p_user_id when userId is empty string', () async {
      stubRpcSuccess(mockClient, 'get_product_details', rawProductDetails);

      await repository.getProductDetails('product-xyz', '');

      final captured = verify(() => mockClient.rpc(
            'get_product_details',
            params: captureAny(named: 'params'),
          )).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params.containsKey('p_user_id'), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // getSellerInfo
  // ---------------------------------------------------------------------------
  group('getSellerInfo', () {
    test('returns seller map on success', () async {
      final sellerData = {
        'id': 'seller-1',
        'username': 'topcomic',
        'rating': 4.7,
      };
      stubRpcSuccess(
          mockClient, 'get_user_profile_with_reviews', sellerData);

      final result = await repository.getSellerInfo('seller-1', 'user-1');

      expect(result, isNotNull);
      expect(result!['username'], 'topcomic');
    });

    test('returns null when RPC returns non-map value', () async {
      stubRpcSuccess(mockClient, 'get_user_profile_with_reviews', 'invalid');

      final result = await repository.getSellerInfo('seller-1', null);

      expect(result, isNull);
    });

    test('returns null on exception', () async {
      stubRpcError(
        mockClient,
        'get_user_profile_with_reviews',
        Exception('Timeout'),
      );

      final result = await repository.getSellerInfo('seller-1', null);

      expect(result, isNull);
    });
  });

  // ---------------------------------------------------------------------------
  // trackProductView
  // ---------------------------------------------------------------------------
  group('trackProductView', () {
    test('calls rpc with correct productId param', () async {
      stubRpcSuccess(mockClient, 'track_product_view', null);

      await repository.trackProductView('product-1', 'user-1');

      final captured = verify(() => mockClient.rpc(
            'track_product_view',
            params: captureAny(named: 'params'),
          )).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_product_id'], 'product-1');
    });

    test('does not throw on exception', () async {
      stubRpcError(
          mockClient, 'track_product_view', Exception('Server error'));

      // trackProductView silently catches errors — should complete normally
      await expectLater(
        repository.trackProductView('product-1', 'user-1'),
        completes,
      );
    });
  });
}

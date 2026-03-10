import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/features/home/domain/models/feed_product_model.dart';

void main() {
  group('FeedProduct', () {
    // ---------------------------------------------------------------------------
    // Default values
    // ---------------------------------------------------------------------------
    group('default values', () {
      test('const constructor produces expected defaults', () {
        const product = FeedProduct();

        expect(product.id, '');
        expect(product.sellerId, '');
        expect(product.title, '');
        expect(product.description, '');
        expect(product.price, 0.0);
        expect(product.originalPrice, isNull);
        expect(product.flashSaleEnabled, isFalse);
        expect(product.flashSalePrice, isNull);
        expect(product.flashSaleEndsAt, isNull);
        expect(product.mainImageUrl, '');
        expect(product.categoryName, '');
        expect(product.conditionName, '');
        expect(product.sellerUsername, '');
        expect(product.sellerAvatarUrl, isNull);
        expect(product.sellerRating, 0.0);
        expect(product.sellerTotalReviews, 0);
        expect(product.isInWishlist, isFalse);
        expect(product.createdAt, isNull);
        expect(product.shippingPrice, 0.0);
        expect(product.freeShipping, isFalse);
        expect(product.useSellerShipping, isFalse);
        expect(product.customFlatRate, isNull);
        expect(product.customAdditionalItemFee, isNull);
      });
    });

    // ---------------------------------------------------------------------------
    // fromJson / toJson round-trip
    // ---------------------------------------------------------------------------
    group('fromJson / toJson', () {
      test('deserializes all fields from JSON correctly', () {
        final json = <String, dynamic>{
          'id': 'fp-1',
          'sellerId': 'seller-fp-1',
          'title': 'Incredible Hulk #181',
          'description': 'First Wolverine appearance',
          'price': 850.0,
          'originalPrice': 1000.0,
          'flashSaleEnabled': true,
          'flashSalePrice': 750.0,
          'flashSaleEndsAt': '2025-06-30T23:59:59.000Z',
          'mainImageUrl': 'https://example.com/hulk181.jpg',
          'categoryName': 'Comics',
          'conditionName': 'Fine',
          'sellerUsername': 'marvelfan',
          'sellerAvatarUrl': 'https://example.com/marvelfan.jpg',
          'sellerRating': 4.9,
          'sellerTotalReviews': 78,
          'isInWishlist': true,
          'createdAt': '2024-02-20T08:00:00.000Z',
          'shippingPrice': 5.99,
          'freeShipping': false,
          'useSellerShipping': true,
          'customFlatRate': 4.0,
          'customAdditionalItemFee': 1.50,
        };

        final product = FeedProduct.fromJson(json);

        expect(product.id, 'fp-1');
        expect(product.sellerId, 'seller-fp-1');
        expect(product.title, 'Incredible Hulk #181');
        expect(product.description, 'First Wolverine appearance');
        expect(product.price, 850.0);
        expect(product.originalPrice, 1000.0);
        expect(product.flashSaleEnabled, isTrue);
        expect(product.flashSalePrice, 750.0);
        expect(product.flashSaleEndsAt,
            DateTime.parse('2025-06-30T23:59:59.000Z'));
        expect(product.mainImageUrl, 'https://example.com/hulk181.jpg');
        expect(product.categoryName, 'Comics');
        expect(product.conditionName, 'Fine');
        expect(product.sellerUsername, 'marvelfan');
        expect(product.sellerAvatarUrl, 'https://example.com/marvelfan.jpg');
        expect(product.sellerRating, 4.9);
        expect(product.sellerTotalReviews, 78);
        expect(product.isInWishlist, isTrue);
        expect(product.createdAt,
            DateTime.parse('2024-02-20T08:00:00.000Z'));
        expect(product.shippingPrice, 5.99);
        expect(product.freeShipping, isFalse);
        expect(product.useSellerShipping, isTrue);
        expect(product.customFlatRate, 4.0);
        expect(product.customAdditionalItemFee, 1.50);
      });

      test('deserializes with nullable fields as null', () {
        final json = <String, dynamic>{
          'id': 'fp-null',
          'title': 'Minimal Comic',
          'price': 5.0,
          'originalPrice': null,
          'flashSalePrice': null,
          'flashSaleEndsAt': null,
          'sellerAvatarUrl': null,
          'createdAt': null,
          'customFlatRate': null,
          'customAdditionalItemFee': null,
        };

        final product = FeedProduct.fromJson(json);

        expect(product.id, 'fp-null');
        expect(product.originalPrice, isNull);
        expect(product.flashSalePrice, isNull);
        expect(product.flashSaleEndsAt, isNull);
        expect(product.sellerAvatarUrl, isNull);
        expect(product.createdAt, isNull);
        expect(product.customFlatRate, isNull);
        expect(product.customAdditionalItemFee, isNull);
      });

      test('toJson produces correct keys and values', () {
        const product = FeedProduct(
          id: 'fp-out',
          sellerId: 'seller-out',
          title: 'Output Comic',
          price: 12.0,
          sellerRating: 4.7,
          sellerTotalReviews: 20,
          isInWishlist: true,
          freeShipping: true,
        );

        final json = product.toJson();

        expect(json['id'], 'fp-out');
        expect(json['sellerId'], 'seller-out');
        expect(json['title'], 'Output Comic');
        expect(json['price'], 12.0);
        expect(json['sellerRating'], 4.7);
        expect(json['sellerTotalReviews'], 20);
        expect(json['isInWishlist'], isTrue);
        expect(json['freeShipping'], isTrue);
        expect(json['flashSaleEnabled'], isFalse);
        expect(json['useSellerShipping'], isFalse);
        expect(json['originalPrice'], isNull);
        expect(json['flashSalePrice'], isNull);
        expect(json['createdAt'], isNull);
      });

      test('fromJson followed by toJson preserves all set values', () {
        final original = <String, dynamic>{
          'id': 'fp-rt',
          'sellerId': 'seller-rt',
          'title': 'Round-trip Feed',
          'description': 'Test description',
          'price': 55.0,
          'originalPrice': 70.0,
          'flashSaleEnabled': false,
          'flashSalePrice': null,
          'flashSaleEndsAt': null,
          'mainImageUrl': 'https://example.com/rt.jpg',
          'categoryName': 'Manga',
          'conditionName': 'Very Good',
          'sellerUsername': 'rtuser',
          'sellerAvatarUrl': null,
          'sellerRating': 3.5,
          'sellerTotalReviews': 5,
          'isInWishlist': false,
          'createdAt': '2024-09-01T00:00:00.000Z',
          'shippingPrice': 2.99,
          'freeShipping': false,
          'useSellerShipping': false,
          'customFlatRate': null,
          'customAdditionalItemFee': null,
        };

        final product = FeedProduct.fromJson(original);
        final encoded = product.toJson();

        expect(encoded['id'], 'fp-rt');
        expect(encoded['title'], 'Round-trip Feed');
        expect(encoded['price'], 55.0);
        expect(encoded['originalPrice'], 70.0);
        expect(encoded['categoryName'], 'Manga');
        expect(encoded['conditionName'], 'Very Good');
        expect(encoded['sellerUsername'], 'rtuser');
        expect(encoded['sellerRating'], 3.5);
        expect(encoded['createdAt'], '2024-09-01T00:00:00.000Z');
        expect(encoded['shippingPrice'], 2.99);
      });
    });

    // ---------------------------------------------------------------------------
    // DateTime handling
    // ---------------------------------------------------------------------------
    group('DateTime handling', () {
      test('parses createdAt ISO-8601 string', () {
        final json = <String, dynamic>{
          'createdAt': '2024-03-10T06:00:00.000Z',
        };

        final product = FeedProduct.fromJson(json);
        expect(product.createdAt, DateTime.parse('2024-03-10T06:00:00.000Z'));
      });

      test('parses flashSaleEndsAt ISO-8601 string', () {
        final json = <String, dynamic>{
          'flashSaleEndsAt': '2025-12-25T00:00:00.000Z',
        };

        final product = FeedProduct.fromJson(json);
        expect(product.flashSaleEndsAt,
            DateTime.parse('2025-12-25T00:00:00.000Z'));
      });

      test('serializes DateTime fields to ISO-8601 strings', () {
        final created = DateTime.utc(2024, 3, 10, 6, 0, 0);
        final saleEnds = DateTime.utc(2025, 12, 25);

        final product = FeedProduct(
          createdAt: created,
          flashSaleEndsAt: saleEnds,
        );

        final json = product.toJson();

        expect(json['createdAt'], created.toIso8601String());
        expect(json['flashSaleEndsAt'], saleEnds.toIso8601String());
      });

      test('null DateTime fields serialize as null', () {
        const product = FeedProduct();
        final json = product.toJson();

        expect(json['createdAt'], isNull);
        expect(json['flashSaleEndsAt'], isNull);
      });
    });

    // ---------------------------------------------------------------------------
    // copyWith
    // ---------------------------------------------------------------------------
    group('copyWith', () {
      test('creates modified copy without altering original', () {
        const original = FeedProduct(
          id: 'orig-fp',
          title: 'Original Title',
          price: 10.0,
          isInWishlist: false,
        );

        final copy = original.copyWith(
          title: 'Wishlisted',
          price: 8.0,
          isInWishlist: true,
        );

        expect(original.id, 'orig-fp');
        expect(original.title, 'Original Title');
        expect(original.price, 10.0);
        expect(original.isInWishlist, isFalse);

        expect(copy.id, 'orig-fp');
        expect(copy.title, 'Wishlisted');
        expect(copy.price, 8.0);
        expect(copy.isInWishlist, isTrue);
      });

      test('copyWith with no args returns equal object', () {
        const product = FeedProduct(
          id: 'same-fp',
          title: 'Same',
          sellerUsername: 'sameuser',
          sellerRating: 4.2,
        );

        final copy = product.copyWith();
        expect(copy, equals(product));
      });

      test('can toggle flashSaleEnabled', () {
        const original = FeedProduct(
          id: 'flash-fp',
          flashSaleEnabled: false,
          flashSalePrice: 50.0,
        );

        final saleActive = original.copyWith(flashSaleEnabled: true);

        expect(saleActive.flashSaleEnabled, isTrue);
        expect(saleActive.flashSalePrice, 50.0);
        expect(original.flashSaleEnabled, isFalse);
      });

      test('can update sellerRating and sellerTotalReviews', () {
        const original = FeedProduct(
          sellerRating: 3.0,
          sellerTotalReviews: 10,
        );

        final updated = original.copyWith(
          sellerRating: 4.5,
          sellerTotalReviews: 11,
        );

        expect(updated.sellerRating, 4.5);
        expect(updated.sellerTotalReviews, 11);
        expect(original.sellerRating, 3.0);
        expect(original.sellerTotalReviews, 10);
      });
    });

    // ---------------------------------------------------------------------------
    // serialize / fromSerializableMap
    // ---------------------------------------------------------------------------
    group('serialize / fromSerializableMap', () {
      test('serialize produces valid JSON string', () {
        const product = FeedProduct(
          id: 'ser-fp',
          title: 'Serialized Feed Product',
          price: 22.0,
          sellerUsername: 'seruser',
        );

        final serialized = product.serialize();
        expect(() => jsonDecode(serialized), returnsNormally);

        final decoded = jsonDecode(serialized) as Map<String, dynamic>;
        expect(decoded['id'], 'ser-fp');
        expect(decoded['title'], 'Serialized Feed Product');
        expect(decoded['price'], 22.0);
        expect(decoded['sellerUsername'], 'seruser');
      });

      test('fromSerializableMap rebuilds equal model', () {
        const product = FeedProduct(
          id: 'round-fp',
          title: 'Round-trip FeedProduct',
          price: 33.0,
          sellerRating: 4.0,
          sellerTotalReviews: 15,
          isInWishlist: true,
          freeShipping: true,
        );

        final serialized = product.serialize();
        final decoded = jsonDecode(serialized) as Map<String, dynamic>;
        final restored = FeedProduct.fromSerializableMap(decoded);

        expect(restored, equals(product));
      });

      test('serialize/fromSerializableMap preserves DateTime fields', () {
        final created = DateTime.utc(2024, 4, 1, 12, 0, 0);
        final product = FeedProduct(createdAt: created);

        final serialized = product.serialize();
        final decoded = jsonDecode(serialized) as Map<String, dynamic>;
        final restored = FeedProduct.fromSerializableMap(decoded);

        expect(restored.createdAt, created);
      });
    });

    // ---------------------------------------------------------------------------
    // Equality
    // ---------------------------------------------------------------------------
    group('equality', () {
      test('two instances with same values are equal', () {
        const a = FeedProduct(
          id: 'eq-fp',
          title: 'Equal',
          price: 5.0,
          sellerRating: 4.5,
        );
        const b = FeedProduct(
          id: 'eq-fp',
          title: 'Equal',
          price: 5.0,
          sellerRating: 4.5,
        );

        expect(a, equals(b));
      });

      test('instances with different IDs are not equal', () {
        const a = FeedProduct(id: 'fp-a');
        const b = FeedProduct(id: 'fp-b');

        expect(a, isNot(equals(b)));
      });

      test('instances differing only in isInWishlist are not equal', () {
        const a = FeedProduct(id: 'wl', isInWishlist: false);
        const b = FeedProduct(id: 'wl', isInWishlist: true);

        expect(a, isNot(equals(b)));
      });

      test('instances differing only in price are not equal', () {
        const a = FeedProduct(id: 'price', price: 9.99);
        const b = FeedProduct(id: 'price', price: 19.99);

        expect(a, isNot(equals(b)));
      });
    });
  });
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/features/home/domain/models/product_details_model.dart';
import 'package:get_it/features/home/domain/models/product_image_model.dart';

void main() {
  group('ProductDetails', () {
    // ---------------------------------------------------------------------------
    // Default values
    // ---------------------------------------------------------------------------
    group('default values', () {
      test('const constructor produces expected defaults', () {
        const product = ProductDetails();

        expect(product.id, '');
        expect(product.sellerId, '');
        expect(product.title, '');
        expect(product.description, '');
        expect(product.price, 0.0);
        expect(product.originalPrice, isNull);
        expect(product.flashSaleEnabled, isFalse);
        expect(product.flashSalePrice, isNull);
        expect(product.flashSaleEndsAt, isNull);
        expect(product.discountType, isNull);
        expect(product.discountAmount, isNull);
        expect(product.quantity, 0);
        expect(product.year, isNull);
        expect(product.issueNumber, isNull);
        expect(product.sku, isNull);
        expect(product.skuNumber, isNull);
        expect(product.shippingInfo, isNull);
        expect(product.shippingPrice, 0.0);
        expect(product.freeShipping, isFalse);
        expect(product.useSellerShipping, isFalse);
        expect(product.customFlatRate, isNull);
        expect(product.customAdditionalItemFee, isNull);
        expect(product.shortlistId, isNull);
        expect(product.viewsCount, 0);
        expect(product.status, '');
        expect(product.mainImageUrl, '');
        expect(product.categoryId, '');
        expect(product.categoryName, '');
        expect(product.subcategoryId, '');
        expect(product.subcategoryName, '');
        expect(product.conditionId, '');
        expect(product.conditionName, '');
        expect(product.sellerUsername, '');
        expect(product.sellerAvatarUrl, '');
        expect(product.createdAt, isNull);
        expect(product.images, isEmpty);
        expect(product.conditions, isEmpty);
        expect(product.category, isNull);
        expect(product.subcategory, isNull);
        expect(product.seller, isNull);
        expect(product.tags, isEmpty);
        expect(product.isInWishlist, isFalse);
        expect(product.isOwnProduct, isFalse);
      });
    });

    // ---------------------------------------------------------------------------
    // fromJson / toJson round-trip — scalar fields only
    // ---------------------------------------------------------------------------
    group('fromJson / toJson — scalar fields', () {
      test('round-trips primitive fields correctly', () {
        final json = <String, dynamic>{
          'id': 'prod-1',
          'sellerId': 'seller-99',
          'title': 'Vintage Comic',
          'description': 'First edition',
          'price': 29.99,
          'originalPrice': 39.99,
          'flashSaleEnabled': true,
          'flashSalePrice': 19.99,
          'flashSaleEndsAt': '2025-12-31T23:59:59.000Z',
          'discountType': 'percentage',
          'discountAmount': 10.0,
          'quantity': 5,
          'year': 1985,
          'issueNumber': 12,
          'sku': 'SKU-001',
          'skuNumber': 'SN-001',
          'shippingInfo': 'Ships in 2–3 days',
          'shippingPrice': 4.99,
          'freeShipping': false,
          'useSellerShipping': true,
          'customFlatRate': 3.50,
          'customAdditionalItemFee': 1.00,
          'shortlistId': 'sl-42',
          'viewsCount': 120,
          'status': 'active',
          'mainImageUrl': 'https://example.com/img.jpg',
          'categoryId': 'cat-1',
          'categoryName': 'Comics',
          'subcategoryId': 'sub-1',
          'subcategoryName': 'Marvel',
          'conditionId': 'cond-1',
          'conditionName': 'Near Mint',
          'sellerUsername': 'comicguy',
          'sellerAvatarUrl': 'https://example.com/avatar.jpg',
          'createdAt': '2024-01-15T10:00:00.000Z',
          'images': <dynamic>[],
          'conditions': <dynamic>[],
          'category': null,
          'subcategory': null,
          'seller': null,
          'tags': <dynamic>[],
          'isInWishlist': true,
          'isOwnProduct': false,
        };

        final product = ProductDetails.fromJson(json);

        expect(product.id, 'prod-1');
        expect(product.sellerId, 'seller-99');
        expect(product.title, 'Vintage Comic');
        expect(product.description, 'First edition');
        expect(product.price, 29.99);
        expect(product.originalPrice, 39.99);
        expect(product.flashSaleEnabled, isTrue);
        expect(product.flashSalePrice, 19.99);
        expect(product.flashSaleEndsAt,
            DateTime.parse('2025-12-31T23:59:59.000Z'));
        expect(product.discountType, 'percentage');
        expect(product.discountAmount, 10.0);
        expect(product.quantity, 5);
        expect(product.year, 1985);
        expect(product.issueNumber, 12);
        expect(product.sku, 'SKU-001');
        expect(product.skuNumber, 'SN-001');
        expect(product.shippingInfo, 'Ships in 2–3 days');
        expect(product.shippingPrice, 4.99);
        expect(product.freeShipping, isFalse);
        expect(product.useSellerShipping, isTrue);
        expect(product.customFlatRate, 3.50);
        expect(product.customAdditionalItemFee, 1.00);
        expect(product.shortlistId, 'sl-42');
        expect(product.viewsCount, 120);
        expect(product.status, 'active');
        expect(product.mainImageUrl, 'https://example.com/img.jpg');
        expect(product.categoryId, 'cat-1');
        expect(product.categoryName, 'Comics');
        expect(product.subcategoryId, 'sub-1');
        expect(product.subcategoryName, 'Marvel');
        expect(product.conditionId, 'cond-1');
        expect(product.conditionName, 'Near Mint');
        expect(product.sellerUsername, 'comicguy');
        expect(product.sellerAvatarUrl, 'https://example.com/avatar.jpg');
        expect(product.createdAt, DateTime.parse('2024-01-15T10:00:00.000Z'));
        expect(product.isInWishlist, isTrue);
        expect(product.isOwnProduct, isFalse);
      });

      test('toJson preserves values written by fromJson', () {
        final original = <String, dynamic>{
          'id': 'prod-round',
          'sellerId': 'seller-round',
          'title': 'Round-trip Title',
          'description': '',
          'price': 9.99,
          'originalPrice': null,
          'flashSaleEnabled': false,
          'flashSalePrice': null,
          'flashSaleEndsAt': null,
          'discountType': null,
          'discountAmount': null,
          'quantity': 1,
          'year': null,
          'issueNumber': null,
          'sku': null,
          'skuNumber': null,
          'shippingInfo': null,
          'shippingPrice': 0.0,
          'freeShipping': true,
          'useSellerShipping': false,
          'customFlatRate': null,
          'customAdditionalItemFee': null,
          'shortlistId': null,
          'viewsCount': 0,
          'status': 'draft',
          'mainImageUrl': '',
          'categoryId': '',
          'categoryName': '',
          'subcategoryId': '',
          'subcategoryName': '',
          'conditionId': '',
          'conditionName': '',
          'sellerUsername': '',
          'sellerAvatarUrl': '',
          'createdAt': null,
          'images': <dynamic>[],
          'conditions': <dynamic>[],
          'category': null,
          'subcategory': null,
          'seller': null,
          'tags': <dynamic>[],
          'isInWishlist': false,
          'isOwnProduct': false,
        };

        final product = ProductDetails.fromJson(original);
        final encoded = product.toJson();

        expect(encoded['id'], 'prod-round');
        expect(encoded['title'], 'Round-trip Title');
        expect(encoded['price'], 9.99);
        expect(encoded['freeShipping'], isTrue);
        expect(encoded['status'], 'draft');
        expect(encoded['flashSaleEndsAt'], isNull);
        expect(encoded['createdAt'], isNull);
      });
    });

    // ---------------------------------------------------------------------------
    // fromJson / toJson — nested objects
    // ---------------------------------------------------------------------------
    group('fromJson / toJson — nested objects', () {
      test('deserializes nested images list', () {
        final json = <String, dynamic>{
          'images': [
            {
              'id': 'img-1',
              'imageUrl': 'https://example.com/1.jpg',
              'thumbnailUrl': 'https://example.com/1t.jpg',
              'isMain': true,
              'sortOrder': 0,
              'width': 800,
              'height': 600,
            },
          ],
          'conditions': <dynamic>[],
          'tags': <dynamic>[],
        };

        final product = ProductDetails.fromJson(json);

        expect(product.images, hasLength(1));
        expect(product.images.first.id, 'img-1');
        expect(product.images.first.isMain, isTrue);
        expect(product.images.first.width, 800);
      });

      test('deserializes nested conditions list', () {
        final json = <String, dynamic>{
          'images': <dynamic>[],
          'conditions': [
            {
              'id': 'cond-nm',
              'name': 'Near Mint',
              'code': 'NM',
              'description': 'Almost perfect',
              'sortOrder': 1,
            },
          ],
          'tags': <dynamic>[],
        };

        final product = ProductDetails.fromJson(json);

        expect(product.conditions, hasLength(1));
        expect(product.conditions.first.name, 'Near Mint');
        expect(product.conditions.first.code, 'NM');
      });

      test('deserializes nested category object', () {
        final json = <String, dynamic>{
          'category': {
            'id': 'cat-1',
            'name': 'Comics',
            'slug': 'comics',
            'imageUrl': '',
            'description': '',
            'subcategories': <dynamic>[],
          },
          'images': <dynamic>[],
          'conditions': <dynamic>[],
          'tags': <dynamic>[],
        };

        final product = ProductDetails.fromJson(json);

        expect(product.category, isNotNull);
        expect(product.category!.id, 'cat-1');
        expect(product.category!.name, 'Comics');
      });

      test('null category stays null', () {
        final json = <String, dynamic>{
          'category': null,
          'images': <dynamic>[],
          'conditions': <dynamic>[],
          'tags': <dynamic>[],
        };

        final product = ProductDetails.fromJson(json);
        expect(product.category, isNull);
      });
    });

    // ---------------------------------------------------------------------------
    // DateTime handling
    // ---------------------------------------------------------------------------
    group('DateTime handling', () {
      test('parses ISO-8601 string into DateTime', () {
        final json = <String, dynamic>{
          'createdAt': '2024-06-01T12:00:00.000Z',
          'flashSaleEndsAt': '2025-01-01T00:00:00.000Z',
          'images': <dynamic>[],
          'conditions': <dynamic>[],
          'tags': <dynamic>[],
        };

        final product = ProductDetails.fromJson(json);

        expect(product.createdAt, DateTime.parse('2024-06-01T12:00:00.000Z'));
        expect(product.flashSaleEndsAt,
            DateTime.parse('2025-01-01T00:00:00.000Z'));
      });

      test('serializes DateTime back to ISO-8601 string', () {
        final dt = DateTime.utc(2024, 6, 1, 12, 0, 0);
        final product = ProductDetails(createdAt: dt);
        final json = product.toJson();

        expect(json['createdAt'], dt.toIso8601String());
      });

      test('null DateTime fields serialize as null', () {
        const product = ProductDetails();
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
        const original = ProductDetails(
          id: 'orig',
          title: 'Original',
          price: 10.0,
        );

        final copy = original.copyWith(
          title: 'Updated',
          price: 20.0,
          isInWishlist: true,
        );

        // original unchanged
        expect(original.id, 'orig');
        expect(original.title, 'Original');
        expect(original.price, 10.0);
        expect(original.isInWishlist, isFalse);

        // copy has changes
        expect(copy.id, 'orig');
        expect(copy.title, 'Updated');
        expect(copy.price, 20.0);
        expect(copy.isInWishlist, isTrue);
      });

      test('copies nested list field independently', () {
        const original = ProductDetails(images: []);
        final newImage = ProductImage(
          id: 'img-copy',
          imageUrl: 'https://example.com/copy.jpg',
        );
        final copy = original.copyWith(images: [newImage]);

        expect(original.images, isEmpty);
        expect(copy.images, hasLength(1));
        expect(copy.images.first.id, 'img-copy');
      });

      test('copyWith with no arguments returns equal object', () {
        const product = ProductDetails(
          id: 'same',
          title: 'Same',
          quantity: 3,
        );
        final copy = product.copyWith();

        expect(copy, equals(product));
      });
    });

    // ---------------------------------------------------------------------------
    // serialize / fromSerializableMap
    // ---------------------------------------------------------------------------
    group('serialize / fromSerializableMap', () {
      test('serialize produces valid JSON string', () {
        const product = ProductDetails(
          id: 'ser-1',
          title: 'Serialized',
          price: 14.99,
        );

        final serialized = product.serialize();
        expect(() => jsonDecode(serialized), returnsNormally);

        final decoded = jsonDecode(serialized) as Map<String, dynamic>;
        expect(decoded['id'], 'ser-1');
        expect(decoded['title'], 'Serialized');
        expect(decoded['price'], 14.99);
      });

      test('fromSerializableMap rebuilds equal model', () {
        const product = ProductDetails(
          id: 'ser-2',
          title: 'Round-trip',
          price: 7.50,
          quantity: 2,
          status: 'active',
          isInWishlist: true,
        );

        final serialized = product.serialize();
        final decoded = jsonDecode(serialized) as Map<String, dynamic>;
        final restored = ProductDetails.fromSerializableMap(decoded);

        expect(restored, equals(product));
      });

      test('serialize/fromSerializableMap preserves DateTime fields', () {
        final dt = DateTime.utc(2024, 3, 15, 8, 30, 0);
        final product = ProductDetails(createdAt: dt);

        final serialized = product.serialize();
        final decoded = jsonDecode(serialized) as Map<String, dynamic>;
        final restored = ProductDetails.fromSerializableMap(decoded);

        expect(restored.createdAt, dt);
      });
    });

    // ---------------------------------------------------------------------------
    // Equality
    // ---------------------------------------------------------------------------
    group('equality', () {
      test('two instances with same values are equal', () {
        const a = ProductDetails(id: 'x', title: 'X', price: 1.0);
        const b = ProductDetails(id: 'x', title: 'X', price: 1.0);

        expect(a, equals(b));
      });

      test('instances with different values are not equal', () {
        const a = ProductDetails(id: 'x');
        const b = ProductDetails(id: 'y');

        expect(a, isNot(equals(b)));
      });
    });
  });
}

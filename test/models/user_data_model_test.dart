import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/features/auth/domain/models/business_address_model.dart';
import 'package:get_it/features/auth/domain/models/user_model.dart';

void main() {
  group('UserData', () {
    // ---------------------------------------------------------------------------
    // Default values
    // ---------------------------------------------------------------------------
    group('default values', () {
      test('const constructor produces expected defaults', () {
        const user = UserData();

        expect(user.id, '');
        expect(user.userId, '');
        expect(user.username, '');
        expect(user.firstName, '');
        expect(user.lastName, '');
        expect(user.avatarUrl, '');
        expect(user.bio, '');
        expect(user.phone, '');
        expect(user.phoneVerified, isFalse);
        expect(user.isSeller, isFalse);
        expect(user.sellerSince, isNull);
        expect(user.businessName, '');
        expect(user.businessAddress, isNull);
        expect(user.businessEmail, '');
        expect(user.ratingAsSeller, 0.0);
        expect(user.ratingAsBuyer, 0.0);
        expect(user.totalReviewsAsSeller, 0);
        expect(user.totalReviewsAsBuyer, 0);
        expect(user.totalSales, 0);
        expect(user.totalPurchases, 0);
        expect(user.totalRefunds, 0);
        expect(user.totalCancelled, 0);
        expect(user.followersCount, 0);
        expect(user.followingCount, 0);
        expect(user.isPrivate, isFalse);
        expect(user.referralCode, '');
        expect(user.referredBy, '');
        expect(user.createdAt, isNull);
        expect(user.updatedAt, isNull);
        expect(user.deletedAt, isNull);
        expect(user.isDeactivated, isFalse);
        expect(user.totalReferrals, 0);
        expect(user.email, '');
        expect(user.stripe, isNull);
        expect(user.paymentMethod, isEmpty);
        expect(user.hasStripeCustomer, isFalse);
        expect(user.defaultPaymentMethodId, '');
        expect(user.userSettings, isNull);
        expect(user.shippingAddress, isNull);
      });
    });

    // ---------------------------------------------------------------------------
    // fromJson / toJson round-trip — scalar fields
    // ---------------------------------------------------------------------------
    group('fromJson / toJson — scalar fields', () {
      test('deserializes all snake_case scalar fields correctly', () {
        final json = <String, dynamic>{
          'id': 'u-1',
          'user_id': 'auth-uid-1',
          'username': 'comicfan42',
          'first_name': 'Jane',
          'last_name': 'Doe',
          'avatar_url': 'https://example.com/jane.jpg',
          'bio': 'Love comics',
          'phone': '+15551234567',
          'phone_verified': true,
          'is_seller': true,
          'seller_since': '2023-01-01T00:00:00.000Z',
          'business_name': 'Jane Comics',
          'business_email': 'jane@comics.com',
          'rating_as_seller': 4.8,
          'rating_as_buyer': 4.5,
          'total_reviews_as_seller': 50,
          'total_reviews_as_buyer': 12,
          'total_sales': 200,
          'total_purchases': 30,
          'total_refunds': 2,
          'total_cancelled': 1,
          'followers_count': 500,
          'following_count': 120,
          'is_private': false,
          'referral_code': 'JANE42',
          'referred_by': '',
          'created_at': '2022-06-15T09:00:00.000Z',
          'updated_at': '2024-03-01T00:00:00.000Z',
          'deleted_at': null,
          'is_deactivated': false,
          'total_referrals': 10,
          'email': 'jane@example.com',
          'paymentMethod': <dynamic>[],
          'hasStripeCustomer': true,
          'defaultPaymentMethodId': 'pm-abc',
        };

        final user = UserData.fromJson(json);

        expect(user.id, 'u-1');
        expect(user.userId, 'auth-uid-1');
        expect(user.username, 'comicfan42');
        expect(user.firstName, 'Jane');
        expect(user.lastName, 'Doe');
        expect(user.avatarUrl, 'https://example.com/jane.jpg');
        expect(user.bio, 'Love comics');
        expect(user.phone, '+15551234567');
        expect(user.phoneVerified, isTrue);
        expect(user.isSeller, isTrue);
        expect(user.sellerSince,
            DateTime.parse('2023-01-01T00:00:00.000Z'));
        expect(user.businessName, 'Jane Comics');
        expect(user.businessEmail, 'jane@comics.com');
        expect(user.ratingAsSeller, 4.8);
        expect(user.ratingAsBuyer, 4.5);
        expect(user.totalReviewsAsSeller, 50);
        expect(user.totalReviewsAsBuyer, 12);
        expect(user.totalSales, 200);
        expect(user.totalPurchases, 30);
        expect(user.totalRefunds, 2);
        expect(user.totalCancelled, 1);
        expect(user.followersCount, 500);
        expect(user.followingCount, 120);
        expect(user.isPrivate, isFalse);
        expect(user.referralCode, 'JANE42');
        expect(user.createdAt,
            DateTime.parse('2022-06-15T09:00:00.000Z'));
        expect(user.updatedAt,
            DateTime.parse('2024-03-01T00:00:00.000Z'));
        expect(user.deletedAt, isNull);
        expect(user.isDeactivated, isFalse);
        expect(user.totalReferrals, 10);
        expect(user.email, 'jane@example.com');
        expect(user.hasStripeCustomer, isTrue);
        expect(user.defaultPaymentMethodId, 'pm-abc');
      });

      test('toJson uses correct snake_case keys for annotated fields', () {
        const user = UserData(
          id: 'u-2',
          userId: 'auth-2',
          firstName: 'John',
          lastName: 'Smith',
          avatarUrl: 'https://example.com/john.jpg',
          isSeller: true,
          followersCount: 100,
          followingCount: 50,
          isPrivate: true,
          referralCode: 'JOHN10',
          isDeactivated: false,
        );

        final json = user.toJson();

        expect(json['id'], 'u-2');
        expect(json['user_id'], 'auth-2');
        expect(json['first_name'], 'John');
        expect(json['last_name'], 'Smith');
        expect(json['avatar_url'], 'https://example.com/john.jpg');
        expect(json['is_seller'], isTrue);
        expect(json['followers_count'], 100);
        expect(json['following_count'], 50);
        expect(json['is_private'], isTrue);
        expect(json['referral_code'], 'JOHN10');
        expect(json['is_deactivated'], isFalse);
      });

      test('toJson does not use camelCase for snake_case annotated fields', () {
        const user = UserData(firstName: 'Alice', lastName: 'Bob');
        final json = user.toJson();

        // The generated JSON should use snake_case keys
        expect(json.containsKey('first_name'), isTrue);
        expect(json.containsKey('last_name'), isTrue);
        expect(json.containsKey('firstName'), isFalse);
        expect(json.containsKey('lastName'), isFalse);
      });
    });

    // ---------------------------------------------------------------------------
    // fromJson / toJson — nested BusinessAddress
    // ---------------------------------------------------------------------------
    group('fromJson / toJson — nested BusinessAddress', () {
      test('deserializes nested business_address object', () {
        final json = <String, dynamic>{
          'business_address': {
            'addressLine1': '123 Main St',
            'addressLine2': 'Suite 4',
            'city': 'Springfield',
            'state': 'IL',
            'zipCode': '62701',
            'country': 'US',
          },
          'paymentMethod': <dynamic>[],
        };

        final user = UserData.fromJson(json);

        expect(user.businessAddress, isNotNull);
        expect(user.businessAddress!.addressLine1, '123 Main St');
        expect(user.businessAddress!.addressLine2, 'Suite 4');
        expect(user.businessAddress!.city, 'Springfield');
        expect(user.businessAddress!.state, 'IL');
        expect(user.businessAddress!.zipCode, '62701');
        expect(user.businessAddress!.country, 'US');
      });

      test('null business_address stays null', () {
        final json = <String, dynamic>{
          'business_address': null,
          'paymentMethod': <dynamic>[],
        };

        final user = UserData.fromJson(json);
        expect(user.businessAddress, isNull);
      });

      test('toJson serializes businessAddress under business_address key', () {
        const address = BusinessAddress(
          addressLine1: '1 Broadway',
          city: 'New York',
          state: 'NY',
          zipCode: '10004',
          country: 'US',
        );
        const user = UserData(businessAddress: address);
        final json = user.toJson();

        expect(json['business_address'], isNotNull);
        expect(json.containsKey('businessAddress'), isFalse);
      });
    });

    // ---------------------------------------------------------------------------
    // DateTime handling
    // ---------------------------------------------------------------------------
    group('DateTime handling', () {
      test('parses ISO-8601 strings for all DateTime fields', () {
        final json = <String, dynamic>{
          'created_at': '2022-01-01T00:00:00.000Z',
          'updated_at': '2023-06-15T12:00:00.000Z',
          'deleted_at': '2024-09-01T08:00:00.000Z',
          'seller_since': '2022-06-01T00:00:00.000Z',
          'paymentMethod': <dynamic>[],
        };

        final user = UserData.fromJson(json);

        expect(user.createdAt, DateTime.parse('2022-01-01T00:00:00.000Z'));
        expect(user.updatedAt, DateTime.parse('2023-06-15T12:00:00.000Z'));
        expect(user.deletedAt, DateTime.parse('2024-09-01T08:00:00.000Z'));
        expect(user.sellerSince, DateTime.parse('2022-06-01T00:00:00.000Z'));
      });

      test('serializes DateTime fields back to ISO-8601', () {
        final created = DateTime.utc(2022, 1, 1);
        final updated = DateTime.utc(2023, 6, 15, 12);

        final user = UserData(createdAt: created, updatedAt: updated);
        final json = user.toJson();

        expect(json['created_at'], created.toIso8601String());
        expect(json['updated_at'], updated.toIso8601String());
      });

      test('null DateTime fields serialize as null', () {
        const user = UserData();
        final json = user.toJson();

        expect(json['created_at'], isNull);
        expect(json['updated_at'], isNull);
        expect(json['deleted_at'], isNull);
        expect(json['seller_since'], isNull);
      });
    });

    // ---------------------------------------------------------------------------
    // copyWith — flat fields
    // ---------------------------------------------------------------------------
    group('copyWith — flat fields', () {
      test('creates modified copy without altering original', () {
        const original = UserData(
          id: 'orig',
          username: 'original_user',
          isSeller: false,
          followersCount: 10,
        );

        final copy = original.copyWith(
          username: 'updated_user',
          isSeller: true,
          followersCount: 25,
        );

        expect(original.id, 'orig');
        expect(original.username, 'original_user');
        expect(original.isSeller, isFalse);
        expect(original.followersCount, 10);

        expect(copy.id, 'orig');
        expect(copy.username, 'updated_user');
        expect(copy.isSeller, isTrue);
        expect(copy.followersCount, 25);
      });

      test('copyWith with no args returns equal object', () {
        const user = UserData(
          id: 'same',
          username: 'same_user',
          email: 'same@example.com',
        );
        final copy = user.copyWith();

        expect(copy, equals(user));
      });
    });

    // ---------------------------------------------------------------------------
    // copyWith — nested BusinessAddress (pattern from CLAUDE.md)
    // ---------------------------------------------------------------------------
    group('copyWith — nested BusinessAddress', () {
      test('updates businessAddress city without losing other fields', () {
        const original = UserData(
          id: 'u-addr',
          businessAddress: BusinessAddress(
            addressLine1: '10 Elm St',
            city: 'OldCity',
            state: 'CA',
            zipCode: '90001',
            country: 'US',
          ),
        );

        final updated = original.copyWith(
          businessAddress:
              (original.businessAddress ?? const BusinessAddress())
                  .copyWith(city: 'NewCity'),
        );

        expect(updated.id, 'u-addr');
        expect(updated.businessAddress!.addressLine1, '10 Elm St');
        expect(updated.businessAddress!.city, 'NewCity');
        expect(updated.businessAddress!.state, 'CA');
        expect(original.businessAddress!.city, 'OldCity');
      });

      test('initialises businessAddress from null via ?? pattern', () {
        const original = UserData(id: 'u-no-addr');

        final updated = original.copyWith(
          businessAddress:
              (original.businessAddress ?? const BusinessAddress())
                  .copyWith(city: 'BrandNew'),
        );

        expect(original.businessAddress, isNull);
        expect(updated.businessAddress!.city, 'BrandNew');
        // Other fields default to empty string
        expect(updated.businessAddress!.addressLine1, '');
      });
    });

    // ---------------------------------------------------------------------------
    // Equality
    // ---------------------------------------------------------------------------
    group('equality', () {
      test('two instances with same values are equal', () {
        const a = UserData(id: 'eq', username: 'same', email: 'a@b.com');
        const b = UserData(id: 'eq', username: 'same', email: 'a@b.com');

        expect(a, equals(b));
      });

      test('instances with different IDs are not equal', () {
        const a = UserData(id: 'a');
        const b = UserData(id: 'b');

        expect(a, isNot(equals(b)));
      });
    });
  });

  // ---------------------------------------------------------------------------
  // BusinessAddress standalone tests
  // ---------------------------------------------------------------------------
  group('BusinessAddress', () {
    test('default values are all empty strings', () {
      const addr = BusinessAddress();

      expect(addr.addressLine1, '');
      expect(addr.addressLine2, '');
      expect(addr.city, '');
      expect(addr.state, '');
      expect(addr.zipCode, '');
      expect(addr.country, '');
    });

    test('fromJson / toJson round-trip', () {
      final json = <String, dynamic>{
        'addressLine1': '42 Market St',
        'addressLine2': 'Apt 7',
        'city': 'Chicago',
        'state': 'IL',
        'zipCode': '60601',
        'country': 'US',
      };

      final addr = BusinessAddress.fromJson(json);
      final encoded = addr.toJson();

      expect(encoded['addressLine1'], '42 Market St');
      expect(encoded['addressLine2'], 'Apt 7');
      expect(encoded['city'], 'Chicago');
      expect(encoded['state'], 'IL');
      expect(encoded['zipCode'], '60601');
      expect(encoded['country'], 'US');
    });

    test('serialize / fromSerializableMap round-trip', () {
      const addr = BusinessAddress(
        addressLine1: '1 Test Blvd',
        city: 'Testville',
        state: 'TX',
        zipCode: '75001',
        country: 'US',
      );

      final serialized = addr.serialize();
      final decoded = jsonDecode(serialized) as Map<String, dynamic>;
      final restored = BusinessAddress.fromSerializableMap(decoded);

      expect(restored, equals(addr));
    });

    test('copyWith preserves unchanged fields', () {
      const original = BusinessAddress(
        addressLine1: '5 Oak Ave',
        city: 'Portland',
        state: 'OR',
        zipCode: '97201',
        country: 'US',
      );

      final updated = original.copyWith(zipCode: '97202');

      expect(updated.addressLine1, '5 Oak Ave');
      expect(updated.city, 'Portland');
      expect(updated.state, 'OR');
      expect(updated.zipCode, '97202');
      expect(updated.country, 'US');
      expect(original.zipCode, '97201');
    });
  });
}

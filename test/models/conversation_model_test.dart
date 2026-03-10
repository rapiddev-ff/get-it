import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/features/messages/domain/models/conversation_model.dart';

void main() {
  group('Conversation', () {
    // ---------------------------------------------------------------------------
    // Default values
    // ---------------------------------------------------------------------------
    group('default values', () {
      test('const constructor produces expected defaults', () {
        const conversation = Conversation();

        expect(conversation.id, '');
        expect(conversation.buyerId, '');
        expect(conversation.sellerId, '');
        expect(conversation.productId, isNull);
        expect(conversation.lastMessageText, isNull);
        expect(conversation.lastMessageAt, isNull);
        expect(conversation.buyerUnreadCount, 0);
        expect(conversation.sellerUnreadCount, 0);
        expect(conversation.otherUserId, '');
        expect(conversation.otherUserUsername, '');
        expect(conversation.otherUserAvatar, isNull);
        expect(conversation.otherUserLastActive, isNull);
        expect(conversation.productTitle, isNull);
        expect(conversation.productImage, isNull);
        expect(conversation.productPrice, isNull);
        expect(conversation.productCondition, isNull);
        expect(conversation.role, '');
      });
    });

    // ---------------------------------------------------------------------------
    // fromJson / toJson round-trip
    // ---------------------------------------------------------------------------
    group('fromJson / toJson', () {
      test('deserializes all fields from JSON correctly', () {
        final json = <String, dynamic>{
          'id': 'conv-1',
          'buyerId': 'buyer-1',
          'sellerId': 'seller-1',
          'productId': 'prod-1',
          'lastMessageText': 'Is this still available?',
          'lastMessageAt': '2024-05-20T14:30:00.000Z',
          'buyerUnreadCount': 2,
          'sellerUnreadCount': 0,
          'otherUserId': 'seller-1',
          'otherUserUsername': 'comicseller',
          'otherUserAvatar': 'https://example.com/seller.jpg',
          'otherUserLastActive': '2024-05-20T15:00:00.000Z',
          'productTitle': 'Amazing Fantasy #15',
          'productImage': 'https://example.com/comic.jpg',
          'productPrice': 199.99,
          'productCondition': 'Very Fine',
          'role': 'buyer',
        };

        final conversation = Conversation.fromJson(json);

        expect(conversation.id, 'conv-1');
        expect(conversation.buyerId, 'buyer-1');
        expect(conversation.sellerId, 'seller-1');
        expect(conversation.productId, 'prod-1');
        expect(conversation.lastMessageText, 'Is this still available?');
        expect(conversation.lastMessageAt,
            DateTime.parse('2024-05-20T14:30:00.000Z'));
        expect(conversation.buyerUnreadCount, 2);
        expect(conversation.sellerUnreadCount, 0);
        expect(conversation.otherUserId, 'seller-1');
        expect(conversation.otherUserUsername, 'comicseller');
        expect(conversation.otherUserAvatar,
            'https://example.com/seller.jpg');
        expect(conversation.otherUserLastActive,
            DateTime.parse('2024-05-20T15:00:00.000Z'));
        expect(conversation.productTitle, 'Amazing Fantasy #15');
        expect(conversation.productImage, 'https://example.com/comic.jpg');
        expect(conversation.productPrice, 199.99);
        expect(conversation.productCondition, 'Very Fine');
        expect(conversation.role, 'buyer');
      });

      test('deserializes with all nullable fields as null', () {
        final json = <String, dynamic>{
          'id': 'conv-empty',
          'buyerId': 'b-1',
          'sellerId': 's-1',
          'productId': null,
          'lastMessageText': null,
          'lastMessageAt': null,
          'buyerUnreadCount': 0,
          'sellerUnreadCount': 0,
          'otherUserId': 'u-1',
          'otherUserUsername': 'user1',
          'otherUserAvatar': null,
          'otherUserLastActive': null,
          'productTitle': null,
          'productImage': null,
          'productPrice': null,
          'productCondition': null,
          'role': 'seller',
        };

        final conversation = Conversation.fromJson(json);

        expect(conversation.id, 'conv-empty');
        expect(conversation.productId, isNull);
        expect(conversation.lastMessageText, isNull);
        expect(conversation.lastMessageAt, isNull);
        expect(conversation.otherUserAvatar, isNull);
        expect(conversation.otherUserLastActive, isNull);
        expect(conversation.productTitle, isNull);
        expect(conversation.productImage, isNull);
        expect(conversation.productPrice, isNull);
        expect(conversation.productCondition, isNull);
        expect(conversation.role, 'seller');
      });

      test('toJson produces correct keys and values', () {
        const conversation = Conversation(
          id: 'conv-out',
          buyerId: 'b-2',
          sellerId: 's-2',
          buyerUnreadCount: 3,
          sellerUnreadCount: 1,
          otherUserId: 'b-2',
          otherUserUsername: 'buyer2',
          role: 'seller',
        );

        final json = conversation.toJson();

        expect(json['id'], 'conv-out');
        expect(json['buyerId'], 'b-2');
        expect(json['sellerId'], 's-2');
        expect(json['buyerUnreadCount'], 3);
        expect(json['sellerUnreadCount'], 1);
        expect(json['otherUserId'], 'b-2');
        expect(json['otherUserUsername'], 'buyer2');
        expect(json['role'], 'seller');
        expect(json['productId'], isNull);
        expect(json['lastMessageText'], isNull);
        expect(json['lastMessageAt'], isNull);
      });

      test('fromJson followed by toJson preserves all values', () {
        final original = <String, dynamic>{
          'id': 'conv-rt',
          'buyerId': 'buyer-rt',
          'sellerId': 'seller-rt',
          'productId': 'prod-rt',
          'lastMessageText': 'Hello!',
          'lastMessageAt': '2024-07-04T12:00:00.000Z',
          'buyerUnreadCount': 1,
          'sellerUnreadCount': 0,
          'otherUserId': 'seller-rt',
          'otherUserUsername': 'seller_rt_user',
          'otherUserAvatar': null,
          'otherUserLastActive': null,
          'productTitle': 'RT Comic',
          'productImage': null,
          'productPrice': 9.99,
          'productCondition': 'Good',
          'role': 'buyer',
        };

        final conversation = Conversation.fromJson(original);
        final encoded = conversation.toJson();

        expect(encoded['id'], 'conv-rt');
        expect(encoded['buyerId'], 'buyer-rt');
        expect(encoded['sellerId'], 'seller-rt');
        expect(encoded['productId'], 'prod-rt');
        expect(encoded['lastMessageText'], 'Hello!');
        expect(encoded['lastMessageAt'], '2024-07-04T12:00:00.000Z');
        expect(encoded['buyerUnreadCount'], 1);
        expect(encoded['productTitle'], 'RT Comic');
        expect(encoded['productPrice'], 9.99);
        expect(encoded['productCondition'], 'Good');
        expect(encoded['role'], 'buyer');
      });
    });

    // ---------------------------------------------------------------------------
    // DateTime handling
    // ---------------------------------------------------------------------------
    group('DateTime handling', () {
      test('parses lastMessageAt ISO-8601 string', () {
        final json = <String, dynamic>{
          'lastMessageAt': '2024-08-10T09:15:30.000Z',
        };

        final conversation = Conversation.fromJson(json);
        expect(conversation.lastMessageAt,
            DateTime.parse('2024-08-10T09:15:30.000Z'));
      });

      test('parses otherUserLastActive ISO-8601 string', () {
        final json = <String, dynamic>{
          'otherUserLastActive': '2024-08-10T10:00:00.000Z',
        };

        final conversation = Conversation.fromJson(json);
        expect(conversation.otherUserLastActive,
            DateTime.parse('2024-08-10T10:00:00.000Z'));
      });

      test('serializes DateTime fields to ISO-8601 strings', () {
        final dt = DateTime.utc(2024, 8, 10, 9, 15, 30);
        final conversation = Conversation(
          lastMessageAt: dt,
          otherUserLastActive: dt,
        );

        final json = conversation.toJson();

        expect(json['lastMessageAt'], dt.toIso8601String());
        expect(json['otherUserLastActive'], dt.toIso8601String());
      });

      test('null DateTime fields serialize as null', () {
        const conversation = Conversation();
        final json = conversation.toJson();

        expect(json['lastMessageAt'], isNull);
        expect(json['otherUserLastActive'], isNull);
      });
    });

    // ---------------------------------------------------------------------------
    // copyWith
    // ---------------------------------------------------------------------------
    group('copyWith', () {
      test('creates modified copy without altering original', () {
        const original = Conversation(
          id: 'orig-conv',
          buyerUnreadCount: 5,
          role: 'buyer',
        );

        final copy = original.copyWith(
          buyerUnreadCount: 0,
          lastMessageText: 'Seen',
          role: 'seller',
        );

        expect(original.id, 'orig-conv');
        expect(original.buyerUnreadCount, 5);
        expect(original.lastMessageText, isNull);
        expect(original.role, 'buyer');

        expect(copy.id, 'orig-conv');
        expect(copy.buyerUnreadCount, 0);
        expect(copy.lastMessageText, 'Seen');
        expect(copy.role, 'seller');
      });

      test('copyWith with no args returns equal object', () {
        const conversation = Conversation(
          id: 'same-conv',
          buyerId: 'b-same',
          sellerId: 's-same',
          role: 'buyer',
        );

        final copy = conversation.copyWith();
        expect(copy, equals(conversation));
      });

      test('can update unreadCount fields independently', () {
        const original = Conversation(
          buyerUnreadCount: 3,
          sellerUnreadCount: 7,
        );

        final buyerCleared = original.copyWith(buyerUnreadCount: 0);

        expect(buyerCleared.buyerUnreadCount, 0);
        expect(buyerCleared.sellerUnreadCount, 7);
        expect(original.buyerUnreadCount, 3);
      });
    });

    // ---------------------------------------------------------------------------
    // serialize / fromSerializableMap
    // ---------------------------------------------------------------------------
    group('serialize / fromSerializableMap', () {
      test('serialize produces valid JSON string', () {
        const conversation = Conversation(
          id: 'ser-conv',
          buyerId: 'b-ser',
          sellerId: 's-ser',
          role: 'buyer',
        );

        final serialized = conversation.serialize();
        expect(() => jsonDecode(serialized), returnsNormally);

        final decoded = jsonDecode(serialized) as Map<String, dynamic>;
        expect(decoded['id'], 'ser-conv');
        expect(decoded['buyerId'], 'b-ser');
        expect(decoded['role'], 'buyer');
      });

      test('fromSerializableMap rebuilds equal model', () {
        const conversation = Conversation(
          id: 'round-conv',
          buyerId: 'b-round',
          sellerId: 's-round',
          buyerUnreadCount: 2,
          sellerUnreadCount: 0,
          otherUserUsername: 'testuser',
          role: 'buyer',
        );

        final serialized = conversation.serialize();
        final decoded = jsonDecode(serialized) as Map<String, dynamic>;
        final restored = Conversation.fromSerializableMap(decoded);

        expect(restored, equals(conversation));
      });

      test('serialize preserves DateTime fields through round-trip', () {
        final dt = DateTime.utc(2024, 11, 5, 18, 0, 0);
        final conversation = Conversation(lastMessageAt: dt);

        final serialized = conversation.serialize();
        final decoded = jsonDecode(serialized) as Map<String, dynamic>;
        final restored = Conversation.fromSerializableMap(decoded);

        expect(restored.lastMessageAt, dt);
      });
    });

    // ---------------------------------------------------------------------------
    // Equality
    // ---------------------------------------------------------------------------
    group('equality', () {
      test('two instances with same values are equal', () {
        const a = Conversation(
          id: 'eq-conv',
          buyerId: 'b-eq',
          sellerId: 's-eq',
          role: 'buyer',
        );
        const b = Conversation(
          id: 'eq-conv',
          buyerId: 'b-eq',
          sellerId: 's-eq',
          role: 'buyer',
        );

        expect(a, equals(b));
      });

      test('instances with different IDs are not equal', () {
        const a = Conversation(id: 'c-a');
        const b = Conversation(id: 'c-b');

        expect(a, isNot(equals(b)));
      });

      test('instances differing only in unreadCount are not equal', () {
        const a = Conversation(id: 'unread', buyerUnreadCount: 0);
        const b = Conversation(id: 'unread', buyerUnreadCount: 5);

        expect(a, isNot(equals(b)));
      });
    });
  });
}

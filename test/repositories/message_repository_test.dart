import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:get_it/features/messages/data/repositories/message_repository.dart';
import '../helpers/mock_supabase.dart';

void main() {
  late MockSupabaseClient mockClient;
  late MessageRepository repository;

  setUp(() {
    mockClient = MockSupabaseClient();
    repository = MessageRepository(mockClient);
  });

  // ---------------------------------------------------------------------------
  // getOrCreateConversation
  // ---------------------------------------------------------------------------
  group('getOrCreateConversation', () {
    test('returns conversation map on success', () async {
      final data = <String, dynamic>{
        'id': 'conv-1',
        'buyer_id': 'buyer-1',
        'seller_id': 'seller-1',
        'product_id': 'prod-1',
      };
      stubRpcSuccess(mockClient, 'get_or_create_conversation', data);

      final result =
          await repository.getOrCreateConversation('seller-1', 'buyer-1');

      expect(result, isNotNull);
      expect(result!['id'], 'conv-1');
      expect(result['buyer_id'], 'buyer-1');
    });

    test('returns null when response is not a Map', () async {
      stubRpcSuccess(mockClient, 'get_or_create_conversation', 'invalid');

      final result =
          await repository.getOrCreateConversation('seller-1', 'buyer-1');

      expect(result, isNull);
    });

    test('returns null on exception', () async {
      stubRpcError(mockClient, 'get_or_create_conversation',
          Exception('network error'));

      final result =
          await repository.getOrCreateConversation('seller-1', 'buyer-1');

      expect(result, isNull);
    });

    test('passes correct params', () async {
      stubRpcSuccess(
          mockClient, 'get_or_create_conversation', <String, dynamic>{});

      await repository.getOrCreateConversation('seller-abc', 'buyer-xyz');

      final captured = verify(
        () => mockClient.rpc(
          'get_or_create_conversation',
          params: captureAny(named: 'params'),
        ),
      ).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_seller_id'], 'seller-abc');
      expect(params['p_buyer_id'], 'buyer-xyz');
    });
  });

  // ---------------------------------------------------------------------------
  // loadConversations
  // ---------------------------------------------------------------------------
  group('loadConversations', () {
    final convList = [
      <String, dynamic>{
        'id': 'conv-1',
        'last_message_text': 'Hello',
        'other_user_username': 'john',
      },
      <String, dynamic>{
        'id': 'conv-2',
        'last_message_text': 'Hi there',
        'other_user_username': 'jane',
      },
    ];

    test('returns list of conversations on success', () async {
      stubRpcSuccess(mockClient, 'get_conversations', convList);

      final result = await repository.loadConversations('user-1');

      expect(result.length, 2);
      expect(result[0]['id'], 'conv-1');
      expect(result[1]['other_user_username'], 'jane');
    });

    test('returns empty list when response is not a List', () async {
      stubRpcSuccess(mockClient, 'get_conversations', 'invalid');

      final result = await repository.loadConversations('user-1');

      expect(result, isEmpty);
    });

    test('returns empty list when response is null', () async {
      stubRpcSuccess(mockClient, 'get_conversations', null);

      final result = await repository.loadConversations('user-1');

      expect(result, isEmpty);
    });

    test('returns empty list on exception', () async {
      stubRpcError(
          mockClient, 'get_conversations', Exception('network error'));

      final result = await repository.loadConversations('user-1');

      expect(result, isEmpty);
    });

    test('passes filter param when provided', () async {
      stubRpcSuccess(mockClient, 'get_conversations', []);

      await repository.loadConversations('user-1', filter: 'buying');

      final captured = verify(
        () => mockClient.rpc(
          'get_conversations',
          params: captureAny(named: 'params'),
        ),
      ).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_user_id'], 'user-1');
      expect(params['p_filter'], 'buying');
    });

    test('omits filter param when not provided', () async {
      stubRpcSuccess(mockClient, 'get_conversations', []);

      await repository.loadConversations('user-1');

      final captured = verify(
        () => mockClient.rpc(
          'get_conversations',
          params: captureAny(named: 'params'),
        ),
      ).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_user_id'], 'user-1');
      expect(params.containsKey('p_filter'), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // loadMessages
  // ---------------------------------------------------------------------------
  group('loadMessages', () {
    final msgList = [
      <String, dynamic>{
        'id': 'msg-1',
        'content': 'Hello!',
        'sender_id': 'user-1',
      },
      <String, dynamic>{
        'id': 'msg-2',
        'content': 'Hi!',
        'sender_id': 'user-2',
      },
    ];

    test('returns list of messages on success', () async {
      stubRpcSuccess(mockClient, 'get_messages', msgList);

      final result = await repository.loadMessages('conv-1');

      expect(result.length, 2);
      expect(result[0]['content'], 'Hello!');
      expect(result[1]['sender_id'], 'user-2');
    });

    test('returns empty list when response is not a List', () async {
      stubRpcSuccess(mockClient, 'get_messages', null);

      final result = await repository.loadMessages('conv-1');

      expect(result, isEmpty);
    });

    test('returns empty list on exception', () async {
      stubRpcError(mockClient, 'get_messages', Exception('error'));

      final result = await repository.loadMessages('conv-1');

      expect(result, isEmpty);
    });

    test('passes limit and offset when provided', () async {
      stubRpcSuccess(mockClient, 'get_messages', []);

      await repository.loadMessages('conv-1', limit: 20, offset: 10);

      final captured = verify(
        () => mockClient.rpc(
          'get_messages',
          params: captureAny(named: 'params'),
        ),
      ).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_conversation_id'], 'conv-1');
      expect(params['p_limit'], 20);
      expect(params['p_offset'], 10);
    });

    test('omits limit and offset when not provided', () async {
      stubRpcSuccess(mockClient, 'get_messages', []);

      await repository.loadMessages('conv-1');

      final captured = verify(
        () => mockClient.rpc(
          'get_messages',
          params: captureAny(named: 'params'),
        ),
      ).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_conversation_id'], 'conv-1');
      expect(params.containsKey('p_limit'), isFalse);
      expect(params.containsKey('p_offset'), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // sendMessage
  // ---------------------------------------------------------------------------
  group('sendMessage', () {
    test('returns message map on success', () async {
      final response = <String, dynamic>{
        'id': 'msg-new',
        'content': 'Hey!',
        'created_at': '2024-03-10T10:00:00Z',
      };
      stubRpcSuccess(mockClient, 'send_message', response);

      final result = await repository.sendMessage('conv-1', 'Hey!');

      expect(result, isNotNull);
      expect(result!['id'], 'msg-new');
      expect(result['content'], 'Hey!');
    });

    test('returns null when response is not a Map', () async {
      stubRpcSuccess(mockClient, 'send_message', 'ok');

      final result = await repository.sendMessage('conv-1', 'test');

      expect(result, isNull);
    });

    test('returns null on exception', () async {
      stubRpcError(mockClient, 'send_message', Exception('error'));

      final result = await repository.sendMessage('conv-1', 'test');

      expect(result, isNull);
    });

    test('passes imageUrls when provided', () async {
      stubRpcSuccess(mockClient, 'send_message', <String, dynamic>{});

      await repository.sendMessage(
        'conv-1',
        'Check these!',
        imageUrls: ['url1.jpg', 'url2.jpg'],
      );

      final captured = verify(
        () => mockClient.rpc(
          'send_message',
          params: captureAny(named: 'params'),
        ),
      ).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_conversation_id'], 'conv-1');
      expect(params['p_content'], 'Check these!');
      expect(params['p_image_urls'], ['url1.jpg', 'url2.jpg']);
    });

    test('omits imageUrls when null', () async {
      stubRpcSuccess(mockClient, 'send_message', <String, dynamic>{});

      await repository.sendMessage('conv-1', 'text only');

      final captured = verify(
        () => mockClient.rpc(
          'send_message',
          params: captureAny(named: 'params'),
        ),
      ).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params.containsKey('p_image_urls'), isFalse);
    });

    test('omits imageUrls when empty list', () async {
      stubRpcSuccess(mockClient, 'send_message', <String, dynamic>{});

      await repository.sendMessage('conv-1', 'text only', imageUrls: []);

      final captured = verify(
        () => mockClient.rpc(
          'send_message',
          params: captureAny(named: 'params'),
        ),
      ).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params.containsKey('p_image_urls'), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // markMessagesAsRead
  // ---------------------------------------------------------------------------
  group('markMessagesAsRead', () {
    test('calls RPC with correct params', () async {
      stubRpcSuccess(mockClient, 'mark_messages_as_read', null);

      await repository.markMessagesAsRead('conv-1', 'user-1');

      final captured = verify(
        () => mockClient.rpc(
          'mark_messages_as_read',
          params: captureAny(named: 'params'),
        ),
      ).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_conversation_id'], 'conv-1');
      expect(params['p_user_id'], 'user-1');
    });

    test('does not throw on exception', () async {
      stubRpcError(mockClient, 'mark_messages_as_read', Exception('error'));

      // Should complete without throwing
      await repository.markMessagesAsRead('conv-1', 'user-1');
    });
  });

  // ---------------------------------------------------------------------------
  // getTotalUnreadCount
  // ---------------------------------------------------------------------------
  group('getTotalUnreadCount', () {
    test('returns int when response is int', () async {
      stubRpcSuccess(mockClient, 'get_total_unread_count', 5);

      final result = await repository.getTotalUnreadCount('user-1');

      expect(result, 5);
    });

    test('returns int when response is num (double)', () async {
      stubRpcSuccess(mockClient, 'get_total_unread_count', 3.0);

      final result = await repository.getTotalUnreadCount('user-1');

      expect(result, 3);
    });

    test('returns 0 when response is null', () async {
      stubRpcSuccess(mockClient, 'get_total_unread_count', null);

      final result = await repository.getTotalUnreadCount('user-1');

      expect(result, 0);
    });

    test('returns 0 on exception', () async {
      stubRpcError(
          mockClient, 'get_total_unread_count', Exception('error'));

      final result = await repository.getTotalUnreadCount('user-1');

      expect(result, 0);
    });

    test('passes userId param', () async {
      stubRpcSuccess(mockClient, 'get_total_unread_count', 0);

      await repository.getTotalUnreadCount('user-abc');

      final captured = verify(
        () => mockClient.rpc(
          'get_total_unread_count',
          params: captureAny(named: 'params'),
        ),
      ).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_user_id'], 'user-abc');
    });
  });

  // ---------------------------------------------------------------------------
  // sendCounterOffer
  // ---------------------------------------------------------------------------
  group('sendCounterOffer', () {
    test('returns offer map on success', () async {
      final response = <String, dynamic>{
        'id': 'offer-1',
        'status': 'pending',
        'offer_price': 25.0,
      };
      stubRpcSuccess(mockClient, 'send_counter_offer', response);

      final result =
          await repository.sendCounterOffer('conv-1', 'prod-1', 25.0);

      expect(result, isNotNull);
      expect(result!['id'], 'offer-1');
      expect(result['offer_price'], 25.0);
    });

    test('returns null when response is not a Map', () async {
      stubRpcSuccess(mockClient, 'send_counter_offer', 'ok');

      final result =
          await repository.sendCounterOffer('conv-1', 'prod-1', 25.0);

      expect(result, isNull);
    });

    test('returns null on exception', () async {
      stubRpcError(mockClient, 'send_counter_offer', Exception('error'));

      final result =
          await repository.sendCounterOffer('conv-1', 'prod-1', 25.0);

      expect(result, isNull);
    });

    test('passes correct params', () async {
      stubRpcSuccess(
          mockClient, 'send_counter_offer', <String, dynamic>{});

      await repository.sendCounterOffer('conv-abc', 'prod-xyz', 19.99);

      final captured = verify(
        () => mockClient.rpc(
          'send_counter_offer',
          params: captureAny(named: 'params'),
        ),
      ).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_conversation_id'], 'conv-abc');
      expect(params['p_product_id'], 'prod-xyz');
      expect(params['p_offer_price'], 19.99);
    });
  });

  // ---------------------------------------------------------------------------
  // respondToCounterOffer
  // ---------------------------------------------------------------------------
  group('respondToCounterOffer', () {
    test('returns response map on accept', () async {
      final response = <String, dynamic>{
        'id': 'offer-1',
        'status': 'accepted',
      };
      stubRpcSuccess(mockClient, 'respond_to_counter_offer', response);

      final result =
          await repository.respondToCounterOffer('offer-1', 'accept');

      expect(result, isNotNull);
      expect(result!['status'], 'accepted');
    });

    test('returns response map on decline', () async {
      final response = <String, dynamic>{
        'id': 'offer-1',
        'status': 'declined',
      };
      stubRpcSuccess(mockClient, 'respond_to_counter_offer', response);

      final result =
          await repository.respondToCounterOffer('offer-1', 'decline');

      expect(result, isNotNull);
      expect(result!['status'], 'declined');
    });

    test('returns null on exception', () async {
      stubRpcError(
          mockClient, 'respond_to_counter_offer', Exception('error'));

      final result =
          await repository.respondToCounterOffer('offer-1', 'accept');

      expect(result, isNull);
    });

    test('passes correct params', () async {
      stubRpcSuccess(
          mockClient, 'respond_to_counter_offer', <String, dynamic>{});

      await repository.respondToCounterOffer('offer-xyz', 'decline');

      final captured = verify(
        () => mockClient.rpc(
          'respond_to_counter_offer',
          params: captureAny(named: 'params'),
        ),
      ).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_offer_id'], 'offer-xyz');
      expect(params['p_action'], 'decline');
    });
  });

  // ---------------------------------------------------------------------------
  // deleteConversation
  // ---------------------------------------------------------------------------
  group('deleteConversation', () {
    test('calls RPC with correct conversationId', () async {
      stubRpcSuccess(mockClient, 'delete_conversation', null);

      await repository.deleteConversation('conv-to-delete');

      final captured = verify(
        () => mockClient.rpc(
          'delete_conversation',
          params: captureAny(named: 'params'),
        ),
      ).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_conversation_id'], 'conv-to-delete');
    });
  });
}

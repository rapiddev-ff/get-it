import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MessageRepository(Supabase.instance.client);
});

class MessageRepository {
  final SupabaseClient _client;

  MessageRepository(this._client);

  /// Creates or retrieves an existing conversation with a seller.
  Future<Map<String, dynamic>?> getOrCreateConversation(
    String sellerId,
    String currentUserId,
  ) async {
    try {
      final response = await _client.rpc(
        'get_or_create_conversation',
        params: {
          'p_seller_id': sellerId,
          'p_buyer_id': currentUserId,
        },
      );
      return response is Map<String, dynamic> ? response : null;
    } catch (e) {
      return null;
    }
  }

  /// Loads conversations for a user.
  Future<List<Map<String, dynamic>>> loadConversations(
    String userId, {
    String? filter,
  }) async {
    try {
      final response = await _client.rpc(
        'get_conversations',
        params: {
          'p_user_id': userId,
          if (filter != null) 'p_filter': filter,
        },
      );

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Loads messages for a conversation.
  Future<List<Map<String, dynamic>>> loadMessages(
    String conversationId, {
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await _client.rpc(
        'get_messages',
        params: {
          'p_conversation_id': conversationId,
          if (limit != null) 'p_limit': limit,
          if (offset != null) 'p_offset': offset,
        },
      );

      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Sends a message in a conversation.
  Future<Map<String, dynamic>?> sendMessage(
    String conversationId,
    String content, {
    List<String>? imageUrls,
  }) async {
    try {
      final response = await _client.rpc(
        'send_message',
        params: {
          'p_conversation_id': conversationId,
          'p_content': content,
          if (imageUrls != null && imageUrls.isNotEmpty)
            'p_image_urls': imageUrls,
        },
      );
      return response is Map<String, dynamic> ? response : null;
    } catch (e) {
      return null;
    }
  }

  /// Marks messages as read in a conversation.
  Future<void> markMessagesAsRead(
    String conversationId,
    String userId,
  ) async {
    try {
      await _client.rpc(
        'mark_messages_as_read',
        params: {
          'p_conversation_id': conversationId,
          'p_user_id': userId,
        },
      );
    } catch (_) {}
  }

  /// Gets total unread count across all conversations.
  Future<int> getTotalUnreadCount(String userId) async {
    try {
      final response = await _client.rpc(
        'get_total_unread_count',
        params: {'p_user_id': userId},
      );
      if (response is int) return response;
      if (response is num) return response.toInt();
      return 0;
    } catch (e) {
      return 0;
    }
  }

  /// Sends a counter offer in a conversation.
  Future<Map<String, dynamic>?> sendCounterOffer(
    String conversationId,
    String productId,
    double offerPrice,
  ) async {
    try {
      final response = await _client.rpc(
        'send_counter_offer',
        params: {
          'p_conversation_id': conversationId,
          'p_product_id': productId,
          'p_offer_price': offerPrice,
        },
      );
      return response is Map<String, dynamic> ? response : null;
    } catch (e) {
      return null;
    }
  }

  /// Responds to a counter offer (accept/decline).
  Future<Map<String, dynamic>?> respondToCounterOffer(
    String offerId,
    String action,
  ) async {
    try {
      final response = await _client.rpc(
        'respond_to_counter_offer',
        params: {
          'p_offer_id': offerId,
          'p_action': action,
        },
      );
      return response is Map<String, dynamic> ? response : null;
    } catch (e) {
      return null;
    }
  }

  /// Edits a message (only by sender).
  Future<bool> editMessage(String messageId, String content) async {
    try {
      await _client.rpc('edit_message', params: {
        'p_message_id': messageId,
        'p_content': content,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Soft-deletes a message (only by sender).
  Future<bool> deleteMessage(String messageId) async {
    try {
      await _client.rpc('delete_message', params: {
        'p_message_id': messageId,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Deletes a conversation.
  Future<void> deleteConversation(String conversationId) async {
    await _client.rpc(
      'delete_conversation',
      params: {'p_conversation_id': conversationId},
    );
  }

  /// Subscribes to conversation updates.
  RealtimeChannel subscribeConversations(
    String userId,
    void Function(PostgresChangePayload payload) onUpdate,
  ) {
    return _client
        .channel('conversations_channel_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'conversations',
          callback: onUpdate,
        )
        .subscribe();
  }

  /// Subscribes to new messages in a conversation.
  RealtimeChannel subscribeMessages(
    String conversationId,
    void Function(PostgresChangePayload payload) onUpdate,
  ) {
    return _client
        .channel('messages_channel_$conversationId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: onUpdate,
        )
        .subscribe();
  }
}

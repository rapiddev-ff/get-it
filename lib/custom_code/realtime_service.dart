import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

class RealtimeService {
  static RealtimeService? _instance;
  static RealtimeService get instance => _instance ??= RealtimeService._();

  RealtimeService._();

  RealtimeChannel? _conversationsChannel;
  RealtimeChannel? _messagesChannel;
  bool _conversationsSubscribed = false;

  Timer? _debounceTimer;
  bool _isRefreshing = false;

  SupabaseClient get _client => Supabase.instance.client;
  String? get _currentUserId => _client.auth.currentUser?.id;

  // ==========================================
  // CONVERSATIONS SUBSCRIPTION
  // ==========================================

  Future<void> subscribeToConversations({
    required Future<void> Function() onUpdate,
  }) async {
    if (_currentUserId == null) {
      print('❌ Cannot subscribe: User not authenticated');
      return;
    }

    // Don't re-subscribe if already active
    if (_conversationsSubscribed && _conversationsChannel != null) {
      print('ℹ️ Conversations already subscribed, skipping');
      return;
    }

    await unsubscribeFromConversations();

    print('🔔 Subscribing to conversations...');

    _conversationsChannel = _client
        .channel(
            'conversations_${_currentUserId}_${DateTime.now().millisecondsSinceEpoch}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'conversations',
          callback: (payload) async {
            final record = payload.newRecord.isNotEmpty
                ? payload.newRecord
                : payload.oldRecord;

            final buyerId = record['buyer_id']?.toString();
            final sellerId = record['seller_id']?.toString();
            final userId = _currentUserId;

            if (userId == null) {
              print('⚠️ Realtime callback: user not authenticated, skipping');
              return;
            }

            if (buyerId == userId || sellerId == userId) {
              print('📨 Conversation updated, scheduling refresh...');
              _debouncedRefresh(onUpdate);
            }
          },
        )
        .subscribe((status, error) {
      print('Conversations subscription: $status');
      if (status == RealtimeSubscribeStatus.subscribed) {
        _conversationsSubscribed = true;
      } else if (status == RealtimeSubscribeStatus.closed) {
        _conversationsSubscribed = false;
      }
      if (error != null) print('Error: $error');
    });
  }

  void _debouncedRefresh(Future<void> Function() onUpdate) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (_isRefreshing) {
        print('⏳ Already refreshing, skipping');
        return;
      }
      _isRefreshing = true;
      try {
        await onUpdate();
      } finally {
        _isRefreshing = false;
      }
    });
  }

  Future<void> unsubscribeFromConversations() async {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _isRefreshing = false;
    _conversationsSubscribed = false;

    if (_conversationsChannel != null) {
      await _client.removeChannel(_conversationsChannel!);
      _conversationsChannel = null;
      print('🔕 Unsubscribed from conversations');
    }
  }

  // ==========================================
  // MESSAGES SUBSCRIPTION
  // ==========================================

  Future<void> subscribeToMessages({
    required String conversationId,
    required void Function(Map<String, dynamic> message) onNewMessage,
    void Function(Map<String, dynamic> message)? onMessageUpdate,
  }) async {
    if (_currentUserId == null) return;

    await unsubscribeFromMessages();

    print('🔔 Subscribing to messages for: $conversationId');

    _messagesChannel = _client
        .channel(
            'messages_${conversationId}_${DateTime.now().millisecondsSinceEpoch}')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            print('📨 New message received');
            onNewMessage(payload.newRecord);
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            print('📝 Message updated');
            onMessageUpdate?.call(payload.newRecord);
          },
        )
        .subscribe((status, error) {
      print('Messages subscription: $status');
      if (error != null) print('Error: $error');
    });
  }

  Future<void> unsubscribeFromMessages() async {
    if (_messagesChannel != null) {
      await _client.removeChannel(_messagesChannel!);
      _messagesChannel = null;
      print('🔕 Unsubscribed from messages');
    }
  }

  // ==========================================
  // CLEANUP
  // ==========================================

  Future<void> disposeAll() async {
    _debounceTimer?.cancel();
    _debounceTimer = null;
    _isRefreshing = false;
    _conversationsSubscribed = false;
    await unsubscribeFromConversations();
    await unsubscribeFromMessages();
  }
}

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final realtimeServiceProvider = Provider<RealtimeService>((ref) {
  final service = RealtimeService(Supabase.instance.client);
  ref.onDispose(() => service.disposeAll());
  return service;
});

class RealtimeService {
  /// @deprecated Use realtimeServiceProvider instead.
  static RealtimeService? _instance;
  static RealtimeService get instance =>
      _instance ??= RealtimeService(Supabase.instance.client);

  final SupabaseClient _client;

  RealtimeService(this._client);

  RealtimeChannel? _conversationsChannel;
  RealtimeChannel? _messagesChannel;
  bool _conversationsSubscribed = false;

  Timer? _debounceTimer;
  bool _isRefreshing = false;

  String? get _currentUserId => _client.auth.currentUser?.id;

  // ==========================================
  // CONVERSATIONS SUBSCRIPTION
  // ==========================================

  Future<void> subscribeToConversations({
    required Future<void> Function() onUpdate,
  }) async {
    if (_currentUserId == null) {
      return;
    }

    // Don't re-subscribe if already active
    if (_conversationsSubscribed && _conversationsChannel != null) {
      return;
    }

    await unsubscribeFromConversations();

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
              return;
            }

            if (buyerId == userId || sellerId == userId) {
              _debouncedRefresh(onUpdate);
            }
          },
        )
        .subscribe((status, error) {
      if (status == RealtimeSubscribeStatus.subscribed) {
        _conversationsSubscribed = true;
      } else if (status == RealtimeSubscribeStatus.closed) {
        _conversationsSubscribed = false;
      }
    });
  }

  void _debouncedRefresh(Future<void> Function() onUpdate) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (_isRefreshing) {
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
            onMessageUpdate?.call(payload.newRecord);
          },
        )
        .subscribe((status, error) {});
  }

  Future<void> unsubscribeFromMessages() async {
    if (_messagesChannel != null) {
      await _client.removeChannel(_messagesChannel!);
      _messagesChannel = null;
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

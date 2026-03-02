// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/widgets/index.dart';
import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class InfiniteMessageList extends StatefulWidget {
  const InfiniteMessageList({
    super.key,
    this.width,
    this.height,
    required this.conversationId,
    required this.itemBuilder,
    this.loadingIndicator,
    this.emptyWidget,
    this.pageSize,
    this.loadMoreThreshold,
  });

  final double? width;
  final double? height;
  final String conversationId;
  final Widget Function(MessageStruct message) itemBuilder;
  final Widget Function()? loadingIndicator;
  final Widget Function()? emptyWidget;
  final int? pageSize;
  final double? loadMoreThreshold;

  @override
  State<InfiniteMessageList> createState() => _InfiniteMessageListState();
}

class _InfiniteMessageListState extends State<InfiniteMessageList> {
  final ScrollController _scrollController = ScrollController();

  List<MessageStruct> _messages = [];
  bool _isLoadingInitial = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _realtimeSubscribed = false;

  int get _pageSize => widget.pageSize ?? 30;
  double get _loadMoreThreshold => widget.loadMoreThreshold ?? 300.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initialize();
  }

  @override
  void didUpdateWidget(covariant InfiniteMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.conversationId != widget.conversationId) {
      _reset();
      _initialize();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _unsubscribeRealtime();
    super.dispose();
  }

  Future<void> _initialize() async {
    await _loadInitialMessages();
    _subscribeRealtime();
  }

  void _reset() {
    _unsubscribeRealtime();
    setState(() {
      _messages = [];
      _isLoadingInitial = true;
      _isLoadingMore = false;
      _hasMore = true;
      _realtimeSubscribed = false;
    });
  }

  // ── ЗАГРУЗКА ──

  Future<void> _loadInitialMessages() async {
    setState(() => _isLoadingInitial = true);
    try {
      final messages = await _fetchMessages(beforeDate: null);
      if (mounted) {
        setState(() {
          _messages = messages;
          _hasMore = messages.length >= _pageSize;
          _isLoadingInitial = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading initial messages: $e');
      if (mounted) setState(() => _isLoadingInitial = false);
    }
  }

  Future<void> _loadMoreMessages() async {
    if (_isLoadingMore || !_hasMore || _messages.isEmpty) return;
    setState(() => _isLoadingMore = true);
    try {
      final oldestMessage = _messages.last;
      final beforeDate = oldestMessage.createdAt;
      final olderMessages = await _fetchMessages(beforeDate: beforeDate);
      if (mounted) {
        setState(() {
          _messages.addAll(olderMessages);
          _hasMore = olderMessages.length >= _pageSize;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Error loading more messages: $e');
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  Future<List<MessageStruct>> _fetchMessages({
    required DateTime? beforeDate,
  }) async {
    final client = Supabase.instance.client;

    final response = await client.rpc('get_messages', params: {
      'p_conversation_id': widget.conversationId,
      'p_limit': _pageSize,
      'p_before_date': beforeDate?.toUtc().toIso8601String(),
    });

    if (response == null) return [];

    final List<MessageStruct> messages = [];

    for (final json in (response as List)) {
      // Берём первое фото
      MessageImageStruct? imageData;
      if (json['images'] != null && json['images'] is List) {
        final imgs = json['images'] as List;
        if (imgs.isNotEmpty) {
          imageData = MessageImageStruct(
            id: imgs[0]['id']?.toString() ?? '',
            imageUrl: imgs[0]['image_url'] ?? '',
          );
        }
      }

      // Counter offer
      CounterOfferStruct? counterOffer;
      if (json['counter_offer'] != null && json['counter_offer'] is Map) {
        final co = json['counter_offer'];
        counterOffer = CounterOfferStruct(
          id: co['id']?.toString() ?? '',
          originalPrice: (co['original_price'] ?? 0).toDouble(),
          offeredPrice: (co['offered_price'] ?? 0).toDouble(),
          status: _parseCounterOfferStatus(co['status']),
          fromUserId: co['from_user_id']?.toString() ?? '',
          toUserId: co['to_user_id']?.toString() ?? '',
          expiresAt: co['expires_at'] != null
              ? DateTime.parse(co['expires_at']).toLocal()
              : null,
          productId: co['product_id']?.toString() ?? '',
        );
      }

      final messageType = _parseMessageType(json['message_type']);

      messages.add(MessageStruct(
        id: json['id'] ?? '',
        conversationId: json['conversation_id'] ?? '',
        senderId: json['sender_id'] ?? '',
        content: json['content'] ?? '',
        messageType: messageType,
        isRead: json['is_read'] ?? false,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at']).toLocal()
            : DateTime.now(),
        senderUsername: json['sender_username'],
        senderAvatar: json['sender_avatar'],
        imageUrl: imageData?.imageUrl,
        counterOffer: counterOffer,
        isSending: false,
      ));
    }

    return messages;
  }

  // ── REALTIME ──

  void _subscribeRealtime() {
    if (_realtimeSubscribed) return;
    _realtimeSubscribed = true;

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    Supabase.instance.client
        .channel('messages:${widget.conversationId}')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: widget.conversationId,
          ),
          callback: (payload) => _handleNewMessage(payload, currentUserId),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: widget.conversationId,
          ),
          callback: (payload) => _handleMessageUpdate(payload),
        )
        .subscribe();
  }

  void _unsubscribeRealtime() {
    if (!_realtimeSubscribed) return;
    Supabase.instance.client.removeChannel(
      Supabase.instance.client.channel('messages:${widget.conversationId}'),
    );
    _realtimeSubscribed = false;
  }

  void _handleNewMessage(
      PostgresChangePayload payload, String? currentUserId) async {
    final json = payload.newRecord;
    if (json.isEmpty) return;

    final messageId = json['id']?.toString() ?? '';
    if (_messages.any((m) => m.id == messageId)) return;

    final messageType = _parseMessageType(json['message_type']);

    // Для image — дозагружаем через RPC
    if (messageType == MessageType.image) {
      try {
        final fullData =
            await Supabase.instance.client.rpc('get_messages', params: {
          'p_conversation_id': widget.conversationId,
          'p_limit': 1,
        });

        if (fullData != null && (fullData as List).isNotEmpty) {
          final fullJson = fullData[0];

          MessageImageStruct? imageData;
          if (fullJson['images'] != null && fullJson['images'] is List) {
            final imgs = fullJson['images'] as List;
            if (imgs.isNotEmpty) {
              imageData = MessageImageStruct(
                id: imgs[0]['id']?.toString() ?? '',
                imageUrl: imgs[0]['image_url'] ?? '',
              );
            }
          }

          final newMessage = MessageStruct(
            id: fullJson['id'] ?? '',
            conversationId: fullJson['conversation_id'] ?? '',
            senderId: fullJson['sender_id'] ?? '',
            content: fullJson['content'] ?? '',
            messageType: _parseMessageType(fullJson['message_type']),
            isRead: fullJson['is_read'] ?? false,
            createdAt: fullJson['created_at'] != null
                ? DateTime.parse(fullJson['created_at']).toLocal()
                : DateTime.now(),
            senderUsername: fullJson['sender_username'],
            senderAvatar: fullJson['sender_avatar'],
            imageUrl: imageData?.imageUrl,
            counterOffer: null,
            isSending: false,
          );

          if (mounted && !_messages.any((m) => m.id == newMessage.id)) {
            setState(() => _messages.insert(0, newMessage));
            _autoScrollToBottom();
          }
        }
      } catch (e) {
        debugPrint('❌ Error loading image message: $e');
      }

      if (json['sender_id'] != currentUserId) _markAsRead();
      return;
    }

    // Text message
    final newMessage = MessageStruct(
      id: messageId,
      conversationId: json['conversation_id'] ?? '',
      senderId: json['sender_id'] ?? '',
      content: json['content'] ?? '',
      messageType: messageType,
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at']).toLocal()
          : DateTime.now(),
      senderUsername: null,
      senderAvatar: null,
      imageUrl: null,
      counterOffer: null,
      isSending: false,
    );

    if (mounted) {
      setState(() => _messages.insert(0, newMessage));
      _autoScrollToBottom();
    }

    if (newMessage.senderId != currentUserId) _markAsRead();
  }

  void _handleMessageUpdate(PostgresChangePayload payload) {
    final json = payload.newRecord;
    if (json.isEmpty) return;

    final messageId = json['id']?.toString() ?? '';
    final isRead = json['is_read'] ?? false;

    if (mounted) {
      setState(() {
        _messages = _messages.map<MessageStruct>((m) {
          if (m.id == messageId) {
            return MessageStruct(
              id: m.id,
              conversationId: m.conversationId,
              senderId: m.senderId,
              content: m.content,
              messageType: m.messageType,
              isRead: isRead,
              createdAt: m.createdAt,
              senderUsername: m.senderUsername,
              senderAvatar: m.senderAvatar,
              imageUrl: m.imageUrl,
              counterOffer: m.counterOffer,
              isSending: m.isSending,
            );
          }
          return m;
        }).toList();
      });
    }
  }

  Future<void> _markAsRead() async {
    try {
      await Supabase.instance.client.rpc('mark_messages_as_read',
          params: {'p_conversation_id': widget.conversationId});
    } catch (e) {
      debugPrint('⚠️ Error marking as read: $e');
    }
  }

  // ── SCROLL ──

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _loadMoreThreshold) {
      _loadMoreMessages();
    }
  }

  void _autoScrollToBottom() {
    if (_scrollController.hasClients) {
      final currentScroll = _scrollController.position.pixels;
      if (currentScroll < 150) {
        Future.delayed(const Duration(milliseconds: 50), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(0,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut);
          }
        });
      }
    }
  }

  void addOptimisticMessage(MessageStruct message) {
    setState(() => _messages.insert(0, message));
    _autoScrollToBottom();
  }

  void replaceOptimisticMessage(String tempId, MessageStruct real) {
    setState(() {
      final index = _messages.indexWhere((m) => m.id == tempId);
      if (index != -1) _messages[index] = real;
    });
  }

  // ── BUILD ──

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoadingInitial) {
      return Center(
          child: widget.loadingIndicator?.call() ??
              const CircularProgressIndicator());
    }

    if (_messages.isEmpty) {
      return Center(
          child: widget.emptyWidget?.call() ??
              Text('No messages yet',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Inter',
                      color: FlutterFlowTheme.of(context).secondaryText)));
    }

    return ListView.separated(
      controller: _scrollController,
      reverse: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      addAutomaticKeepAlives: true,
      itemCount: _messages.length + (_hasMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          return Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                  child: _isLoadingMore
                      ? (widget.loadingIndicator?.call() ??
                          const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2)))
                      : const SizedBox.shrink()));
        }
        return widget.itemBuilder(_messages[index]);
      },
    );
  }

  static MessageType _parseMessageType(dynamic type) {
    if (type == null) return MessageType.text;
    final typeStr = type.toString().toLowerCase();
    switch (typeStr) {
      case 'image':
        return MessageType.image;
      case 'counter_offer':
        return MessageType.counter_offer;
      case 'system':
        return MessageType.system;
      default:
        return MessageType.text;
    }
  }

  static CounterOfferStatus _parseCounterOfferStatus(dynamic status) {
    if (status == null) return CounterOfferStatus.pending;
    final statusStr = status.toString().toLowerCase();
    switch (statusStr) {
      case 'accepted':
        return CounterOfferStatus.accepted;
      case 'rejected':
        return CounterOfferStatus.rejected;
      case 'expired':
        return CounterOfferStatus.expired;
      default:
        return CounterOfferStatus.pending;
    }
  }
}

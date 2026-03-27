import '/features/messages/domain/models/message_model.dart';
import '/features/messages/domain/models/message_image_model.dart';
import '/features/home/domain/models/counter_offer_model.dart';
import 'package:flutter/material.dart';
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
  final Widget Function(Message message) itemBuilder;
  final Widget Function()? loadingIndicator;
  final Widget Function()? emptyWidget;
  final int? pageSize;
  final double? loadMoreThreshold;

  @override
  InfiniteMessageListState createState() => InfiniteMessageListState();
}

class InfiniteMessageListState extends State<InfiniteMessageList> {
  final ScrollController _scrollController = ScrollController();

  List<Message> _messages = [];
  bool _isLoadingInitial = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  RealtimeChannel? _channel;

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
    if (!mounted) return;
    setState(() {
      _messages = [];
      _isLoadingInitial = true;
      _isLoadingMore = false;
      _hasMore = true;
    });
  }

  // -- LOADING --

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
      debugPrint('Error loading initial messages: $e');
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
          _messages = [..._messages, ...olderMessages];
          _hasMore = olderMessages.length >= _pageSize;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading more messages: $e');
      if (mounted) setState(() => _isLoadingMore = false);
    }
  }

  Future<List<Message>> _fetchMessages({
    required DateTime? beforeDate,
  }) async {
    final client = Supabase.instance.client;

    final response = await client.rpc('get_messages', params: {
      'p_conversation_id': widget.conversationId,
      'p_limit': _pageSize,
      'p_before_date': beforeDate?.toUtc().toIso8601String(),
    });

    if (response == null) return [];

    final List<Message> messages = [];

    for (final json in (response as List)) {
      // Get first image
      MessageImage? imageData;
      if (json['images'] != null && json['images'] is List) {
        final imgs = json['images'] as List;
        if (imgs.isNotEmpty) {
          imageData = MessageImage(
            id: imgs[0]['id']?.toString() ?? '',
            imageUrl: imgs[0]['image_url'] ?? '',
          );
        }
      }

      // Counter offer
      CounterOffer? counterOffer;
      if (json['counter_offer'] != null && json['counter_offer'] is Map) {
        final co = json['counter_offer'];
        counterOffer = CounterOffer(
          id: co['id']?.toString() ?? '',
          originalPrice: (co['original_price'] ?? 0).toDouble(),
          offeredPrice: (co['offered_price'] ?? 0).toDouble(),
          status: co['status']?.toString(),
          fromUserId: co['from_user_id']?.toString() ?? '',
          toUserId: co['to_user_id']?.toString() ?? '',
          expiresAt: co['expires_at'] != null
              ? DateTime.parse(co['expires_at']).toLocal()
              : null,
          productId: co['product_id']?.toString() ?? '',
        );
      }

      final messageType = json['message_type']?.toString() ?? 'text';

      messages.add(Message(
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

  // -- REALTIME --

  void _subscribeRealtime() {
    if (_channel != null) return;

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    _channel = Supabase.instance.client
        .channel(
            'messages:${widget.conversationId}:${DateTime.now().millisecondsSinceEpoch}')
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
    if (_channel == null) return;
    Supabase.instance.client.removeChannel(_channel!);
    _channel = null;
  }

  void _handleNewMessage(
      PostgresChangePayload payload, String? currentUserId) async {
    final json = payload.newRecord;
    if (json.isEmpty) return;

    final messageId = json['id']?.toString() ?? '';
    if (_messages.any((m) => m.id == messageId)) return;

    final messageType = json['message_type']?.toString() ?? 'text';

    // For image messages -- reload via RPC
    if (messageType == 'image') {
      try {
        final fullData =
            await Supabase.instance.client.rpc('get_messages', params: {
          'p_conversation_id': widget.conversationId,
          'p_limit': 1,
        });

        if (fullData != null && (fullData as List).isNotEmpty) {
          final fullJson = fullData[0];

          MessageImage? imageData;
          if (fullJson['images'] != null && fullJson['images'] is List) {
            final imgs = fullJson['images'] as List;
            if (imgs.isNotEmpty) {
              imageData = MessageImage(
                id: imgs[0]['id']?.toString() ?? '',
                imageUrl: imgs[0]['image_url'] ?? '',
              );
            }
          }

          final newMessage = Message(
            id: fullJson['id'] ?? '',
            conversationId: fullJson['conversation_id'] ?? '',
            senderId: fullJson['sender_id'] ?? '',
            content: fullJson['content'] ?? '',
            messageType: fullJson['message_type']?.toString() ?? 'text',
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
        debugPrint('Error loading image message: $e');
      }

      if (json['sender_id'] != currentUserId) _markAsRead();
      return;
    }

    // Text message
    final newMessage = Message(
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
    if (json.isEmpty || !mounted) return;

    final messageId = json['id']?.toString() ?? '';
    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    // Handle soft-delete
    if (json['deleted_at'] != null) {
      setState(() => _messages.removeAt(index));
      return;
    }

    final current = _messages[index];
    final isRead = json['is_read'] ?? current.isRead;
    final content = json['content']?.toString() ?? current.content;
    final isEdited = json['is_edited'] ?? current.isEdited;

    setState(() {
      _messages[index] = current.copyWith(
        isRead: isRead,
        content: content,
        isEdited: isEdited,
      );
    });
  }

  Future<void> _markAsRead() async {
    try {
      await Supabase.instance.client.rpc('mark_messages_as_read',
          params: {'p_conversation_id': widget.conversationId});
    } catch (e) {
      debugPrint('Error marking as read: $e');
    }
  }

  // -- SCROLL --

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

  /// Updates a message in the list (for edit).
  void updateMessage(String messageId, Message updated) {
    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      setState(() => _messages[index] = updated);
    }
  }

  /// Removes a message from the list (for delete).
  void removeMessage(String messageId) {
    setState(() => _messages.removeWhere((m) => m.id == messageId));
  }

  void addOptimisticMessage(Message message) {
    setState(() => _messages.insert(0, message));
    _autoScrollToBottom();
  }

  void replaceOptimisticMessage(String tempId, Message real) {
    setState(() {
      final index = _messages.indexWhere((m) => m.id == tempId);
      if (index != -1) _messages[index] = real;
    });
  }

  // -- BUILD --

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
                  style: Theme.of(context).textTheme.labelMedium!));
    }

    return ListView.separated(
      controller: _scrollController,
      reverse: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 8),
      addAutomaticKeepAlives: false,
      addRepaintBoundaries: true,
      itemCount: _messages.length + (_hasMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        if (index == _messages.length) {
          return _isLoadingMore
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : const SizedBox.shrink();
        }
        return RepaintBoundary(
          child: widget.itemBuilder(_messages[index]),
        );
      },
    );
  }
}

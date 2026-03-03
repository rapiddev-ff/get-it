import '/features/messages/domain/models/message_model.dart';
import '/features/messages/domain/models/conversation_model.dart';
import '/features/messages/presentation/providers/messages_provider.dart';
import '/custom_code/realtime_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future subscribeToMessages(WidgetRef ref, String conversationId) async {
  final currentUserId = Supabase.instance.client.auth.currentUser?.id;
  final client = Supabase.instance.client;

  await RealtimeService.instance.subscribeToMessages(
    conversationId: conversationId,
    onNewMessage: (json) async {
      final currentMessages = ref.read(messagesProvider).currentChatMessages;
      final exists = currentMessages.any((m) => m.id == json['id']);

      if (!exists) {
        final messageType = json['message_type']?.toString() ?? 'text';

        if (messageType == 'image') {
          try {
            final fullData = await client.rpc('get_messages', params: {
              'p_conversation_id': conversationId,
              'p_limit': 1,
            });

            if (fullData != null && (fullData as List).isNotEmpty) {
              final fullJson = fullData[0];

              String? imageUrl;
              if (fullJson['images'] != null && fullJson['images'] is List) {
                final imgs = fullJson['images'] as List;
                if (imgs.isNotEmpty) {
                  imageUrl = imgs[0]['image_url']?.toString();
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
                imageUrl: imageUrl,
                counterOffer: null,
                isSending: false,
              );

              final stillMissing = !ref
                  .read(messagesProvider)
                  .currentChatMessages
                  .any((m) => m.id == newMessage.id);

              if (stillMissing) {
                ref.read(messagesProvider.notifier).setCurrentChatMessages([
                  newMessage,
                  ...ref.read(messagesProvider).currentChatMessages,
                ]);
              }

              _updateConversationLastMessage(
                ref,
                conversationId,
                '📷 Photo',
                newMessage.createdAt ?? DateTime.now(),
              );
            }
          } catch (_) {}

          if (json['sender_id'] != currentUserId) {
            try {
              await client.rpc('mark_messages_as_read',
                  params: {'p_conversation_id': conversationId});
            } catch (_) {}
          }
          return;
        }

        final newMessage = Message(
          id: json['id'] ?? '',
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

        ref.read(messagesProvider.notifier).setCurrentChatMessages([
          newMessage,
          ...ref.read(messagesProvider).currentChatMessages,
        ]);

        _updateConversationLastMessage(
          ref,
          conversationId,
          newMessage.content,
          newMessage.createdAt ?? DateTime.now(),
        );

        if (newMessage.senderId != currentUserId) {
          try {
            await client.rpc('mark_messages_as_read',
                params: {'p_conversation_id': conversationId});
          } catch (_) {}
        }
      }
    },
    onMessageUpdate: (json) {
      final messageId = json['id'];
      final isRead = json['is_read'] ?? false;

      final updated = ref.read(messagesProvider).currentChatMessages.map((m) {
        if (m.id == messageId) {
          return m.copyWith(isRead: isRead);
        }
        return m;
      }).toList();
      ref.read(messagesProvider.notifier).setCurrentChatMessages(updated);
    },
  );
}

void _updateConversationLastMessage(
  WidgetRef ref,
  String conversationId,
  String messageText,
  DateTime messageTime,
) {
  final conversations = ref.read(messagesProvider).conversations;
  final index = conversations.indexWhere((c) => c.id == conversationId);
  if (index == -1) return;

  final old = conversations[index];
  final updated = old.copyWith(
    lastMessageText: messageText,
    lastMessageAt: messageTime,
  );

  final list = List<Conversation>.from(conversations);
  list.removeAt(index);
  list.insert(0, updated);
  ref.read(messagesProvider.notifier).setConversations(list);
}

import '/features/messages/domain/models/message_model.dart';
import '/features/messages/domain/models/conversation_model.dart';
import '/features/messages/presentation/providers/messages_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<Message?> sendMessage(
  WidgetRef ref,
  String conversationId,
  String content,
  List<String>? imageUrls,
) async {
  final client = Supabase.instance.client;

  try {
    final response = await client.rpc(
      'send_message',
      params: {
        'p_conversation_id': conversationId,
        'p_content': content,
        'p_image_urls': imageUrls ?? [],
      },
    );

    if (response == null || (response as List).isEmpty) return null;

    final json = response[0];

    String? imageUrl;
    if (json['images'] != null && json['images'] is List) {
      final imgs = json['images'] as List;
      if (imgs.isNotEmpty) {
        imageUrl = imgs[0]['image_url']?.toString();
      }
    }

    final messageType = json['message_type']?.toString() ?? 'text';

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
      senderUsername: json['sender_username'],
      senderAvatar: json['sender_avatar'],
      imageUrl: imageUrl,
      counterOffer: null,
      isSending: false,
    );

    final currentMessages = ref.read(messagesProvider).currentChatMessages;
    final exists = currentMessages.any((m) => m.id == newMessage.id);

    if (!exists) {
      ref.read(messagesProvider.notifier).setCurrentChatMessages([
        newMessage,
        ...currentMessages,
      ]);
    }

    final lastMsgText = messageType == 'image' ? '📷 Photo' : content;

    _updateConversationLastMessage(
      ref,
      conversationId,
      lastMsgText,
      newMessage.createdAt ?? DateTime.now(),
    );

    return newMessage;
  } catch (_) {
    return null;
  }
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

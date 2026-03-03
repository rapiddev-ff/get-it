import '/backend/schema/enums/enums.dart';
import '/features/messages/domain/models/message_model.dart';
import '/features/messages/domain/models/conversation_model.dart';
import '/backend/supabase/supabase.dart';
import '/core/state/app_state_service.dart';
import '/core/utils/uploaded_file.dart';
import 'index.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

Future<List<Message>> uploadAndSendImages(
  String conversationId,
  List<FFUploadedFile> images,
) async {
  final client = Supabase.instance.client;
  final userId = client.auth.currentUser?.id;
  final List<Message> sentMessages = [];

  if (userId == null || images.isEmpty) return [];

  for (final image in images) {
    try {
      if (image.bytes == null) continue;

      final ext = image.name?.split('.').last ?? 'jpg';
      final fileName = '${const Uuid().v4()}.$ext';
      final path = '$userId/$fileName';

      await client.storage.from('chat-images').uploadBinary(
            path,
            image.bytes!,
            fileOptions: FileOptions(
              contentType: 'image/$ext',
              upsert: true,
            ),
          );

      final imageUrl = client.storage.from('chat-images').getPublicUrl(path);

      final response = await client.rpc('send_message', params: {
        'p_conversation_id': conversationId,
        'p_content': '',
        'p_image_urls': [imageUrl],
      });

      if (response == null || (response as List).isEmpty) continue;

      final json = response[0];

      // Берём первое фото
      String? msgImageUrl;
      if (json['images'] != null && json['images'] is List) {
        final imgs = json['images'] as List;
        if (imgs.isNotEmpty) {
          msgImageUrl = imgs[0]['image_url']?.toString();
        }
      }

      final newMessage = Message(
        id: json['id'] ?? '',
        conversationId: json['conversation_id'] ?? '',
        senderId: json['sender_id'] ?? '',
        content: json['content'] ?? '',
        messageType: 'image',
        isRead: json['is_read'] ?? false,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at']).toLocal()
            : DateTime.now(),
        senderUsername: json['sender_username'],
        senderAvatar: json['sender_avatar'],
        imageUrl: msgImageUrl,
        counterOffer: null,
        isSending: false,
      );

      final exists =
          FFAppState().currentChatMessages.any((m) => m.id == newMessage.id);

      if (!exists) {
        FFAppState().update(() {
          FFAppState().currentChatMessages = [
            newMessage,
            ...FFAppState().currentChatMessages,
          ];
        });
      }

      sentMessages.add(newMessage);
    } catch (e) {
      print('❌ Error uploading image: $e');
    }
  }

  if (sentMessages.isNotEmpty) {
    _updateConversationLastMessage(
      conversationId,
      '📷 Photo',
      sentMessages.last.createdAt ?? DateTime.now(),
    );
  }

  return sentMessages;
}

void _updateConversationLastMessage(
  String conversationId,
  String messageText,
  DateTime messageTime,
) {
  final conversations = FFAppState().conversations;
  final index = conversations.indexWhere((c) => c.id == conversationId);
  if (index == -1) return;

  final old = conversations[index];
  final updated = old.copyWith(
    lastMessageText: messageText,
    lastMessageAt: messageTime,
  );

  FFAppState().update(() {
    final list = List<Conversation>.from(FFAppState().conversations);
    list.removeAt(index);
    list.insert(0, updated);
    FFAppState().conversations = list;
  });
}

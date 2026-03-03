// Automatic FlutterFlow imports
import '/backend/schema/enums/enums.dart';
import '/features/messages/domain/models/message_model.dart';
import '/features/messages/domain/models/conversation_model.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<Message?> sendMessage(
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

    // Берём первое фото если есть
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

    final lastMsgText = messageType == 'image' ? '📷 Photo' : content;

    _updateConversationLastMessage(
      conversationId,
      lastMsgText,
      newMessage.createdAt ?? DateTime.now(),
    );

    return newMessage;
  } catch (e) {
    print('❌ Error sending message: $e');
    return null;
  }
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


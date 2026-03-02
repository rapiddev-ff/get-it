// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
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

Future<MessageStruct?> sendMessage(
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

    final messageType = _parseMessageType(json['message_type']);

    final newMessage = MessageStruct(
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

    final lastMsgText = messageType == MessageType.image ? '📷 Photo' : content;

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
  final updated = ConversationStruct(
    id: old.id,
    buyerId: old.buyerId,
    sellerId: old.sellerId,
    productId: old.productId,
    lastMessageText: messageText,
    lastMessageAt: messageTime,
    buyerUnreadCount: old.buyerUnreadCount,
    sellerUnreadCount: old.sellerUnreadCount,
    otherUserId: old.otherUserId,
    otherUserUsername: old.otherUserUsername,
    otherUserAvatar: old.otherUserAvatar,
    otherUserLastActive: old.otherUserLastActive,
    productTitle: old.productTitle,
    productImage: old.productImage,
    productPrice: old.productPrice,
    productCondition: old.productCondition,
  );

  FFAppState().update(() {
    final list = List<ConversationStruct>.from(FFAppState().conversations);
    list.removeAt(index);
    list.insert(0, updated);
    FFAppState().conversations = list;
  });
}

MessageType _parseMessageType(dynamic type) {
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

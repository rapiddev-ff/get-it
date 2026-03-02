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

Future<List<MessageStruct>> loadMessages(
  String conversationId,
  int limit,
  DateTime? beforeDate,
) async {
  final client = Supabase.instance.client;

  try {
    final response = await client.rpc(
      'get_messages',
      params: {
        'p_conversation_id': conversationId,
        'p_limit': limit,
        'p_before_date': beforeDate?.toUtc().toIso8601String(),
      },
    );

    if (response == null) return [];

    final List<MessageStruct> messages = [];

    for (final json in (response as List)) {
      // Берём первое фото
      String? imageUrl;
      if (json['images'] != null && json['images'] is List) {
        final imgs = json['images'] as List;
        if (imgs.isNotEmpty) {
          imageUrl = imgs[0]['image_url']?.toString();
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
        imageUrl: imageUrl,
        counterOffer: counterOffer,
        isSending: false,
      ));
    }

    return messages;
  } catch (e) {
    print('❌ Error loading messages: $e');
    return [];
  }
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

CounterOfferStatus _parseCounterOfferStatus(dynamic status) {
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

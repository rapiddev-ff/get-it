import '/backend/schema/enums/enums.dart';
import '/features/messages/domain/models/message_model.dart';
import '/features/home/domain/models/counter_offer_model.dart';
import '/backend/supabase/supabase.dart';
import 'index.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Message>> loadMessages(
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

    final List<Message> messages = [];

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
      CounterOffer? counterOffer;
      if (json['counter_offer'] != null && json['counter_offer'] is Map) {
        final co = json['counter_offer'];
        counterOffer = CounterOffer(
          id: co['id']?.toString() ?? '',
          originalPrice: (co['original_price'] ?? 0).toDouble(),
          offeredPrice: (co['offered_price'] ?? 0).toDouble(),
          status: co['status']?.toString() ?? 'pending',
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


import '/features/messages/domain/models/conversation_model.dart';
import '/backend/supabase/supabase.dart';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<Conversation?> getOrCreateConversation(
  String sellerId,
  String? productId,
) async {
  final client = Supabase.instance.client;

  try {
    final response = await client.rpc(
      'get_or_create_conversation',
      params: {
        'p_seller_id': sellerId,
        if (productId != null && productId.isNotEmpty)
          'p_product_id': productId,
      },
    );

    if (response == null || (response as List).isEmpty) return null;

    final json = response[0];

    return Conversation(
      id: json['id'] ?? '',
      buyerId: json['buyer_id'] ?? '',
      sellerId: json['seller_id'] ?? '',
      productId: (json['product_id'] != null &&
              json['product_id'].toString().isNotEmpty)
          ? json['product_id']
          : null,
      lastMessageText: json['last_message_text'],
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'])
          : null,
      buyerUnreadCount: json['buyer_unread_count'] ?? 0,
      sellerUnreadCount: json['seller_unread_count'] ?? 0,
      otherUserId: json['other_user_id'] ?? '',
      otherUserUsername: json['other_user_username'] ?? 'User',
      otherUserAvatar: (json['other_user_avatar'] != null &&
              json['other_user_avatar'].toString().isNotEmpty)
          ? json['other_user_avatar']
          : null,
      productTitle: (json['product_title'] != null &&
              json['product_title'].toString().isNotEmpty)
          ? json['product_title']
          : null,
      productImage: (json['product_image'] != null &&
              json['product_image'].toString().isNotEmpty)
          ? json['product_image']
          : null,
      productPrice: (json['product_price'] as num?)?.toDouble(),
    );
  } catch (e) {
    debugPrint('[getOrCreateConversation] Error: $e');
    return null;
  }
}

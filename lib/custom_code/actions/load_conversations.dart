import '/features/messages/domain/models/conversation_model.dart';
import '/features/messages/presentation/providers/messages_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String? _nullIfEmpty(dynamic value) {
  if (value == null) return null;
  final str = value.toString();
  return str.isNotEmpty ? str : null;
}

Future<List<Conversation>> loadConversations(
  WidgetRef ref,
  String filter,
) async {
  final client = Supabase.instance.client;

  if (client.auth.currentUser == null) {
    return [];
  }

  try {
    final response = await client.rpc(
      'get_conversations',
      params: {'p_filter': 'all'},
    );

    if (response == null) {
      return [];
    }

    final all = (response as List).map((json) {
      return Conversation(
        id: json['id'] ?? '',
        buyerId: json['buyer_id'] ?? '',
        sellerId: json['seller_id'] ?? '',
        productId: _nullIfEmpty(json['product_id']),
        lastMessageText: json['last_message_text'],
        lastMessageAt: json['last_message_at'] != null
            ? DateTime.parse(json['last_message_at'])
            : null,
        buyerUnreadCount: json['buyer_unread_count'] ?? 0,
        sellerUnreadCount: json['seller_unread_count'] ?? 0,
        otherUserId: json['other_user_id'] ?? '',
        otherUserUsername: json['other_user_username'] ?? 'User',
        otherUserAvatar: _nullIfEmpty(json['other_user_avatar']),
        otherUserLastActive: json['other_user_last_active'] != null
            ? DateTime.parse(json['other_user_last_active'])
            : null,
        productTitle: _nullIfEmpty(json['product_title']),
        productImage: _nullIfEmpty(json['product_image']),
        productPrice: (json['product_price'] as num?)?.toDouble(),
        productCondition: _nullIfEmpty(json['product_condition']),
        role: json['role'] ?? 'buyer',
      );
    }).toList();

    ref.read(messagesProvider.notifier).setConversations(all);

    List<Conversation> filtered;
    if (filter == 'buying') {
      filtered =
          all.where((c) => c.role == 'buyer' || c.role == 'both').toList();
    } else if (filter == 'selling') {
      filtered =
          all.where((c) => c.role == 'seller' || c.role == 'both').toList();
    } else {
      filtered = all;
    }

    return filtered;
  } catch (_) {
    return [];
  }
}

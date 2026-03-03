import '/features/messages/domain/models/conversation_model.dart';
import '/features/messages/presentation/providers/messages_provider.dart';
import '/custom_code/realtime_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String? _nullIfEmptySub(dynamic value) {
  if (value == null) return null;
  final str = value.toString();
  return str.isNotEmpty ? str : null;
}

Future subscribeToConversations(WidgetRef ref) async {
  await RealtimeService.instance.subscribeToConversations(
    onUpdate: () async {
      final client = Supabase.instance.client;

      if (client.auth.currentUser == null) {
        return;
      }

      try {
        final response = await client.rpc(
          'get_conversations',
          params: {'p_filter': 'all'},
        );

        if (response == null) {
          return;
        }

        final all = (response as List).map((json) {
          return Conversation(
            id: json['id'] ?? '',
            buyerId: json['buyer_id'] ?? '',
            sellerId: json['seller_id'] ?? '',
            productId: _nullIfEmptySub(json['product_id']),
            lastMessageText: json['last_message_text'],
            lastMessageAt: json['last_message_at'] != null
                ? DateTime.parse(json['last_message_at'])
                : null,
            buyerUnreadCount: json['buyer_unread_count'] ?? 0,
            sellerUnreadCount: json['seller_unread_count'] ?? 0,
            otherUserId: json['other_user_id'] ?? '',
            otherUserUsername: json['other_user_username'] ?? 'User',
            otherUserAvatar: _nullIfEmptySub(json['other_user_avatar']),
            otherUserLastActive: json['other_user_last_active'] != null
                ? DateTime.parse(json['other_user_last_active'])
                : null,
            productTitle: _nullIfEmptySub(json['product_title']),
            productImage: _nullIfEmptySub(json['product_image']),
            productPrice: (json['product_price'] as num?)?.toDouble(),
            productCondition: _nullIfEmptySub(json['product_condition']),
            role: json['role'] ?? 'buyer',
          );
        }).toList();

        final currentConversations = ref.read(messagesProvider).conversations;

        // Don't overwrite with empty if we had data before
        if (all.isEmpty && currentConversations.isNotEmpty) {
          return;
        }

        // Only update if data actually changed
        final oldIds = currentConversations.map((c) => c.id).toSet();
        final newIds = all.map((c) => c.id).toSet();

        final hasChanges = oldIds.length != newIds.length ||
            !oldIds.containsAll(newIds) ||
            all.any((newConv) {
              final oldConv = currentConversations
                  .where((c) => c.id == newConv.id)
                  .firstOrNull;
              if (oldConv == null) return true;
              return oldConv.lastMessageText != newConv.lastMessageText ||
                  oldConv.buyerUnreadCount != newConv.buyerUnreadCount ||
                  oldConv.sellerUnreadCount != newConv.sellerUnreadCount;
            });

        if (!hasChanges) {
          return;
        }

        ref.read(messagesProvider.notifier).setConversations(all);

        final unreadResponse = await client.rpc('get_total_unread_count');
        ref
            .read(messagesProvider.notifier)
            .setTotalUnreadCount(unreadResponse as int? ?? 0);
      } catch (_) {}
    },
  );
}

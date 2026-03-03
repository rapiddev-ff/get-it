import '/features/messages/domain/models/conversation_model.dart';
import '/features/messages/presentation/providers/messages_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future markMessagesAsRead(WidgetRef ref, String conversationId) async {
  final client = Supabase.instance.client;
  final currentUserId = client.auth.currentUser?.id;

  try {
    await client.rpc(
      'mark_messages_as_read',
      params: {'p_conversation_id': conversationId},
    );

    if (currentUserId != null) {
      final conversations = ref.read(messagesProvider).conversations;
      final index = conversations.indexWhere((c) => c.id == conversationId);

      if (index != -1) {
        final old = conversations[index];

        final isBuyer = old.buyerId == currentUserId;

        final updated = old.copyWith(
          buyerUnreadCount: isBuyer ? 0 : old.buyerUnreadCount,
          sellerUnreadCount: isBuyer ? old.sellerUnreadCount : 0,
        );

        final list = List<Conversation>.from(conversations);
        list[index] = updated;
        ref.read(messagesProvider.notifier).setConversations(list);
      }
    }
  } catch (_) {}
}

import '/backend/schema/enums/enums.dart';
import '/features/messages/domain/models/conversation_model.dart';
import '/backend/supabase/supabase.dart';
import '/core/state/app_state_service.dart';
import 'index.dart';
import 'package:flutter/material.dart';

import '/custom_code/realtime_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String? _nullIfEmptySub(dynamic value) {
  if (value == null) return null;
  final str = value.toString();
  return str.isNotEmpty ? str : null;
}

Future subscribeToConversations() async {
  await RealtimeService.instance.subscribeToConversations(
    onUpdate: () async {
      final client = Supabase.instance.client;

      if (client.auth.currentUser == null) {
        print('⚠️ Realtime: User not authenticated, skipping refresh');
        return;
      }

      try {
        final response = await client.rpc(
          'get_conversations',
          params: {'p_filter': 'all'},
        );

        if (response == null) {
          print('⚠️ Realtime: RPC returned null, skipping');
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

        // Don't overwrite with empty if we had data before
        if (all.isEmpty && FFAppState().conversations.isNotEmpty) {
          print('⚠️ Realtime: returned empty list, skipping update');
          return;
        }

        // Only update if data actually changed
        final oldIds = FFAppState().conversations.map((c) => c.id).toSet();
        final newIds = all.map((c) => c.id).toSet();

        final hasChanges = oldIds.length != newIds.length ||
            !oldIds.containsAll(newIds) ||
            all.any((newConv) {
              final oldConv = FFAppState()
                  .conversations
                  .where((c) => c.id == newConv.id)
                  .firstOrNull;
              if (oldConv == null) return true;
              return oldConv.lastMessageText != newConv.lastMessageText ||
                  oldConv.buyerUnreadCount != newConv.buyerUnreadCount ||
                  oldConv.sellerUnreadCount != newConv.sellerUnreadCount;
            });

        if (!hasChanges) {
          print('ℹ️ Realtime: no changes, skipping UI update');
          return;
        }

        print('📋 Realtime loaded ${all.length} conversations');
        for (final c in all) {
          print('  - ${c.otherUserUsername}: role=${c.role}, id=${c.id}');
        }

        FFAppState().update(() {
          FFAppState().conversations = all;
        });

        final unreadResponse = await client.rpc('get_total_unread_count');
        FFAppState().update(() {
          FFAppState().totalUnreadCount = unreadResponse as int? ?? 0;
        });

        print('✅ Conversations refreshed via realtime');
      } catch (e) {
        print('❌ Error refreshing conversations: $e');
      }
    },
  );
}

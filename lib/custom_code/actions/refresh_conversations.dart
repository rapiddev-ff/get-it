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

String? _nullIfEmptyRefresh(dynamic value) {
  if (value == null) return null;
  final str = value.toString();
  return str.isNotEmpty ? str : null;
}

Future refreshConversations() async {
  print('🔄 refreshConversations called');

  final client = Supabase.instance.client;

  if (client.auth.currentUser == null) {
    print('⚠️ refreshConversations: User not authenticated');
    return;
  }

  try {
    final response = await client.rpc(
      'get_conversations',
      params: {'p_filter': 'all'},
    );

    if (response == null) {
      print('⚠️ refreshConversations: RPC returned null');
      return;
    }

    final all = (response as List).map((json) {
      return ConversationStruct(
        id: json['id'] ?? '',
        buyerId: json['buyer_id'] ?? '',
        sellerId: json['seller_id'] ?? '',
        productId: _nullIfEmptyRefresh(json['product_id']),
        lastMessageText: json['last_message_text'],
        lastMessageAt: json['last_message_at'] != null
            ? DateTime.parse(json['last_message_at'])
            : null,
        buyerUnreadCount: json['buyer_unread_count'] ?? 0,
        sellerUnreadCount: json['seller_unread_count'] ?? 0,
        otherUserId: json['other_user_id'] ?? '',
        otherUserUsername: json['other_user_username'] ?? 'User',
        otherUserAvatar: _nullIfEmptyRefresh(json['other_user_avatar']),
        otherUserLastActive: json['other_user_last_active'] != null
            ? DateTime.parse(json['other_user_last_active'])
            : null,
        productTitle: _nullIfEmptyRefresh(json['product_title']),
        productImage: _nullIfEmptyRefresh(json['product_image']),
        productPrice: (json['product_price'] as num?)?.toDouble(),
        productCondition: _nullIfEmptyRefresh(json['product_condition']),
        role: json['role'] ?? 'buyer',
      );
    }).toList();

    if (all.isEmpty && FFAppState().conversations.isNotEmpty) {
      print('⚠️ refreshConversations: got empty list, skipping');
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
      print('ℹ️ refreshConversations: no changes, skipping UI update');
      return;
    }

    print('✅ refreshConversations: loaded ${all.length} conversations');

    FFAppState().update(() {
      FFAppState().conversations = all;
    });

    final unreadResponse = await client.rpc('get_total_unread_count');
    FFAppState().update(() {
      FFAppState().totalUnreadCount = unreadResponse as int? ?? 0;
    });
  } catch (e) {
    print('❌ refreshConversations error: $e');
  }
}

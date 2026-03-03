// Automatic FlutterFlow imports
import '/backend/schema/enums/enums.dart';
import '/features/messages/domain/models/conversation_model.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:supabase_flutter/supabase_flutter.dart';

Future markMessagesAsRead(String conversationId) async {
  final client = Supabase.instance.client;
  final currentUserId = client.auth.currentUser?.id;

  try {
    await client.rpc(
      'mark_messages_as_read',
      params: {'p_conversation_id': conversationId},
    );

    print('✅ Messages marked as read');

    // ✅ Сбрасываем счётчик в AppState
    if (currentUserId != null) {
      final conversations = FFAppState().conversations;
      final index = conversations.indexWhere((c) => c.id == conversationId);

      if (index != -1) {
        final old = conversations[index];

        final isBuyer = old.buyerId == currentUserId;

        final updated = old.copyWith(
          buyerUnreadCount: isBuyer ? 0 : old.buyerUnreadCount,
          sellerUnreadCount: isBuyer ? old.sellerUnreadCount : 0,
        );

        FFAppState().update(() {
          final list =
              List<Conversation>.from(FFAppState().conversations);
          list[index] = updated;
          FFAppState().conversations = list;
        });

        print('✅ Unread count reset in AppState');
      }
    }
  } catch (e) {
    print('❌ Error marking messages as read: $e');
  }
}

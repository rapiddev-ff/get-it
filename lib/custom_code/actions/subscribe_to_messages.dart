import '/backend/schema/enums/enums.dart';
import '/features/messages/domain/models/message_model.dart';
import '/features/messages/domain/models/conversation_model.dart';
import '/backend/supabase/supabase.dart';
import '/core/state/app_state_service.dart';
import 'index.dart';
import 'package:flutter/material.dart';
import '/custom_code/realtime_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future subscribeToMessages(String conversationId) async {
  final currentUserId = Supabase.instance.client.auth.currentUser?.id;
  final client = Supabase.instance.client;

  await RealtimeService.instance.subscribeToMessages(
    conversationId: conversationId,
    onNewMessage: (json) async {
      print('📨 Processing new message: ${json['id']}');

      final exists =
          FFAppState().currentChatMessages.any((m) => m.id == json['id']);

      if (!exists) {
        final messageType = json['message_type']?.toString() ?? 'text';

        // IMAGE: дозагружаем через RPC
        if (messageType == 'image') {
          try {
            final fullData = await client.rpc('get_messages', params: {
              'p_conversation_id': conversationId,
              'p_limit': 1,
            });

            if (fullData != null && (fullData as List).isNotEmpty) {
              final fullJson = fullData[0];

              String? imageUrl;
              if (fullJson['images'] != null && fullJson['images'] is List) {
                final imgs = fullJson['images'] as List;
                if (imgs.isNotEmpty) {
                  imageUrl = imgs[0]['image_url']?.toString();
                }
              }

              final newMessage = Message(
                id: fullJson['id'] ?? '',
                conversationId: fullJson['conversation_id'] ?? '',
                senderId: fullJson['sender_id'] ?? '',
                content: fullJson['content'] ?? '',
                messageType: fullJson['message_type']?.toString() ?? 'text',
                isRead: fullJson['is_read'] ?? false,
                createdAt: fullJson['created_at'] != null
                    ? DateTime.parse(fullJson['created_at']).toLocal()
                    : DateTime.now(),
                senderUsername: fullJson['sender_username'],
                senderAvatar: fullJson['sender_avatar'],
                imageUrl: imageUrl,
                counterOffer: null,
                isSending: false,
              );

              final stillMissing = !FFAppState()
                  .currentChatMessages
                  .any((m) => m.id == newMessage.id);

              if (stillMissing) {
                FFAppState().update(() {
                  FFAppState().currentChatMessages = [
                    newMessage,
                    ...FFAppState().currentChatMessages,
                  ];
                });
                print('✅ Image message added via RPC');
              }

              _updateConversationLastMessage(
                conversationId,
                '📷 Photo',
                newMessage.createdAt ?? DateTime.now(),
              );
            }
          } catch (e) {
            print('❌ Error loading image message: $e');
          }

          if (json['sender_id'] != currentUserId) {
            try {
              await client.rpc('mark_messages_as_read',
                  params: {'p_conversation_id': conversationId});
            } catch (_) {}
          }
          return;
        }

        // TEXT: как раньше
        final newMessage = Message(
          id: json['id'] ?? '',
          conversationId: json['conversation_id'] ?? '',
          senderId: json['sender_id'] ?? '',
          content: json['content'] ?? '',
          messageType: messageType,
          isRead: json['is_read'] ?? false,
          createdAt: json['created_at'] != null
              ? DateTime.parse(json['created_at']).toLocal()
              : DateTime.now(),
          senderUsername: null,
          senderAvatar: null,
          imageUrl: null,
          counterOffer: null,
          isSending: false,
        );

        FFAppState().update(() {
          FFAppState().currentChatMessages = [
            newMessage,
            ...FFAppState().currentChatMessages,
          ];
        });

        print('✅ Text message added');

        _updateConversationLastMessage(
          conversationId,
          newMessage.content,
          newMessage.createdAt ?? DateTime.now(),
        );

        if (newMessage.senderId != currentUserId) {
          try {
            await client.rpc('mark_messages_as_read',
                params: {'p_conversation_id': conversationId});
            print('✅ Marked as read');
          } catch (e) {
            print('⚠️ Error marking as read: $e');
          }
        }
      } else {
        print('⚠️ Message already exists, skipping');
      }
    },
    onMessageUpdate: (json) {
      print('📝 Message updated: ${json['id']}');

      final messageId = json['id'];
      final isRead = json['is_read'] ?? false;

      FFAppState().update(() {
        FFAppState().currentChatMessages =
            FFAppState().currentChatMessages.map((m) {
          if (m.id == messageId) {
            return m.copyWith(isRead: isRead);
          }
          return m;
        }).toList();
      });
    },
  );
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
  final updated = old.copyWith(
    lastMessageText: messageText,
    lastMessageAt: messageTime,
  );

  FFAppState().update(() {
    final list = List<Conversation>.from(FFAppState().conversations);
    list.removeAt(index);
    list.insert(0, updated);
    FFAppState().conversations = list;
  });
}

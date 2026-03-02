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

String? _nullIfEmpty(dynamic value) {
  if (value == null) return null;
  final str = value.toString();
  return str.isNotEmpty ? str : null;
}

Future<List<ConversationStruct>> loadConversations(String filter) async {
  print('🔄 loadConversations called with filter: $filter');

  final client = Supabase.instance.client;

  if (client.auth.currentUser == null) {
    print('⚠️ loadConversations: User not authenticated');
    return [];
  }

  try {
    final response = await client.rpc(
      'get_conversations',
      params: {'p_filter': 'all'},
    );

    if (response == null) {
      print('⚠️ loadConversations: RPC returned null');
      return [];
    }

    final all = (response as List).map((json) {
      return ConversationStruct(
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

    print('📋 loadConversations: loaded ${all.length} total');
    for (final c in all) {
      print('  - ${c.otherUserUsername}: role=${c.role}');
    }

    FFAppState().update(() {
      FFAppState().conversations = all;
    });

    List<ConversationStruct> filtered;
    if (filter == 'buying') {
      filtered =
          all.where((c) => c.role == 'buyer' || c.role == 'both').toList();
    } else if (filter == 'selling') {
      filtered =
          all.where((c) => c.role == 'seller' || c.role == 'both').toList();
    } else {
      filtered = all;
    }

    print('📋 loadConversations: returning ${filtered.length} for "$filter"');
    return filtered;
  } catch (e) {
    print('❌ Error loading conversations: $e');
    return [];
  }
}

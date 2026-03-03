import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '/core/utils/json_converters.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

@freezed
class Conversation with _$Conversation {
  const Conversation._();

  const factory Conversation({
    @Default('') String id,
    @Default('') String buyerId,
    @Default('') String sellerId,
    String? productId,
    String? lastMessageText,
    @DateTimeConverter() DateTime? lastMessageAt,
    @Default(0) int buyerUnreadCount,
    @Default(0) int sellerUnreadCount,
    @Default('') String otherUserId,
    @Default('') String otherUserUsername,
    String? otherUserAvatar,
    @DateTimeConverter() DateTime? otherUserLastActive,
    String? productTitle,
    String? productImage,
    double? productPrice,
    String? productCondition,
    @Default('') String role,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);

  String serialize() => jsonEncode(toJson());

  static Conversation fromSerializableMap(Map<String, dynamic> data) =>
      Conversation.fromJson(data);
}

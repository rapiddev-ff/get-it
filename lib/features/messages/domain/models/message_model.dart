import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '/core/utils/json_converters.dart';
import '/features/home/domain/models/counter_offer_model.dart';
import 'message_image_model.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class Message with _$Message {
  const Message._();

  const factory Message({
    @Default('') String id,
    @Default('') String conversationId,
    @Default('') String senderId,
    @Default('') String content,
    @Default('') String messageType,
    @DateTimeConverter() DateTime? createdAt,
    @Default(false) bool isRead,
    @Default([]) List<MessageImage> images,
    CounterOffer? counterOffer,
    String? senderUsername,
    String? senderAvatar,
    String? imageUrl,
    @Default(false) bool isSending,
    @Default(false) bool isEdited,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  String serialize() => jsonEncode(toJson());

  static Message fromSerializableMap(Map<String, dynamic> data) =>
      Message.fromJson(data);
}

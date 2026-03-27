// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageImpl _$$MessageImplFromJson(Map<String, dynamic> json) =>
    _$MessageImpl(
      id: json['id'] as String? ?? '',
      conversationId: json['conversationId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      messageType: json['messageType'] as String? ?? '',
      createdAt: const DateTimeConverter().fromJson(json['createdAt']),
      isRead: json['isRead'] as bool? ?? false,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => MessageImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      counterOffer: json['counterOffer'] == null
          ? null
          : CounterOffer.fromJson(json['counterOffer'] as Map<String, dynamic>),
      senderUsername: json['senderUsername'] as String?,
      senderAvatar: json['senderAvatar'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isSending: json['isSending'] as bool? ?? false,
      isEdited: json['isEdited'] as bool? ?? false,
    );

Map<String, dynamic> _$$MessageImplToJson(_$MessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'content': instance.content,
      'messageType': instance.messageType,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'isRead': instance.isRead,
      'images': instance.images,
      'counterOffer': instance.counterOffer,
      'senderUsername': instance.senderUsername,
      'senderAvatar': instance.senderAvatar,
      'imageUrl': instance.imageUrl,
      'isSending': instance.isSending,
      'isEdited': instance.isEdited,
    };

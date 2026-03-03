// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationImpl _$$ConversationImplFromJson(Map<String, dynamic> json) =>
    _$ConversationImpl(
      id: json['id'] as String? ?? '',
      buyerId: json['buyerId'] as String? ?? '',
      sellerId: json['sellerId'] as String? ?? '',
      productId: json['productId'] as String?,
      lastMessageText: json['lastMessageText'] as String?,
      lastMessageAt: const DateTimeConverter().fromJson(json['lastMessageAt']),
      buyerUnreadCount: (json['buyerUnreadCount'] as num?)?.toInt() ?? 0,
      sellerUnreadCount: (json['sellerUnreadCount'] as num?)?.toInt() ?? 0,
      otherUserId: json['otherUserId'] as String? ?? '',
      otherUserUsername: json['otherUserUsername'] as String? ?? '',
      otherUserAvatar: json['otherUserAvatar'] as String?,
      otherUserLastActive:
          const DateTimeConverter().fromJson(json['otherUserLastActive']),
      productTitle: json['productTitle'] as String?,
      productImage: json['productImage'] as String?,
      productPrice: (json['productPrice'] as num?)?.toDouble(),
      productCondition: json['productCondition'] as String?,
      role: json['role'] as String? ?? '',
    );

Map<String, dynamic> _$$ConversationImplToJson(_$ConversationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'buyerId': instance.buyerId,
      'sellerId': instance.sellerId,
      'productId': instance.productId,
      'lastMessageText': instance.lastMessageText,
      'lastMessageAt': const DateTimeConverter().toJson(instance.lastMessageAt),
      'buyerUnreadCount': instance.buyerUnreadCount,
      'sellerUnreadCount': instance.sellerUnreadCount,
      'otherUserId': instance.otherUserId,
      'otherUserUsername': instance.otherUserUsername,
      'otherUserAvatar': instance.otherUserAvatar,
      'otherUserLastActive':
          const DateTimeConverter().toJson(instance.otherUserLastActive),
      'productTitle': instance.productTitle,
      'productImage': instance.productImage,
      'productPrice': instance.productPrice,
      'productCondition': instance.productCondition,
      'role': instance.role,
    };

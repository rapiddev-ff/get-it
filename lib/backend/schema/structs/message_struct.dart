// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MessageStruct extends BaseStruct {
  MessageStruct({
    String? id,
    String? conversationId,
    String? senderId,
    String? content,
    MessageType? messageType,
    bool? isRead,
    DateTime? createdAt,
    String? senderUsername,
    String? senderAvatar,
    String? imageUrl,
    CounterOfferStruct? counterOffer,
    bool? isSending,
  })  : _id = id,
        _conversationId = conversationId,
        _senderId = senderId,
        _content = content,
        _messageType = messageType,
        _isRead = isRead,
        _createdAt = createdAt,
        _senderUsername = senderUsername,
        _senderAvatar = senderAvatar,
        _imageUrl = imageUrl,
        _counterOffer = counterOffer,
        _isSending = isSending;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "conversationId" field.
  String? _conversationId;
  String get conversationId => _conversationId ?? '';
  set conversationId(String? val) => _conversationId = val;

  bool hasConversationId() => _conversationId != null;

  // "senderId" field.
  String? _senderId;
  String get senderId => _senderId ?? '';
  set senderId(String? val) => _senderId = val;

  bool hasSenderId() => _senderId != null;

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  set content(String? val) => _content = val;

  bool hasContent() => _content != null;

  // "messageType" field.
  MessageType? _messageType;
  MessageType? get messageType => _messageType;
  set messageType(MessageType? val) => _messageType = val;

  bool hasMessageType() => _messageType != null;

  // "isRead" field.
  bool? _isRead;
  bool get isRead => _isRead ?? false;
  set isRead(bool? val) => _isRead = val;

  bool hasIsRead() => _isRead != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "senderUsername" field.
  String? _senderUsername;
  String get senderUsername => _senderUsername ?? '';
  set senderUsername(String? val) => _senderUsername = val;

  bool hasSenderUsername() => _senderUsername != null;

  // "senderAvatar" field.
  String? _senderAvatar;
  String get senderAvatar => _senderAvatar ?? '';
  set senderAvatar(String? val) => _senderAvatar = val;

  bool hasSenderAvatar() => _senderAvatar != null;

  // "imageUrl" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;

  bool hasImageUrl() => _imageUrl != null;

  // "counterOffer" field.
  CounterOfferStruct? _counterOffer;
  CounterOfferStruct get counterOffer => _counterOffer ?? CounterOfferStruct();
  set counterOffer(CounterOfferStruct? val) => _counterOffer = val;

  void updateCounterOffer(Function(CounterOfferStruct) updateFn) {
    updateFn(_counterOffer ??= CounterOfferStruct());
  }

  bool hasCounterOffer() => _counterOffer != null;

  // "isSending" field.
  bool? _isSending;
  bool get isSending => _isSending ?? false;
  set isSending(bool? val) => _isSending = val;

  bool hasIsSending() => _isSending != null;

  static MessageStruct fromMap(Map<String, dynamic> data) => MessageStruct(
        id: data['id'] as String?,
        conversationId: data['conversationId'] as String?,
        senderId: data['senderId'] as String?,
        content: data['content'] as String?,
        messageType: data['messageType'] is MessageType
            ? data['messageType']
            : deserializeEnum<MessageType>(data['messageType']),
        isRead: data['isRead'] as bool?,
        createdAt: data['createdAt'] as DateTime?,
        senderUsername: data['senderUsername'] as String?,
        senderAvatar: data['senderAvatar'] as String?,
        imageUrl: data['imageUrl'] as String?,
        counterOffer: data['counterOffer'] is CounterOfferStruct
            ? data['counterOffer']
            : CounterOfferStruct.maybeFromMap(data['counterOffer']),
        isSending: data['isSending'] as bool?,
      );

  static MessageStruct? maybeFromMap(dynamic data) =>
      data is Map ? MessageStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'conversationId': _conversationId,
        'senderId': _senderId,
        'content': _content,
        'messageType': _messageType?.serialize(),
        'isRead': _isRead,
        'createdAt': _createdAt,
        'senderUsername': _senderUsername,
        'senderAvatar': _senderAvatar,
        'imageUrl': _imageUrl,
        'counterOffer': _counterOffer?.toMap(),
        'isSending': _isSending,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'conversationId': serializeParam(
          _conversationId,
          ParamType.String,
        ),
        'senderId': serializeParam(
          _senderId,
          ParamType.String,
        ),
        'content': serializeParam(
          _content,
          ParamType.String,
        ),
        'messageType': serializeParam(
          _messageType,
          ParamType.Enum,
        ),
        'isRead': serializeParam(
          _isRead,
          ParamType.bool,
        ),
        'createdAt': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
        'senderUsername': serializeParam(
          _senderUsername,
          ParamType.String,
        ),
        'senderAvatar': serializeParam(
          _senderAvatar,
          ParamType.String,
        ),
        'imageUrl': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
        'counterOffer': serializeParam(
          _counterOffer,
          ParamType.DataStruct,
        ),
        'isSending': serializeParam(
          _isSending,
          ParamType.bool,
        ),
      }.withoutNulls;

  static MessageStruct fromSerializableMap(Map<String, dynamic> data) =>
      MessageStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        conversationId: deserializeParam(
          data['conversationId'],
          ParamType.String,
          false,
        ),
        senderId: deserializeParam(
          data['senderId'],
          ParamType.String,
          false,
        ),
        content: deserializeParam(
          data['content'],
          ParamType.String,
          false,
        ),
        messageType: deserializeParam<MessageType>(
          data['messageType'],
          ParamType.Enum,
          false,
        ),
        isRead: deserializeParam(
          data['isRead'],
          ParamType.bool,
          false,
        ),
        createdAt: deserializeParam(
          data['createdAt'],
          ParamType.DateTime,
          false,
        ),
        senderUsername: deserializeParam(
          data['senderUsername'],
          ParamType.String,
          false,
        ),
        senderAvatar: deserializeParam(
          data['senderAvatar'],
          ParamType.String,
          false,
        ),
        imageUrl: deserializeParam(
          data['imageUrl'],
          ParamType.String,
          false,
        ),
        counterOffer: deserializeStructParam(
          data['counterOffer'],
          ParamType.DataStruct,
          false,
          structBuilder: CounterOfferStruct.fromSerializableMap,
        ),
        isSending: deserializeParam(
          data['isSending'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'MessageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MessageStruct &&
        id == other.id &&
        conversationId == other.conversationId &&
        senderId == other.senderId &&
        content == other.content &&
        messageType == other.messageType &&
        isRead == other.isRead &&
        createdAt == other.createdAt &&
        senderUsername == other.senderUsername &&
        senderAvatar == other.senderAvatar &&
        imageUrl == other.imageUrl &&
        counterOffer == other.counterOffer &&
        isSending == other.isSending;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        conversationId,
        senderId,
        content,
        messageType,
        isRead,
        createdAt,
        senderUsername,
        senderAvatar,
        imageUrl,
        counterOffer,
        isSending
      ]);
}

MessageStruct createMessageStruct({
  String? id,
  String? conversationId,
  String? senderId,
  String? content,
  MessageType? messageType,
  bool? isRead,
  DateTime? createdAt,
  String? senderUsername,
  String? senderAvatar,
  String? imageUrl,
  CounterOfferStruct? counterOffer,
  bool? isSending,
}) =>
    MessageStruct(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      messageType: messageType,
      isRead: isRead,
      createdAt: createdAt,
      senderUsername: senderUsername,
      senderAvatar: senderAvatar,
      imageUrl: imageUrl,
      counterOffer: counterOffer ?? CounterOfferStruct(),
      isSending: isSending,
    );

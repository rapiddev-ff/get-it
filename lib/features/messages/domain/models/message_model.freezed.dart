// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Message _$MessageFromJson(Map<String, dynamic> json) {
  return _Message.fromJson(json);
}

/// @nodoc
mixin _$Message {
  String get id => throw _privateConstructorUsedError;
  String get conversationId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get messageType => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  bool get isRead => throw _privateConstructorUsedError;
  List<MessageImage> get images => throw _privateConstructorUsedError;
  CounterOffer? get counterOffer => throw _privateConstructorUsedError;
  String? get senderUsername => throw _privateConstructorUsedError;
  String? get senderAvatar => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  bool get isSending => throw _privateConstructorUsedError;
  bool get isEdited => throw _privateConstructorUsedError;

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageCopyWith<Message> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCopyWith<$Res> {
  factory $MessageCopyWith(Message value, $Res Function(Message) then) =
      _$MessageCopyWithImpl<$Res, Message>;
  @useResult
  $Res call(
      {String id,
      String conversationId,
      String senderId,
      String content,
      String messageType,
      @DateTimeConverter() DateTime? createdAt,
      bool isRead,
      List<MessageImage> images,
      CounterOffer? counterOffer,
      String? senderUsername,
      String? senderAvatar,
      String? imageUrl,
      bool isSending,
      bool isEdited});

  $CounterOfferCopyWith<$Res>? get counterOffer;
}

/// @nodoc
class _$MessageCopyWithImpl<$Res, $Val extends Message>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? content = null,
    Object? messageType = null,
    Object? createdAt = freezed,
    Object? isRead = null,
    Object? images = null,
    Object? counterOffer = freezed,
    Object? senderUsername = freezed,
    Object? senderAvatar = freezed,
    Object? imageUrl = freezed,
    Object? isSending = null,
    Object? isEdited = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<MessageImage>,
      counterOffer: freezed == counterOffer
          ? _value.counterOffer
          : counterOffer // ignore: cast_nullable_to_non_nullable
              as CounterOffer?,
      senderUsername: freezed == senderUsername
          ? _value.senderUsername
          : senderUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      senderAvatar: freezed == senderAvatar
          ? _value.senderAvatar
          : senderAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isSending: null == isSending
          ? _value.isSending
          : isSending // ignore: cast_nullable_to_non_nullable
              as bool,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CounterOfferCopyWith<$Res>? get counterOffer {
    if (_value.counterOffer == null) {
      return null;
    }

    return $CounterOfferCopyWith<$Res>(_value.counterOffer!, (value) {
      return _then(_value.copyWith(counterOffer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MessageImplCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$$MessageImplCopyWith(
          _$MessageImpl value, $Res Function(_$MessageImpl) then) =
      __$$MessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String conversationId,
      String senderId,
      String content,
      String messageType,
      @DateTimeConverter() DateTime? createdAt,
      bool isRead,
      List<MessageImage> images,
      CounterOffer? counterOffer,
      String? senderUsername,
      String? senderAvatar,
      String? imageUrl,
      bool isSending,
      bool isEdited});

  @override
  $CounterOfferCopyWith<$Res>? get counterOffer;
}

/// @nodoc
class __$$MessageImplCopyWithImpl<$Res>
    extends _$MessageCopyWithImpl<$Res, _$MessageImpl>
    implements _$$MessageImplCopyWith<$Res> {
  __$$MessageImplCopyWithImpl(
      _$MessageImpl _value, $Res Function(_$MessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = null,
    Object? content = null,
    Object? messageType = null,
    Object? createdAt = freezed,
    Object? isRead = null,
    Object? images = null,
    Object? counterOffer = freezed,
    Object? senderUsername = freezed,
    Object? senderAvatar = freezed,
    Object? imageUrl = freezed,
    Object? isSending = null,
    Object? isEdited = null,
  }) {
    return _then(_$MessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      messageType: null == messageType
          ? _value.messageType
          : messageType // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<MessageImage>,
      counterOffer: freezed == counterOffer
          ? _value.counterOffer
          : counterOffer // ignore: cast_nullable_to_non_nullable
              as CounterOffer?,
      senderUsername: freezed == senderUsername
          ? _value.senderUsername
          : senderUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      senderAvatar: freezed == senderAvatar
          ? _value.senderAvatar
          : senderAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isSending: null == isSending
          ? _value.isSending
          : isSending // ignore: cast_nullable_to_non_nullable
              as bool,
      isEdited: null == isEdited
          ? _value.isEdited
          : isEdited // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageImpl extends _Message {
  const _$MessageImpl(
      {this.id = '',
      this.conversationId = '',
      this.senderId = '',
      this.content = '',
      this.messageType = '',
      @DateTimeConverter() this.createdAt,
      this.isRead = false,
      final List<MessageImage> images = const [],
      this.counterOffer,
      this.senderUsername,
      this.senderAvatar,
      this.imageUrl,
      this.isSending = false,
      this.isEdited = false})
      : _images = images,
        super._();

  factory _$MessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String conversationId;
  @override
  @JsonKey()
  final String senderId;
  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey()
  final String messageType;
  @override
  @DateTimeConverter()
  final DateTime? createdAt;
  @override
  @JsonKey()
  final bool isRead;
  final List<MessageImage> _images;
  @override
  @JsonKey()
  List<MessageImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final CounterOffer? counterOffer;
  @override
  final String? senderUsername;
  @override
  final String? senderAvatar;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final bool isSending;
  @override
  @JsonKey()
  final bool isEdited;

  @override
  String toString() {
    return 'Message(id: $id, conversationId: $conversationId, senderId: $senderId, content: $content, messageType: $messageType, createdAt: $createdAt, isRead: $isRead, images: $images, counterOffer: $counterOffer, senderUsername: $senderUsername, senderAvatar: $senderAvatar, imageUrl: $imageUrl, isSending: $isSending, isEdited: $isEdited)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.messageType, messageType) ||
                other.messageType == messageType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.counterOffer, counterOffer) ||
                other.counterOffer == counterOffer) &&
            (identical(other.senderUsername, senderUsername) ||
                other.senderUsername == senderUsername) &&
            (identical(other.senderAvatar, senderAvatar) ||
                other.senderAvatar == senderAvatar) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.isSending, isSending) ||
                other.isSending == isSending) &&
            (identical(other.isEdited, isEdited) ||
                other.isEdited == isEdited));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      conversationId,
      senderId,
      content,
      messageType,
      createdAt,
      isRead,
      const DeepCollectionEquality().hash(_images),
      counterOffer,
      senderUsername,
      senderAvatar,
      imageUrl,
      isSending,
      isEdited);

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      __$$MessageImplCopyWithImpl<_$MessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageImplToJson(
      this,
    );
  }
}

abstract class _Message extends Message {
  const factory _Message(
      {final String id,
      final String conversationId,
      final String senderId,
      final String content,
      final String messageType,
      @DateTimeConverter() final DateTime? createdAt,
      final bool isRead,
      final List<MessageImage> images,
      final CounterOffer? counterOffer,
      final String? senderUsername,
      final String? senderAvatar,
      final String? imageUrl,
      final bool isSending,
      final bool isEdited}) = _$MessageImpl;
  const _Message._() : super._();

  factory _Message.fromJson(Map<String, dynamic> json) = _$MessageImpl.fromJson;

  @override
  String get id;
  @override
  String get conversationId;
  @override
  String get senderId;
  @override
  String get content;
  @override
  String get messageType;
  @override
  @DateTimeConverter()
  DateTime? get createdAt;
  @override
  bool get isRead;
  @override
  List<MessageImage> get images;
  @override
  CounterOffer? get counterOffer;
  @override
  String? get senderUsername;
  @override
  String? get senderAvatar;
  @override
  String? get imageUrl;
  @override
  bool get isSending;
  @override
  bool get isEdited;

  /// Create a copy of Message
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageImplCopyWith<_$MessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return _Conversation.fromJson(json);
}

/// @nodoc
mixin _$Conversation {
  String get id => throw _privateConstructorUsedError;
  String get buyerId => throw _privateConstructorUsedError;
  String get sellerId => throw _privateConstructorUsedError;
  String? get productId => throw _privateConstructorUsedError;
  String? get lastMessageText => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get lastMessageAt => throw _privateConstructorUsedError;
  int get buyerUnreadCount => throw _privateConstructorUsedError;
  int get sellerUnreadCount => throw _privateConstructorUsedError;
  String get otherUserId => throw _privateConstructorUsedError;
  String get otherUserUsername => throw _privateConstructorUsedError;
  String? get otherUserAvatar => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get otherUserLastActive => throw _privateConstructorUsedError;
  String? get productTitle => throw _privateConstructorUsedError;
  String? get productImage => throw _privateConstructorUsedError;
  double? get productPrice => throw _privateConstructorUsedError;
  String? get productCondition => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationCopyWith<Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
          Conversation value, $Res Function(Conversation) then) =
      _$ConversationCopyWithImpl<$Res, Conversation>;
  @useResult
  $Res call(
      {String id,
      String buyerId,
      String sellerId,
      String? productId,
      String? lastMessageText,
      @DateTimeConverter() DateTime? lastMessageAt,
      int buyerUnreadCount,
      int sellerUnreadCount,
      String otherUserId,
      String otherUserUsername,
      String? otherUserAvatar,
      @DateTimeConverter() DateTime? otherUserLastActive,
      String? productTitle,
      String? productImage,
      double? productPrice,
      String? productCondition,
      String role});
}

/// @nodoc
class _$ConversationCopyWithImpl<$Res, $Val extends Conversation>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? buyerId = null,
    Object? sellerId = null,
    Object? productId = freezed,
    Object? lastMessageText = freezed,
    Object? lastMessageAt = freezed,
    Object? buyerUnreadCount = null,
    Object? sellerUnreadCount = null,
    Object? otherUserId = null,
    Object? otherUserUsername = null,
    Object? otherUserAvatar = freezed,
    Object? otherUserLastActive = freezed,
    Object? productTitle = freezed,
    Object? productImage = freezed,
    Object? productPrice = freezed,
    Object? productCondition = freezed,
    Object? role = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      buyerId: null == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageText: freezed == lastMessageText
          ? _value.lastMessageText
          : lastMessageText // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      buyerUnreadCount: null == buyerUnreadCount
          ? _value.buyerUnreadCount
          : buyerUnreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      sellerUnreadCount: null == sellerUnreadCount
          ? _value.sellerUnreadCount
          : sellerUnreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      otherUserId: null == otherUserId
          ? _value.otherUserId
          : otherUserId // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserUsername: null == otherUserUsername
          ? _value.otherUserUsername
          : otherUserUsername // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserAvatar: freezed == otherUserAvatar
          ? _value.otherUserAvatar
          : otherUserAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      otherUserLastActive: freezed == otherUserLastActive
          ? _value.otherUserLastActive
          : otherUserLastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      productTitle: freezed == productTitle
          ? _value.productTitle
          : productTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      productImage: freezed == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String?,
      productPrice: freezed == productPrice
          ? _value.productPrice
          : productPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      productCondition: freezed == productCondition
          ? _value.productCondition
          : productCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationImplCopyWith<$Res>
    implements $ConversationCopyWith<$Res> {
  factory _$$ConversationImplCopyWith(
          _$ConversationImpl value, $Res Function(_$ConversationImpl) then) =
      __$$ConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String buyerId,
      String sellerId,
      String? productId,
      String? lastMessageText,
      @DateTimeConverter() DateTime? lastMessageAt,
      int buyerUnreadCount,
      int sellerUnreadCount,
      String otherUserId,
      String otherUserUsername,
      String? otherUserAvatar,
      @DateTimeConverter() DateTime? otherUserLastActive,
      String? productTitle,
      String? productImage,
      double? productPrice,
      String? productCondition,
      String role});
}

/// @nodoc
class __$$ConversationImplCopyWithImpl<$Res>
    extends _$ConversationCopyWithImpl<$Res, _$ConversationImpl>
    implements _$$ConversationImplCopyWith<$Res> {
  __$$ConversationImplCopyWithImpl(
      _$ConversationImpl _value, $Res Function(_$ConversationImpl) _then)
      : super(_value, _then);

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? buyerId = null,
    Object? sellerId = null,
    Object? productId = freezed,
    Object? lastMessageText = freezed,
    Object? lastMessageAt = freezed,
    Object? buyerUnreadCount = null,
    Object? sellerUnreadCount = null,
    Object? otherUserId = null,
    Object? otherUserUsername = null,
    Object? otherUserAvatar = freezed,
    Object? otherUserLastActive = freezed,
    Object? productTitle = freezed,
    Object? productImage = freezed,
    Object? productPrice = freezed,
    Object? productCondition = freezed,
    Object? role = null,
  }) {
    return _then(_$ConversationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      buyerId: null == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageText: freezed == lastMessageText
          ? _value.lastMessageText
          : lastMessageText // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      buyerUnreadCount: null == buyerUnreadCount
          ? _value.buyerUnreadCount
          : buyerUnreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      sellerUnreadCount: null == sellerUnreadCount
          ? _value.sellerUnreadCount
          : sellerUnreadCount // ignore: cast_nullable_to_non_nullable
              as int,
      otherUserId: null == otherUserId
          ? _value.otherUserId
          : otherUserId // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserUsername: null == otherUserUsername
          ? _value.otherUserUsername
          : otherUserUsername // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserAvatar: freezed == otherUserAvatar
          ? _value.otherUserAvatar
          : otherUserAvatar // ignore: cast_nullable_to_non_nullable
              as String?,
      otherUserLastActive: freezed == otherUserLastActive
          ? _value.otherUserLastActive
          : otherUserLastActive // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      productTitle: freezed == productTitle
          ? _value.productTitle
          : productTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      productImage: freezed == productImage
          ? _value.productImage
          : productImage // ignore: cast_nullable_to_non_nullable
              as String?,
      productPrice: freezed == productPrice
          ? _value.productPrice
          : productPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      productCondition: freezed == productCondition
          ? _value.productCondition
          : productCondition // ignore: cast_nullable_to_non_nullable
              as String?,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationImpl extends _Conversation {
  const _$ConversationImpl(
      {this.id = '',
      this.buyerId = '',
      this.sellerId = '',
      this.productId,
      this.lastMessageText,
      @DateTimeConverter() this.lastMessageAt,
      this.buyerUnreadCount = 0,
      this.sellerUnreadCount = 0,
      this.otherUserId = '',
      this.otherUserUsername = '',
      this.otherUserAvatar,
      @DateTimeConverter() this.otherUserLastActive,
      this.productTitle,
      this.productImage,
      this.productPrice,
      this.productCondition,
      this.role = ''})
      : super._();

  factory _$ConversationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String buyerId;
  @override
  @JsonKey()
  final String sellerId;
  @override
  final String? productId;
  @override
  final String? lastMessageText;
  @override
  @DateTimeConverter()
  final DateTime? lastMessageAt;
  @override
  @JsonKey()
  final int buyerUnreadCount;
  @override
  @JsonKey()
  final int sellerUnreadCount;
  @override
  @JsonKey()
  final String otherUserId;
  @override
  @JsonKey()
  final String otherUserUsername;
  @override
  final String? otherUserAvatar;
  @override
  @DateTimeConverter()
  final DateTime? otherUserLastActive;
  @override
  final String? productTitle;
  @override
  final String? productImage;
  @override
  final double? productPrice;
  @override
  final String? productCondition;
  @override
  @JsonKey()
  final String role;

  @override
  String toString() {
    return 'Conversation(id: $id, buyerId: $buyerId, sellerId: $sellerId, productId: $productId, lastMessageText: $lastMessageText, lastMessageAt: $lastMessageAt, buyerUnreadCount: $buyerUnreadCount, sellerUnreadCount: $sellerUnreadCount, otherUserId: $otherUserId, otherUserUsername: $otherUserUsername, otherUserAvatar: $otherUserAvatar, otherUserLastActive: $otherUserLastActive, productTitle: $productTitle, productImage: $productImage, productPrice: $productPrice, productCondition: $productCondition, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.buyerId, buyerId) || other.buyerId == buyerId) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.lastMessageText, lastMessageText) ||
                other.lastMessageText == lastMessageText) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.buyerUnreadCount, buyerUnreadCount) ||
                other.buyerUnreadCount == buyerUnreadCount) &&
            (identical(other.sellerUnreadCount, sellerUnreadCount) ||
                other.sellerUnreadCount == sellerUnreadCount) &&
            (identical(other.otherUserId, otherUserId) ||
                other.otherUserId == otherUserId) &&
            (identical(other.otherUserUsername, otherUserUsername) ||
                other.otherUserUsername == otherUserUsername) &&
            (identical(other.otherUserAvatar, otherUserAvatar) ||
                other.otherUserAvatar == otherUserAvatar) &&
            (identical(other.otherUserLastActive, otherUserLastActive) ||
                other.otherUserLastActive == otherUserLastActive) &&
            (identical(other.productTitle, productTitle) ||
                other.productTitle == productTitle) &&
            (identical(other.productImage, productImage) ||
                other.productImage == productImage) &&
            (identical(other.productPrice, productPrice) ||
                other.productPrice == productPrice) &&
            (identical(other.productCondition, productCondition) ||
                other.productCondition == productCondition) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      buyerId,
      sellerId,
      productId,
      lastMessageText,
      lastMessageAt,
      buyerUnreadCount,
      sellerUnreadCount,
      otherUserId,
      otherUserUsername,
      otherUserAvatar,
      otherUserLastActive,
      productTitle,
      productImage,
      productPrice,
      productCondition,
      role);

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      __$$ConversationImplCopyWithImpl<_$ConversationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationImplToJson(
      this,
    );
  }
}

abstract class _Conversation extends Conversation {
  const factory _Conversation(
      {final String id,
      final String buyerId,
      final String sellerId,
      final String? productId,
      final String? lastMessageText,
      @DateTimeConverter() final DateTime? lastMessageAt,
      final int buyerUnreadCount,
      final int sellerUnreadCount,
      final String otherUserId,
      final String otherUserUsername,
      final String? otherUserAvatar,
      @DateTimeConverter() final DateTime? otherUserLastActive,
      final String? productTitle,
      final String? productImage,
      final double? productPrice,
      final String? productCondition,
      final String role}) = _$ConversationImpl;
  const _Conversation._() : super._();

  factory _Conversation.fromJson(Map<String, dynamic> json) =
      _$ConversationImpl.fromJson;

  @override
  String get id;
  @override
  String get buyerId;
  @override
  String get sellerId;
  @override
  String? get productId;
  @override
  String? get lastMessageText;
  @override
  @DateTimeConverter()
  DateTime? get lastMessageAt;
  @override
  int get buyerUnreadCount;
  @override
  int get sellerUnreadCount;
  @override
  String get otherUserId;
  @override
  String get otherUserUsername;
  @override
  String? get otherUserAvatar;
  @override
  @DateTimeConverter()
  DateTime? get otherUserLastActive;
  @override
  String? get productTitle;
  @override
  String? get productImage;
  @override
  double? get productPrice;
  @override
  String? get productCondition;
  @override
  String get role;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

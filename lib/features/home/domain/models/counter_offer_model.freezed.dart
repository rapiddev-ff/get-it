// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'counter_offer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CounterOffer _$CounterOfferFromJson(Map<String, dynamic> json) {
  return _CounterOffer.fromJson(json);
}

/// @nodoc
mixin _$CounterOffer {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  double get originalPrice => throw _privateConstructorUsedError;
  double get offeredPrice => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String get fromUserId => throw _privateConstructorUsedError;
  String get toUserId => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this CounterOffer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CounterOffer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CounterOfferCopyWith<CounterOffer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CounterOfferCopyWith<$Res> {
  factory $CounterOfferCopyWith(
          CounterOffer value, $Res Function(CounterOffer) then) =
      _$CounterOfferCopyWithImpl<$Res, CounterOffer>;
  @useResult
  $Res call(
      {String id,
      String productId,
      double originalPrice,
      double offeredPrice,
      String? status,
      String fromUserId,
      String toUserId,
      @DateTimeConverter() DateTime? createdAt,
      @DateTimeConverter() DateTime? expiresAt});
}

/// @nodoc
class _$CounterOfferCopyWithImpl<$Res, $Val extends CounterOffer>
    implements $CounterOfferCopyWith<$Res> {
  _$CounterOfferCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CounterOffer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? originalPrice = null,
    Object? offeredPrice = null,
    Object? status = freezed,
    Object? fromUserId = null,
    Object? toUserId = null,
    Object? createdAt = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      offeredPrice: null == offeredPrice
          ? _value.offeredPrice
          : offeredPrice // ignore: cast_nullable_to_non_nullable
              as double,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      fromUserId: null == fromUserId
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as String,
      toUserId: null == toUserId
          ? _value.toUserId
          : toUserId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CounterOfferImplCopyWith<$Res>
    implements $CounterOfferCopyWith<$Res> {
  factory _$$CounterOfferImplCopyWith(
          _$CounterOfferImpl value, $Res Function(_$CounterOfferImpl) then) =
      __$$CounterOfferImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String productId,
      double originalPrice,
      double offeredPrice,
      String? status,
      String fromUserId,
      String toUserId,
      @DateTimeConverter() DateTime? createdAt,
      @DateTimeConverter() DateTime? expiresAt});
}

/// @nodoc
class __$$CounterOfferImplCopyWithImpl<$Res>
    extends _$CounterOfferCopyWithImpl<$Res, _$CounterOfferImpl>
    implements _$$CounterOfferImplCopyWith<$Res> {
  __$$CounterOfferImplCopyWithImpl(
      _$CounterOfferImpl _value, $Res Function(_$CounterOfferImpl) _then)
      : super(_value, _then);

  /// Create a copy of CounterOffer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? originalPrice = null,
    Object? offeredPrice = null,
    Object? status = freezed,
    Object? fromUserId = null,
    Object? toUserId = null,
    Object? createdAt = freezed,
    Object? expiresAt = freezed,
  }) {
    return _then(_$CounterOfferImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      offeredPrice: null == offeredPrice
          ? _value.offeredPrice
          : offeredPrice // ignore: cast_nullable_to_non_nullable
              as double,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      fromUserId: null == fromUserId
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as String,
      toUserId: null == toUserId
          ? _value.toUserId
          : toUserId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CounterOfferImpl extends _CounterOffer {
  const _$CounterOfferImpl(
      {this.id = '',
      this.productId = '',
      this.originalPrice = 0.0,
      this.offeredPrice = 0.0,
      this.status,
      this.fromUserId = '',
      this.toUserId = '',
      @DateTimeConverter() this.createdAt,
      @DateTimeConverter() this.expiresAt})
      : super._();

  factory _$CounterOfferImpl.fromJson(Map<String, dynamic> json) =>
      _$$CounterOfferImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String productId;
  @override
  @JsonKey()
  final double originalPrice;
  @override
  @JsonKey()
  final double offeredPrice;
  @override
  final String? status;
  @override
  @JsonKey()
  final String fromUserId;
  @override
  @JsonKey()
  final String toUserId;
  @override
  @DateTimeConverter()
  final DateTime? createdAt;
  @override
  @DateTimeConverter()
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'CounterOffer(id: $id, productId: $productId, originalPrice: $originalPrice, offeredPrice: $offeredPrice, status: $status, fromUserId: $fromUserId, toUserId: $toUserId, createdAt: $createdAt, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CounterOfferImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.offeredPrice, offeredPrice) ||
                other.offeredPrice == offeredPrice) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.fromUserId, fromUserId) ||
                other.fromUserId == fromUserId) &&
            (identical(other.toUserId, toUserId) ||
                other.toUserId == toUserId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, productId, originalPrice,
      offeredPrice, status, fromUserId, toUserId, createdAt, expiresAt);

  /// Create a copy of CounterOffer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CounterOfferImplCopyWith<_$CounterOfferImpl> get copyWith =>
      __$$CounterOfferImplCopyWithImpl<_$CounterOfferImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CounterOfferImplToJson(
      this,
    );
  }
}

abstract class _CounterOffer extends CounterOffer {
  const factory _CounterOffer(
      {final String id,
      final String productId,
      final double originalPrice,
      final double offeredPrice,
      final String? status,
      final String fromUserId,
      final String toUserId,
      @DateTimeConverter() final DateTime? createdAt,
      @DateTimeConverter() final DateTime? expiresAt}) = _$CounterOfferImpl;
  const _CounterOffer._() : super._();

  factory _CounterOffer.fromJson(Map<String, dynamic> json) =
      _$CounterOfferImpl.fromJson;

  @override
  String get id;
  @override
  String get productId;
  @override
  double get originalPrice;
  @override
  double get offeredPrice;
  @override
  String? get status;
  @override
  String get fromUserId;
  @override
  String get toUserId;
  @override
  @DateTimeConverter()
  DateTime? get createdAt;
  @override
  @DateTimeConverter()
  DateTime? get expiresAt;

  /// Create a copy of CounterOffer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CounterOfferImplCopyWith<_$CounterOfferImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

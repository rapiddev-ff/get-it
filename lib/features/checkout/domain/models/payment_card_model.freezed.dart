// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_card_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentCard _$PaymentCardFromJson(Map<String, dynamic> json) {
  return _PaymentCard.fromJson(json);
}

/// @nodoc
mixin _$PaymentCard {
  String get brand => throw _privateConstructorUsedError;
  String get last4 => throw _privateConstructorUsedError;
  int get expMonth => throw _privateConstructorUsedError;
  int get expYear => throw _privateConstructorUsedError;
  String get funding => throw _privateConstructorUsedError;

  /// Serializes this PaymentCard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentCardCopyWith<PaymentCard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentCardCopyWith<$Res> {
  factory $PaymentCardCopyWith(
          PaymentCard value, $Res Function(PaymentCard) then) =
      _$PaymentCardCopyWithImpl<$Res, PaymentCard>;
  @useResult
  $Res call(
      {String brand, String last4, int expMonth, int expYear, String funding});
}

/// @nodoc
class _$PaymentCardCopyWithImpl<$Res, $Val extends PaymentCard>
    implements $PaymentCardCopyWith<$Res> {
  _$PaymentCardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brand = null,
    Object? last4 = null,
    Object? expMonth = null,
    Object? expYear = null,
    Object? funding = null,
  }) {
    return _then(_value.copyWith(
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      last4: null == last4
          ? _value.last4
          : last4 // ignore: cast_nullable_to_non_nullable
              as String,
      expMonth: null == expMonth
          ? _value.expMonth
          : expMonth // ignore: cast_nullable_to_non_nullable
              as int,
      expYear: null == expYear
          ? _value.expYear
          : expYear // ignore: cast_nullable_to_non_nullable
              as int,
      funding: null == funding
          ? _value.funding
          : funding // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentCardImplCopyWith<$Res>
    implements $PaymentCardCopyWith<$Res> {
  factory _$$PaymentCardImplCopyWith(
          _$PaymentCardImpl value, $Res Function(_$PaymentCardImpl) then) =
      __$$PaymentCardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String brand, String last4, int expMonth, int expYear, String funding});
}

/// @nodoc
class __$$PaymentCardImplCopyWithImpl<$Res>
    extends _$PaymentCardCopyWithImpl<$Res, _$PaymentCardImpl>
    implements _$$PaymentCardImplCopyWith<$Res> {
  __$$PaymentCardImplCopyWithImpl(
      _$PaymentCardImpl _value, $Res Function(_$PaymentCardImpl) _then)
      : super(_value, _then);

  /// Create a copy of PaymentCard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? brand = null,
    Object? last4 = null,
    Object? expMonth = null,
    Object? expYear = null,
    Object? funding = null,
  }) {
    return _then(_$PaymentCardImpl(
      brand: null == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String,
      last4: null == last4
          ? _value.last4
          : last4 // ignore: cast_nullable_to_non_nullable
              as String,
      expMonth: null == expMonth
          ? _value.expMonth
          : expMonth // ignore: cast_nullable_to_non_nullable
              as int,
      expYear: null == expYear
          ? _value.expYear
          : expYear // ignore: cast_nullable_to_non_nullable
              as int,
      funding: null == funding
          ? _value.funding
          : funding // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentCardImpl extends _PaymentCard {
  const _$PaymentCardImpl(
      {this.brand = '',
      this.last4 = '',
      this.expMonth = 0,
      this.expYear = 0,
      this.funding = ''})
      : super._();

  factory _$PaymentCardImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentCardImplFromJson(json);

  @override
  @JsonKey()
  final String brand;
  @override
  @JsonKey()
  final String last4;
  @override
  @JsonKey()
  final int expMonth;
  @override
  @JsonKey()
  final int expYear;
  @override
  @JsonKey()
  final String funding;

  @override
  String toString() {
    return 'PaymentCard(brand: $brand, last4: $last4, expMonth: $expMonth, expYear: $expYear, funding: $funding)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentCardImpl &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.last4, last4) || other.last4 == last4) &&
            (identical(other.expMonth, expMonth) ||
                other.expMonth == expMonth) &&
            (identical(other.expYear, expYear) || other.expYear == expYear) &&
            (identical(other.funding, funding) || other.funding == funding));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, brand, last4, expMonth, expYear, funding);

  /// Create a copy of PaymentCard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentCardImplCopyWith<_$PaymentCardImpl> get copyWith =>
      __$$PaymentCardImplCopyWithImpl<_$PaymentCardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentCardImplToJson(
      this,
    );
  }
}

abstract class _PaymentCard extends PaymentCard {
  const factory _PaymentCard(
      {final String brand,
      final String last4,
      final int expMonth,
      final int expYear,
      final String funding}) = _$PaymentCardImpl;
  const _PaymentCard._() : super._();

  factory _PaymentCard.fromJson(Map<String, dynamic> json) =
      _$PaymentCardImpl.fromJson;

  @override
  String get brand;
  @override
  String get last4;
  @override
  int get expMonth;
  @override
  int get expYear;
  @override
  String get funding;

  /// Create a copy of PaymentCard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentCardImplCopyWith<_$PaymentCardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

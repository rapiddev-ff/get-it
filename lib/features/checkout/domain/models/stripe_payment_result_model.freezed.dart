// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stripe_payment_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StripePaymentResult _$StripePaymentResultFromJson(Map<String, dynamic> json) {
  return _StripePaymentResult.fromJson(json);
}

/// @nodoc
mixin _$StripePaymentResult {
  bool get success => throw _privateConstructorUsedError;
  String get paymentIntentId => throw _privateConstructorUsedError;
  String get clientSecret => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;

  /// Serializes this StripePaymentResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StripePaymentResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StripePaymentResultCopyWith<StripePaymentResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StripePaymentResultCopyWith<$Res> {
  factory $StripePaymentResultCopyWith(
          StripePaymentResult value, $Res Function(StripePaymentResult) then) =
      _$StripePaymentResultCopyWithImpl<$Res, StripePaymentResult>;
  @useResult
  $Res call(
      {bool success,
      String paymentIntentId,
      String clientSecret,
      String error});
}

/// @nodoc
class _$StripePaymentResultCopyWithImpl<$Res, $Val extends StripePaymentResult>
    implements $StripePaymentResultCopyWith<$Res> {
  _$StripePaymentResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StripePaymentResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? paymentIntentId = null,
    Object? clientSecret = null,
    Object? error = null,
  }) {
    return _then(_value.copyWith(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      paymentIntentId: null == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String,
      clientSecret: null == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StripePaymentResultImplCopyWith<$Res>
    implements $StripePaymentResultCopyWith<$Res> {
  factory _$$StripePaymentResultImplCopyWith(_$StripePaymentResultImpl value,
          $Res Function(_$StripePaymentResultImpl) then) =
      __$$StripePaymentResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool success,
      String paymentIntentId,
      String clientSecret,
      String error});
}

/// @nodoc
class __$$StripePaymentResultImplCopyWithImpl<$Res>
    extends _$StripePaymentResultCopyWithImpl<$Res, _$StripePaymentResultImpl>
    implements _$$StripePaymentResultImplCopyWith<$Res> {
  __$$StripePaymentResultImplCopyWithImpl(_$StripePaymentResultImpl _value,
      $Res Function(_$StripePaymentResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of StripePaymentResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = null,
    Object? paymentIntentId = null,
    Object? clientSecret = null,
    Object? error = null,
  }) {
    return _then(_$StripePaymentResultImpl(
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      paymentIntentId: null == paymentIntentId
          ? _value.paymentIntentId
          : paymentIntentId // ignore: cast_nullable_to_non_nullable
              as String,
      clientSecret: null == clientSecret
          ? _value.clientSecret
          : clientSecret // ignore: cast_nullable_to_non_nullable
              as String,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StripePaymentResultImpl extends _StripePaymentResult {
  const _$StripePaymentResultImpl(
      {this.success = false,
      this.paymentIntentId = '',
      this.clientSecret = '',
      this.error = ''})
      : super._();

  factory _$StripePaymentResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$StripePaymentResultImplFromJson(json);

  @override
  @JsonKey()
  final bool success;
  @override
  @JsonKey()
  final String paymentIntentId;
  @override
  @JsonKey()
  final String clientSecret;
  @override
  @JsonKey()
  final String error;

  @override
  String toString() {
    return 'StripePaymentResult(success: $success, paymentIntentId: $paymentIntentId, clientSecret: $clientSecret, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StripePaymentResultImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.paymentIntentId, paymentIntentId) ||
                other.paymentIntentId == paymentIntentId) &&
            (identical(other.clientSecret, clientSecret) ||
                other.clientSecret == clientSecret) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, success, paymentIntentId, clientSecret, error);

  /// Create a copy of StripePaymentResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StripePaymentResultImplCopyWith<_$StripePaymentResultImpl> get copyWith =>
      __$$StripePaymentResultImplCopyWithImpl<_$StripePaymentResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StripePaymentResultImplToJson(
      this,
    );
  }
}

abstract class _StripePaymentResult extends StripePaymentResult {
  const factory _StripePaymentResult(
      {final bool success,
      final String paymentIntentId,
      final String clientSecret,
      final String error}) = _$StripePaymentResultImpl;
  const _StripePaymentResult._() : super._();

  factory _StripePaymentResult.fromJson(Map<String, dynamic> json) =
      _$StripePaymentResultImpl.fromJson;

  @override
  bool get success;
  @override
  String get paymentIntentId;
  @override
  String get clientSecret;
  @override
  String get error;

  /// Create a copy of StripePaymentResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StripePaymentResultImplCopyWith<_$StripePaymentResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

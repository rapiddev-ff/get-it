// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stripe_account_status_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StripeAccountStatus _$StripeAccountStatusFromJson(Map<String, dynamic> json) {
  return _StripeAccountStatus.fromJson(json);
}

/// @nodoc
mixin _$StripeAccountStatus {
  bool get hasAccount => throw _privateConstructorUsedError;
  String? get stripeAccountId => throw _privateConstructorUsedError;
  bool get chargesEnabled => throw _privateConstructorUsedError;
  bool get payoutsEnabled => throw _privateConstructorUsedError;
  bool get detailsSubmitted => throw _privateConstructorUsedError;
  bool get onboardingCompleted => throw _privateConstructorUsedError;
  bool get needsOnboarding => throw _privateConstructorUsedError;
  String? get disabledReason => throw _privateConstructorUsedError;
  List<String> get currentlyDue => throw _privateConstructorUsedError;
  List<String> get pastDue => throw _privateConstructorUsedError;
  bool get hasPastDue => throw _privateConstructorUsedError;
  String get accountStatus => throw _privateConstructorUsedError;
  String get statusLabel => throw _privateConstructorUsedError;
  String get statusColor => throw _privateConstructorUsedError;
  bool get canSell => throw _privateConstructorUsedError;
  bool get needsAttention => throw _privateConstructorUsedError;

  /// Serializes this StripeAccountStatus to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StripeAccountStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StripeAccountStatusCopyWith<StripeAccountStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StripeAccountStatusCopyWith<$Res> {
  factory $StripeAccountStatusCopyWith(
          StripeAccountStatus value, $Res Function(StripeAccountStatus) then) =
      _$StripeAccountStatusCopyWithImpl<$Res, StripeAccountStatus>;
  @useResult
  $Res call(
      {bool hasAccount,
      String? stripeAccountId,
      bool chargesEnabled,
      bool payoutsEnabled,
      bool detailsSubmitted,
      bool onboardingCompleted,
      bool needsOnboarding,
      String? disabledReason,
      List<String> currentlyDue,
      List<String> pastDue,
      bool hasPastDue,
      String accountStatus,
      String statusLabel,
      String statusColor,
      bool canSell,
      bool needsAttention});
}

/// @nodoc
class _$StripeAccountStatusCopyWithImpl<$Res, $Val extends StripeAccountStatus>
    implements $StripeAccountStatusCopyWith<$Res> {
  _$StripeAccountStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StripeAccountStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasAccount = null,
    Object? stripeAccountId = freezed,
    Object? chargesEnabled = null,
    Object? payoutsEnabled = null,
    Object? detailsSubmitted = null,
    Object? onboardingCompleted = null,
    Object? needsOnboarding = null,
    Object? disabledReason = freezed,
    Object? currentlyDue = null,
    Object? pastDue = null,
    Object? hasPastDue = null,
    Object? accountStatus = null,
    Object? statusLabel = null,
    Object? statusColor = null,
    Object? canSell = null,
    Object? needsAttention = null,
  }) {
    return _then(_value.copyWith(
      hasAccount: null == hasAccount
          ? _value.hasAccount
          : hasAccount // ignore: cast_nullable_to_non_nullable
              as bool,
      stripeAccountId: freezed == stripeAccountId
          ? _value.stripeAccountId
          : stripeAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      chargesEnabled: null == chargesEnabled
          ? _value.chargesEnabled
          : chargesEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      payoutsEnabled: null == payoutsEnabled
          ? _value.payoutsEnabled
          : payoutsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      detailsSubmitted: null == detailsSubmitted
          ? _value.detailsSubmitted
          : detailsSubmitted // ignore: cast_nullable_to_non_nullable
              as bool,
      onboardingCompleted: null == onboardingCompleted
          ? _value.onboardingCompleted
          : onboardingCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      needsOnboarding: null == needsOnboarding
          ? _value.needsOnboarding
          : needsOnboarding // ignore: cast_nullable_to_non_nullable
              as bool,
      disabledReason: freezed == disabledReason
          ? _value.disabledReason
          : disabledReason // ignore: cast_nullable_to_non_nullable
              as String?,
      currentlyDue: null == currentlyDue
          ? _value.currentlyDue
          : currentlyDue // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pastDue: null == pastDue
          ? _value.pastDue
          : pastDue // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasPastDue: null == hasPastDue
          ? _value.hasPastDue
          : hasPastDue // ignore: cast_nullable_to_non_nullable
              as bool,
      accountStatus: null == accountStatus
          ? _value.accountStatus
          : accountStatus // ignore: cast_nullable_to_non_nullable
              as String,
      statusLabel: null == statusLabel
          ? _value.statusLabel
          : statusLabel // ignore: cast_nullable_to_non_nullable
              as String,
      statusColor: null == statusColor
          ? _value.statusColor
          : statusColor // ignore: cast_nullable_to_non_nullable
              as String,
      canSell: null == canSell
          ? _value.canSell
          : canSell // ignore: cast_nullable_to_non_nullable
              as bool,
      needsAttention: null == needsAttention
          ? _value.needsAttention
          : needsAttention // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StripeAccountStatusImplCopyWith<$Res>
    implements $StripeAccountStatusCopyWith<$Res> {
  factory _$$StripeAccountStatusImplCopyWith(_$StripeAccountStatusImpl value,
          $Res Function(_$StripeAccountStatusImpl) then) =
      __$$StripeAccountStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool hasAccount,
      String? stripeAccountId,
      bool chargesEnabled,
      bool payoutsEnabled,
      bool detailsSubmitted,
      bool onboardingCompleted,
      bool needsOnboarding,
      String? disabledReason,
      List<String> currentlyDue,
      List<String> pastDue,
      bool hasPastDue,
      String accountStatus,
      String statusLabel,
      String statusColor,
      bool canSell,
      bool needsAttention});
}

/// @nodoc
class __$$StripeAccountStatusImplCopyWithImpl<$Res>
    extends _$StripeAccountStatusCopyWithImpl<$Res, _$StripeAccountStatusImpl>
    implements _$$StripeAccountStatusImplCopyWith<$Res> {
  __$$StripeAccountStatusImplCopyWithImpl(_$StripeAccountStatusImpl _value,
      $Res Function(_$StripeAccountStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of StripeAccountStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasAccount = null,
    Object? stripeAccountId = freezed,
    Object? chargesEnabled = null,
    Object? payoutsEnabled = null,
    Object? detailsSubmitted = null,
    Object? onboardingCompleted = null,
    Object? needsOnboarding = null,
    Object? disabledReason = freezed,
    Object? currentlyDue = null,
    Object? pastDue = null,
    Object? hasPastDue = null,
    Object? accountStatus = null,
    Object? statusLabel = null,
    Object? statusColor = null,
    Object? canSell = null,
    Object? needsAttention = null,
  }) {
    return _then(_$StripeAccountStatusImpl(
      hasAccount: null == hasAccount
          ? _value.hasAccount
          : hasAccount // ignore: cast_nullable_to_non_nullable
              as bool,
      stripeAccountId: freezed == stripeAccountId
          ? _value.stripeAccountId
          : stripeAccountId // ignore: cast_nullable_to_non_nullable
              as String?,
      chargesEnabled: null == chargesEnabled
          ? _value.chargesEnabled
          : chargesEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      payoutsEnabled: null == payoutsEnabled
          ? _value.payoutsEnabled
          : payoutsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      detailsSubmitted: null == detailsSubmitted
          ? _value.detailsSubmitted
          : detailsSubmitted // ignore: cast_nullable_to_non_nullable
              as bool,
      onboardingCompleted: null == onboardingCompleted
          ? _value.onboardingCompleted
          : onboardingCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      needsOnboarding: null == needsOnboarding
          ? _value.needsOnboarding
          : needsOnboarding // ignore: cast_nullable_to_non_nullable
              as bool,
      disabledReason: freezed == disabledReason
          ? _value.disabledReason
          : disabledReason // ignore: cast_nullable_to_non_nullable
              as String?,
      currentlyDue: null == currentlyDue
          ? _value._currentlyDue
          : currentlyDue // ignore: cast_nullable_to_non_nullable
              as List<String>,
      pastDue: null == pastDue
          ? _value._pastDue
          : pastDue // ignore: cast_nullable_to_non_nullable
              as List<String>,
      hasPastDue: null == hasPastDue
          ? _value.hasPastDue
          : hasPastDue // ignore: cast_nullable_to_non_nullable
              as bool,
      accountStatus: null == accountStatus
          ? _value.accountStatus
          : accountStatus // ignore: cast_nullable_to_non_nullable
              as String,
      statusLabel: null == statusLabel
          ? _value.statusLabel
          : statusLabel // ignore: cast_nullable_to_non_nullable
              as String,
      statusColor: null == statusColor
          ? _value.statusColor
          : statusColor // ignore: cast_nullable_to_non_nullable
              as String,
      canSell: null == canSell
          ? _value.canSell
          : canSell // ignore: cast_nullable_to_non_nullable
              as bool,
      needsAttention: null == needsAttention
          ? _value.needsAttention
          : needsAttention // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StripeAccountStatusImpl extends _StripeAccountStatus {
  const _$StripeAccountStatusImpl(
      {this.hasAccount = false,
      this.stripeAccountId,
      this.chargesEnabled = false,
      this.payoutsEnabled = false,
      this.detailsSubmitted = false,
      this.onboardingCompleted = false,
      this.needsOnboarding = true,
      this.disabledReason,
      final List<String> currentlyDue = const [],
      final List<String> pastDue = const [],
      this.hasPastDue = false,
      this.accountStatus = '',
      this.statusLabel = '',
      this.statusColor = '',
      this.canSell = false,
      this.needsAttention = false})
      : _currentlyDue = currentlyDue,
        _pastDue = pastDue,
        super._();

  factory _$StripeAccountStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$StripeAccountStatusImplFromJson(json);

  @override
  @JsonKey()
  final bool hasAccount;
  @override
  final String? stripeAccountId;
  @override
  @JsonKey()
  final bool chargesEnabled;
  @override
  @JsonKey()
  final bool payoutsEnabled;
  @override
  @JsonKey()
  final bool detailsSubmitted;
  @override
  @JsonKey()
  final bool onboardingCompleted;
  @override
  @JsonKey()
  final bool needsOnboarding;
  @override
  final String? disabledReason;
  final List<String> _currentlyDue;
  @override
  @JsonKey()
  List<String> get currentlyDue {
    if (_currentlyDue is EqualUnmodifiableListView) return _currentlyDue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentlyDue);
  }

  final List<String> _pastDue;
  @override
  @JsonKey()
  List<String> get pastDue {
    if (_pastDue is EqualUnmodifiableListView) return _pastDue;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pastDue);
  }

  @override
  @JsonKey()
  final bool hasPastDue;
  @override
  @JsonKey()
  final String accountStatus;
  @override
  @JsonKey()
  final String statusLabel;
  @override
  @JsonKey()
  final String statusColor;
  @override
  @JsonKey()
  final bool canSell;
  @override
  @JsonKey()
  final bool needsAttention;

  @override
  String toString() {
    return 'StripeAccountStatus(hasAccount: $hasAccount, stripeAccountId: $stripeAccountId, chargesEnabled: $chargesEnabled, payoutsEnabled: $payoutsEnabled, detailsSubmitted: $detailsSubmitted, onboardingCompleted: $onboardingCompleted, needsOnboarding: $needsOnboarding, disabledReason: $disabledReason, currentlyDue: $currentlyDue, pastDue: $pastDue, hasPastDue: $hasPastDue, accountStatus: $accountStatus, statusLabel: $statusLabel, statusColor: $statusColor, canSell: $canSell, needsAttention: $needsAttention)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StripeAccountStatusImpl &&
            (identical(other.hasAccount, hasAccount) ||
                other.hasAccount == hasAccount) &&
            (identical(other.stripeAccountId, stripeAccountId) ||
                other.stripeAccountId == stripeAccountId) &&
            (identical(other.chargesEnabled, chargesEnabled) ||
                other.chargesEnabled == chargesEnabled) &&
            (identical(other.payoutsEnabled, payoutsEnabled) ||
                other.payoutsEnabled == payoutsEnabled) &&
            (identical(other.detailsSubmitted, detailsSubmitted) ||
                other.detailsSubmitted == detailsSubmitted) &&
            (identical(other.onboardingCompleted, onboardingCompleted) ||
                other.onboardingCompleted == onboardingCompleted) &&
            (identical(other.needsOnboarding, needsOnboarding) ||
                other.needsOnboarding == needsOnboarding) &&
            (identical(other.disabledReason, disabledReason) ||
                other.disabledReason == disabledReason) &&
            const DeepCollectionEquality()
                .equals(other._currentlyDue, _currentlyDue) &&
            const DeepCollectionEquality().equals(other._pastDue, _pastDue) &&
            (identical(other.hasPastDue, hasPastDue) ||
                other.hasPastDue == hasPastDue) &&
            (identical(other.accountStatus, accountStatus) ||
                other.accountStatus == accountStatus) &&
            (identical(other.statusLabel, statusLabel) ||
                other.statusLabel == statusLabel) &&
            (identical(other.statusColor, statusColor) ||
                other.statusColor == statusColor) &&
            (identical(other.canSell, canSell) || other.canSell == canSell) &&
            (identical(other.needsAttention, needsAttention) ||
                other.needsAttention == needsAttention));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      hasAccount,
      stripeAccountId,
      chargesEnabled,
      payoutsEnabled,
      detailsSubmitted,
      onboardingCompleted,
      needsOnboarding,
      disabledReason,
      const DeepCollectionEquality().hash(_currentlyDue),
      const DeepCollectionEquality().hash(_pastDue),
      hasPastDue,
      accountStatus,
      statusLabel,
      statusColor,
      canSell,
      needsAttention);

  /// Create a copy of StripeAccountStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StripeAccountStatusImplCopyWith<_$StripeAccountStatusImpl> get copyWith =>
      __$$StripeAccountStatusImplCopyWithImpl<_$StripeAccountStatusImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StripeAccountStatusImplToJson(
      this,
    );
  }
}

abstract class _StripeAccountStatus extends StripeAccountStatus {
  const factory _StripeAccountStatus(
      {final bool hasAccount,
      final String? stripeAccountId,
      final bool chargesEnabled,
      final bool payoutsEnabled,
      final bool detailsSubmitted,
      final bool onboardingCompleted,
      final bool needsOnboarding,
      final String? disabledReason,
      final List<String> currentlyDue,
      final List<String> pastDue,
      final bool hasPastDue,
      final String accountStatus,
      final String statusLabel,
      final String statusColor,
      final bool canSell,
      final bool needsAttention}) = _$StripeAccountStatusImpl;
  const _StripeAccountStatus._() : super._();

  factory _StripeAccountStatus.fromJson(Map<String, dynamic> json) =
      _$StripeAccountStatusImpl.fromJson;

  @override
  bool get hasAccount;
  @override
  String? get stripeAccountId;
  @override
  bool get chargesEnabled;
  @override
  bool get payoutsEnabled;
  @override
  bool get detailsSubmitted;
  @override
  bool get onboardingCompleted;
  @override
  bool get needsOnboarding;
  @override
  String? get disabledReason;
  @override
  List<String> get currentlyDue;
  @override
  List<String> get pastDue;
  @override
  bool get hasPastDue;
  @override
  String get accountStatus;
  @override
  String get statusLabel;
  @override
  String get statusColor;
  @override
  bool get canSell;
  @override
  bool get needsAttention;

  /// Create a copy of StripeAccountStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StripeAccountStatusImplCopyWith<_$StripeAccountStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

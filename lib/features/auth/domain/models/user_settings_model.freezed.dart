// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) {
  return _UserSettings.fromJson(json);
}

/// @nodoc
mixin _$UserSettings {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'swipe_payment_enabled')
  bool get swipePaymentEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_budget')
  double get dailyBudget => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_budget_used')
  double get dailyBudgetUsed => throw _privateConstructorUsedError;
  @JsonKey(name: 'budget_reset_at')
  @DateTimeConverter()
  DateTime? get budgetResetAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'default_payment_method_id')
  String get defaultPaymentMethodId => throw _privateConstructorUsedError;
  @JsonKey(name: 'default_shipping_address_id')
  String get defaultShippingAddressId => throw _privateConstructorUsedError;
  @JsonKey(name: 'fcm_token')
  String get fcmToken => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  @DateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  @DateTimeConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'notification_preferences')
  NotificationPreferences? get notificationPreferences =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'default_flat_shipping_rate')
  double get defaultFlatShippingRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'default_additional_item_fee')
  double get defaultAdditionalItemFee => throw _privateConstructorUsedError;

  /// Serializes this UserSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSettingsCopyWith<UserSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSettingsCopyWith<$Res> {
  factory $UserSettingsCopyWith(
          UserSettings value, $Res Function(UserSettings) then) =
      _$UserSettingsCopyWithImpl<$Res, UserSettings>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'swipe_payment_enabled') bool swipePaymentEnabled,
      @JsonKey(name: 'daily_budget') double dailyBudget,
      @JsonKey(name: 'daily_budget_used') double dailyBudgetUsed,
      @JsonKey(name: 'budget_reset_at')
      @DateTimeConverter()
      DateTime? budgetResetAt,
      @JsonKey(name: 'default_payment_method_id') String defaultPaymentMethodId,
      @JsonKey(name: 'default_shipping_address_id')
      String defaultShippingAddressId,
      @JsonKey(name: 'fcm_token') String fcmToken,
      @JsonKey(name: 'created_at') @DateTimeConverter() DateTime? createdAt,
      @JsonKey(name: 'updated_at') @DateTimeConverter() DateTime? updatedAt,
      @JsonKey(name: 'notification_preferences')
      NotificationPreferences? notificationPreferences,
      @JsonKey(name: 'default_flat_shipping_rate')
      double defaultFlatShippingRate,
      @JsonKey(name: 'default_additional_item_fee')
      double defaultAdditionalItemFee});

  $NotificationPreferencesCopyWith<$Res>? get notificationPreferences;
}

/// @nodoc
class _$UserSettingsCopyWithImpl<$Res, $Val extends UserSettings>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? swipePaymentEnabled = null,
    Object? dailyBudget = null,
    Object? dailyBudgetUsed = null,
    Object? budgetResetAt = freezed,
    Object? defaultPaymentMethodId = null,
    Object? defaultShippingAddressId = null,
    Object? fcmToken = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? notificationPreferences = freezed,
    Object? defaultFlatShippingRate = null,
    Object? defaultAdditionalItemFee = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      swipePaymentEnabled: null == swipePaymentEnabled
          ? _value.swipePaymentEnabled
          : swipePaymentEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      dailyBudget: null == dailyBudget
          ? _value.dailyBudget
          : dailyBudget // ignore: cast_nullable_to_non_nullable
              as double,
      dailyBudgetUsed: null == dailyBudgetUsed
          ? _value.dailyBudgetUsed
          : dailyBudgetUsed // ignore: cast_nullable_to_non_nullable
              as double,
      budgetResetAt: freezed == budgetResetAt
          ? _value.budgetResetAt
          : budgetResetAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      defaultPaymentMethodId: null == defaultPaymentMethodId
          ? _value.defaultPaymentMethodId
          : defaultPaymentMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      defaultShippingAddressId: null == defaultShippingAddressId
          ? _value.defaultShippingAddressId
          : defaultShippingAddressId // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: null == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notificationPreferences: freezed == notificationPreferences
          ? _value.notificationPreferences
          : notificationPreferences // ignore: cast_nullable_to_non_nullable
              as NotificationPreferences?,
      defaultFlatShippingRate: null == defaultFlatShippingRate
          ? _value.defaultFlatShippingRate
          : defaultFlatShippingRate // ignore: cast_nullable_to_non_nullable
              as double,
      defaultAdditionalItemFee: null == defaultAdditionalItemFee
          ? _value.defaultAdditionalItemFee
          : defaultAdditionalItemFee // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NotificationPreferencesCopyWith<$Res>? get notificationPreferences {
    if (_value.notificationPreferences == null) {
      return null;
    }

    return $NotificationPreferencesCopyWith<$Res>(
        _value.notificationPreferences!, (value) {
      return _then(_value.copyWith(notificationPreferences: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserSettingsImplCopyWith<$Res>
    implements $UserSettingsCopyWith<$Res> {
  factory _$$UserSettingsImplCopyWith(
          _$UserSettingsImpl value, $Res Function(_$UserSettingsImpl) then) =
      __$$UserSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'swipe_payment_enabled') bool swipePaymentEnabled,
      @JsonKey(name: 'daily_budget') double dailyBudget,
      @JsonKey(name: 'daily_budget_used') double dailyBudgetUsed,
      @JsonKey(name: 'budget_reset_at')
      @DateTimeConverter()
      DateTime? budgetResetAt,
      @JsonKey(name: 'default_payment_method_id') String defaultPaymentMethodId,
      @JsonKey(name: 'default_shipping_address_id')
      String defaultShippingAddressId,
      @JsonKey(name: 'fcm_token') String fcmToken,
      @JsonKey(name: 'created_at') @DateTimeConverter() DateTime? createdAt,
      @JsonKey(name: 'updated_at') @DateTimeConverter() DateTime? updatedAt,
      @JsonKey(name: 'notification_preferences')
      NotificationPreferences? notificationPreferences,
      @JsonKey(name: 'default_flat_shipping_rate')
      double defaultFlatShippingRate,
      @JsonKey(name: 'default_additional_item_fee')
      double defaultAdditionalItemFee});

  @override
  $NotificationPreferencesCopyWith<$Res>? get notificationPreferences;
}

/// @nodoc
class __$$UserSettingsImplCopyWithImpl<$Res>
    extends _$UserSettingsCopyWithImpl<$Res, _$UserSettingsImpl>
    implements _$$UserSettingsImplCopyWith<$Res> {
  __$$UserSettingsImplCopyWithImpl(
      _$UserSettingsImpl _value, $Res Function(_$UserSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? swipePaymentEnabled = null,
    Object? dailyBudget = null,
    Object? dailyBudgetUsed = null,
    Object? budgetResetAt = freezed,
    Object? defaultPaymentMethodId = null,
    Object? defaultShippingAddressId = null,
    Object? fcmToken = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? notificationPreferences = freezed,
    Object? defaultFlatShippingRate = null,
    Object? defaultAdditionalItemFee = null,
  }) {
    return _then(_$UserSettingsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      swipePaymentEnabled: null == swipePaymentEnabled
          ? _value.swipePaymentEnabled
          : swipePaymentEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      dailyBudget: null == dailyBudget
          ? _value.dailyBudget
          : dailyBudget // ignore: cast_nullable_to_non_nullable
              as double,
      dailyBudgetUsed: null == dailyBudgetUsed
          ? _value.dailyBudgetUsed
          : dailyBudgetUsed // ignore: cast_nullable_to_non_nullable
              as double,
      budgetResetAt: freezed == budgetResetAt
          ? _value.budgetResetAt
          : budgetResetAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      defaultPaymentMethodId: null == defaultPaymentMethodId
          ? _value.defaultPaymentMethodId
          : defaultPaymentMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      defaultShippingAddressId: null == defaultShippingAddressId
          ? _value.defaultShippingAddressId
          : defaultShippingAddressId // ignore: cast_nullable_to_non_nullable
              as String,
      fcmToken: null == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notificationPreferences: freezed == notificationPreferences
          ? _value.notificationPreferences
          : notificationPreferences // ignore: cast_nullable_to_non_nullable
              as NotificationPreferences?,
      defaultFlatShippingRate: null == defaultFlatShippingRate
          ? _value.defaultFlatShippingRate
          : defaultFlatShippingRate // ignore: cast_nullable_to_non_nullable
              as double,
      defaultAdditionalItemFee: null == defaultAdditionalItemFee
          ? _value.defaultAdditionalItemFee
          : defaultAdditionalItemFee // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSettingsImpl extends _UserSettings {
  const _$UserSettingsImpl(
      {this.id = '',
      @JsonKey(name: 'user_id') this.userId = '',
      @JsonKey(name: 'swipe_payment_enabled') this.swipePaymentEnabled = false,
      @JsonKey(name: 'daily_budget') this.dailyBudget = 0.0,
      @JsonKey(name: 'daily_budget_used') this.dailyBudgetUsed = 0.0,
      @JsonKey(name: 'budget_reset_at') @DateTimeConverter() this.budgetResetAt,
      @JsonKey(name: 'default_payment_method_id')
      this.defaultPaymentMethodId = '',
      @JsonKey(name: 'default_shipping_address_id')
      this.defaultShippingAddressId = '',
      @JsonKey(name: 'fcm_token') this.fcmToken = '',
      @JsonKey(name: 'created_at') @DateTimeConverter() this.createdAt,
      @JsonKey(name: 'updated_at') @DateTimeConverter() this.updatedAt,
      @JsonKey(name: 'notification_preferences') this.notificationPreferences,
      @JsonKey(name: 'default_flat_shipping_rate')
      this.defaultFlatShippingRate = 0.0,
      @JsonKey(name: 'default_additional_item_fee')
      this.defaultAdditionalItemFee = 0.0})
      : super._();

  factory _$UserSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSettingsImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'swipe_payment_enabled')
  final bool swipePaymentEnabled;
  @override
  @JsonKey(name: 'daily_budget')
  final double dailyBudget;
  @override
  @JsonKey(name: 'daily_budget_used')
  final double dailyBudgetUsed;
  @override
  @JsonKey(name: 'budget_reset_at')
  @DateTimeConverter()
  final DateTime? budgetResetAt;
  @override
  @JsonKey(name: 'default_payment_method_id')
  final String defaultPaymentMethodId;
  @override
  @JsonKey(name: 'default_shipping_address_id')
  final String defaultShippingAddressId;
  @override
  @JsonKey(name: 'fcm_token')
  final String fcmToken;
  @override
  @JsonKey(name: 'created_at')
  @DateTimeConverter()
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  @DateTimeConverter()
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'notification_preferences')
  final NotificationPreferences? notificationPreferences;
  @override
  @JsonKey(name: 'default_flat_shipping_rate')
  final double defaultFlatShippingRate;
  @override
  @JsonKey(name: 'default_additional_item_fee')
  final double defaultAdditionalItemFee;

  @override
  String toString() {
    return 'UserSettings(id: $id, userId: $userId, swipePaymentEnabled: $swipePaymentEnabled, dailyBudget: $dailyBudget, dailyBudgetUsed: $dailyBudgetUsed, budgetResetAt: $budgetResetAt, defaultPaymentMethodId: $defaultPaymentMethodId, defaultShippingAddressId: $defaultShippingAddressId, fcmToken: $fcmToken, createdAt: $createdAt, updatedAt: $updatedAt, notificationPreferences: $notificationPreferences, defaultFlatShippingRate: $defaultFlatShippingRate, defaultAdditionalItemFee: $defaultAdditionalItemFee)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSettingsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.swipePaymentEnabled, swipePaymentEnabled) ||
                other.swipePaymentEnabled == swipePaymentEnabled) &&
            (identical(other.dailyBudget, dailyBudget) ||
                other.dailyBudget == dailyBudget) &&
            (identical(other.dailyBudgetUsed, dailyBudgetUsed) ||
                other.dailyBudgetUsed == dailyBudgetUsed) &&
            (identical(other.budgetResetAt, budgetResetAt) ||
                other.budgetResetAt == budgetResetAt) &&
            (identical(other.defaultPaymentMethodId, defaultPaymentMethodId) ||
                other.defaultPaymentMethodId == defaultPaymentMethodId) &&
            (identical(
                    other.defaultShippingAddressId, defaultShippingAddressId) ||
                other.defaultShippingAddressId == defaultShippingAddressId) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(
                    other.notificationPreferences, notificationPreferences) ||
                other.notificationPreferences == notificationPreferences) &&
            (identical(
                    other.defaultFlatShippingRate, defaultFlatShippingRate) ||
                other.defaultFlatShippingRate == defaultFlatShippingRate) &&
            (identical(
                    other.defaultAdditionalItemFee, defaultAdditionalItemFee) ||
                other.defaultAdditionalItemFee == defaultAdditionalItemFee));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      swipePaymentEnabled,
      dailyBudget,
      dailyBudgetUsed,
      budgetResetAt,
      defaultPaymentMethodId,
      defaultShippingAddressId,
      fcmToken,
      createdAt,
      updatedAt,
      notificationPreferences,
      defaultFlatShippingRate,
      defaultAdditionalItemFee);

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      __$$UserSettingsImplCopyWithImpl<_$UserSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSettingsImplToJson(
      this,
    );
  }
}

abstract class _UserSettings extends UserSettings {
  const factory _UserSettings(
      {final String id,
      @JsonKey(name: 'user_id') final String userId,
      @JsonKey(name: 'swipe_payment_enabled') final bool swipePaymentEnabled,
      @JsonKey(name: 'daily_budget') final double dailyBudget,
      @JsonKey(name: 'daily_budget_used') final double dailyBudgetUsed,
      @JsonKey(name: 'budget_reset_at')
      @DateTimeConverter()
      final DateTime? budgetResetAt,
      @JsonKey(name: 'default_payment_method_id')
      final String defaultPaymentMethodId,
      @JsonKey(name: 'default_shipping_address_id')
      final String defaultShippingAddressId,
      @JsonKey(name: 'fcm_token') final String fcmToken,
      @JsonKey(name: 'created_at')
      @DateTimeConverter()
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      @DateTimeConverter()
      final DateTime? updatedAt,
      @JsonKey(name: 'notification_preferences')
      final NotificationPreferences? notificationPreferences,
      @JsonKey(name: 'default_flat_shipping_rate')
      final double defaultFlatShippingRate,
      @JsonKey(name: 'default_additional_item_fee')
      final double defaultAdditionalItemFee}) = _$UserSettingsImpl;
  const _UserSettings._() : super._();

  factory _UserSettings.fromJson(Map<String, dynamic> json) =
      _$UserSettingsImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'swipe_payment_enabled')
  bool get swipePaymentEnabled;
  @override
  @JsonKey(name: 'daily_budget')
  double get dailyBudget;
  @override
  @JsonKey(name: 'daily_budget_used')
  double get dailyBudgetUsed;
  @override
  @JsonKey(name: 'budget_reset_at')
  @DateTimeConverter()
  DateTime? get budgetResetAt;
  @override
  @JsonKey(name: 'default_payment_method_id')
  String get defaultPaymentMethodId;
  @override
  @JsonKey(name: 'default_shipping_address_id')
  String get defaultShippingAddressId;
  @override
  @JsonKey(name: 'fcm_token')
  String get fcmToken;
  @override
  @JsonKey(name: 'created_at')
  @DateTimeConverter()
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  @DateTimeConverter()
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'notification_preferences')
  NotificationPreferences? get notificationPreferences;
  @override
  @JsonKey(name: 'default_flat_shipping_rate')
  double get defaultFlatShippingRate;
  @override
  @JsonKey(name: 'default_additional_item_fee')
  double get defaultAdditionalItemFee;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

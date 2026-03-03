import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '/core/utils/json_converters.dart';
import '/features/notifications/domain/models/notification_preferences_model.dart';

part 'user_settings_model.freezed.dart';
part 'user_settings_model.g.dart';

@freezed
class UserSettings with _$UserSettings {
  const UserSettings._();

  const factory UserSettings({
    @Default('') String id,
    @JsonKey(name: 'user_id') @Default('') String userId,
    @JsonKey(name: 'swipe_payment_enabled') @Default(false) bool swipePaymentEnabled,
    @JsonKey(name: 'daily_budget') @Default(0.0) double dailyBudget,
    @JsonKey(name: 'daily_budget_used') @Default(0.0) double dailyBudgetUsed,
    @JsonKey(name: 'budget_reset_at') @DateTimeConverter() DateTime? budgetResetAt,
    @JsonKey(name: 'default_payment_method_id') @Default('') String defaultPaymentMethodId,
    @JsonKey(name: 'default_shipping_address_id') @Default('') String defaultShippingAddressId,
    @JsonKey(name: 'fcm_token') @Default('') String fcmToken,
    @JsonKey(name: 'created_at') @DateTimeConverter() DateTime? createdAt,
    @JsonKey(name: 'updated_at') @DateTimeConverter() DateTime? updatedAt,
    @JsonKey(name: 'notification_preferences') NotificationPreferences? notificationPreferences,
    @JsonKey(name: 'default_flat_shipping_rate') @Default(0.0) double defaultFlatShippingRate,
    @JsonKey(name: 'default_additional_item_fee') @Default(0.0) double defaultAdditionalItemFee,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  String serialize() => jsonEncode(toJson());

  static UserSettings fromSerializableMap(Map<String, dynamic> data) =>
      UserSettings.fromJson(data);
}

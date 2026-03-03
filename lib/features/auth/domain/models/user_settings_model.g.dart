// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSettingsImpl _$$UserSettingsImplFromJson(Map<String, dynamic> json) =>
    _$UserSettingsImpl(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      swipePaymentEnabled: json['swipe_payment_enabled'] as bool? ?? false,
      dailyBudget: (json['daily_budget'] as num?)?.toDouble() ?? 0.0,
      dailyBudgetUsed: (json['daily_budget_used'] as num?)?.toDouble() ?? 0.0,
      budgetResetAt:
          const DateTimeConverter().fromJson(json['budget_reset_at']),
      defaultPaymentMethodId:
          json['default_payment_method_id'] as String? ?? '',
      defaultShippingAddressId:
          json['default_shipping_address_id'] as String? ?? '',
      fcmToken: json['fcm_token'] as String? ?? '',
      createdAt: const DateTimeConverter().fromJson(json['created_at']),
      updatedAt: const DateTimeConverter().fromJson(json['updated_at']),
      notificationPreferences: json['notification_preferences'] == null
          ? null
          : NotificationPreferences.fromJson(
              json['notification_preferences'] as Map<String, dynamic>),
      defaultFlatShippingRate:
          (json['default_flat_shipping_rate'] as num?)?.toDouble() ?? 0.0,
      defaultAdditionalItemFee:
          (json['default_additional_item_fee'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'swipe_payment_enabled': instance.swipePaymentEnabled,
      'daily_budget': instance.dailyBudget,
      'daily_budget_used': instance.dailyBudgetUsed,
      'budget_reset_at':
          const DateTimeConverter().toJson(instance.budgetResetAt),
      'default_payment_method_id': instance.defaultPaymentMethodId,
      'default_shipping_address_id': instance.defaultShippingAddressId,
      'fcm_token': instance.fcmToken,
      'created_at': const DateTimeConverter().toJson(instance.createdAt),
      'updated_at': const DateTimeConverter().toJson(instance.updatedAt),
      'notification_preferences': instance.notificationPreferences,
      'default_flat_shipping_rate': instance.defaultFlatShippingRate,
      'default_additional_item_fee': instance.defaultAdditionalItemFee,
    };

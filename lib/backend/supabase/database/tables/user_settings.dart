import '../database.dart';

class UserSettingsTable extends SupabaseTable<UserSettingsRow> {
  @override
  String get tableName => 'user_settings';

  @override
  UserSettingsRow createRow(Map<String, dynamic> data) => UserSettingsRow(data);
}

class UserSettingsRow extends SupabaseDataRow {
  UserSettingsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserSettingsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  bool? get swipePaymentEnabled => getField<bool>('swipe_payment_enabled');
  set swipePaymentEnabled(bool? value) =>
      setField<bool>('swipe_payment_enabled', value);

  double? get dailyBudget => getField<double>('daily_budget');
  set dailyBudget(double? value) => setField<double>('daily_budget', value);

  double? get dailyBudgetUsed => getField<double>('daily_budget_used');
  set dailyBudgetUsed(double? value) =>
      setField<double>('daily_budget_used', value);

  DateTime? get budgetResetAt => getField<DateTime>('budget_reset_at');
  set budgetResetAt(DateTime? value) =>
      setField<DateTime>('budget_reset_at', value);

  String? get defaultPaymentMethodId =>
      getField<String>('default_payment_method_id');
  set defaultPaymentMethodId(String? value) =>
      setField<String>('default_payment_method_id', value);

  String? get defaultShippingAddressId =>
      getField<String>('default_shipping_address_id');
  set defaultShippingAddressId(String? value) =>
      setField<String>('default_shipping_address_id', value);

  dynamic get notificationPreferences =>
      getField<dynamic>('notification_preferences');
  set notificationPreferences(dynamic value) =>
      setField<dynamic>('notification_preferences', value);

  String? get fcmToken => getField<String>('fcm_token');
  set fcmToken(String? value) => setField<String>('fcm_token', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);

  double? get defaultFlatShippingRate =>
      getField<double>('default_flat_shipping_rate');
  set defaultFlatShippingRate(double? value) =>
      setField<double>('default_flat_shipping_rate', value);

  double? get defaultAdditionalItemFee =>
      getField<double>('default_additional_item_fee');
  set defaultAdditionalItemFee(double? value) =>
      setField<double>('default_additional_item_fee', value);
}

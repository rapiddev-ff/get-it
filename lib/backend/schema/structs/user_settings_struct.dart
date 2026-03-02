// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserSettingsStruct extends BaseStruct {
  UserSettingsStruct({
    String? id,
    String? userId,
    bool? swipePaymentEnabled,
    double? dailyBudget,
    double? dailyBudgetUsed,
    DateTime? budgetResetAt,
    String? defaultPaymentMethodId,
    String? defaultShippingAddressId,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
    NotificationPreferencesStruct? notificationPreferences,
    double? defaultFlatShippingRate,
    double? defaultAdditionalItemFee,
  })  : _id = id,
        _userId = userId,
        _swipePaymentEnabled = swipePaymentEnabled,
        _dailyBudget = dailyBudget,
        _dailyBudgetUsed = dailyBudgetUsed,
        _budgetResetAt = budgetResetAt,
        _defaultPaymentMethodId = defaultPaymentMethodId,
        _defaultShippingAddressId = defaultShippingAddressId,
        _fcmToken = fcmToken,
        _createdAt = createdAt,
        _updatedAt = updatedAt,
        _notificationPreferences = notificationPreferences,
        _defaultFlatShippingRate = defaultFlatShippingRate,
        _defaultAdditionalItemFee = defaultAdditionalItemFee;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  set userId(String? val) => _userId = val;

  bool hasUserId() => _userId != null;

  // "swipe_payment_enabled" field.
  bool? _swipePaymentEnabled;
  bool get swipePaymentEnabled => _swipePaymentEnabled ?? false;
  set swipePaymentEnabled(bool? val) => _swipePaymentEnabled = val;

  bool hasSwipePaymentEnabled() => _swipePaymentEnabled != null;

  // "daily_budget" field.
  double? _dailyBudget;
  double get dailyBudget => _dailyBudget ?? 0.0;
  set dailyBudget(double? val) => _dailyBudget = val;

  void incrementDailyBudget(double amount) =>
      dailyBudget = dailyBudget + amount;

  bool hasDailyBudget() => _dailyBudget != null;

  // "daily_budget_used" field.
  double? _dailyBudgetUsed;
  double get dailyBudgetUsed => _dailyBudgetUsed ?? 0.0;
  set dailyBudgetUsed(double? val) => _dailyBudgetUsed = val;

  void incrementDailyBudgetUsed(double amount) =>
      dailyBudgetUsed = dailyBudgetUsed + amount;

  bool hasDailyBudgetUsed() => _dailyBudgetUsed != null;

  // "budget_reset_at" field.
  DateTime? _budgetResetAt;
  DateTime? get budgetResetAt => _budgetResetAt;
  set budgetResetAt(DateTime? val) => _budgetResetAt = val;

  bool hasBudgetResetAt() => _budgetResetAt != null;

  // "default_payment_method_id" field.
  String? _defaultPaymentMethodId;
  String get defaultPaymentMethodId => _defaultPaymentMethodId ?? '';
  set defaultPaymentMethodId(String? val) => _defaultPaymentMethodId = val;

  bool hasDefaultPaymentMethodId() => _defaultPaymentMethodId != null;

  // "default_shipping_address_id" field.
  String? _defaultShippingAddressId;
  String get defaultShippingAddressId => _defaultShippingAddressId ?? '';
  set defaultShippingAddressId(String? val) => _defaultShippingAddressId = val;

  bool hasDefaultShippingAddressId() => _defaultShippingAddressId != null;

  // "fcm_token" field.
  String? _fcmToken;
  String get fcmToken => _fcmToken ?? '';
  set fcmToken(String? val) => _fcmToken = val;

  bool hasFcmToken() => _fcmToken != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "updated_at" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  set updatedAt(DateTime? val) => _updatedAt = val;

  bool hasUpdatedAt() => _updatedAt != null;

  // "notification_preferences" field.
  NotificationPreferencesStruct? _notificationPreferences;
  NotificationPreferencesStruct get notificationPreferences =>
      _notificationPreferences ?? NotificationPreferencesStruct();
  set notificationPreferences(NotificationPreferencesStruct? val) =>
      _notificationPreferences = val;

  void updateNotificationPreferences(
      Function(NotificationPreferencesStruct) updateFn) {
    updateFn(_notificationPreferences ??= NotificationPreferencesStruct());
  }

  bool hasNotificationPreferences() => _notificationPreferences != null;

  // "default_flat_shipping_rate" field.
  double? _defaultFlatShippingRate;
  double get defaultFlatShippingRate => _defaultFlatShippingRate ?? 0.0;
  set defaultFlatShippingRate(double? val) => _defaultFlatShippingRate = val;

  void incrementDefaultFlatShippingRate(double amount) =>
      defaultFlatShippingRate = defaultFlatShippingRate + amount;

  bool hasDefaultFlatShippingRate() => _defaultFlatShippingRate != null;

  // "default_additional_item_fee" field.
  double? _defaultAdditionalItemFee;
  double get defaultAdditionalItemFee => _defaultAdditionalItemFee ?? 0.0;
  set defaultAdditionalItemFee(double? val) => _defaultAdditionalItemFee = val;

  void incrementDefaultAdditionalItemFee(double amount) =>
      defaultAdditionalItemFee = defaultAdditionalItemFee + amount;

  bool hasDefaultAdditionalItemFee() => _defaultAdditionalItemFee != null;

  static UserSettingsStruct fromMap(Map<String, dynamic> data) =>
      UserSettingsStruct(
        id: data['id'] as String?,
        userId: data['user_id'] as String?,
        swipePaymentEnabled: data['swipe_payment_enabled'] as bool?,
        dailyBudget: castToType<double>(data['daily_budget']),
        dailyBudgetUsed: castToType<double>(data['daily_budget_used']),
        budgetResetAt: data['budget_reset_at'] as DateTime?,
        defaultPaymentMethodId: data['default_payment_method_id'] as String?,
        defaultShippingAddressId:
            data['default_shipping_address_id'] as String?,
        fcmToken: data['fcm_token'] as String?,
        createdAt: data['created_at'] as DateTime?,
        updatedAt: data['updated_at'] as DateTime?,
        notificationPreferences:
            data['notification_preferences'] is NotificationPreferencesStruct
                ? data['notification_preferences']
                : NotificationPreferencesStruct.maybeFromMap(
                    data['notification_preferences']),
        defaultFlatShippingRate:
            castToType<double>(data['default_flat_shipping_rate']),
        defaultAdditionalItemFee:
            castToType<double>(data['default_additional_item_fee']),
      );

  static UserSettingsStruct? maybeFromMap(dynamic data) => data is Map
      ? UserSettingsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'user_id': _userId,
        'swipe_payment_enabled': _swipePaymentEnabled,
        'daily_budget': _dailyBudget,
        'daily_budget_used': _dailyBudgetUsed,
        'budget_reset_at': _budgetResetAt,
        'default_payment_method_id': _defaultPaymentMethodId,
        'default_shipping_address_id': _defaultShippingAddressId,
        'fcm_token': _fcmToken,
        'created_at': _createdAt,
        'updated_at': _updatedAt,
        'notification_preferences': _notificationPreferences?.toMap(),
        'default_flat_shipping_rate': _defaultFlatShippingRate,
        'default_additional_item_fee': _defaultAdditionalItemFee,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'user_id': serializeParam(
          _userId,
          ParamType.String,
        ),
        'swipe_payment_enabled': serializeParam(
          _swipePaymentEnabled,
          ParamType.bool,
        ),
        'daily_budget': serializeParam(
          _dailyBudget,
          ParamType.double,
        ),
        'daily_budget_used': serializeParam(
          _dailyBudgetUsed,
          ParamType.double,
        ),
        'budget_reset_at': serializeParam(
          _budgetResetAt,
          ParamType.DateTime,
        ),
        'default_payment_method_id': serializeParam(
          _defaultPaymentMethodId,
          ParamType.String,
        ),
        'default_shipping_address_id': serializeParam(
          _defaultShippingAddressId,
          ParamType.String,
        ),
        'fcm_token': serializeParam(
          _fcmToken,
          ParamType.String,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
        'updated_at': serializeParam(
          _updatedAt,
          ParamType.DateTime,
        ),
        'notification_preferences': serializeParam(
          _notificationPreferences,
          ParamType.DataStruct,
        ),
        'default_flat_shipping_rate': serializeParam(
          _defaultFlatShippingRate,
          ParamType.double,
        ),
        'default_additional_item_fee': serializeParam(
          _defaultAdditionalItemFee,
          ParamType.double,
        ),
      }.withoutNulls;

  static UserSettingsStruct fromSerializableMap(Map<String, dynamic> data) =>
      UserSettingsStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        userId: deserializeParam(
          data['user_id'],
          ParamType.String,
          false,
        ),
        swipePaymentEnabled: deserializeParam(
          data['swipe_payment_enabled'],
          ParamType.bool,
          false,
        ),
        dailyBudget: deserializeParam(
          data['daily_budget'],
          ParamType.double,
          false,
        ),
        dailyBudgetUsed: deserializeParam(
          data['daily_budget_used'],
          ParamType.double,
          false,
        ),
        budgetResetAt: deserializeParam(
          data['budget_reset_at'],
          ParamType.DateTime,
          false,
        ),
        defaultPaymentMethodId: deserializeParam(
          data['default_payment_method_id'],
          ParamType.String,
          false,
        ),
        defaultShippingAddressId: deserializeParam(
          data['default_shipping_address_id'],
          ParamType.String,
          false,
        ),
        fcmToken: deserializeParam(
          data['fcm_token'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.DateTime,
          false,
        ),
        updatedAt: deserializeParam(
          data['updated_at'],
          ParamType.DateTime,
          false,
        ),
        notificationPreferences: deserializeStructParam(
          data['notification_preferences'],
          ParamType.DataStruct,
          false,
          structBuilder: NotificationPreferencesStruct.fromSerializableMap,
        ),
        defaultFlatShippingRate: deserializeParam(
          data['default_flat_shipping_rate'],
          ParamType.double,
          false,
        ),
        defaultAdditionalItemFee: deserializeParam(
          data['default_additional_item_fee'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'UserSettingsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is UserSettingsStruct &&
        id == other.id &&
        userId == other.userId &&
        swipePaymentEnabled == other.swipePaymentEnabled &&
        dailyBudget == other.dailyBudget &&
        dailyBudgetUsed == other.dailyBudgetUsed &&
        budgetResetAt == other.budgetResetAt &&
        defaultPaymentMethodId == other.defaultPaymentMethodId &&
        defaultShippingAddressId == other.defaultShippingAddressId &&
        fcmToken == other.fcmToken &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        notificationPreferences == other.notificationPreferences &&
        defaultFlatShippingRate == other.defaultFlatShippingRate &&
        defaultAdditionalItemFee == other.defaultAdditionalItemFee;
  }

  @override
  int get hashCode => const ListEquality().hash([
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
        defaultAdditionalItemFee
      ]);
}

UserSettingsStruct createUserSettingsStruct({
  String? id,
  String? userId,
  bool? swipePaymentEnabled,
  double? dailyBudget,
  double? dailyBudgetUsed,
  DateTime? budgetResetAt,
  String? defaultPaymentMethodId,
  String? defaultShippingAddressId,
  String? fcmToken,
  DateTime? createdAt,
  DateTime? updatedAt,
  NotificationPreferencesStruct? notificationPreferences,
  double? defaultFlatShippingRate,
  double? defaultAdditionalItemFee,
}) =>
    UserSettingsStruct(
      id: id,
      userId: userId,
      swipePaymentEnabled: swipePaymentEnabled,
      dailyBudget: dailyBudget,
      dailyBudgetUsed: dailyBudgetUsed,
      budgetResetAt: budgetResetAt,
      defaultPaymentMethodId: defaultPaymentMethodId,
      defaultShippingAddressId: defaultShippingAddressId,
      fcmToken: fcmToken,
      createdAt: createdAt,
      updatedAt: updatedAt,
      notificationPreferences:
          notificationPreferences ?? NotificationPreferencesStruct(),
      defaultFlatShippingRate: defaultFlatShippingRate,
      defaultAdditionalItemFee: defaultAdditionalItemFee,
    );

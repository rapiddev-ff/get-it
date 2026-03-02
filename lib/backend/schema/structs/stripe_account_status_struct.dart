// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StripeAccountStatusStruct extends BaseStruct {
  StripeAccountStatusStruct({
    bool? hasAccount,
    String? stripeAccountId,
    bool? chargesEnabled,
    bool? payoutsEnabled,
    bool? detailsSubmitted,
    bool? onboardingCompleted,
    bool? needsOnboarding,
    String? disabledReason,
    List<String>? currentlyDue,
    List<String>? pastDue,
    bool? hasPastDue,
    String? accountStatus,
    String? statusLabel,
    String? statusColor,
    bool? canSell,
    bool? needsAttention,
  })  : _hasAccount = hasAccount,
        _stripeAccountId = stripeAccountId,
        _chargesEnabled = chargesEnabled,
        _payoutsEnabled = payoutsEnabled,
        _detailsSubmitted = detailsSubmitted,
        _onboardingCompleted = onboardingCompleted,
        _needsOnboarding = needsOnboarding,
        _disabledReason = disabledReason,
        _currentlyDue = currentlyDue,
        _pastDue = pastDue,
        _hasPastDue = hasPastDue,
        _accountStatus = accountStatus,
        _statusLabel = statusLabel,
        _statusColor = statusColor,
        _canSell = canSell,
        _needsAttention = needsAttention;

  // "hasAccount" field.
  bool? _hasAccount;
  bool get hasAccount => _hasAccount ?? false;
  set hasAccount(bool? val) => _hasAccount = val;

  bool hasHasAccount() => _hasAccount != null;

  // "stripeAccountId" field.
  String? _stripeAccountId;
  String get stripeAccountId => _stripeAccountId ?? '';
  set stripeAccountId(String? val) => _stripeAccountId = val;

  bool hasStripeAccountId() => _stripeAccountId != null;

  // "chargesEnabled" field.
  bool? _chargesEnabled;
  bool get chargesEnabled => _chargesEnabled ?? false;
  set chargesEnabled(bool? val) => _chargesEnabled = val;

  bool hasChargesEnabled() => _chargesEnabled != null;

  // "payoutsEnabled" field.
  bool? _payoutsEnabled;
  bool get payoutsEnabled => _payoutsEnabled ?? false;
  set payoutsEnabled(bool? val) => _payoutsEnabled = val;

  bool hasPayoutsEnabled() => _payoutsEnabled != null;

  // "detailsSubmitted" field.
  bool? _detailsSubmitted;
  bool get detailsSubmitted => _detailsSubmitted ?? false;
  set detailsSubmitted(bool? val) => _detailsSubmitted = val;

  bool hasDetailsSubmitted() => _detailsSubmitted != null;

  // "onboardingCompleted" field.
  bool? _onboardingCompleted;
  bool get onboardingCompleted => _onboardingCompleted ?? false;
  set onboardingCompleted(bool? val) => _onboardingCompleted = val;

  bool hasOnboardingCompleted() => _onboardingCompleted != null;

  // "needsOnboarding" field.
  bool? _needsOnboarding;
  bool get needsOnboarding => _needsOnboarding ?? false;
  set needsOnboarding(bool? val) => _needsOnboarding = val;

  bool hasNeedsOnboarding() => _needsOnboarding != null;

  // "disabledReason" field.
  String? _disabledReason;
  String get disabledReason => _disabledReason ?? '';
  set disabledReason(String? val) => _disabledReason = val;

  bool hasDisabledReason() => _disabledReason != null;

  // "currentlyDue" field.
  List<String>? _currentlyDue;
  List<String> get currentlyDue => _currentlyDue ?? const [];
  set currentlyDue(List<String>? val) => _currentlyDue = val;

  void updateCurrentlyDue(Function(List<String>) updateFn) {
    updateFn(_currentlyDue ??= []);
  }

  bool hasCurrentlyDue() => _currentlyDue != null;

  // "pastDue" field.
  List<String>? _pastDue;
  List<String> get pastDue => _pastDue ?? const [];
  set pastDue(List<String>? val) => _pastDue = val;

  void updatePastDue(Function(List<String>) updateFn) {
    updateFn(_pastDue ??= []);
  }

  bool hasPastDueField() => _pastDue != null;

  // "hasPastDue" field.
  bool? _hasPastDue;
  bool get hasPastDue => _hasPastDue ?? false;
  set hasPastDue(bool? val) => _hasPastDue = val;

  bool hasHasPastDue() => _hasPastDue != null;

  // "accountStatus" field.
  String? _accountStatus;
  String get accountStatus => _accountStatus ?? '';
  set accountStatus(String? val) => _accountStatus = val;

  bool hasAccountStatus() => _accountStatus != null;

  // "statusLabel" field.
  String? _statusLabel;
  String get statusLabel => _statusLabel ?? '';
  set statusLabel(String? val) => _statusLabel = val;

  bool hasStatusLabel() => _statusLabel != null;

  // "statusColor" field.
  String? _statusColor;
  String get statusColor => _statusColor ?? '';
  set statusColor(String? val) => _statusColor = val;

  bool hasStatusColor() => _statusColor != null;

  // "canSell" field.
  bool? _canSell;
  bool get canSell => _canSell ?? false;
  set canSell(bool? val) => _canSell = val;

  bool hasCanSell() => _canSell != null;

  // "needsAttention" field.
  bool? _needsAttention;
  bool get needsAttention => _needsAttention ?? false;
  set needsAttention(bool? val) => _needsAttention = val;

  bool hasNeedsAttention() => _needsAttention != null;

  static StripeAccountStatusStruct fromMap(Map<String, dynamic> data) =>
      StripeAccountStatusStruct(
        hasAccount: data['hasAccount'] as bool?,
        stripeAccountId: data['stripeAccountId'] as String?,
        chargesEnabled: data['chargesEnabled'] as bool?,
        payoutsEnabled: data['payoutsEnabled'] as bool?,
        detailsSubmitted: data['detailsSubmitted'] as bool?,
        onboardingCompleted: data['onboardingCompleted'] as bool?,
        needsOnboarding: data['needsOnboarding'] as bool?,
        disabledReason: data['disabledReason'] as String?,
        currentlyDue: getDataList(data['currentlyDue']),
        pastDue: getDataList(data['pastDue']),
        hasPastDue: data['hasPastDue'] as bool?,
        accountStatus: data['accountStatus'] as String?,
        statusLabel: data['statusLabel'] as String?,
        statusColor: data['statusColor'] as String?,
        canSell: data['canSell'] as bool?,
        needsAttention: data['needsAttention'] as bool?,
      );

  static StripeAccountStatusStruct? maybeFromMap(dynamic data) => data is Map
      ? StripeAccountStatusStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'hasAccount': _hasAccount,
        'stripeAccountId': _stripeAccountId,
        'chargesEnabled': _chargesEnabled,
        'payoutsEnabled': _payoutsEnabled,
        'detailsSubmitted': _detailsSubmitted,
        'onboardingCompleted': _onboardingCompleted,
        'needsOnboarding': _needsOnboarding,
        'disabledReason': _disabledReason,
        'currentlyDue': _currentlyDue,
        'pastDue': _pastDue,
        'hasPastDue': _hasPastDue,
        'accountStatus': _accountStatus,
        'statusLabel': _statusLabel,
        'statusColor': _statusColor,
        'canSell': _canSell,
        'needsAttention': _needsAttention,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'hasAccount': serializeParam(
          _hasAccount,
          ParamType.bool,
        ),
        'stripeAccountId': serializeParam(
          _stripeAccountId,
          ParamType.String,
        ),
        'chargesEnabled': serializeParam(
          _chargesEnabled,
          ParamType.bool,
        ),
        'payoutsEnabled': serializeParam(
          _payoutsEnabled,
          ParamType.bool,
        ),
        'detailsSubmitted': serializeParam(
          _detailsSubmitted,
          ParamType.bool,
        ),
        'onboardingCompleted': serializeParam(
          _onboardingCompleted,
          ParamType.bool,
        ),
        'needsOnboarding': serializeParam(
          _needsOnboarding,
          ParamType.bool,
        ),
        'disabledReason': serializeParam(
          _disabledReason,
          ParamType.String,
        ),
        'currentlyDue': serializeParam(
          _currentlyDue,
          ParamType.String,
          isList: true,
        ),
        'pastDue': serializeParam(
          _pastDue,
          ParamType.String,
          isList: true,
        ),
        'hasPastDue': serializeParam(
          _hasPastDue,
          ParamType.bool,
        ),
        'accountStatus': serializeParam(
          _accountStatus,
          ParamType.String,
        ),
        'statusLabel': serializeParam(
          _statusLabel,
          ParamType.String,
        ),
        'statusColor': serializeParam(
          _statusColor,
          ParamType.String,
        ),
        'canSell': serializeParam(
          _canSell,
          ParamType.bool,
        ),
        'needsAttention': serializeParam(
          _needsAttention,
          ParamType.bool,
        ),
      }.withoutNulls;

  static StripeAccountStatusStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      StripeAccountStatusStruct(
        hasAccount: deserializeParam(
          data['hasAccount'],
          ParamType.bool,
          false,
        ),
        stripeAccountId: deserializeParam(
          data['stripeAccountId'],
          ParamType.String,
          false,
        ),
        chargesEnabled: deserializeParam(
          data['chargesEnabled'],
          ParamType.bool,
          false,
        ),
        payoutsEnabled: deserializeParam(
          data['payoutsEnabled'],
          ParamType.bool,
          false,
        ),
        detailsSubmitted: deserializeParam(
          data['detailsSubmitted'],
          ParamType.bool,
          false,
        ),
        onboardingCompleted: deserializeParam(
          data['onboardingCompleted'],
          ParamType.bool,
          false,
        ),
        needsOnboarding: deserializeParam(
          data['needsOnboarding'],
          ParamType.bool,
          false,
        ),
        disabledReason: deserializeParam(
          data['disabledReason'],
          ParamType.String,
          false,
        ),
        currentlyDue: deserializeParam<String>(
          data['currentlyDue'],
          ParamType.String,
          true,
        ),
        pastDue: deserializeParam<String>(
          data['pastDue'],
          ParamType.String,
          true,
        ),
        hasPastDue: deserializeParam(
          data['hasPastDue'],
          ParamType.bool,
          false,
        ),
        accountStatus: deserializeParam(
          data['accountStatus'],
          ParamType.String,
          false,
        ),
        statusLabel: deserializeParam(
          data['statusLabel'],
          ParamType.String,
          false,
        ),
        statusColor: deserializeParam(
          data['statusColor'],
          ParamType.String,
          false,
        ),
        canSell: deserializeParam(
          data['canSell'],
          ParamType.bool,
          false,
        ),
        needsAttention: deserializeParam(
          data['needsAttention'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'StripeAccountStatusStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is StripeAccountStatusStruct &&
        hasAccount == other.hasAccount &&
        stripeAccountId == other.stripeAccountId &&
        chargesEnabled == other.chargesEnabled &&
        payoutsEnabled == other.payoutsEnabled &&
        detailsSubmitted == other.detailsSubmitted &&
        onboardingCompleted == other.onboardingCompleted &&
        needsOnboarding == other.needsOnboarding &&
        disabledReason == other.disabledReason &&
        listEquality.equals(currentlyDue, other.currentlyDue) &&
        listEquality.equals(pastDue, other.pastDue) &&
        hasPastDue == other.hasPastDue &&
        accountStatus == other.accountStatus &&
        statusLabel == other.statusLabel &&
        statusColor == other.statusColor &&
        canSell == other.canSell &&
        needsAttention == other.needsAttention;
  }

  @override
  int get hashCode => const ListEquality().hash([
        hasAccount,
        stripeAccountId,
        chargesEnabled,
        payoutsEnabled,
        detailsSubmitted,
        onboardingCompleted,
        needsOnboarding,
        disabledReason,
        currentlyDue,
        pastDue,
        hasPastDue,
        accountStatus,
        statusLabel,
        statusColor,
        canSell,
        needsAttention
      ]);
}

StripeAccountStatusStruct createStripeAccountStatusStruct({
  bool? hasAccount,
  String? stripeAccountId,
  bool? chargesEnabled,
  bool? payoutsEnabled,
  bool? detailsSubmitted,
  bool? onboardingCompleted,
  bool? needsOnboarding,
  String? disabledReason,
  bool? hasPastDue,
  String? accountStatus,
  String? statusLabel,
  String? statusColor,
  bool? canSell,
  bool? needsAttention,
}) =>
    StripeAccountStatusStruct(
      hasAccount: hasAccount,
      stripeAccountId: stripeAccountId,
      chargesEnabled: chargesEnabled,
      payoutsEnabled: payoutsEnabled,
      detailsSubmitted: detailsSubmitted,
      onboardingCompleted: onboardingCompleted,
      needsOnboarding: needsOnboarding,
      disabledReason: disabledReason,
      hasPastDue: hasPastDue,
      accountStatus: accountStatus,
      statusLabel: statusLabel,
      statusColor: statusColor,
      canSell: canSell,
      needsAttention: needsAttention,
    );

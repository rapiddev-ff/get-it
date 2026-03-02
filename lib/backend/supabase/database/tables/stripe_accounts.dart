import '../database.dart';

class StripeAccountsTable extends SupabaseTable<StripeAccountsRow> {
  @override
  String get tableName => 'stripe_accounts';

  @override
  StripeAccountsRow createRow(Map<String, dynamic> data) =>
      StripeAccountsRow(data);
}

class StripeAccountsRow extends SupabaseDataRow {
  StripeAccountsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => StripeAccountsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get stripeAccountId => getField<String>('stripe_account_id')!;
  set stripeAccountId(String value) =>
      setField<String>('stripe_account_id', value);

  String? get accountType => getField<String>('account_type');
  set accountType(String? value) => setField<String>('account_type', value);

  bool? get chargesEnabled => getField<bool>('charges_enabled');
  set chargesEnabled(bool? value) => setField<bool>('charges_enabled', value);

  bool? get payoutsEnabled => getField<bool>('payouts_enabled');
  set payoutsEnabled(bool? value) => setField<bool>('payouts_enabled', value);

  bool? get detailsSubmitted => getField<bool>('details_submitted');
  set detailsSubmitted(bool? value) =>
      setField<bool>('details_submitted', value);

  bool? get onboardingCompleted => getField<bool>('onboarding_completed');
  set onboardingCompleted(bool? value) =>
      setField<bool>('onboarding_completed', value);

  String? get businessType => getField<String>('business_type');
  set businessType(String? value) => setField<String>('business_type', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get defaultCurrency => getField<String>('default_currency');
  set defaultCurrency(String? value) =>
      setField<String>('default_currency', value);

  dynamic get capabilities => getField<dynamic>('capabilities');
  set capabilities(dynamic value) => setField<dynamic>('capabilities', value);

  dynamic get requirements => getField<dynamic>('requirements');
  set requirements(dynamic value) => setField<dynamic>('requirements', value);

  dynamic get settings => getField<dynamic>('settings');
  set settings(dynamic value) => setField<dynamic>('settings', value);

  dynamic get payoutSchedule => getField<dynamic>('payout_schedule');
  set payoutSchedule(dynamic value) =>
      setField<dynamic>('payout_schedule', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String get accountStatus => getField<String>('account_status')!;
  set accountStatus(String value) => setField<String>('account_status', value);

  String? get disabledReason => getField<String>('disabled_reason');
  set disabledReason(String? value) =>
      setField<String>('disabled_reason', value);

  List<String> get currentlyDue => getListField<String>('currently_due');
  set currentlyDue(List<String>? value) =>
      setListField<String>('currently_due', value);

  List<String> get pastDue => getListField<String>('past_due');
  set pastDue(List<String>? value) => setListField<String>('past_due', value);

  List<String> get eventuallyDue => getListField<String>('eventually_due');
  set eventuallyDue(List<String>? value) =>
      setListField<String>('eventually_due', value);

  DateTime? get requirementsDeadline =>
      getField<DateTime>('requirements_deadline');
  set requirementsDeadline(DateTime? value) =>
      setField<DateTime>('requirements_deadline', value);
}

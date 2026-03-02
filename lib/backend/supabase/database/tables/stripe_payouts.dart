import '../database.dart';

class StripePayoutsTable extends SupabaseTable<StripePayoutsRow> {
  @override
  String get tableName => 'stripe_payouts';

  @override
  StripePayoutsRow createRow(Map<String, dynamic> data) =>
      StripePayoutsRow(data);
}

class StripePayoutsRow extends SupabaseDataRow {
  StripePayoutsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => StripePayoutsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get stripeAccountId => getField<String>('stripe_account_id')!;
  set stripeAccountId(String value) =>
      setField<String>('stripe_account_id', value);

  String get stripePayoutId => getField<String>('stripe_payout_id')!;
  set stripePayoutId(String value) =>
      setField<String>('stripe_payout_id', value);

  String? get stripeBalanceTransactionId =>
      getField<String>('stripe_balance_transaction_id');
  set stripeBalanceTransactionId(String? value) =>
      setField<String>('stripe_balance_transaction_id', value);

  int get amount => getField<int>('amount')!;
  set amount(int value) => setField<int>('amount', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get arrivalDate => getField<DateTime>('arrival_date');
  set arrivalDate(DateTime? value) => setField<DateTime>('arrival_date', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get failureCode => getField<String>('failure_code');
  set failureCode(String? value) => setField<String>('failure_code', value);

  String? get failureMessage => getField<String>('failure_message');
  set failureMessage(String? value) =>
      setField<String>('failure_message', value);

  dynamic get metadata => getField<dynamic>('metadata');
  set metadata(dynamic value) => setField<dynamic>('metadata', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}

import '../database.dart';

class StripePaymentIntentsTable extends SupabaseTable<StripePaymentIntentsRow> {
  @override
  String get tableName => 'stripe_payment_intents';

  @override
  StripePaymentIntentsRow createRow(Map<String, dynamic> data) =>
      StripePaymentIntentsRow(data);
}

class StripePaymentIntentsRow extends SupabaseDataRow {
  StripePaymentIntentsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => StripePaymentIntentsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get orderId => getField<String>('order_id')!;
  set orderId(String value) => setField<String>('order_id', value);

  String get buyerId => getField<String>('buyer_id')!;
  set buyerId(String value) => setField<String>('buyer_id', value);

  String get sellerId => getField<String>('seller_id')!;
  set sellerId(String value) => setField<String>('seller_id', value);

  String get stripePaymentIntentId =>
      getField<String>('stripe_payment_intent_id')!;
  set stripePaymentIntentId(String value) =>
      setField<String>('stripe_payment_intent_id', value);

  String? get stripeCustomerId => getField<String>('stripe_customer_id');
  set stripeCustomerId(String? value) =>
      setField<String>('stripe_customer_id', value);

  String? get stripeConnectedAccountId =>
      getField<String>('stripe_connected_account_id');
  set stripeConnectedAccountId(String? value) =>
      setField<String>('stripe_connected_account_id', value);

  int get amount => getField<int>('amount')!;
  set amount(int value) => setField<int>('amount', value);

  int? get platformFee => getField<int>('platform_fee');
  set platformFee(int? value) => setField<int>('platform_fee', value);

  int get sellerAmount => getField<int>('seller_amount')!;
  set sellerAmount(int value) => setField<int>('seller_amount', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get captureMethod => getField<String>('capture_method');
  set captureMethod(String? value) => setField<String>('capture_method', value);

  DateTime? get capturedAt => getField<DateTime>('captured_at');
  set capturedAt(DateTime? value) => setField<DateTime>('captured_at', value);

  DateTime? get cancelledAt => getField<DateTime>('cancelled_at');
  set cancelledAt(DateTime? value) => setField<DateTime>('cancelled_at', value);

  String? get transferId => getField<String>('transfer_id');
  set transferId(String? value) => setField<String>('transfer_id', value);

  String? get transferStatus => getField<String>('transfer_status');
  set transferStatus(String? value) =>
      setField<String>('transfer_status', value);

  DateTime? get transferCreatedAt => getField<DateTime>('transfer_created_at');
  set transferCreatedAt(DateTime? value) =>
      setField<DateTime>('transfer_created_at', value);

  DateTime? get holdUntil => getField<DateTime>('hold_until');
  set holdUntil(DateTime? value) => setField<DateTime>('hold_until', value);

  DateTime? get releasedAt => getField<DateTime>('released_at');
  set releasedAt(DateTime? value) => setField<DateTime>('released_at', value);

  dynamic get metadata => getField<dynamic>('metadata');
  set metadata(dynamic value) => setField<dynamic>('metadata', value);

  String? get errorMessage => getField<String>('error_message');
  set errorMessage(String? value) => setField<String>('error_message', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}

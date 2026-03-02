import '../database.dart';

class StripeRefundsTable extends SupabaseTable<StripeRefundsRow> {
  @override
  String get tableName => 'stripe_refunds';

  @override
  StripeRefundsRow createRow(Map<String, dynamic> data) =>
      StripeRefundsRow(data);
}

class StripeRefundsRow extends SupabaseDataRow {
  StripeRefundsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => StripeRefundsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get paymentIntentId => getField<String>('payment_intent_id');
  set paymentIntentId(String? value) =>
      setField<String>('payment_intent_id', value);

  String? get orderId => getField<String>('order_id');
  set orderId(String? value) => setField<String>('order_id', value);

  String get stripeRefundId => getField<String>('stripe_refund_id')!;
  set stripeRefundId(String value) =>
      setField<String>('stripe_refund_id', value);

  String get stripePaymentIntentId =>
      getField<String>('stripe_payment_intent_id')!;
  set stripePaymentIntentId(String value) =>
      setField<String>('stripe_payment_intent_id', value);

  String? get stripeChargeId => getField<String>('stripe_charge_id');
  set stripeChargeId(String? value) =>
      setField<String>('stripe_charge_id', value);

  int get amount => getField<int>('amount')!;
  set amount(int value) => setField<int>('amount', value);

  String? get currency => getField<String>('currency');
  set currency(String? value) => setField<String>('currency', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get reason => getField<String>('reason');
  set reason(String? value) => setField<String>('reason', value);

  String? get initiatedBy => getField<String>('initiated_by');
  set initiatedBy(String? value) => setField<String>('initiated_by', value);

  String? get failureReason => getField<String>('failure_reason');
  set failureReason(String? value) => setField<String>('failure_reason', value);

  dynamic get metadata => getField<dynamic>('metadata');
  set metadata(dynamic value) => setField<dynamic>('metadata', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}

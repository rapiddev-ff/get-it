import '../database.dart';

class PaymentMethodsTable extends SupabaseTable<PaymentMethodsRow> {
  @override
  String get tableName => 'payment_methods';

  @override
  PaymentMethodsRow createRow(Map<String, dynamic> data) =>
      PaymentMethodsRow(data);
}

class PaymentMethodsRow extends SupabaseDataRow {
  PaymentMethodsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PaymentMethodsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get stripePaymentMethodId =>
      getField<String>('stripe_payment_method_id')!;
  set stripePaymentMethodId(String value) =>
      setField<String>('stripe_payment_method_id', value);

  String? get cardBrand => getField<String>('card_brand');
  set cardBrand(String? value) => setField<String>('card_brand', value);

  String? get cardLast4 => getField<String>('card_last4');
  set cardLast4(String? value) => setField<String>('card_last4', value);

  int? get cardExpMonth => getField<int>('card_exp_month');
  set cardExpMonth(int? value) => setField<int>('card_exp_month', value);

  int? get cardExpYear => getField<int>('card_exp_year');
  set cardExpYear(int? value) => setField<int>('card_exp_year', value);

  String? get billingName => getField<String>('billing_name');
  set billingName(String? value) => setField<String>('billing_name', value);

  String? get billingAddressLine1 => getField<String>('billing_address_line1');
  set billingAddressLine1(String? value) =>
      setField<String>('billing_address_line1', value);

  String? get billingAddressLine2 => getField<String>('billing_address_line2');
  set billingAddressLine2(String? value) =>
      setField<String>('billing_address_line2', value);

  String? get billingCity => getField<String>('billing_city');
  set billingCity(String? value) => setField<String>('billing_city', value);

  String? get billingState => getField<String>('billing_state');
  set billingState(String? value) => setField<String>('billing_state', value);

  String? get billingZip => getField<String>('billing_zip');
  set billingZip(String? value) => setField<String>('billing_zip', value);

  String? get billingCountry => getField<String>('billing_country');
  set billingCountry(String? value) =>
      setField<String>('billing_country', value);

  bool? get isDefault => getField<bool>('is_default');
  set isDefault(bool? value) => setField<bool>('is_default', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);
}

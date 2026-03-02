import '../database.dart';

class StripeCustomersTable extends SupabaseTable<StripeCustomersRow> {
  @override
  String get tableName => 'stripe_customers';

  @override
  StripeCustomersRow createRow(Map<String, dynamic> data) =>
      StripeCustomersRow(data);
}

class StripeCustomersRow extends SupabaseDataRow {
  StripeCustomersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => StripeCustomersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get stripeCustomerId => getField<String>('stripe_customer_id')!;
  set stripeCustomerId(String value) =>
      setField<String>('stripe_customer_id', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);

  String? get defaultPaymentMethodId =>
      getField<String>('default_payment_method_id');
  set defaultPaymentMethodId(String? value) =>
      setField<String>('default_payment_method_id', value);

  dynamic get metadata => getField<dynamic>('metadata');
  set metadata(dynamic value) => setField<dynamic>('metadata', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}

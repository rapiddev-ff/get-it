import '../database.dart';

class CounterOffersTable extends SupabaseTable<CounterOffersRow> {
  @override
  String get tableName => 'counter_offers';

  @override
  CounterOffersRow createRow(Map<String, dynamic> data) =>
      CounterOffersRow(data);
}

class CounterOffersRow extends SupabaseDataRow {
  CounterOffersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => CounterOffersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get conversationId => getField<String>('conversation_id')!;
  set conversationId(String value) =>
      setField<String>('conversation_id', value);

  String get productId => getField<String>('product_id')!;
  set productId(String value) => setField<String>('product_id', value);

  String get fromUserId => getField<String>('from_user_id')!;
  set fromUserId(String value) => setField<String>('from_user_id', value);

  String get toUserId => getField<String>('to_user_id')!;
  set toUserId(String value) => setField<String>('to_user_id', value);

  double get offeredPrice => getField<double>('offered_price')!;
  set offeredPrice(double value) => setField<double>('offered_price', value);

  double get originalPrice => getField<double>('original_price')!;
  set originalPrice(double value) => setField<double>('original_price', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get expiresAt => getField<DateTime>('expires_at');
  set expiresAt(DateTime? value) => setField<DateTime>('expires_at', value);

  DateTime? get respondedAt => getField<DateTime>('responded_at');
  set respondedAt(DateTime? value) => setField<DateTime>('responded_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

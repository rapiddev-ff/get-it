import '../database.dart';

class PromotionsTable extends SupabaseTable<PromotionsRow> {
  @override
  String get tableName => 'promotions';

  @override
  PromotionsRow createRow(Map<String, dynamic> data) => PromotionsRow(data);
}

class PromotionsRow extends SupabaseDataRow {
  PromotionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PromotionsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get productId => getField<String>('product_id')!;
  set productId(String value) => setField<String>('product_id', value);

  String get sellerId => getField<String>('seller_id')!;
  set sellerId(String value) => setField<String>('seller_id', value);

  String get type => getField<String>('type')!;
  set type(String value) => setField<String>('type', value);

  String get duration => getField<String>('duration')!;
  set duration(String value) => setField<String>('duration', value);

  double get cost => getField<double>('cost')!;
  set cost(double value) => setField<double>('cost', value);

  String? get stripePaymentIntentId =>
      getField<String>('stripe_payment_intent_id');
  set stripePaymentIntentId(String? value) =>
      setField<String>('stripe_payment_intent_id', value);

  dynamic get targetTags => getField<dynamic>('target_tags');
  set targetTags(dynamic value) => setField<dynamic>('target_tags', value);

  bool? get targetPreviousBuyers => getField<bool>('target_previous_buyers');
  set targetPreviousBuyers(bool? value) =>
      setField<bool>('target_previous_buyers', value);

  int? get impressions => getField<int>('impressions');
  set impressions(int? value) => setField<int>('impressions', value);

  int? get clicks => getField<int>('clicks');
  set clicks(int? value) => setField<int>('clicks', value);

  DateTime get startsAt => getField<DateTime>('starts_at')!;
  set startsAt(DateTime value) => setField<DateTime>('starts_at', value);

  DateTime get endsAt => getField<DateTime>('ends_at')!;
  set endsAt(DateTime value) => setField<DateTime>('ends_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);
}

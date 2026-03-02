import '../database.dart';

class ReviewsTable extends SupabaseTable<ReviewsRow> {
  @override
  String get tableName => 'reviews';

  @override
  ReviewsRow createRow(Map<String, dynamic> data) => ReviewsRow(data);
}

class ReviewsRow extends SupabaseDataRow {
  ReviewsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ReviewsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get reviewerId => getField<String>('reviewer_id')!;
  set reviewerId(String value) => setField<String>('reviewer_id', value);

  String get reviewedId => getField<String>('reviewed_id')!;
  set reviewedId(String value) => setField<String>('reviewed_id', value);

  String? get orderId => getField<String>('order_id');
  set orderId(String? value) => setField<String>('order_id', value);

  String? get productId => getField<String>('product_id');
  set productId(String? value) => setField<String>('product_id', value);

  String get role => getField<String>('role')!;
  set role(String value) => setField<String>('role', value);

  int get rating => getField<int>('rating')!;
  set rating(int value) => setField<int>('rating', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get content => getField<String>('content');
  set content(String? value) => setField<String>('content', value);

  bool? get wouldRecommend => getField<bool>('would_recommend');
  set wouldRecommend(bool? value) => setField<bool>('would_recommend', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);
}

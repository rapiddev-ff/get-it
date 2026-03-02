import '../database.dart';

class ReviewImagesTable extends SupabaseTable<ReviewImagesRow> {
  @override
  String get tableName => 'review_images';

  @override
  ReviewImagesRow createRow(Map<String, dynamic> data) => ReviewImagesRow(data);
}

class ReviewImagesRow extends SupabaseDataRow {
  ReviewImagesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ReviewImagesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get reviewId => getField<String>('review_id')!;
  set reviewId(String value) => setField<String>('review_id', value);

  String get imageUrl => getField<String>('image_url')!;
  set imageUrl(String value) => setField<String>('image_url', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

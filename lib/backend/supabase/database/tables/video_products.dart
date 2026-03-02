import '../database.dart';

class VideoProductsTable extends SupabaseTable<VideoProductsRow> {
  @override
  String get tableName => 'video_products';

  @override
  VideoProductsRow createRow(Map<String, dynamic> data) =>
      VideoProductsRow(data);
}

class VideoProductsRow extends SupabaseDataRow {
  VideoProductsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VideoProductsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get videoId => getField<String>('video_id')!;
  set videoId(String value) => setField<String>('video_id', value);

  String get productId => getField<String>('product_id')!;
  set productId(String value) => setField<String>('product_id', value);

  int? get timestampSeconds => getField<int>('timestamp_seconds');
  set timestampSeconds(int? value) => setField<int>('timestamp_seconds', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

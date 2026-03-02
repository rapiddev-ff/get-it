import '../database.dart';

class ProductViewsTable extends SupabaseTable<ProductViewsRow> {
  @override
  String get tableName => 'product_views';

  @override
  ProductViewsRow createRow(Map<String, dynamic> data) => ProductViewsRow(data);
}

class ProductViewsRow extends SupabaseDataRow {
  ProductViewsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProductViewsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get productId => getField<String>('product_id')!;
  set productId(String value) => setField<String>('product_id', value);

  String? get viewerId => getField<String>('viewer_id');
  set viewerId(String? value) => setField<String>('viewer_id', value);

  DateTime get viewedAt => getField<DateTime>('viewed_at')!;
  set viewedAt(DateTime value) => setField<DateTime>('viewed_at', value);

  String? get source => getField<String>('source');
  set source(String? value) => setField<String>('source', value);
}

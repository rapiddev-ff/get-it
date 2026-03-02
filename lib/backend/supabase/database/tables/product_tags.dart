import '../database.dart';

class ProductTagsTable extends SupabaseTable<ProductTagsRow> {
  @override
  String get tableName => 'product_tags';

  @override
  ProductTagsRow createRow(Map<String, dynamic> data) => ProductTagsRow(data);
}

class ProductTagsRow extends SupabaseDataRow {
  ProductTagsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProductTagsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get productId => getField<String>('product_id')!;
  set productId(String value) => setField<String>('product_id', value);

  String get tagId => getField<String>('tag_id')!;
  set tagId(String value) => setField<String>('tag_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

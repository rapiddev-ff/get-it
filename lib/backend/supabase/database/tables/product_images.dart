import '../database.dart';

class ProductImagesTable extends SupabaseTable<ProductImagesRow> {
  @override
  String get tableName => 'product_images';

  @override
  ProductImagesRow createRow(Map<String, dynamic> data) =>
      ProductImagesRow(data);
}

class ProductImagesRow extends SupabaseDataRow {
  ProductImagesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProductImagesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get productId => getField<String>('product_id')!;
  set productId(String value) => setField<String>('product_id', value);

  String get imageUrl => getField<String>('image_url')!;
  set imageUrl(String value) => setField<String>('image_url', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  bool? get isMain => getField<bool>('is_main');
  set isMain(bool? value) => setField<bool>('is_main', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

import '../database.dart';

class SubcategoriesTable extends SupabaseTable<SubcategoriesRow> {
  @override
  String get tableName => 'subcategories';

  @override
  SubcategoriesRow createRow(Map<String, dynamic> data) =>
      SubcategoriesRow(data);
}

class SubcategoriesRow extends SupabaseDataRow {
  SubcategoriesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SubcategoriesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get categoryId => getField<String>('category_id')!;
  set categoryId(String value) => setField<String>('category_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get slug => getField<String>('slug')!;
  set slug(String value) => setField<String>('slug', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);
}

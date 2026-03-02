import '../database.dart';

class TagsTable extends SupabaseTable<TagsRow> {
  @override
  String get tableName => 'tags';

  @override
  TagsRow createRow(Map<String, dynamic> data) => TagsRow(data);
}

class TagsRow extends SupabaseDataRow {
  TagsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TagsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get slug => getField<String>('slug')!;
  set slug(String value) => setField<String>('slug', value);

  int? get usageCount => getField<int>('usage_count');
  set usageCount(int? value) => setField<int>('usage_count', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

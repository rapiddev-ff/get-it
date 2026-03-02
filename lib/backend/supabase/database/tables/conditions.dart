import '../database.dart';

class ConditionsTable extends SupabaseTable<ConditionsRow> {
  @override
  String get tableName => 'conditions';

  @override
  ConditionsRow createRow(Map<String, dynamic> data) => ConditionsRow(data);
}

class ConditionsRow extends SupabaseDataRow {
  ConditionsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ConditionsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String get code => getField<String>('code')!;
  set code(String value) => setField<String>('code', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

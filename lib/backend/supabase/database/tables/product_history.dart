import '../database.dart';

class ProductHistoryTable extends SupabaseTable<ProductHistoryRow> {
  @override
  String get tableName => 'product_history';

  @override
  ProductHistoryRow createRow(Map<String, dynamic> data) =>
      ProductHistoryRow(data);
}

class ProductHistoryRow extends SupabaseDataRow {
  ProductHistoryRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProductHistoryTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get productId => getField<String>('product_id')!;
  set productId(String value) => setField<String>('product_id', value);

  dynamic get changedFields => getField<dynamic>('changed_fields')!;
  set changedFields(dynamic value) =>
      setField<dynamic>('changed_fields', value);

  dynamic get oldValues => getField<dynamic>('old_values')!;
  set oldValues(dynamic value) => setField<dynamic>('old_values', value);

  dynamic get newValues => getField<dynamic>('new_values')!;
  set newValues(dynamic value) => setField<dynamic>('new_values', value);

  String? get changedBy => getField<String>('changed_by');
  set changedBy(String? value) => setField<String>('changed_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

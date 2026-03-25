import '../database.dart';

class ShortlistItemsTable extends SupabaseTable<ShortlistItemsRow> {
  @override
  String get tableName => 'shortlist_items';

  @override
  ShortlistItemsRow createRow(Map<String, dynamic> data) =>
      ShortlistItemsRow(data);
}

class ShortlistItemsRow extends SupabaseDataRow {
  ShortlistItemsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ShortlistItemsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get shortlistId => getField<String>('shortlist_id')!;
  set shortlistId(String value) => setField<String>('shortlist_id', value);

  String get productId => getField<String>('product_id')!;
  set productId(String value) => setField<String>('product_id', value);

  int? get customQuantity => getField<int>('custom_quantity');
  set customQuantity(int? value) => setField<int>('custom_quantity', value);

  int get quantity => getField<int>('quantity') ?? 1;
  set quantity(int value) => setField<int>('quantity', value);

  String get status => getField<String>('status') ?? 'active';
  set status(String value) => setField<String>('status', value);

  String? get notes => getField<String>('notes');
  set notes(String? value) => setField<String>('notes', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  DateTime? get reservedAt => getField<DateTime>('reserved_at');
  set reservedAt(DateTime? value) => setField<DateTime>('reserved_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

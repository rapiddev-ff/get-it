import '../database.dart';

class WishlistsTable extends SupabaseTable<WishlistsRow> {
  @override
  String get tableName => 'wishlists';

  @override
  WishlistsRow createRow(Map<String, dynamic> data) => WishlistsRow(data);
}

class WishlistsRow extends SupabaseDataRow {
  WishlistsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => WishlistsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get productId => getField<String>('product_id')!;
  set productId(String value) => setField<String>('product_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

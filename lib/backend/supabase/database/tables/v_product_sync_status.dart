import '../database.dart';

class VProductSyncStatusTable extends SupabaseTable<VProductSyncStatusRow> {
  @override
  String get tableName => 'v_product_sync_status';

  @override
  VProductSyncStatusRow createRow(Map<String, dynamic> data) =>
      VProductSyncStatusRow(data);
}

class VProductSyncStatusRow extends SupabaseDataRow {
  VProductSyncStatusRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VProductSyncStatusTable();

  String? get productId => getField<String>('product_id');
  set productId(String? value) => setField<String>('product_id', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  double? get price => getField<double>('price');
  set price(double? value) => setField<double>('price', value);

  int? get quantity => getField<int>('quantity');
  set quantity(int? value) => setField<int>('quantity', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get sellerId => getField<String>('seller_id');
  set sellerId(String? value) => setField<String>('seller_id', value);

  String? get shopDomain => getField<String>('shop_domain');
  set shopDomain(String? value) => setField<String>('shop_domain', value);

  String? get shopifyProductId => getField<String>('shopify_product_id');
  set shopifyProductId(String? value) =>
      setField<String>('shopify_product_id', value);

  String? get originalDirection => getField<String>('original_direction');
  set originalDirection(String? value) =>
      setField<String>('original_direction', value);

  DateTime? get lastSyncedAt => getField<DateTime>('last_synced_at');
  set lastSyncedAt(DateTime? value) =>
      setField<DateTime>('last_synced_at', value);

  bool? get hasConflict => getField<bool>('has_conflict');
  set hasConflict(bool? value) => setField<bool>('has_conflict', value);

  String? get syncStatus => getField<String>('sync_status');
  set syncStatus(String? value) => setField<String>('sync_status', value);
}

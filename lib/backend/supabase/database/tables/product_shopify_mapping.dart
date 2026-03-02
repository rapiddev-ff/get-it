import '../database.dart';

class ProductShopifyMappingTable
    extends SupabaseTable<ProductShopifyMappingRow> {
  @override
  String get tableName => 'product_shopify_mapping';

  @override
  ProductShopifyMappingRow createRow(Map<String, dynamic> data) =>
      ProductShopifyMappingRow(data);
}

class ProductShopifyMappingRow extends SupabaseDataRow {
  ProductShopifyMappingRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProductShopifyMappingTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get productId => getField<String>('product_id')!;
  set productId(String value) => setField<String>('product_id', value);

  String get shopifyProductId => getField<String>('shopify_product_id')!;
  set shopifyProductId(String value) =>
      setField<String>('shopify_product_id', value);

  String? get shopifyVariantId => getField<String>('shopify_variant_id');
  set shopifyVariantId(String? value) =>
      setField<String>('shopify_variant_id', value);

  String? get shopifyInventoryItemId =>
      getField<String>('shopify_inventory_item_id');
  set shopifyInventoryItemId(String? value) =>
      setField<String>('shopify_inventory_item_id', value);

  String get integrationId => getField<String>('integration_id')!;
  set integrationId(String value) => setField<String>('integration_id', value);

  String get syncDirection => getField<String>('sync_direction')!;
  set syncDirection(String value) => setField<String>('sync_direction', value);

  DateTime? get lastSyncedAt => getField<DateTime>('last_synced_at');
  set lastSyncedAt(DateTime? value) =>
      setField<DateTime>('last_synced_at', value);

  DateTime? get lastShopifyUpdatedAt =>
      getField<DateTime>('last_shopify_updated_at');
  set lastShopifyUpdatedAt(DateTime? value) =>
      setField<DateTime>('last_shopify_updated_at', value);

  DateTime? get lastCardsmartUpdatedAt =>
      getField<DateTime>('last_cardsmart_updated_at');
  set lastCardsmartUpdatedAt(DateTime? value) =>
      setField<DateTime>('last_cardsmart_updated_at', value);

  String? get shopifyDataHash => getField<String>('shopify_data_hash');
  set shopifyDataHash(String? value) =>
      setField<String>('shopify_data_hash', value);

  String? get cardsmartDataHash => getField<String>('cardsmart_data_hash');
  set cardsmartDataHash(String? value) =>
      setField<String>('cardsmart_data_hash', value);

  bool? get hasConflict => getField<bool>('has_conflict');
  set hasConflict(bool? value) => setField<bool>('has_conflict', value);

  DateTime? get conflictResolvedAt =>
      getField<DateTime>('conflict_resolved_at');
  set conflictResolvedAt(DateTime? value) =>
      setField<DateTime>('conflict_resolved_at', value);

  String? get conflictResolution => getField<String>('conflict_resolution');
  set conflictResolution(String? value) =>
      setField<String>('conflict_resolution', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}

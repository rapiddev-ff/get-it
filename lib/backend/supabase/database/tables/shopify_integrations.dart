import '../database.dart';

class ShopifyIntegrationsTable extends SupabaseTable<ShopifyIntegrationsRow> {
  @override
  String get tableName => 'shopify_integrations';

  @override
  ShopifyIntegrationsRow createRow(Map<String, dynamic> data) =>
      ShopifyIntegrationsRow(data);
}

class ShopifyIntegrationsRow extends SupabaseDataRow {
  ShopifyIntegrationsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ShopifyIntegrationsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get shopDomain => getField<String>('shop_domain')!;
  set shopDomain(String value) => setField<String>('shop_domain', value);

  String? get shopName => getField<String>('shop_name');
  set shopName(String? value) => setField<String>('shop_name', value);

  String? get shopEmail => getField<String>('shop_email');
  set shopEmail(String? value) => setField<String>('shop_email', value);

  String get accessToken => getField<String>('access_token')!;
  set accessToken(String value) => setField<String>('access_token', value);

  String? get scope => getField<String>('scope');
  set scope(String? value) => setField<String>('scope', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  bool? get autoSyncEnabled => getField<bool>('auto_sync_enabled');
  set autoSyncEnabled(bool? value) =>
      setField<bool>('auto_sync_enabled', value);

  int? get autoSyncIntervalMinutes =>
      getField<int>('auto_sync_interval_minutes');
  set autoSyncIntervalMinutes(int? value) =>
      setField<int>('auto_sync_interval_minutes', value);

  bool? get autoSyncSales => getField<bool>('auto_sync_sales');
  set autoSyncSales(bool? value) => setField<bool>('auto_sync_sales', value);

  bool? get autoSyncInventory => getField<bool>('auto_sync_inventory');
  set autoSyncInventory(bool? value) =>
      setField<bool>('auto_sync_inventory', value);

  String? get syncDirectionPreference =>
      getField<String>('sync_direction_preference');
  set syncDirectionPreference(String? value) =>
      setField<String>('sync_direction_preference', value);

  String? get defaultCategoryId => getField<String>('default_category_id');
  set defaultCategoryId(String? value) =>
      setField<String>('default_category_id', value);

  int? get totalProductsImported => getField<int>('total_products_imported');
  set totalProductsImported(int? value) =>
      setField<int>('total_products_imported', value);

  int? get totalProductsExported => getField<int>('total_products_exported');
  set totalProductsExported(int? value) =>
      setField<int>('total_products_exported', value);

  DateTime? get lastImportAt => getField<DateTime>('last_import_at');
  set lastImportAt(DateTime? value) =>
      setField<DateTime>('last_import_at', value);

  DateTime? get lastExportAt => getField<DateTime>('last_export_at');
  set lastExportAt(DateTime? value) =>
      setField<DateTime>('last_export_at', value);

  DateTime? get lastAutoSyncAt => getField<DateTime>('last_auto_sync_at');
  set lastAutoSyncAt(DateTime? value) =>
      setField<DateTime>('last_auto_sync_at', value);

  String? get lastError => getField<String>('last_error');
  set lastError(String? value) => setField<String>('last_error', value);

  DateTime? get lastErrorAt => getField<DateTime>('last_error_at');
  set lastErrorAt(DateTime? value) =>
      setField<DateTime>('last_error_at', value);

  int? get consecutiveErrors => getField<int>('consecutive_errors');
  set consecutiveErrors(int? value) =>
      setField<int>('consecutive_errors', value);

  bool? get webhooksRegistered => getField<bool>('webhooks_registered');
  set webhooksRegistered(bool? value) =>
      setField<bool>('webhooks_registered', value);

  String? get webhookSecret => getField<String>('webhook_secret');
  set webhookSecret(String? value) => setField<String>('webhook_secret', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);
}

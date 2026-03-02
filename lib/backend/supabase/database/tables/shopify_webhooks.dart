import '../database.dart';

class ShopifyWebhooksTable extends SupabaseTable<ShopifyWebhooksRow> {
  @override
  String get tableName => 'shopify_webhooks';

  @override
  ShopifyWebhooksRow createRow(Map<String, dynamic> data) =>
      ShopifyWebhooksRow(data);
}

class ShopifyWebhooksRow extends SupabaseDataRow {
  ShopifyWebhooksRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ShopifyWebhooksTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get integrationId => getField<String>('integration_id')!;
  set integrationId(String value) => setField<String>('integration_id', value);

  String get shopifyWebhookId => getField<String>('shopify_webhook_id')!;
  set shopifyWebhookId(String value) =>
      setField<String>('shopify_webhook_id', value);

  String get topic => getField<String>('topic')!;
  set topic(String value) => setField<String>('topic', value);

  String get address => getField<String>('address')!;
  set address(String value) => setField<String>('address', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

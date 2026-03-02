import '../database.dart';

class ShopifyWebhookEventsTable extends SupabaseTable<ShopifyWebhookEventsRow> {
  @override
  String get tableName => 'shopify_webhook_events';

  @override
  ShopifyWebhookEventsRow createRow(Map<String, dynamic> data) =>
      ShopifyWebhookEventsRow(data);
}

class ShopifyWebhookEventsRow extends SupabaseDataRow {
  ShopifyWebhookEventsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ShopifyWebhookEventsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get integrationId => getField<String>('integration_id');
  set integrationId(String? value) => setField<String>('integration_id', value);

  String get topic => getField<String>('topic')!;
  set topic(String value) => setField<String>('topic', value);

  String? get shopifyWebhookId => getField<String>('shopify_webhook_id');
  set shopifyWebhookId(String? value) =>
      setField<String>('shopify_webhook_id', value);

  dynamic get payload => getField<dynamic>('payload')!;
  set payload(dynamic value) => setField<dynamic>('payload', value);

  dynamic get headers => getField<dynamic>('headers');
  set headers(dynamic value) => setField<dynamic>('headers', value);

  bool? get processed => getField<bool>('processed');
  set processed(bool? value) => setField<bool>('processed', value);

  DateTime? get processedAt => getField<DateTime>('processed_at');
  set processedAt(DateTime? value) => setField<DateTime>('processed_at', value);

  String? get processError => getField<String>('process_error');
  set processError(String? value) => setField<String>('process_error', value);

  int? get retryCount => getField<int>('retry_count');
  set retryCount(int? value) => setField<int>('retry_count', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

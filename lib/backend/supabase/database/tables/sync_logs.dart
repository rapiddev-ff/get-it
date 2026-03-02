import '../database.dart';

class SyncLogsTable extends SupabaseTable<SyncLogsRow> {
  @override
  String get tableName => 'sync_logs';

  @override
  SyncLogsRow createRow(Map<String, dynamic> data) => SyncLogsRow(data);
}

class SyncLogsRow extends SupabaseDataRow {
  SyncLogsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SyncLogsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get syncJobId => getField<String>('sync_job_id');
  set syncJobId(String? value) => setField<String>('sync_job_id', value);

  String get integrationId => getField<String>('integration_id')!;
  set integrationId(String value) => setField<String>('integration_id', value);

  String? get productId => getField<String>('product_id');
  set productId(String? value) => setField<String>('product_id', value);

  String get direction => getField<String>('direction')!;
  set direction(String value) => setField<String>('direction', value);

  String get action => getField<String>('action')!;
  set action(String value) => setField<String>('action', value);

  String? get shopifyProductId => getField<String>('shopify_product_id');
  set shopifyProductId(String? value) =>
      setField<String>('shopify_product_id', value);

  dynamic get changes => getField<dynamic>('changes');
  set changes(dynamic value) => setField<dynamic>('changes', value);

  String? get errorMessage => getField<String>('error_message');
  set errorMessage(String? value) => setField<String>('error_message', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}

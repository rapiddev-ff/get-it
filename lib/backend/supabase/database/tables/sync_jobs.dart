import '../database.dart';

class SyncJobsTable extends SupabaseTable<SyncJobsRow> {
  @override
  String get tableName => 'sync_jobs';

  @override
  SyncJobsRow createRow(Map<String, dynamic> data) => SyncJobsRow(data);
}

class SyncJobsRow extends SupabaseDataRow {
  SyncJobsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SyncJobsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get integrationId => getField<String>('integration_id')!;
  set integrationId(String value) => setField<String>('integration_id', value);

  String get direction => getField<String>('direction')!;
  set direction(String value) => setField<String>('direction', value);

  String get syncType => getField<String>('sync_type')!;
  set syncType(String value) => setField<String>('sync_type', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  dynamic get scope => getField<dynamic>('scope');
  set scope(dynamic value) => setField<dynamic>('scope', value);

  int? get totalItems => getField<int>('total_items');
  set totalItems(int? value) => setField<int>('total_items', value);

  int? get processedItems => getField<int>('processed_items');
  set processedItems(int? value) => setField<int>('processed_items', value);

  int? get successfulItems => getField<int>('successful_items');
  set successfulItems(int? value) => setField<int>('successful_items', value);

  int? get failedItems => getField<int>('failed_items');
  set failedItems(int? value) => setField<int>('failed_items', value);

  int? get skippedItems => getField<int>('skipped_items');
  set skippedItems(int? value) => setField<int>('skipped_items', value);

  dynamic get resultSummary => getField<dynamic>('result_summary');
  set resultSummary(dynamic value) =>
      setField<dynamic>('result_summary', value);

  String? get errorMessage => getField<String>('error_message');
  set errorMessage(String? value) => setField<String>('error_message', value);

  dynamic get errorDetails => getField<dynamic>('error_details');
  set errorDetails(dynamic value) => setField<dynamic>('error_details', value);

  DateTime? get startedAt => getField<DateTime>('started_at');
  set startedAt(DateTime? value) => setField<DateTime>('started_at', value);

  DateTime? get completedAt => getField<DateTime>('completed_at');
  set completedAt(DateTime? value) => setField<DateTime>('completed_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}

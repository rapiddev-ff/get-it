import '../database.dart';

class VSyncHistoryTable extends SupabaseTable<VSyncHistoryRow> {
  @override
  String get tableName => 'v_sync_history';

  @override
  VSyncHistoryRow createRow(Map<String, dynamic> data) => VSyncHistoryRow(data);
}

class VSyncHistoryRow extends SupabaseDataRow {
  VSyncHistoryRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VSyncHistoryTable();

  String? get jobId => getField<String>('job_id');
  set jobId(String? value) => setField<String>('job_id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get direction => getField<String>('direction');
  set direction(String? value) => setField<String>('direction', value);

  String? get syncType => getField<String>('sync_type');
  set syncType(String? value) => setField<String>('sync_type', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  int? get totalItems => getField<int>('total_items');
  set totalItems(int? value) => setField<int>('total_items', value);

  int? get successfulItems => getField<int>('successful_items');
  set successfulItems(int? value) => setField<int>('successful_items', value);

  int? get failedItems => getField<int>('failed_items');
  set failedItems(int? value) => setField<int>('failed_items', value);

  DateTime? get startedAt => getField<DateTime>('started_at');
  set startedAt(DateTime? value) => setField<DateTime>('started_at', value);

  DateTime? get completedAt => getField<DateTime>('completed_at');
  set completedAt(DateTime? value) => setField<DateTime>('completed_at', value);

  String? get errorMessage => getField<String>('error_message');
  set errorMessage(String? value) => setField<String>('error_message', value);

  String? get shopDomain => getField<String>('shop_domain');
  set shopDomain(String? value) => setField<String>('shop_domain', value);

  double? get durationSeconds => getField<double>('duration_seconds');
  set durationSeconds(double? value) =>
      setField<double>('duration_seconds', value);
}

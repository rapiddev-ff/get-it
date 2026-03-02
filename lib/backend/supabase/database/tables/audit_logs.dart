import '../database.dart';

class AuditLogsTable extends SupabaseTable<AuditLogsRow> {
  @override
  String get tableName => 'audit_logs';

  @override
  AuditLogsRow createRow(Map<String, dynamic> data) => AuditLogsRow(data);
}

class AuditLogsRow extends SupabaseDataRow {
  AuditLogsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AuditLogsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get tableNameField => getField<String>('table_name')!;
  set tableNameField(String value) => setField<String>('table_name', value);

  String? get recordId => getField<String>('record_id');
  set recordId(String? value) => setField<String>('record_id', value);

  String get action => getField<String>('action')!;
  set action(String value) => setField<String>('action', value);

  dynamic get oldData => getField<dynamic>('old_data');
  set oldData(dynamic value) => setField<dynamic>('old_data', value);

  dynamic get newData => getField<dynamic>('new_data');
  set newData(dynamic value) => setField<dynamic>('new_data', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get ipAddress => getField<String>('ip_address');
  set ipAddress(String? value) => setField<String>('ip_address', value);

  String? get userAgent => getField<String>('user_agent');
  set userAgent(String? value) => setField<String>('user_agent', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}

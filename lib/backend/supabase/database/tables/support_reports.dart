import '../database.dart';

class SupportReportsTable extends SupabaseTable<SupportReportsRow> {
  @override
  String get tableName => 'support_reports';

  @override
  SupportReportsRow createRow(Map<String, dynamic> data) =>
      SupportReportsRow(data);
}

class SupportReportsRow extends SupabaseDataRow {
  SupportReportsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => SupportReportsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get message => getField<String>('message')!;
  set message(String value) => setField<String>('message', value);

  DateTime get createdAt => getField<DateTime>('created_at')!;
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);
}

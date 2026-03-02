import '../database.dart';

class TaxDocumentDownloadsTable extends SupabaseTable<TaxDocumentDownloadsRow> {
  @override
  String get tableName => 'tax_document_downloads';

  @override
  TaxDocumentDownloadsRow createRow(Map<String, dynamic> data) =>
      TaxDocumentDownloadsRow(data);
}

class TaxDocumentDownloadsRow extends SupabaseDataRow {
  TaxDocumentDownloadsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TaxDocumentDownloadsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get documentId => getField<String>('document_id')!;
  set documentId(String value) => setField<String>('document_id', value);

  DateTime? get downloadedAt => getField<DateTime>('downloaded_at');
  set downloadedAt(DateTime? value) =>
      setField<DateTime>('downloaded_at', value);

  String? get ipAddress => getField<String>('ip_address');
  set ipAddress(String? value) => setField<String>('ip_address', value);

  String? get userAgent => getField<String>('user_agent');
  set userAgent(String? value) => setField<String>('user_agent', value);
}

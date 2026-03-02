import '../database.dart';

class TaxDocumentsTable extends SupabaseTable<TaxDocumentsRow> {
  @override
  String get tableName => 'tax_documents';

  @override
  TaxDocumentsRow createRow(Map<String, dynamic> data) => TaxDocumentsRow(data);
}

class TaxDocumentsRow extends SupabaseDataRow {
  TaxDocumentsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TaxDocumentsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get stripeDocumentId => getField<String>('stripe_document_id')!;
  set stripeDocumentId(String value) =>
      setField<String>('stripe_document_id', value);

  String get documentType => getField<String>('document_type')!;
  set documentType(String value) => setField<String>('document_type', value);

  int get year => getField<int>('year')!;
  set year(int value) => setField<int>('year', value);

  String? get documentUrl => getField<String>('document_url');
  set documentUrl(String? value) => setField<String>('document_url', value);

  String? get storageUrl => getField<String>('storage_url');
  set storageUrl(String? value) => setField<String>('storage_url', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get downloadedAt => getField<DateTime>('downloaded_at');
  set downloadedAt(DateTime? value) =>
      setField<DateTime>('downloaded_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}

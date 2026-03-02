import '../database.dart';

class ShortlistsTable extends SupabaseTable<ShortlistsRow> {
  @override
  String get tableName => 'shortlists';

  @override
  ShortlistsRow createRow(Map<String, dynamic> data) => ShortlistsRow(data);
}

class ShortlistsRow extends SupabaseDataRow {
  ShortlistsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ShortlistsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get sellerId => getField<String>('seller_id')!;
  set sellerId(String value) => setField<String>('seller_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get eventName => getField<String>('event_name');
  set eventName(String? value) => setField<String>('event_name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get qrCodeUrl => getField<String>('qr_code_url');
  set qrCodeUrl(String? value) => setField<String>('qr_code_url', value);

  String? get shareCode => getField<String>('share_code');
  set shareCode(String? value) => setField<String>('share_code', value);

  DateTime? get startDate => getField<DateTime>('start_date');
  set startDate(DateTime? value) => setField<DateTime>('start_date', value);

  DateTime? get endDate => getField<DateTime>('end_date');
  set endDate(DateTime? value) => setField<DateTime>('end_date', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  bool? get isPublic => getField<bool>('is_public');
  set isPublic(bool? value) => setField<bool>('is_public', value);

  double? get discountPercentage => getField<double>('discount_percentage');
  set discountPercentage(double? value) =>
      setField<double>('discount_percentage', value);

  int? get totalItems => getField<int>('total_items');
  set totalItems(int? value) => setField<int>('total_items', value);

  double? get totalSales => getField<double>('total_sales');
  set totalSales(double? value) => setField<double>('total_sales', value);

  int? get itemsSold => getField<int>('items_sold');
  set itemsSold(int? value) => setField<int>('items_sold', value);

  int? get scanCount => getField<int>('scan_count');
  set scanCount(int? value) => setField<int>('scan_count', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);
}

import '../database.dart';

class ShippingAddressesTable extends SupabaseTable<ShippingAddressesRow> {
  @override
  String get tableName => 'shipping_addresses';

  @override
  ShippingAddressesRow createRow(Map<String, dynamic> data) =>
      ShippingAddressesRow(data);
}

class ShippingAddressesRow extends SupabaseDataRow {
  ShippingAddressesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ShippingAddressesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get fullName => getField<String>('full_name')!;
  set fullName(String value) => setField<String>('full_name', value);

  String get addressLine1 => getField<String>('address_line1')!;
  set addressLine1(String value) => setField<String>('address_line1', value);

  String? get addressLine2 => getField<String>('address_line2');
  set addressLine2(String? value) => setField<String>('address_line2', value);

  String get city => getField<String>('city')!;
  set city(String value) => setField<String>('city', value);

  String get state => getField<String>('state')!;
  set state(String value) => setField<String>('state', value);

  String get zipCode => getField<String>('zip_code')!;
  set zipCode(String value) => setField<String>('zip_code', value);

  String? get country => getField<String>('country');
  set country(String? value) => setField<String>('country', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);

  bool? get isDefault => getField<bool>('is_default');
  set isDefault(bool? value) => setField<bool>('is_default', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);
}

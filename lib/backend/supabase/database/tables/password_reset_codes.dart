import '../database.dart';

class PasswordResetCodesTable extends SupabaseTable<PasswordResetCodesRow> {
  @override
  String get tableName => 'password_reset_codes';

  @override
  PasswordResetCodesRow createRow(Map<String, dynamic> data) =>
      PasswordResetCodesRow(data);
}

class PasswordResetCodesRow extends SupabaseDataRow {
  PasswordResetCodesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PasswordResetCodesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get code => getField<String>('code')!;
  set code(String value) => setField<String>('code', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get email => getField<String>('email')!;
  set email(String value) => setField<String>('email', value);

  DateTime get expiresAt => getField<DateTime>('expires_at')!;
  set expiresAt(DateTime value) => setField<DateTime>('expires_at', value);

  bool? get used => getField<bool>('used');
  set used(bool? value) => setField<bool>('used', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

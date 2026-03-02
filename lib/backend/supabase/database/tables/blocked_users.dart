import '../database.dart';

class BlockedUsersTable extends SupabaseTable<BlockedUsersRow> {
  @override
  String get tableName => 'blocked_users';

  @override
  BlockedUsersRow createRow(Map<String, dynamic> data) => BlockedUsersRow(data);
}

class BlockedUsersRow extends SupabaseDataRow {
  BlockedUsersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BlockedUsersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get blockerId => getField<String>('blocker_id')!;
  set blockerId(String value) => setField<String>('blocker_id', value);

  String get blockedId => getField<String>('blocked_id')!;
  set blockedId(String value) => setField<String>('blocked_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

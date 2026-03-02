import '../database.dart';

class ConversationsTable extends SupabaseTable<ConversationsRow> {
  @override
  String get tableName => 'conversations';

  @override
  ConversationsRow createRow(Map<String, dynamic> data) =>
      ConversationsRow(data);
}

class ConversationsRow extends SupabaseDataRow {
  ConversationsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ConversationsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get buyerId => getField<String>('buyer_id')!;
  set buyerId(String value) => setField<String>('buyer_id', value);

  String get sellerId => getField<String>('seller_id')!;
  set sellerId(String value) => setField<String>('seller_id', value);

  String? get productId => getField<String>('product_id');
  set productId(String? value) => setField<String>('product_id', value);

  String? get lastMessageText => getField<String>('last_message_text');
  set lastMessageText(String? value) =>
      setField<String>('last_message_text', value);

  DateTime? get lastMessageAt => getField<DateTime>('last_message_at');
  set lastMessageAt(DateTime? value) =>
      setField<DateTime>('last_message_at', value);

  int? get buyerUnreadCount => getField<int>('buyer_unread_count');
  set buyerUnreadCount(int? value) =>
      setField<int>('buyer_unread_count', value);

  int? get sellerUnreadCount => getField<int>('seller_unread_count');
  set sellerUnreadCount(int? value) =>
      setField<int>('seller_unread_count', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);
}

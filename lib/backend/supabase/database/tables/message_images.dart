import '../database.dart';

class MessageImagesTable extends SupabaseTable<MessageImagesRow> {
  @override
  String get tableName => 'message_images';

  @override
  MessageImagesRow createRow(Map<String, dynamic> data) =>
      MessageImagesRow(data);
}

class MessageImagesRow extends SupabaseDataRow {
  MessageImagesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => MessageImagesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get messageId => getField<String>('message_id')!;
  set messageId(String value) => setField<String>('message_id', value);

  String get imageUrl => getField<String>('image_url')!;
  set imageUrl(String value) => setField<String>('image_url', value);

  String? get thumbnailUrl => getField<String>('thumbnail_url');
  set thumbnailUrl(String? value) => setField<String>('thumbnail_url', value);

  int? get width => getField<int>('width');
  set width(int? value) => setField<int>('width', value);

  int? get height => getField<int>('height');
  set height(int? value) => setField<int>('height', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

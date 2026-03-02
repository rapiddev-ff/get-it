import '../database.dart';

class VideoLikesTable extends SupabaseTable<VideoLikesRow> {
  @override
  String get tableName => 'video_likes';

  @override
  VideoLikesRow createRow(Map<String, dynamic> data) => VideoLikesRow(data);
}

class VideoLikesRow extends SupabaseDataRow {
  VideoLikesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VideoLikesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get videoId => getField<String>('video_id')!;
  set videoId(String value) => setField<String>('video_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}

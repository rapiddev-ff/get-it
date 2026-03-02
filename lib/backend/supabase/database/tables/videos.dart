import '../database.dart';

class VideosTable extends SupabaseTable<VideosRow> {
  @override
  String get tableName => 'videos';

  @override
  VideosRow createRow(Map<String, dynamic> data) => VideosRow(data);
}

class VideosRow extends SupabaseDataRow {
  VideosRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VideosTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String get videoUrl => getField<String>('video_url')!;
  set videoUrl(String value) => setField<String>('video_url', value);

  String? get thumbnailUrl => getField<String>('thumbnail_url');
  set thumbnailUrl(String? value) => setField<String>('thumbnail_url', value);

  int? get duration => getField<int>('duration');
  set duration(int? value) => setField<int>('duration', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  int? get viewsCount => getField<int>('views_count');
  set viewsCount(int? value) => setField<int>('views_count', value);

  int? get likesCount => getField<int>('likes_count');
  set likesCount(int? value) => setField<int>('likes_count', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  DateTime? get publishedAt => getField<DateTime>('published_at');
  set publishedAt(DateTime? value) => setField<DateTime>('published_at', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);
}

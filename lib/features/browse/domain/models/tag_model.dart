import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tag_model.freezed.dart';
part 'tag_model.g.dart';

@freezed
class Tag with _$Tag {
  const Tag._();
  const factory Tag({
    @Default('') String id,
    @Default('') String name,
    @Default('') String slug,
    @Default(0) int productCount,
  }) = _Tag;

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  String serialize() => jsonEncode(toJson());
  static Tag fromSerializableMap(Map<String, dynamic> data) =>
      Tag.fromJson(data);
}

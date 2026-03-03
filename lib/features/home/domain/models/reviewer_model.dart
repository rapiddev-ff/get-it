import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reviewer_model.freezed.dart';
part 'reviewer_model.g.dart';

@freezed
class Reviewer with _$Reviewer {
  const Reviewer._();
  const factory Reviewer({
    @Default('') String id,
    @Default('') String username,
    @Default('') String avatarUrl,
  }) = _Reviewer;

  factory Reviewer.fromJson(Map<String, dynamic> json) =>
      _$ReviewerFromJson(json);

  String serialize() => jsonEncode(toJson());
  static Reviewer fromSerializableMap(Map<String, dynamic> data) =>
      Reviewer.fromJson(data);
}

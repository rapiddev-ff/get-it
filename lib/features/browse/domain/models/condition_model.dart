import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'condition_model.freezed.dart';
part 'condition_model.g.dart';

@freezed
class Condition with _$Condition {
  const Condition._();
  const factory Condition({
    @Default('') String id,
    @Default('') String name,
    @Default('') String code,
    @Default('') String description,
    @Default(0) int sortOrder,
  }) = _Condition;

  factory Condition.fromJson(Map<String, dynamic> json) =>
      _$ConditionFromJson(json);

  String serialize() => jsonEncode(toJson());
  static Condition fromSerializableMap(Map<String, dynamic> data) =>
      Condition.fromJson(data);
}

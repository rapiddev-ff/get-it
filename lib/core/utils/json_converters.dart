import 'package:json_annotation/json_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime?, Object?> {
  const DateTimeConverter();

  @override
  DateTime? fromJson(Object? json) => json is DateTime
      ? json
      : json is String
          ? DateTime.tryParse(json)
          : null;

  @override
  Object? toJson(DateTime? dt) => dt?.toIso8601String();
}

import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_image_model.freezed.dart';
part 'message_image_model.g.dart';

@freezed
class MessageImage with _$MessageImage {
  const MessageImage._();
  const factory MessageImage({
    @Default('') String id,
    @Default('') String imageUrl,
    @Default('') String thumbnailUrl,
    @Default('') String width,
    @Default('') String height,
  }) = _MessageImage;

  factory MessageImage.fromJson(Map<String, dynamic> json) =>
      _$MessageImageFromJson(json);

  String serialize() => jsonEncode(toJson());
  static MessageImage fromSerializableMap(Map<String, dynamic> data) =>
      MessageImage.fromJson(data);
}

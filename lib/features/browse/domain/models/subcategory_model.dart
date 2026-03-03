import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'subcategory_model.freezed.dart';
part 'subcategory_model.g.dart';

@freezed
class Subcategory with _$Subcategory {
  const Subcategory._();
  const factory Subcategory({
    @Default('') String id,
    @Default('') String name,
    @Default('') String categoryId,
    @Default('') String imageUrl,
    @Default('') String description,
  }) = _Subcategory;

  factory Subcategory.fromJson(Map<String, dynamic> json) =>
      _$SubcategoryFromJson(json);

  String serialize() => jsonEncode(toJson());
  static Subcategory fromSerializableMap(Map<String, dynamic> data) =>
      Subcategory.fromJson(data);
}

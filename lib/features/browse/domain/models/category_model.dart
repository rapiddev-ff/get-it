import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'subcategory_model.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class Category with _$Category {
  const Category._();
  const factory Category({
    @Default('') String id,
    @Default('') String name,
    @Default('') String slug,
    @Default('') String imageUrl,
    @Default('') String description,
    @Default([]) List<Subcategory> subcategories,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  String serialize() => jsonEncode(toJson());
  static Category fromSerializableMap(Map<String, dynamic> data) =>
      Category.fromJson(data);
}

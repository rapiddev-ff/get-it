// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SubcategoryStruct extends BaseStruct {
  SubcategoryStruct({
    String? id,
    String? name,
    String? slug,
  })  : _id = id,
        _name = name,
        _slug = slug;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "slug" field.
  String? _slug;
  String get slug => _slug ?? '';
  set slug(String? val) => _slug = val;

  bool hasSlug() => _slug != null;

  static SubcategoryStruct fromMap(Map<String, dynamic> data) =>
      SubcategoryStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
      );

  static SubcategoryStruct? maybeFromMap(dynamic data) => data is Map
      ? SubcategoryStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'slug': _slug,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'slug': serializeParam(
          _slug,
          ParamType.String,
        ),
      }.withoutNulls;

  static SubcategoryStruct fromSerializableMap(Map<String, dynamic> data) =>
      SubcategoryStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        slug: deserializeParam(
          data['slug'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SubcategoryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SubcategoryStruct &&
        id == other.id &&
        name == other.name &&
        slug == other.slug;
  }

  @override
  int get hashCode => const ListEquality().hash([id, name, slug]);
}

SubcategoryStruct createSubcategoryStruct({
  String? id,
  String? name,
  String? slug,
}) =>
    SubcategoryStruct(
      id: id,
      name: name,
      slug: slug,
    );

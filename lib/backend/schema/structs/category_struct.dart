// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CategoryStruct extends BaseStruct {
  CategoryStruct({
    String? id,
    String? name,
    String? slug,
    List<SubcategoryStruct>? subcategories,
  })  : _id = id,
        _name = name,
        _slug = slug,
        _subcategories = subcategories;

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

  // "subcategories" field.
  List<SubcategoryStruct>? _subcategories;
  List<SubcategoryStruct> get subcategories => _subcategories ?? const [];
  set subcategories(List<SubcategoryStruct>? val) => _subcategories = val;

  void updateSubcategories(Function(List<SubcategoryStruct>) updateFn) {
    updateFn(_subcategories ??= []);
  }

  bool hasSubcategories() => _subcategories != null;

  static CategoryStruct fromMap(Map<String, dynamic> data) => CategoryStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        slug: data['slug'] as String?,
        subcategories: getStructList(
          data['subcategories'],
          SubcategoryStruct.fromMap,
        ),
      );

  static CategoryStruct? maybeFromMap(dynamic data) =>
      data is Map ? CategoryStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'slug': _slug,
        'subcategories': _subcategories?.map((e) => e.toMap()).toList(),
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
        'subcategories': serializeParam(
          _subcategories,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static CategoryStruct fromSerializableMap(Map<String, dynamic> data) =>
      CategoryStruct(
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
        subcategories: deserializeStructParam<SubcategoryStruct>(
          data['subcategories'],
          ParamType.DataStruct,
          true,
          structBuilder: SubcategoryStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'CategoryStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CategoryStruct &&
        id == other.id &&
        name == other.name &&
        slug == other.slug &&
        listEquality.equals(subcategories, other.subcategories);
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, name, slug, subcategories]);
}

CategoryStruct createCategoryStruct({
  String? id,
  String? name,
  String? slug,
}) =>
    CategoryStruct(
      id: id,
      name: name,
      slug: slug,
    );

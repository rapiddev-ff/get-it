// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProductImageStruct extends BaseStruct {
  ProductImageStruct({
    String? id,
    String? imageUrl,
    bool? isMain,
    int? sortOrder,
  })  : _id = id,
        _imageUrl = imageUrl,
        _isMain = isMain,
        _sortOrder = sortOrder;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "imageUrl" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;

  bool hasImageUrl() => _imageUrl != null;

  // "isMain" field.
  bool? _isMain;
  bool get isMain => _isMain ?? false;
  set isMain(bool? val) => _isMain = val;

  bool hasIsMain() => _isMain != null;

  // "sortOrder" field.
  int? _sortOrder;
  int get sortOrder => _sortOrder ?? 0;
  set sortOrder(int? val) => _sortOrder = val;

  void incrementSortOrder(int amount) => sortOrder = sortOrder + amount;

  bool hasSortOrder() => _sortOrder != null;

  static ProductImageStruct fromMap(Map<String, dynamic> data) =>
      ProductImageStruct(
        id: data['id'] as String?,
        imageUrl: data['imageUrl'] as String?,
        isMain: data['isMain'] as bool?,
        sortOrder: castToType<int>(data['sortOrder']),
      );

  static ProductImageStruct? maybeFromMap(dynamic data) => data is Map
      ? ProductImageStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'imageUrl': _imageUrl,
        'isMain': _isMain,
        'sortOrder': _sortOrder,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'imageUrl': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
        'isMain': serializeParam(
          _isMain,
          ParamType.bool,
        ),
        'sortOrder': serializeParam(
          _sortOrder,
          ParamType.int,
        ),
      }.withoutNulls;

  static ProductImageStruct fromSerializableMap(Map<String, dynamic> data) =>
      ProductImageStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        imageUrl: deserializeParam(
          data['imageUrl'],
          ParamType.String,
          false,
        ),
        isMain: deserializeParam(
          data['isMain'],
          ParamType.bool,
          false,
        ),
        sortOrder: deserializeParam(
          data['sortOrder'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'ProductImageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ProductImageStruct &&
        id == other.id &&
        imageUrl == other.imageUrl &&
        isMain == other.isMain &&
        sortOrder == other.sortOrder;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, imageUrl, isMain, sortOrder]);
}

ProductImageStruct createProductImageStruct({
  String? id,
  String? imageUrl,
  bool? isMain,
  int? sortOrder,
}) =>
    ProductImageStruct(
      id: id,
      imageUrl: imageUrl,
      isMain: isMain,
      sortOrder: sortOrder,
    );

// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ShortlistCoverImageStruct extends BaseStruct {
  ShortlistCoverImageStruct({
    String? productId,
    String? imageUrl,
    int? sortOrder,
  })  : _productId = productId,
        _imageUrl = imageUrl,
        _sortOrder = sortOrder;

  // "productId" field.
  String? _productId;
  String get productId => _productId ?? '';
  set productId(String? val) => _productId = val;

  bool hasProductId() => _productId != null;

  // "imageUrl" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;

  bool hasImageUrl() => _imageUrl != null;

  // "sortOrder" field.
  int? _sortOrder;
  int get sortOrder => _sortOrder ?? 0;
  set sortOrder(int? val) => _sortOrder = val;

  void incrementSortOrder(int amount) => sortOrder = sortOrder + amount;

  bool hasSortOrder() => _sortOrder != null;

  static ShortlistCoverImageStruct fromMap(Map<String, dynamic> data) =>
      ShortlistCoverImageStruct(
        productId: data['productId'] as String?,
        imageUrl: data['imageUrl'] as String?,
        sortOrder: castToType<int>(data['sortOrder']),
      );

  static ShortlistCoverImageStruct? maybeFromMap(dynamic data) => data is Map
      ? ShortlistCoverImageStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'productId': _productId,
        'imageUrl': _imageUrl,
        'sortOrder': _sortOrder,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'productId': serializeParam(
          _productId,
          ParamType.String,
        ),
        'imageUrl': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
        'sortOrder': serializeParam(
          _sortOrder,
          ParamType.int,
        ),
      }.withoutNulls;

  static ShortlistCoverImageStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      ShortlistCoverImageStruct(
        productId: deserializeParam(
          data['productId'],
          ParamType.String,
          false,
        ),
        imageUrl: deserializeParam(
          data['imageUrl'],
          ParamType.String,
          false,
        ),
        sortOrder: deserializeParam(
          data['sortOrder'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'ShortlistCoverImageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ShortlistCoverImageStruct &&
        productId == other.productId &&
        imageUrl == other.imageUrl &&
        sortOrder == other.sortOrder;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([productId, imageUrl, sortOrder]);
}

ShortlistCoverImageStruct createShortlistCoverImageStruct({
  String? productId,
  String? imageUrl,
  int? sortOrder,
}) =>
    ShortlistCoverImageStruct(
      productId: productId,
      imageUrl: imageUrl,
      sortOrder: sortOrder,
    );

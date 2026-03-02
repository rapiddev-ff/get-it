// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReviewImageStruct extends BaseStruct {
  ReviewImageStruct({
    String? id,
    String? imageUrl,
  })  : _id = id,
        _imageUrl = imageUrl;

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

  static ReviewImageStruct fromMap(Map<String, dynamic> data) =>
      ReviewImageStruct(
        id: data['id'] as String?,
        imageUrl: data['imageUrl'] as String?,
      );

  static ReviewImageStruct? maybeFromMap(dynamic data) => data is Map
      ? ReviewImageStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'imageUrl': _imageUrl,
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
      }.withoutNulls;

  static ReviewImageStruct fromSerializableMap(Map<String, dynamic> data) =>
      ReviewImageStruct(
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
      );

  @override
  String toString() => 'ReviewImageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ReviewImageStruct &&
        id == other.id &&
        imageUrl == other.imageUrl;
  }

  @override
  int get hashCode => const ListEquality().hash([id, imageUrl]);
}

ReviewImageStruct createReviewImageStruct({
  String? id,
  String? imageUrl,
}) =>
    ReviewImageStruct(
      id: id,
      imageUrl: imageUrl,
    );

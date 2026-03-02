// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MessageImageStruct extends BaseStruct {
  MessageImageStruct({
    String? id,
    String? imageUrl,
    String? thumbnailUrl,
    String? width,
    String? height,
  })  : _id = id,
        _imageUrl = imageUrl,
        _thumbnailUrl = thumbnailUrl,
        _width = width,
        _height = height;

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

  // "thumbnailUrl" field.
  String? _thumbnailUrl;
  String get thumbnailUrl => _thumbnailUrl ?? '';
  set thumbnailUrl(String? val) => _thumbnailUrl = val;

  bool hasThumbnailUrl() => _thumbnailUrl != null;

  // "width" field.
  String? _width;
  String get width => _width ?? '';
  set width(String? val) => _width = val;

  bool hasWidth() => _width != null;

  // "height" field.
  String? _height;
  String get height => _height ?? '';
  set height(String? val) => _height = val;

  bool hasHeight() => _height != null;

  static MessageImageStruct fromMap(Map<String, dynamic> data) =>
      MessageImageStruct(
        id: data['id'] as String?,
        imageUrl: data['imageUrl'] as String?,
        thumbnailUrl: data['thumbnailUrl'] as String?,
        width: data['width'] as String?,
        height: data['height'] as String?,
      );

  static MessageImageStruct? maybeFromMap(dynamic data) => data is Map
      ? MessageImageStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'imageUrl': _imageUrl,
        'thumbnailUrl': _thumbnailUrl,
        'width': _width,
        'height': _height,
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
        'thumbnailUrl': serializeParam(
          _thumbnailUrl,
          ParamType.String,
        ),
        'width': serializeParam(
          _width,
          ParamType.String,
        ),
        'height': serializeParam(
          _height,
          ParamType.String,
        ),
      }.withoutNulls;

  static MessageImageStruct fromSerializableMap(Map<String, dynamic> data) =>
      MessageImageStruct(
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
        thumbnailUrl: deserializeParam(
          data['thumbnailUrl'],
          ParamType.String,
          false,
        ),
        width: deserializeParam(
          data['width'],
          ParamType.String,
          false,
        ),
        height: deserializeParam(
          data['height'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'MessageImageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MessageImageStruct &&
        id == other.id &&
        imageUrl == other.imageUrl &&
        thumbnailUrl == other.thumbnailUrl &&
        width == other.width &&
        height == other.height;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, imageUrl, thumbnailUrl, width, height]);
}

MessageImageStruct createMessageImageStruct({
  String? id,
  String? imageUrl,
  String? thumbnailUrl,
  String? width,
  String? height,
}) =>
    MessageImageStruct(
      id: id,
      imageUrl: imageUrl,
      thumbnailUrl: thumbnailUrl,
      width: width,
      height: height,
    );

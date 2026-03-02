// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReviewerStruct extends BaseStruct {
  ReviewerStruct({
    String? id,
    String? username,
    String? avatarUrl,
  })  : _id = id,
        _username = username,
        _avatarUrl = avatarUrl;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "username" field.
  String? _username;
  String get username => _username ?? '';
  set username(String? val) => _username = val;

  bool hasUsername() => _username != null;

  // "avatarUrl" field.
  String? _avatarUrl;
  String get avatarUrl => _avatarUrl ?? '';
  set avatarUrl(String? val) => _avatarUrl = val;

  bool hasAvatarUrl() => _avatarUrl != null;

  static ReviewerStruct fromMap(Map<String, dynamic> data) => ReviewerStruct(
        id: data['id'] as String?,
        username: data['username'] as String?,
        avatarUrl: data['avatarUrl'] as String?,
      );

  static ReviewerStruct? maybeFromMap(dynamic data) =>
      data is Map ? ReviewerStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'username': _username,
        'avatarUrl': _avatarUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'username': serializeParam(
          _username,
          ParamType.String,
        ),
        'avatarUrl': serializeParam(
          _avatarUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static ReviewerStruct fromSerializableMap(Map<String, dynamic> data) =>
      ReviewerStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        username: deserializeParam(
          data['username'],
          ParamType.String,
          false,
        ),
        avatarUrl: deserializeParam(
          data['avatarUrl'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ReviewerStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ReviewerStruct &&
        id == other.id &&
        username == other.username &&
        avatarUrl == other.avatarUrl;
  }

  @override
  int get hashCode => const ListEquality().hash([id, username, avatarUrl]);
}

ReviewerStruct createReviewerStruct({
  String? id,
  String? username,
  String? avatarUrl,
}) =>
    ReviewerStruct(
      id: id,
      username: username,
      avatarUrl: avatarUrl,
    );

// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ConditionStruct extends BaseStruct {
  ConditionStruct({
    String? id,
    String? name,
    String? code,
    String? description,
  })  : _id = id,
        _name = name,
        _code = code,
        _description = description;

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

  // "code" field.
  String? _code;
  String get code => _code ?? '';
  set code(String? val) => _code = val;

  bool hasCode() => _code != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  static ConditionStruct fromMap(Map<String, dynamic> data) => ConditionStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        code: data['code'] as String?,
        description: data['description'] as String?,
      );

  static ConditionStruct? maybeFromMap(dynamic data) => data is Map
      ? ConditionStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'code': _code,
        'description': _description,
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
        'code': serializeParam(
          _code,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
      }.withoutNulls;

  static ConditionStruct fromSerializableMap(Map<String, dynamic> data) =>
      ConditionStruct(
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
        code: deserializeParam(
          data['code'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ConditionStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ConditionStruct &&
        id == other.id &&
        name == other.name &&
        code == other.code &&
        description == other.description;
  }

  @override
  int get hashCode => const ListEquality().hash([id, name, code, description]);
}

ConditionStruct createConditionStruct({
  String? id,
  String? name,
  String? code,
  String? description,
}) =>
    ConditionStruct(
      id: id,
      name: name,
      code: code,
      description: description,
    );

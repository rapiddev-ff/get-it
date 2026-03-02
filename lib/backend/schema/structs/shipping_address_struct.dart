// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ShippingAddressStruct extends BaseStruct {
  ShippingAddressStruct({
    String? fullName,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? zipCode,
    String? country,
  })  : _fullName = fullName,
        _addressLine1 = addressLine1,
        _addressLine2 = addressLine2,
        _city = city,
        _state = state,
        _zipCode = zipCode,
        _country = country;

  // "fullName" field.
  String? _fullName;
  String get fullName => _fullName ?? '';
  set fullName(String? val) => _fullName = val;

  bool hasFullName() => _fullName != null;

  // "addressLine1" field.
  String? _addressLine1;
  String get addressLine1 => _addressLine1 ?? '';
  set addressLine1(String? val) => _addressLine1 = val;

  bool hasAddressLine1() => _addressLine1 != null;

  // "addressLine2" field.
  String? _addressLine2;
  String get addressLine2 => _addressLine2 ?? '';
  set addressLine2(String? val) => _addressLine2 = val;

  bool hasAddressLine2() => _addressLine2 != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "zipCode" field.
  String? _zipCode;
  String get zipCode => _zipCode ?? '';
  set zipCode(String? val) => _zipCode = val;

  bool hasZipCode() => _zipCode != null;

  // "country" field.
  String? _country;
  String get country => _country ?? '';
  set country(String? val) => _country = val;

  bool hasCountry() => _country != null;

  static ShippingAddressStruct fromMap(Map<String, dynamic> data) =>
      ShippingAddressStruct(
        fullName: data['fullName'] as String?,
        addressLine1: data['addressLine1'] as String?,
        addressLine2: data['addressLine2'] as String?,
        city: data['city'] as String?,
        state: data['state'] as String?,
        zipCode: data['zipCode'] as String?,
        country: data['country'] as String?,
      );

  static ShippingAddressStruct? maybeFromMap(dynamic data) => data is Map
      ? ShippingAddressStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'fullName': _fullName,
        'addressLine1': _addressLine1,
        'addressLine2': _addressLine2,
        'city': _city,
        'state': _state,
        'zipCode': _zipCode,
        'country': _country,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'fullName': serializeParam(
          _fullName,
          ParamType.String,
        ),
        'addressLine1': serializeParam(
          _addressLine1,
          ParamType.String,
        ),
        'addressLine2': serializeParam(
          _addressLine2,
          ParamType.String,
        ),
        'city': serializeParam(
          _city,
          ParamType.String,
        ),
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'zipCode': serializeParam(
          _zipCode,
          ParamType.String,
        ),
        'country': serializeParam(
          _country,
          ParamType.String,
        ),
      }.withoutNulls;

  static ShippingAddressStruct fromSerializableMap(Map<String, dynamic> data) =>
      ShippingAddressStruct(
        fullName: deserializeParam(
          data['fullName'],
          ParamType.String,
          false,
        ),
        addressLine1: deserializeParam(
          data['addressLine1'],
          ParamType.String,
          false,
        ),
        addressLine2: deserializeParam(
          data['addressLine2'],
          ParamType.String,
          false,
        ),
        city: deserializeParam(
          data['city'],
          ParamType.String,
          false,
        ),
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        zipCode: deserializeParam(
          data['zipCode'],
          ParamType.String,
          false,
        ),
        country: deserializeParam(
          data['country'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ShippingAddressStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ShippingAddressStruct &&
        fullName == other.fullName &&
        addressLine1 == other.addressLine1 &&
        addressLine2 == other.addressLine2 &&
        city == other.city &&
        state == other.state &&
        zipCode == other.zipCode &&
        country == other.country;
  }

  @override
  int get hashCode => const ListEquality().hash(
      [fullName, addressLine1, addressLine2, city, state, zipCode, country]);
}

ShippingAddressStruct createShippingAddressStruct({
  String? fullName,
  String? addressLine1,
  String? addressLine2,
  String? city,
  String? state,
  String? zipCode,
  String? country,
}) =>
    ShippingAddressStruct(
      fullName: fullName,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      state: state,
      zipCode: zipCode,
      country: country,
    );

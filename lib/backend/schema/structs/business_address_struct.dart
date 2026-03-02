// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BusinessAddressStruct extends BaseStruct {
  BusinessAddressStruct({
    String? addressLine1,
    String? addressLine2,
    String? country,
    String? state,
    String? city,
    String? zipCode,
  })  : _addressLine1 = addressLine1,
        _addressLine2 = addressLine2,
        _country = country,
        _state = state,
        _city = city,
        _zipCode = zipCode;

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

  // "country" field.
  String? _country;
  String get country => _country ?? '';
  set country(String? val) => _country = val;

  bool hasCountry() => _country != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "city" field.
  String? _city;
  String get city => _city ?? '';
  set city(String? val) => _city = val;

  bool hasCity() => _city != null;

  // "zipCode" field.
  String? _zipCode;
  String get zipCode => _zipCode ?? '';
  set zipCode(String? val) => _zipCode = val;

  bool hasZipCode() => _zipCode != null;

  static BusinessAddressStruct fromMap(Map<String, dynamic> data) =>
      BusinessAddressStruct(
        addressLine1: data['addressLine1'] as String?,
        addressLine2: data['addressLine2'] as String?,
        country: data['country'] as String?,
        state: data['state'] as String?,
        city: data['city'] as String?,
        zipCode: data['zipCode'] as String?,
      );

  static BusinessAddressStruct? maybeFromMap(dynamic data) => data is Map
      ? BusinessAddressStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'addressLine1': _addressLine1,
        'addressLine2': _addressLine2,
        'country': _country,
        'state': _state,
        'city': _city,
        'zipCode': _zipCode,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'addressLine1': serializeParam(
          _addressLine1,
          ParamType.String,
        ),
        'addressLine2': serializeParam(
          _addressLine2,
          ParamType.String,
        ),
        'country': serializeParam(
          _country,
          ParamType.String,
        ),
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'city': serializeParam(
          _city,
          ParamType.String,
        ),
        'zipCode': serializeParam(
          _zipCode,
          ParamType.String,
        ),
      }.withoutNulls;

  static BusinessAddressStruct fromSerializableMap(Map<String, dynamic> data) =>
      BusinessAddressStruct(
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
        country: deserializeParam(
          data['country'],
          ParamType.String,
          false,
        ),
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        city: deserializeParam(
          data['city'],
          ParamType.String,
          false,
        ),
        zipCode: deserializeParam(
          data['zipCode'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'BusinessAddressStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is BusinessAddressStruct &&
        addressLine1 == other.addressLine1 &&
        addressLine2 == other.addressLine2 &&
        country == other.country &&
        state == other.state &&
        city == other.city &&
        zipCode == other.zipCode;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([addressLine1, addressLine2, country, state, city, zipCode]);
}

BusinessAddressStruct createBusinessAddressStruct({
  String? addressLine1,
  String? addressLine2,
  String? country,
  String? state,
  String? city,
  String? zipCode,
}) =>
    BusinessAddressStruct(
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      country: country,
      state: state,
      city: city,
      zipCode: zipCode,
    );

// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BillingDetailsStruct extends BaseStruct {
  BillingDetailsStruct({
    String? name,
    String? email,
    String? phone,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
  })  : _name = name,
        _email = email,
        _phone = phone,
        _addressLine1 = addressLine1,
        _addressLine2 = addressLine2,
        _city = city,
        _state = state,
        _postalCode = postalCode,
        _country = country;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  set phone(String? val) => _phone = val;

  bool hasPhone() => _phone != null;

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

  // "postalCode" field.
  String? _postalCode;
  String get postalCode => _postalCode ?? '';
  set postalCode(String? val) => _postalCode = val;

  bool hasPostalCode() => _postalCode != null;

  // "country" field.
  String? _country;
  String get country => _country ?? '';
  set country(String? val) => _country = val;

  bool hasCountry() => _country != null;

  static BillingDetailsStruct fromMap(Map<String, dynamic> data) =>
      BillingDetailsStruct(
        name: data['name'] as String?,
        email: data['email'] as String?,
        phone: data['phone'] as String?,
        addressLine1: data['addressLine1'] as String?,
        addressLine2: data['addressLine2'] as String?,
        city: data['city'] as String?,
        state: data['state'] as String?,
        postalCode: data['postalCode'] as String?,
        country: data['country'] as String?,
      );

  static BillingDetailsStruct? maybeFromMap(dynamic data) => data is Map
      ? BillingDetailsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'email': _email,
        'phone': _phone,
        'addressLine1': _addressLine1,
        'addressLine2': _addressLine2,
        'city': _city,
        'state': _state,
        'postalCode': _postalCode,
        'country': _country,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'phone': serializeParam(
          _phone,
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
        'postalCode': serializeParam(
          _postalCode,
          ParamType.String,
        ),
        'country': serializeParam(
          _country,
          ParamType.String,
        ),
      }.withoutNulls;

  static BillingDetailsStruct fromSerializableMap(Map<String, dynamic> data) =>
      BillingDetailsStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        phone: deserializeParam(
          data['phone'],
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
        postalCode: deserializeParam(
          data['postalCode'],
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
  String toString() => 'BillingDetailsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is BillingDetailsStruct &&
        name == other.name &&
        email == other.email &&
        phone == other.phone &&
        addressLine1 == other.addressLine1 &&
        addressLine2 == other.addressLine2 &&
        city == other.city &&
        state == other.state &&
        postalCode == other.postalCode &&
        country == other.country;
  }

  @override
  int get hashCode => const ListEquality().hash([
        name,
        email,
        phone,
        addressLine1,
        addressLine2,
        city,
        state,
        postalCode,
        country
      ]);
}

BillingDetailsStruct createBillingDetailsStruct({
  String? name,
  String? email,
  String? phone,
  String? addressLine1,
  String? addressLine2,
  String? city,
  String? state,
  String? postalCode,
  String? country,
}) =>
    BillingDetailsStruct(
      name: name,
      email: email,
      phone: phone,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      state: state,
      postalCode: postalCode,
      country: country,
    );

// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PaymentCardStruct extends BaseStruct {
  PaymentCardStruct({
    String? brand,
    String? last4,
    int? expMonth,
    int? expYear,
    String? funding,
  })  : _brand = brand,
        _last4 = last4,
        _expMonth = expMonth,
        _expYear = expYear,
        _funding = funding;

  // "brand" field.
  String? _brand;
  String get brand => _brand ?? '';
  set brand(String? val) => _brand = val;

  bool hasBrand() => _brand != null;

  // "last4" field.
  String? _last4;
  String get last4 => _last4 ?? '';
  set last4(String? val) => _last4 = val;

  bool hasLast4() => _last4 != null;

  // "expMonth" field.
  int? _expMonth;
  int get expMonth => _expMonth ?? 0;
  set expMonth(int? val) => _expMonth = val;

  void incrementExpMonth(int amount) => expMonth = expMonth + amount;

  bool hasExpMonth() => _expMonth != null;

  // "expYear" field.
  int? _expYear;
  int get expYear => _expYear ?? 0;
  set expYear(int? val) => _expYear = val;

  void incrementExpYear(int amount) => expYear = expYear + amount;

  bool hasExpYear() => _expYear != null;

  // "funding" field.
  String? _funding;
  String get funding => _funding ?? '';
  set funding(String? val) => _funding = val;

  bool hasFunding() => _funding != null;

  static PaymentCardStruct fromMap(Map<String, dynamic> data) =>
      PaymentCardStruct(
        brand: data['brand'] as String?,
        last4: data['last4'] as String?,
        expMonth: castToType<int>(data['expMonth']),
        expYear: castToType<int>(data['expYear']),
        funding: data['funding'] as String?,
      );

  static PaymentCardStruct? maybeFromMap(dynamic data) => data is Map
      ? PaymentCardStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'brand': _brand,
        'last4': _last4,
        'expMonth': _expMonth,
        'expYear': _expYear,
        'funding': _funding,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'brand': serializeParam(
          _brand,
          ParamType.String,
        ),
        'last4': serializeParam(
          _last4,
          ParamType.String,
        ),
        'expMonth': serializeParam(
          _expMonth,
          ParamType.int,
        ),
        'expYear': serializeParam(
          _expYear,
          ParamType.int,
        ),
        'funding': serializeParam(
          _funding,
          ParamType.String,
        ),
      }.withoutNulls;

  static PaymentCardStruct fromSerializableMap(Map<String, dynamic> data) =>
      PaymentCardStruct(
        brand: deserializeParam(
          data['brand'],
          ParamType.String,
          false,
        ),
        last4: deserializeParam(
          data['last4'],
          ParamType.String,
          false,
        ),
        expMonth: deserializeParam(
          data['expMonth'],
          ParamType.int,
          false,
        ),
        expYear: deserializeParam(
          data['expYear'],
          ParamType.int,
          false,
        ),
        funding: deserializeParam(
          data['funding'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'PaymentCardStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PaymentCardStruct &&
        brand == other.brand &&
        last4 == other.last4 &&
        expMonth == other.expMonth &&
        expYear == other.expYear &&
        funding == other.funding;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([brand, last4, expMonth, expYear, funding]);
}

PaymentCardStruct createPaymentCardStruct({
  String? brand,
  String? last4,
  int? expMonth,
  int? expYear,
  String? funding,
}) =>
    PaymentCardStruct(
      brand: brand,
      last4: last4,
      expMonth: expMonth,
      expYear: expYear,
      funding: funding,
    );

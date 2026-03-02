// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class StripePaymentResultStruct extends BaseStruct {
  StripePaymentResultStruct({
    bool? success,
    String? paymentIntentId,
    String? error,
  })  : _success = success,
        _paymentIntentId = paymentIntentId,
        _error = error;

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  // "paymentIntentId" field.
  String? _paymentIntentId;
  String get paymentIntentId => _paymentIntentId ?? '';
  set paymentIntentId(String? val) => _paymentIntentId = val;

  bool hasPaymentIntentId() => _paymentIntentId != null;

  // "error" field.
  String? _error;
  String get error => _error ?? '';
  set error(String? val) => _error = val;

  bool hasError() => _error != null;

  static StripePaymentResultStruct fromMap(Map<String, dynamic> data) =>
      StripePaymentResultStruct(
        success: data['success'] as bool?,
        paymentIntentId: data['paymentIntentId'] as String?,
        error: data['error'] as String?,
      );

  static StripePaymentResultStruct? maybeFromMap(dynamic data) => data is Map
      ? StripePaymentResultStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'success': _success,
        'paymentIntentId': _paymentIntentId,
        'error': _error,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
        'paymentIntentId': serializeParam(
          _paymentIntentId,
          ParamType.String,
        ),
        'error': serializeParam(
          _error,
          ParamType.String,
        ),
      }.withoutNulls;

  static StripePaymentResultStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      StripePaymentResultStruct(
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
        paymentIntentId: deserializeParam(
          data['paymentIntentId'],
          ParamType.String,
          false,
        ),
        error: deserializeParam(
          data['error'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'StripePaymentResultStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is StripePaymentResultStruct &&
        success == other.success &&
        paymentIntentId == other.paymentIntentId &&
        error == other.error;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([success, paymentIntentId, error]);
}

StripePaymentResultStruct createStripePaymentResultStruct({
  bool? success,
  String? paymentIntentId,
  String? error,
}) =>
    StripePaymentResultStruct(
      success: success,
      paymentIntentId: paymentIntentId,
      error: error,
    );

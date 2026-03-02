// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CounterOfferStruct extends BaseStruct {
  CounterOfferStruct({
    String? id,
    double? originalPrice,
    double? offeredPrice,
    CounterOfferStatus? status,
    String? fromUserId,
    String? toUserId,
    DateTime? expiresAt,
    String? productId,
  })  : _id = id,
        _originalPrice = originalPrice,
        _offeredPrice = offeredPrice,
        _status = status,
        _fromUserId = fromUserId,
        _toUserId = toUserId,
        _expiresAt = expiresAt,
        _productId = productId;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "originalPrice" field.
  double? _originalPrice;
  double get originalPrice => _originalPrice ?? 0.0;
  set originalPrice(double? val) => _originalPrice = val;

  void incrementOriginalPrice(double amount) =>
      originalPrice = originalPrice + amount;

  bool hasOriginalPrice() => _originalPrice != null;

  // "offeredPrice" field.
  double? _offeredPrice;
  double get offeredPrice => _offeredPrice ?? 0.0;
  set offeredPrice(double? val) => _offeredPrice = val;

  void incrementOfferedPrice(double amount) =>
      offeredPrice = offeredPrice + amount;

  bool hasOfferedPrice() => _offeredPrice != null;

  // "status" field.
  CounterOfferStatus? _status;
  CounterOfferStatus? get status => _status;
  set status(CounterOfferStatus? val) => _status = val;

  bool hasStatus() => _status != null;

  // "fromUserId" field.
  String? _fromUserId;
  String get fromUserId => _fromUserId ?? '';
  set fromUserId(String? val) => _fromUserId = val;

  bool hasFromUserId() => _fromUserId != null;

  // "toUserId" field.
  String? _toUserId;
  String get toUserId => _toUserId ?? '';
  set toUserId(String? val) => _toUserId = val;

  bool hasToUserId() => _toUserId != null;

  // "expiresAt" field.
  DateTime? _expiresAt;
  DateTime? get expiresAt => _expiresAt;
  set expiresAt(DateTime? val) => _expiresAt = val;

  bool hasExpiresAt() => _expiresAt != null;

  // "productId" field.
  String? _productId;
  String get productId => _productId ?? '';
  set productId(String? val) => _productId = val;

  bool hasProductId() => _productId != null;

  static CounterOfferStruct fromMap(Map<String, dynamic> data) =>
      CounterOfferStruct(
        id: data['id'] as String?,
        originalPrice: castToType<double>(data['originalPrice']),
        offeredPrice: castToType<double>(data['offeredPrice']),
        status: data['status'] is CounterOfferStatus
            ? data['status']
            : deserializeEnum<CounterOfferStatus>(data['status']),
        fromUserId: data['fromUserId'] as String?,
        toUserId: data['toUserId'] as String?,
        expiresAt: data['expiresAt'] as DateTime?,
        productId: data['productId'] as String?,
      );

  static CounterOfferStruct? maybeFromMap(dynamic data) => data is Map
      ? CounterOfferStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'originalPrice': _originalPrice,
        'offeredPrice': _offeredPrice,
        'status': _status?.serialize(),
        'fromUserId': _fromUserId,
        'toUserId': _toUserId,
        'expiresAt': _expiresAt,
        'productId': _productId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'originalPrice': serializeParam(
          _originalPrice,
          ParamType.double,
        ),
        'offeredPrice': serializeParam(
          _offeredPrice,
          ParamType.double,
        ),
        'status': serializeParam(
          _status,
          ParamType.Enum,
        ),
        'fromUserId': serializeParam(
          _fromUserId,
          ParamType.String,
        ),
        'toUserId': serializeParam(
          _toUserId,
          ParamType.String,
        ),
        'expiresAt': serializeParam(
          _expiresAt,
          ParamType.DateTime,
        ),
        'productId': serializeParam(
          _productId,
          ParamType.String,
        ),
      }.withoutNulls;

  static CounterOfferStruct fromSerializableMap(Map<String, dynamic> data) =>
      CounterOfferStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        originalPrice: deserializeParam(
          data['originalPrice'],
          ParamType.double,
          false,
        ),
        offeredPrice: deserializeParam(
          data['offeredPrice'],
          ParamType.double,
          false,
        ),
        status: deserializeParam<CounterOfferStatus>(
          data['status'],
          ParamType.Enum,
          false,
        ),
        fromUserId: deserializeParam(
          data['fromUserId'],
          ParamType.String,
          false,
        ),
        toUserId: deserializeParam(
          data['toUserId'],
          ParamType.String,
          false,
        ),
        expiresAt: deserializeParam(
          data['expiresAt'],
          ParamType.DateTime,
          false,
        ),
        productId: deserializeParam(
          data['productId'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CounterOfferStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CounterOfferStruct &&
        id == other.id &&
        originalPrice == other.originalPrice &&
        offeredPrice == other.offeredPrice &&
        status == other.status &&
        fromUserId == other.fromUserId &&
        toUserId == other.toUserId &&
        expiresAt == other.expiresAt &&
        productId == other.productId;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        originalPrice,
        offeredPrice,
        status,
        fromUserId,
        toUserId,
        expiresAt,
        productId
      ]);
}

CounterOfferStruct createCounterOfferStruct({
  String? id,
  double? originalPrice,
  double? offeredPrice,
  CounterOfferStatus? status,
  String? fromUserId,
  String? toUserId,
  DateTime? expiresAt,
  String? productId,
}) =>
    CounterOfferStruct(
      id: id,
      originalPrice: originalPrice,
      offeredPrice: offeredPrice,
      status: status,
      fromUserId: fromUserId,
      toUserId: toUserId,
      expiresAt: expiresAt,
      productId: productId,
    );

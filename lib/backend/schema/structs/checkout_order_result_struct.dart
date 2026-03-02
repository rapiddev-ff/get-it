// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CheckoutOrderResultStruct extends BaseStruct {
  CheckoutOrderResultStruct({
    bool? success,
    String? orderId,
    String? orderNumber,
    double? subtotal,
    double? shippingCost,
    double? taxAmount,
    double? platformFee,
    double? totalAmount,
    String? sellerId,
    String? productTitle,
  })  : _success = success,
        _orderId = orderId,
        _orderNumber = orderNumber,
        _subtotal = subtotal,
        _shippingCost = shippingCost,
        _taxAmount = taxAmount,
        _platformFee = platformFee,
        _totalAmount = totalAmount,
        _sellerId = sellerId,
        _productTitle = productTitle;

  // "success" field.
  bool? _success;
  bool get success => _success ?? false;
  set success(bool? val) => _success = val;

  bool hasSuccess() => _success != null;

  // "orderId" field.
  String? _orderId;
  String get orderId => _orderId ?? '0';
  set orderId(String? val) => _orderId = val;

  bool hasOrderId() => _orderId != null;

  // "orderNumber" field.
  String? _orderNumber;
  String get orderNumber => _orderNumber ?? '0';
  set orderNumber(String? val) => _orderNumber = val;

  bool hasOrderNumber() => _orderNumber != null;

  // "subtotal" field.
  double? _subtotal;
  double get subtotal => _subtotal ?? 0.0;
  set subtotal(double? val) => _subtotal = val;

  void incrementSubtotal(double amount) => subtotal = subtotal + amount;

  bool hasSubtotal() => _subtotal != null;

  // "shippingCost" field.
  double? _shippingCost;
  double get shippingCost => _shippingCost ?? 0.0;
  set shippingCost(double? val) => _shippingCost = val;

  void incrementShippingCost(double amount) =>
      shippingCost = shippingCost + amount;

  bool hasShippingCost() => _shippingCost != null;

  // "taxAmount" field.
  double? _taxAmount;
  double get taxAmount => _taxAmount ?? 0.0;
  set taxAmount(double? val) => _taxAmount = val;

  void incrementTaxAmount(double amount) => taxAmount = taxAmount + amount;

  bool hasTaxAmount() => _taxAmount != null;

  // "platformFee" field.
  double? _platformFee;
  double get platformFee => _platformFee ?? 0.0;
  set platformFee(double? val) => _platformFee = val;

  void incrementPlatformFee(double amount) =>
      platformFee = platformFee + amount;

  bool hasPlatformFee() => _platformFee != null;

  // "totalAmount" field.
  double? _totalAmount;
  double get totalAmount => _totalAmount ?? 0.0;
  set totalAmount(double? val) => _totalAmount = val;

  void incrementTotalAmount(double amount) =>
      totalAmount = totalAmount + amount;

  bool hasTotalAmount() => _totalAmount != null;

  // "sellerId" field.
  String? _sellerId;
  String get sellerId => _sellerId ?? '';
  set sellerId(String? val) => _sellerId = val;

  bool hasSellerId() => _sellerId != null;

  // "productTitle" field.
  String? _productTitle;
  String get productTitle => _productTitle ?? '';
  set productTitle(String? val) => _productTitle = val;

  bool hasProductTitle() => _productTitle != null;

  static CheckoutOrderResultStruct fromMap(Map<String, dynamic> data) =>
      CheckoutOrderResultStruct(
        success: data['success'] as bool?,
        orderId: data['orderId'] as String?,
        orderNumber: data['orderNumber'] as String?,
        subtotal: castToType<double>(data['subtotal']),
        shippingCost: castToType<double>(data['shippingCost']),
        taxAmount: castToType<double>(data['taxAmount']),
        platformFee: castToType<double>(data['platformFee']),
        totalAmount: castToType<double>(data['totalAmount']),
        sellerId: data['sellerId'] as String?,
        productTitle: data['productTitle'] as String?,
      );

  static CheckoutOrderResultStruct? maybeFromMap(dynamic data) => data is Map
      ? CheckoutOrderResultStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'success': _success,
        'orderId': _orderId,
        'orderNumber': _orderNumber,
        'subtotal': _subtotal,
        'shippingCost': _shippingCost,
        'taxAmount': _taxAmount,
        'platformFee': _platformFee,
        'totalAmount': _totalAmount,
        'sellerId': _sellerId,
        'productTitle': _productTitle,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'success': serializeParam(
          _success,
          ParamType.bool,
        ),
        'orderId': serializeParam(
          _orderId,
          ParamType.String,
        ),
        'orderNumber': serializeParam(
          _orderNumber,
          ParamType.String,
        ),
        'subtotal': serializeParam(
          _subtotal,
          ParamType.double,
        ),
        'shippingCost': serializeParam(
          _shippingCost,
          ParamType.double,
        ),
        'taxAmount': serializeParam(
          _taxAmount,
          ParamType.double,
        ),
        'platformFee': serializeParam(
          _platformFee,
          ParamType.double,
        ),
        'totalAmount': serializeParam(
          _totalAmount,
          ParamType.double,
        ),
        'sellerId': serializeParam(
          _sellerId,
          ParamType.String,
        ),
        'productTitle': serializeParam(
          _productTitle,
          ParamType.String,
        ),
      }.withoutNulls;

  static CheckoutOrderResultStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      CheckoutOrderResultStruct(
        success: deserializeParam(
          data['success'],
          ParamType.bool,
          false,
        ),
        orderId: deserializeParam(
          data['orderId'],
          ParamType.String,
          false,
        ),
        orderNumber: deserializeParam(
          data['orderNumber'],
          ParamType.String,
          false,
        ),
        subtotal: deserializeParam(
          data['subtotal'],
          ParamType.double,
          false,
        ),
        shippingCost: deserializeParam(
          data['shippingCost'],
          ParamType.double,
          false,
        ),
        taxAmount: deserializeParam(
          data['taxAmount'],
          ParamType.double,
          false,
        ),
        platformFee: deserializeParam(
          data['platformFee'],
          ParamType.double,
          false,
        ),
        totalAmount: deserializeParam(
          data['totalAmount'],
          ParamType.double,
          false,
        ),
        sellerId: deserializeParam(
          data['sellerId'],
          ParamType.String,
          false,
        ),
        productTitle: deserializeParam(
          data['productTitle'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CheckoutOrderResultStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CheckoutOrderResultStruct &&
        success == other.success &&
        orderId == other.orderId &&
        orderNumber == other.orderNumber &&
        subtotal == other.subtotal &&
        shippingCost == other.shippingCost &&
        taxAmount == other.taxAmount &&
        platformFee == other.platformFee &&
        totalAmount == other.totalAmount &&
        sellerId == other.sellerId &&
        productTitle == other.productTitle;
  }

  @override
  int get hashCode => const ListEquality().hash([
        success,
        orderId,
        orderNumber,
        subtotal,
        shippingCost,
        taxAmount,
        platformFee,
        totalAmount,
        sellerId,
        productTitle
      ]);
}

CheckoutOrderResultStruct createCheckoutOrderResultStruct({
  bool? success,
  String? orderId,
  String? orderNumber,
  double? subtotal,
  double? shippingCost,
  double? taxAmount,
  double? platformFee,
  double? totalAmount,
  String? sellerId,
  String? productTitle,
}) =>
    CheckoutOrderResultStruct(
      success: success,
      orderId: orderId,
      orderNumber: orderNumber,
      subtotal: subtotal,
      shippingCost: shippingCost,
      taxAmount: taxAmount,
      platformFee: platformFee,
      totalAmount: totalAmount,
      sellerId: sellerId,
      productTitle: productTitle,
    );

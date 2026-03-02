// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CheckoutTotalsStruct extends BaseStruct {
  CheckoutTotalsStruct({
    double? effectivePrice,
    double? originalPrice,
    bool? isFlashSale,
    double? subtotal,
    double? shippingCost,
    bool? freeShipping,
    double? taxAmount,
    double? platformFee,
    double? totalAmount,
    int? availableQuantity,
  })  : _effectivePrice = effectivePrice,
        _originalPrice = originalPrice,
        _isFlashSale = isFlashSale,
        _subtotal = subtotal,
        _shippingCost = shippingCost,
        _freeShipping = freeShipping,
        _taxAmount = taxAmount,
        _platformFee = platformFee,
        _totalAmount = totalAmount,
        _availableQuantity = availableQuantity;

  // "effectivePrice" field.
  double? _effectivePrice;
  double get effectivePrice => _effectivePrice ?? 0.0;
  set effectivePrice(double? val) => _effectivePrice = val;

  void incrementEffectivePrice(double amount) =>
      effectivePrice = effectivePrice + amount;

  bool hasEffectivePrice() => _effectivePrice != null;

  // "originalPrice" field.
  double? _originalPrice;
  double get originalPrice => _originalPrice ?? 0.0;
  set originalPrice(double? val) => _originalPrice = val;

  void incrementOriginalPrice(double amount) =>
      originalPrice = originalPrice + amount;

  bool hasOriginalPrice() => _originalPrice != null;

  // "isFlashSale" field.
  bool? _isFlashSale;
  bool get isFlashSale => _isFlashSale ?? false;
  set isFlashSale(bool? val) => _isFlashSale = val;

  bool hasIsFlashSale() => _isFlashSale != null;

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

  // "freeShipping" field.
  bool? _freeShipping;
  bool get freeShipping => _freeShipping ?? false;
  set freeShipping(bool? val) => _freeShipping = val;

  bool hasFreeShipping() => _freeShipping != null;

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

  // "availableQuantity" field.
  int? _availableQuantity;
  int get availableQuantity => _availableQuantity ?? 0;
  set availableQuantity(int? val) => _availableQuantity = val;

  void incrementAvailableQuantity(int amount) =>
      availableQuantity = availableQuantity + amount;

  bool hasAvailableQuantity() => _availableQuantity != null;

  static CheckoutTotalsStruct fromMap(Map<String, dynamic> data) =>
      CheckoutTotalsStruct(
        effectivePrice: castToType<double>(data['effectivePrice']),
        originalPrice: castToType<double>(data['originalPrice']),
        isFlashSale: data['isFlashSale'] as bool?,
        subtotal: castToType<double>(data['subtotal']),
        shippingCost: castToType<double>(data['shippingCost']),
        freeShipping: data['freeShipping'] as bool?,
        taxAmount: castToType<double>(data['taxAmount']),
        platformFee: castToType<double>(data['platformFee']),
        totalAmount: castToType<double>(data['totalAmount']),
        availableQuantity: castToType<int>(data['availableQuantity']),
      );

  static CheckoutTotalsStruct? maybeFromMap(dynamic data) => data is Map
      ? CheckoutTotalsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'effectivePrice': _effectivePrice,
        'originalPrice': _originalPrice,
        'isFlashSale': _isFlashSale,
        'subtotal': _subtotal,
        'shippingCost': _shippingCost,
        'freeShipping': _freeShipping,
        'taxAmount': _taxAmount,
        'platformFee': _platformFee,
        'totalAmount': _totalAmount,
        'availableQuantity': _availableQuantity,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'effectivePrice': serializeParam(
          _effectivePrice,
          ParamType.double,
        ),
        'originalPrice': serializeParam(
          _originalPrice,
          ParamType.double,
        ),
        'isFlashSale': serializeParam(
          _isFlashSale,
          ParamType.bool,
        ),
        'subtotal': serializeParam(
          _subtotal,
          ParamType.double,
        ),
        'shippingCost': serializeParam(
          _shippingCost,
          ParamType.double,
        ),
        'freeShipping': serializeParam(
          _freeShipping,
          ParamType.bool,
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
        'availableQuantity': serializeParam(
          _availableQuantity,
          ParamType.int,
        ),
      }.withoutNulls;

  static CheckoutTotalsStruct fromSerializableMap(Map<String, dynamic> data) =>
      CheckoutTotalsStruct(
        effectivePrice: deserializeParam(
          data['effectivePrice'],
          ParamType.double,
          false,
        ),
        originalPrice: deserializeParam(
          data['originalPrice'],
          ParamType.double,
          false,
        ),
        isFlashSale: deserializeParam(
          data['isFlashSale'],
          ParamType.bool,
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
        freeShipping: deserializeParam(
          data['freeShipping'],
          ParamType.bool,
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
        availableQuantity: deserializeParam(
          data['availableQuantity'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'CheckoutTotalsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CheckoutTotalsStruct &&
        effectivePrice == other.effectivePrice &&
        originalPrice == other.originalPrice &&
        isFlashSale == other.isFlashSale &&
        subtotal == other.subtotal &&
        shippingCost == other.shippingCost &&
        freeShipping == other.freeShipping &&
        taxAmount == other.taxAmount &&
        platformFee == other.platformFee &&
        totalAmount == other.totalAmount &&
        availableQuantity == other.availableQuantity;
  }

  @override
  int get hashCode => const ListEquality().hash([
        effectivePrice,
        originalPrice,
        isFlashSale,
        subtotal,
        shippingCost,
        freeShipping,
        taxAmount,
        platformFee,
        totalAmount,
        availableQuantity
      ]);
}

CheckoutTotalsStruct createCheckoutTotalsStruct({
  double? effectivePrice,
  double? originalPrice,
  bool? isFlashSale,
  double? subtotal,
  double? shippingCost,
  bool? freeShipping,
  double? taxAmount,
  double? platformFee,
  double? totalAmount,
  int? availableQuantity,
}) =>
    CheckoutTotalsStruct(
      effectivePrice: effectivePrice,
      originalPrice: originalPrice,
      isFlashSale: isFlashSale,
      subtotal: subtotal,
      shippingCost: shippingCost,
      freeShipping: freeShipping,
      taxAmount: taxAmount,
      platformFee: platformFee,
      totalAmount: totalAmount,
      availableQuantity: availableQuantity,
    );

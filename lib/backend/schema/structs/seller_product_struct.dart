// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SellerProductStruct extends BaseStruct {
  SellerProductStruct({
    String? id,
    String? orderId,
    String? title,
    double? price,
    double? originalPrice,
    String? status,
    int? viewsCount,
    String? conditionName,
    String? mainImageUrl,
    bool? isInWishlist,
    DateTime? createdAt,
    int? quantity,
    String? categoryId,
  })  : _id = id,
        _orderId = orderId,
        _title = title,
        _price = price,
        _originalPrice = originalPrice,
        _status = status,
        _viewsCount = viewsCount,
        _conditionName = conditionName,
        _mainImageUrl = mainImageUrl,
        _isInWishlist = isInWishlist,
        _createdAt = createdAt,
        _quantity = quantity,
        _categoryId = categoryId;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "orderId" field.
  String? _orderId;
  String get orderId => _orderId ?? '';
  set orderId(String? val) => _orderId = val;

  bool hasOrderId() => _orderId != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  set price(double? val) => _price = val;

  void incrementPrice(double amount) => price = price + amount;

  bool hasPrice() => _price != null;

  // "originalPrice" field.
  double? _originalPrice;
  double get originalPrice => _originalPrice ?? 0.0;
  set originalPrice(double? val) => _originalPrice = val;

  void incrementOriginalPrice(double amount) =>
      originalPrice = originalPrice + amount;

  bool hasOriginalPrice() => _originalPrice != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "viewsCount" field.
  int? _viewsCount;
  int get viewsCount => _viewsCount ?? 0;
  set viewsCount(int? val) => _viewsCount = val;

  void incrementViewsCount(int amount) => viewsCount = viewsCount + amount;

  bool hasViewsCount() => _viewsCount != null;

  // "conditionName" field.
  String? _conditionName;
  String get conditionName => _conditionName ?? '';
  set conditionName(String? val) => _conditionName = val;

  bool hasConditionName() => _conditionName != null;

  // "mainImageUrl" field.
  String? _mainImageUrl;
  String get mainImageUrl => _mainImageUrl ?? '';
  set mainImageUrl(String? val) => _mainImageUrl = val;

  bool hasMainImageUrl() => _mainImageUrl != null;

  // "isInWishlist" field.
  bool? _isInWishlist;
  bool get isInWishlist => _isInWishlist ?? false;
  set isInWishlist(bool? val) => _isInWishlist = val;

  bool hasIsInWishlist() => _isInWishlist != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "quantity" field.
  int? _quantity;
  int get quantity => _quantity ?? 0;
  set quantity(int? val) => _quantity = val;

  void incrementQuantity(int amount) => quantity = quantity + amount;

  bool hasQuantity() => _quantity != null;

  // "categoryId" field.
  String? _categoryId;
  String get categoryId => _categoryId ?? '';
  set categoryId(String? val) => _categoryId = val;

  bool hasCategoryId() => _categoryId != null;

  static SellerProductStruct fromMap(Map<String, dynamic> data) =>
      SellerProductStruct(
        id: data['id'] as String?,
        orderId: data['orderId'] as String?,
        title: data['title'] as String?,
        price: castToType<double>(data['price']),
        originalPrice: castToType<double>(data['originalPrice']),
        status: data['status'] as String?,
        viewsCount: castToType<int>(data['viewsCount']),
        conditionName: data['conditionName'] as String?,
        mainImageUrl: data['mainImageUrl'] as String?,
        isInWishlist: data['isInWishlist'] as bool?,
        createdAt: data['createdAt'] as DateTime?,
        quantity: castToType<int>(data['quantity']),
        categoryId: data['categoryId'] as String?,
      );

  static SellerProductStruct? maybeFromMap(dynamic data) => data is Map
      ? SellerProductStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'orderId': _orderId,
        'title': _title,
        'price': _price,
        'originalPrice': _originalPrice,
        'status': _status,
        'viewsCount': _viewsCount,
        'conditionName': _conditionName,
        'mainImageUrl': _mainImageUrl,
        'isInWishlist': _isInWishlist,
        'createdAt': _createdAt,
        'quantity': _quantity,
        'categoryId': _categoryId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'orderId': serializeParam(
          _orderId,
          ParamType.String,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'price': serializeParam(
          _price,
          ParamType.double,
        ),
        'originalPrice': serializeParam(
          _originalPrice,
          ParamType.double,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'viewsCount': serializeParam(
          _viewsCount,
          ParamType.int,
        ),
        'conditionName': serializeParam(
          _conditionName,
          ParamType.String,
        ),
        'mainImageUrl': serializeParam(
          _mainImageUrl,
          ParamType.String,
        ),
        'isInWishlist': serializeParam(
          _isInWishlist,
          ParamType.bool,
        ),
        'createdAt': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
        'quantity': serializeParam(
          _quantity,
          ParamType.int,
        ),
        'categoryId': serializeParam(
          _categoryId,
          ParamType.String,
        ),
      }.withoutNulls;

  static SellerProductStruct fromSerializableMap(Map<String, dynamic> data) =>
      SellerProductStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        orderId: deserializeParam(
          data['orderId'],
          ParamType.String,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        price: deserializeParam(
          data['price'],
          ParamType.double,
          false,
        ),
        originalPrice: deserializeParam(
          data['originalPrice'],
          ParamType.double,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        viewsCount: deserializeParam(
          data['viewsCount'],
          ParamType.int,
          false,
        ),
        conditionName: deserializeParam(
          data['conditionName'],
          ParamType.String,
          false,
        ),
        mainImageUrl: deserializeParam(
          data['mainImageUrl'],
          ParamType.String,
          false,
        ),
        isInWishlist: deserializeParam(
          data['isInWishlist'],
          ParamType.bool,
          false,
        ),
        createdAt: deserializeParam(
          data['createdAt'],
          ParamType.DateTime,
          false,
        ),
        quantity: deserializeParam(
          data['quantity'],
          ParamType.int,
          false,
        ),
        categoryId: deserializeParam(
          data['categoryId'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'SellerProductStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is SellerProductStruct &&
        id == other.id &&
        orderId == other.orderId &&
        title == other.title &&
        price == other.price &&
        originalPrice == other.originalPrice &&
        status == other.status &&
        viewsCount == other.viewsCount &&
        conditionName == other.conditionName &&
        mainImageUrl == other.mainImageUrl &&
        isInWishlist == other.isInWishlist &&
        createdAt == other.createdAt &&
        quantity == other.quantity &&
        categoryId == other.categoryId;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        orderId,
        title,
        price,
        originalPrice,
        status,
        viewsCount,
        conditionName,
        mainImageUrl,
        isInWishlist,
        createdAt,
        quantity,
        categoryId
      ]);
}

SellerProductStruct createSellerProductStruct({
  String? id,
  String? orderId,
  String? title,
  double? price,
  double? originalPrice,
  String? status,
  int? viewsCount,
  String? conditionName,
  String? mainImageUrl,
  bool? isInWishlist,
  DateTime? createdAt,
  int? quantity,
  String? categoryId,
}) =>
    SellerProductStruct(
      id: id,
      orderId: orderId,
      title: title,
      price: price,
      originalPrice: originalPrice,
      status: status,
      viewsCount: viewsCount,
      conditionName: conditionName,
      mainImageUrl: mainImageUrl,
      isInWishlist: isInWishlist,
      createdAt: createdAt,
      quantity: quantity,
      categoryId: categoryId,
    );

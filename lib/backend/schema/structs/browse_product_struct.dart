// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BrowseProductStruct extends BaseStruct {
  BrowseProductStruct({
    String? id,
    String? title,
    double? price,
    double? originalPrice,
    String? status,
    int? viewsCount,
    String? conditionName,
    String? categoryName,
    String? mainImageUrl,
    bool? isInWishlist,
    String? sellerId,
    String? sellerUsername,
    String? sellerAvatarUrl,
    double? sellerRating,
    DateTime? createdAt,
    bool? freeShipping,
    bool? flashSaleEnabled,
    double? flashSalePrice,
    DateTime? flashSaleEndsAt,
  })  : _id = id,
        _title = title,
        _price = price,
        _originalPrice = originalPrice,
        _status = status,
        _viewsCount = viewsCount,
        _conditionName = conditionName,
        _categoryName = categoryName,
        _mainImageUrl = mainImageUrl,
        _isInWishlist = isInWishlist,
        _sellerId = sellerId,
        _sellerUsername = sellerUsername,
        _sellerAvatarUrl = sellerAvatarUrl,
        _sellerRating = sellerRating,
        _createdAt = createdAt,
        _freeShipping = freeShipping,
        _flashSaleEnabled = flashSaleEnabled,
        _flashSalePrice = flashSalePrice,
        _flashSaleEndsAt = flashSaleEndsAt;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

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

  // "categoryName" field.
  String? _categoryName;
  String get categoryName => _categoryName ?? '';
  set categoryName(String? val) => _categoryName = val;

  bool hasCategoryName() => _categoryName != null;

  // "main_image_url" field.
  String? _mainImageUrl;
  String get mainImageUrl => _mainImageUrl ?? '';
  set mainImageUrl(String? val) => _mainImageUrl = val;

  bool hasMainImageUrl() => _mainImageUrl != null;

  // "isInWishlist" field.
  bool? _isInWishlist;
  bool get isInWishlist => _isInWishlist ?? false;
  set isInWishlist(bool? val) => _isInWishlist = val;

  bool hasIsInWishlist() => _isInWishlist != null;

  // "sellerId" field.
  String? _sellerId;
  String get sellerId => _sellerId ?? '';
  set sellerId(String? val) => _sellerId = val;

  bool hasSellerId() => _sellerId != null;

  // "sellerUsername" field.
  String? _sellerUsername;
  String get sellerUsername => _sellerUsername ?? '';
  set sellerUsername(String? val) => _sellerUsername = val;

  bool hasSellerUsername() => _sellerUsername != null;

  // "sellerAvatarUrl" field.
  String? _sellerAvatarUrl;
  String get sellerAvatarUrl => _sellerAvatarUrl ?? '';
  set sellerAvatarUrl(String? val) => _sellerAvatarUrl = val;

  bool hasSellerAvatarUrl() => _sellerAvatarUrl != null;

  // "sellerRating" field.
  double? _sellerRating;
  double get sellerRating => _sellerRating ?? 0.0;
  set sellerRating(double? val) => _sellerRating = val;

  void incrementSellerRating(double amount) =>
      sellerRating = sellerRating + amount;

  bool hasSellerRating() => _sellerRating != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "freeShipping" field.
  bool? _freeShipping;
  bool get freeShipping => _freeShipping ?? false;
  set freeShipping(bool? val) => _freeShipping = val;

  bool hasFreeShipping() => _freeShipping != null;

  // "flashSaleEnabled" field.
  bool? _flashSaleEnabled;
  bool get flashSaleEnabled => _flashSaleEnabled ?? false;
  set flashSaleEnabled(bool? val) => _flashSaleEnabled = val;

  bool hasFlashSaleEnabled() => _flashSaleEnabled != null;

  // "flashSalePrice" field.
  double? _flashSalePrice;
  double get flashSalePrice => _flashSalePrice ?? 0.0;
  set flashSalePrice(double? val) => _flashSalePrice = val;

  void incrementFlashSalePrice(double amount) =>
      flashSalePrice = flashSalePrice + amount;

  bool hasFlashSalePrice() => _flashSalePrice != null;

  // "flashSaleEndsAt" field.
  DateTime? _flashSaleEndsAt;
  DateTime? get flashSaleEndsAt => _flashSaleEndsAt;
  set flashSaleEndsAt(DateTime? val) => _flashSaleEndsAt = val;

  bool hasFlashSaleEndsAt() => _flashSaleEndsAt != null;

  static BrowseProductStruct fromMap(Map<String, dynamic> data) =>
      BrowseProductStruct(
        id: data['id'] as String?,
        title: data['title'] as String?,
        price: castToType<double>(data['price']),
        originalPrice: castToType<double>(data['originalPrice']),
        status: data['status'] as String?,
        viewsCount: castToType<int>(data['viewsCount']),
        conditionName: data['conditionName'] as String?,
        categoryName: data['categoryName'] as String?,
        mainImageUrl: data['main_image_url'] as String?,
        isInWishlist: data['isInWishlist'] as bool?,
        sellerId: data['sellerId'] as String?,
        sellerUsername: data['sellerUsername'] as String?,
        sellerAvatarUrl: data['sellerAvatarUrl'] as String?,
        sellerRating: castToType<double>(data['sellerRating']),
        createdAt: data['createdAt'] as DateTime?,
        freeShipping: data['freeShipping'] as bool?,
        flashSaleEnabled: data['flashSaleEnabled'] as bool?,
        flashSalePrice: castToType<double>(data['flashSalePrice']),
        flashSaleEndsAt: data['flashSaleEndsAt'] as DateTime?,
      );

  static BrowseProductStruct? maybeFromMap(dynamic data) => data is Map
      ? BrowseProductStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title,
        'price': _price,
        'originalPrice': _originalPrice,
        'status': _status,
        'viewsCount': _viewsCount,
        'conditionName': _conditionName,
        'categoryName': _categoryName,
        'main_image_url': _mainImageUrl,
        'isInWishlist': _isInWishlist,
        'sellerId': _sellerId,
        'sellerUsername': _sellerUsername,
        'sellerAvatarUrl': _sellerAvatarUrl,
        'sellerRating': _sellerRating,
        'createdAt': _createdAt,
        'freeShipping': _freeShipping,
        'flashSaleEnabled': _flashSaleEnabled,
        'flashSalePrice': _flashSalePrice,
        'flashSaleEndsAt': _flashSaleEndsAt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
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
        'categoryName': serializeParam(
          _categoryName,
          ParamType.String,
        ),
        'main_image_url': serializeParam(
          _mainImageUrl,
          ParamType.String,
        ),
        'isInWishlist': serializeParam(
          _isInWishlist,
          ParamType.bool,
        ),
        'sellerId': serializeParam(
          _sellerId,
          ParamType.String,
        ),
        'sellerUsername': serializeParam(
          _sellerUsername,
          ParamType.String,
        ),
        'sellerAvatarUrl': serializeParam(
          _sellerAvatarUrl,
          ParamType.String,
        ),
        'sellerRating': serializeParam(
          _sellerRating,
          ParamType.double,
        ),
        'createdAt': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
        'freeShipping': serializeParam(
          _freeShipping,
          ParamType.bool,
        ),
        'flashSaleEnabled': serializeParam(
          _flashSaleEnabled,
          ParamType.bool,
        ),
        'flashSalePrice': serializeParam(
          _flashSalePrice,
          ParamType.double,
        ),
        'flashSaleEndsAt': serializeParam(
          _flashSaleEndsAt,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static BrowseProductStruct fromSerializableMap(Map<String, dynamic> data) =>
      BrowseProductStruct(
        id: deserializeParam(
          data['id'],
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
        categoryName: deserializeParam(
          data['categoryName'],
          ParamType.String,
          false,
        ),
        mainImageUrl: deserializeParam(
          data['main_image_url'],
          ParamType.String,
          false,
        ),
        isInWishlist: deserializeParam(
          data['isInWishlist'],
          ParamType.bool,
          false,
        ),
        sellerId: deserializeParam(
          data['sellerId'],
          ParamType.String,
          false,
        ),
        sellerUsername: deserializeParam(
          data['sellerUsername'],
          ParamType.String,
          false,
        ),
        sellerAvatarUrl: deserializeParam(
          data['sellerAvatarUrl'],
          ParamType.String,
          false,
        ),
        sellerRating: deserializeParam(
          data['sellerRating'],
          ParamType.double,
          false,
        ),
        createdAt: deserializeParam(
          data['createdAt'],
          ParamType.DateTime,
          false,
        ),
        freeShipping: deserializeParam(
          data['freeShipping'],
          ParamType.bool,
          false,
        ),
        flashSaleEnabled: deserializeParam(
          data['flashSaleEnabled'],
          ParamType.bool,
          false,
        ),
        flashSalePrice: deserializeParam(
          data['flashSalePrice'],
          ParamType.double,
          false,
        ),
        flashSaleEndsAt: deserializeParam(
          data['flashSaleEndsAt'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'BrowseProductStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is BrowseProductStruct &&
        id == other.id &&
        title == other.title &&
        price == other.price &&
        originalPrice == other.originalPrice &&
        status == other.status &&
        viewsCount == other.viewsCount &&
        conditionName == other.conditionName &&
        categoryName == other.categoryName &&
        mainImageUrl == other.mainImageUrl &&
        isInWishlist == other.isInWishlist &&
        sellerId == other.sellerId &&
        sellerUsername == other.sellerUsername &&
        sellerAvatarUrl == other.sellerAvatarUrl &&
        sellerRating == other.sellerRating &&
        createdAt == other.createdAt &&
        freeShipping == other.freeShipping &&
        flashSaleEnabled == other.flashSaleEnabled &&
        flashSalePrice == other.flashSalePrice &&
        flashSaleEndsAt == other.flashSaleEndsAt;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        title,
        price,
        originalPrice,
        status,
        viewsCount,
        conditionName,
        categoryName,
        mainImageUrl,
        isInWishlist,
        sellerId,
        sellerUsername,
        sellerAvatarUrl,
        sellerRating,
        createdAt,
        freeShipping,
        flashSaleEnabled,
        flashSalePrice,
        flashSaleEndsAt
      ]);
}

BrowseProductStruct createBrowseProductStruct({
  String? id,
  String? title,
  double? price,
  double? originalPrice,
  String? status,
  int? viewsCount,
  String? conditionName,
  String? categoryName,
  String? mainImageUrl,
  bool? isInWishlist,
  String? sellerId,
  String? sellerUsername,
  String? sellerAvatarUrl,
  double? sellerRating,
  DateTime? createdAt,
  bool? freeShipping,
  bool? flashSaleEnabled,
  double? flashSalePrice,
  DateTime? flashSaleEndsAt,
}) =>
    BrowseProductStruct(
      id: id,
      title: title,
      price: price,
      originalPrice: originalPrice,
      status: status,
      viewsCount: viewsCount,
      conditionName: conditionName,
      categoryName: categoryName,
      mainImageUrl: mainImageUrl,
      isInWishlist: isInWishlist,
      sellerId: sellerId,
      sellerUsername: sellerUsername,
      sellerAvatarUrl: sellerAvatarUrl,
      sellerRating: sellerRating,
      createdAt: createdAt,
      freeShipping: freeShipping,
      flashSaleEnabled: flashSaleEnabled,
      flashSalePrice: flashSalePrice,
      flashSaleEndsAt: flashSaleEndsAt,
    );

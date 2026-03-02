// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FeedProductStruct extends BaseStruct {
  FeedProductStruct({
    String? id,
    String? title,
    String? description,
    double? price,
    double? originalPrice,
    bool? flashSaleEnabled,
    double? flashSalePrice,
    DateTime? flashSaleEndsAt,
    String? conditionName,
    String? mainImageUrl,
    String? sellerId,
    String? sellerUsername,
    String? sellerAvatarUrl,
    double? sellerRating,
    int? sellerTotalReviews,
    bool? isInWishlist,
    DateTime? createdAt,
    double? shippingPrice,
    bool? freeShipping,
    bool? useSellerShipping,
    double? customFlatRate,
    double? customAdditionalItemFee,
  })  : _id = id,
        _title = title,
        _description = description,
        _price = price,
        _originalPrice = originalPrice,
        _flashSaleEnabled = flashSaleEnabled,
        _flashSalePrice = flashSalePrice,
        _flashSaleEndsAt = flashSaleEndsAt,
        _conditionName = conditionName,
        _mainImageUrl = mainImageUrl,
        _sellerId = sellerId,
        _sellerUsername = sellerUsername,
        _sellerAvatarUrl = sellerAvatarUrl,
        _sellerRating = sellerRating,
        _sellerTotalReviews = sellerTotalReviews,
        _isInWishlist = isInWishlist,
        _createdAt = createdAt,
        _shippingPrice = shippingPrice,
        _freeShipping = freeShipping,
        _useSellerShipping = useSellerShipping,
        _customFlatRate = customFlatRate,
        _customAdditionalItemFee = customAdditionalItemFee;

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

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

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

  // "sellerTotalReviews" field.
  int? _sellerTotalReviews;
  int get sellerTotalReviews => _sellerTotalReviews ?? 0;
  set sellerTotalReviews(int? val) => _sellerTotalReviews = val;

  void incrementSellerTotalReviews(int amount) =>
      sellerTotalReviews = sellerTotalReviews + amount;

  bool hasSellerTotalReviews() => _sellerTotalReviews != null;

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

  // "shippingPrice" field.
  double? _shippingPrice;
  double get shippingPrice => _shippingPrice ?? 0.0;
  set shippingPrice(double? val) => _shippingPrice = val;

  void incrementShippingPrice(double amount) =>
      shippingPrice = shippingPrice + amount;

  bool hasShippingPrice() => _shippingPrice != null;

  // "freeShipping" field.
  bool? _freeShipping;
  bool get freeShipping => _freeShipping ?? false;
  set freeShipping(bool? val) => _freeShipping = val;

  bool hasFreeShipping() => _freeShipping != null;

  // "useSellerShipping" field.
  bool? _useSellerShipping;
  bool get useSellerShipping => _useSellerShipping ?? false;
  set useSellerShipping(bool? val) => _useSellerShipping = val;

  bool hasUseSellerShipping() => _useSellerShipping != null;

  // "customFlatRate" field.
  double? _customFlatRate;
  double get customFlatRate => _customFlatRate ?? 0.0;
  set customFlatRate(double? val) => _customFlatRate = val;

  void incrementCustomFlatRate(double amount) =>
      customFlatRate = customFlatRate + amount;

  bool hasCustomFlatRate() => _customFlatRate != null;

  // "customAdditionalItemFee" field.
  double? _customAdditionalItemFee;
  double get customAdditionalItemFee => _customAdditionalItemFee ?? 0.0;
  set customAdditionalItemFee(double? val) => _customAdditionalItemFee = val;

  void incrementCustomAdditionalItemFee(double amount) =>
      customAdditionalItemFee = customAdditionalItemFee + amount;

  bool hasCustomAdditionalItemFee() => _customAdditionalItemFee != null;

  static FeedProductStruct fromMap(Map<String, dynamic> data) =>
      FeedProductStruct(
        id: data['id'] as String?,
        title: data['title'] as String?,
        description: data['description'] as String?,
        price: castToType<double>(data['price']),
        originalPrice: castToType<double>(data['originalPrice']),
        flashSaleEnabled: data['flashSaleEnabled'] as bool?,
        flashSalePrice: castToType<double>(data['flashSalePrice']),
        flashSaleEndsAt: data['flashSaleEndsAt'] as DateTime?,
        conditionName: data['conditionName'] as String?,
        mainImageUrl: data['mainImageUrl'] as String?,
        sellerId: data['sellerId'] as String?,
        sellerUsername: data['sellerUsername'] as String?,
        sellerAvatarUrl: data['sellerAvatarUrl'] as String?,
        sellerRating: castToType<double>(data['sellerRating']),
        sellerTotalReviews: castToType<int>(data['sellerTotalReviews']),
        isInWishlist: data['isInWishlist'] as bool?,
        createdAt: data['createdAt'] as DateTime?,
        shippingPrice: castToType<double>(data['shippingPrice']),
        freeShipping: data['freeShipping'] as bool?,
        useSellerShipping: data['useSellerShipping'] as bool?,
        customFlatRate: castToType<double>(data['customFlatRate']),
        customAdditionalItemFee:
            castToType<double>(data['customAdditionalItemFee']),
      );

  static FeedProductStruct? maybeFromMap(dynamic data) => data is Map
      ? FeedProductStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title,
        'description': _description,
        'price': _price,
        'originalPrice': _originalPrice,
        'flashSaleEnabled': _flashSaleEnabled,
        'flashSalePrice': _flashSalePrice,
        'flashSaleEndsAt': _flashSaleEndsAt,
        'conditionName': _conditionName,
        'mainImageUrl': _mainImageUrl,
        'sellerId': _sellerId,
        'sellerUsername': _sellerUsername,
        'sellerAvatarUrl': _sellerAvatarUrl,
        'sellerRating': _sellerRating,
        'sellerTotalReviews': _sellerTotalReviews,
        'isInWishlist': _isInWishlist,
        'createdAt': _createdAt,
        'shippingPrice': _shippingPrice,
        'freeShipping': _freeShipping,
        'useSellerShipping': _useSellerShipping,
        'customFlatRate': _customFlatRate,
        'customAdditionalItemFee': _customAdditionalItemFee,
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
        'description': serializeParam(
          _description,
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
        'conditionName': serializeParam(
          _conditionName,
          ParamType.String,
        ),
        'mainImageUrl': serializeParam(
          _mainImageUrl,
          ParamType.String,
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
        'sellerTotalReviews': serializeParam(
          _sellerTotalReviews,
          ParamType.int,
        ),
        'isInWishlist': serializeParam(
          _isInWishlist,
          ParamType.bool,
        ),
        'createdAt': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
        'shippingPrice': serializeParam(
          _shippingPrice,
          ParamType.double,
        ),
        'freeShipping': serializeParam(
          _freeShipping,
          ParamType.bool,
        ),
        'useSellerShipping': serializeParam(
          _useSellerShipping,
          ParamType.bool,
        ),
        'customFlatRate': serializeParam(
          _customFlatRate,
          ParamType.double,
        ),
        'customAdditionalItemFee': serializeParam(
          _customAdditionalItemFee,
          ParamType.double,
        ),
      }.withoutNulls;

  static FeedProductStruct fromSerializableMap(Map<String, dynamic> data) =>
      FeedProductStruct(
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
        description: deserializeParam(
          data['description'],
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
        sellerTotalReviews: deserializeParam(
          data['sellerTotalReviews'],
          ParamType.int,
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
        shippingPrice: deserializeParam(
          data['shippingPrice'],
          ParamType.double,
          false,
        ),
        freeShipping: deserializeParam(
          data['freeShipping'],
          ParamType.bool,
          false,
        ),
        useSellerShipping: deserializeParam(
          data['useSellerShipping'],
          ParamType.bool,
          false,
        ),
        customFlatRate: deserializeParam(
          data['customFlatRate'],
          ParamType.double,
          false,
        ),
        customAdditionalItemFee: deserializeParam(
          data['customAdditionalItemFee'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'FeedProductStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FeedProductStruct &&
        id == other.id &&
        title == other.title &&
        description == other.description &&
        price == other.price &&
        originalPrice == other.originalPrice &&
        flashSaleEnabled == other.flashSaleEnabled &&
        flashSalePrice == other.flashSalePrice &&
        flashSaleEndsAt == other.flashSaleEndsAt &&
        conditionName == other.conditionName &&
        mainImageUrl == other.mainImageUrl &&
        sellerId == other.sellerId &&
        sellerUsername == other.sellerUsername &&
        sellerAvatarUrl == other.sellerAvatarUrl &&
        sellerRating == other.sellerRating &&
        sellerTotalReviews == other.sellerTotalReviews &&
        isInWishlist == other.isInWishlist &&
        createdAt == other.createdAt &&
        shippingPrice == other.shippingPrice &&
        freeShipping == other.freeShipping &&
        useSellerShipping == other.useSellerShipping &&
        customFlatRate == other.customFlatRate &&
        customAdditionalItemFee == other.customAdditionalItemFee;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        title,
        description,
        price,
        originalPrice,
        flashSaleEnabled,
        flashSalePrice,
        flashSaleEndsAt,
        conditionName,
        mainImageUrl,
        sellerId,
        sellerUsername,
        sellerAvatarUrl,
        sellerRating,
        sellerTotalReviews,
        isInWishlist,
        createdAt,
        shippingPrice,
        freeShipping,
        useSellerShipping,
        customFlatRate,
        customAdditionalItemFee
      ]);
}

FeedProductStruct createFeedProductStruct({
  String? id,
  String? title,
  String? description,
  double? price,
  double? originalPrice,
  bool? flashSaleEnabled,
  double? flashSalePrice,
  DateTime? flashSaleEndsAt,
  String? conditionName,
  String? mainImageUrl,
  String? sellerId,
  String? sellerUsername,
  String? sellerAvatarUrl,
  double? sellerRating,
  int? sellerTotalReviews,
  bool? isInWishlist,
  DateTime? createdAt,
  double? shippingPrice,
  bool? freeShipping,
  bool? useSellerShipping,
  double? customFlatRate,
  double? customAdditionalItemFee,
}) =>
    FeedProductStruct(
      id: id,
      title: title,
      description: description,
      price: price,
      originalPrice: originalPrice,
      flashSaleEnabled: flashSaleEnabled,
      flashSalePrice: flashSalePrice,
      flashSaleEndsAt: flashSaleEndsAt,
      conditionName: conditionName,
      mainImageUrl: mainImageUrl,
      sellerId: sellerId,
      sellerUsername: sellerUsername,
      sellerAvatarUrl: sellerAvatarUrl,
      sellerRating: sellerRating,
      sellerTotalReviews: sellerTotalReviews,
      isInWishlist: isInWishlist,
      createdAt: createdAt,
      shippingPrice: shippingPrice,
      freeShipping: freeShipping,
      useSellerShipping: useSellerShipping,
      customFlatRate: customFlatRate,
      customAdditionalItemFee: customAdditionalItemFee,
    );

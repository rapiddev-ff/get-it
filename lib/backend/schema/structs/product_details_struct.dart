// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProductDetailsStruct extends BaseStruct {
  ProductDetailsStruct({
    String? id,
    String? title,
    String? description,
    double? price,
    double? originalPrice,
    bool? flashSaleEnabled,
    double? flashSalePrice,
    DateTime? flashSaleEndsAt,
    int? quantity,
    int? year,
    String? sku,
    String? skuNumber,
    String? shippingInfo,
    double? shippingPrice,
    bool? freeShipping,
    int? viewsCount,
    String? status,
    DateTime? createdAt,
    List<ConditionStruct>? conditions,
    CategoryStruct? category,
    SubcategoryStruct? subcategory,
    SellerStruct? seller,
    List<ProductImageStruct>? images,
    List<TagStruct>? tags,
    bool? isInWishlist,
    bool? isOwnProduct,
    int? issueNumber,
    String? discountType,
    double? discountAmount,
    bool? useSellerShipping,
    double? customFlatRate,
    double? customAdditionalItemFee,
    String? shortlistId,
  })  : _id = id,
        _title = title,
        _description = description,
        _price = price,
        _originalPrice = originalPrice,
        _flashSaleEnabled = flashSaleEnabled,
        _flashSalePrice = flashSalePrice,
        _flashSaleEndsAt = flashSaleEndsAt,
        _quantity = quantity,
        _year = year,
        _sku = sku,
        _skuNumber = skuNumber,
        _shippingInfo = shippingInfo,
        _shippingPrice = shippingPrice,
        _freeShipping = freeShipping,
        _viewsCount = viewsCount,
        _status = status,
        _createdAt = createdAt,
        _conditions = conditions,
        _category = category,
        _subcategory = subcategory,
        _seller = seller,
        _images = images,
        _tags = tags,
        _isInWishlist = isInWishlist,
        _isOwnProduct = isOwnProduct,
        _issueNumber = issueNumber,
        _discountType = discountType,
        _discountAmount = discountAmount,
        _useSellerShipping = useSellerShipping,
        _customFlatRate = customFlatRate,
        _customAdditionalItemFee = customAdditionalItemFee,
        _shortlistId = shortlistId;

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

  // "quantity" field.
  int? _quantity;
  int get quantity => _quantity ?? 0;
  set quantity(int? val) => _quantity = val;

  void incrementQuantity(int amount) => quantity = quantity + amount;

  bool hasQuantity() => _quantity != null;

  // "year" field.
  int? _year;
  int get year => _year ?? 0;
  set year(int? val) => _year = val;

  void incrementYear(int amount) => year = year + amount;

  bool hasYear() => _year != null;

  // "sku" field.
  String? _sku;
  String get sku => _sku ?? '';
  set sku(String? val) => _sku = val;

  bool hasSku() => _sku != null;

  // "skuNumber" field.
  String? _skuNumber;
  String get skuNumber => _skuNumber ?? '';
  set skuNumber(String? val) => _skuNumber = val;

  bool hasSkuNumber() => _skuNumber != null;

  // "shippingInfo" field.
  String? _shippingInfo;
  String get shippingInfo => _shippingInfo ?? '';
  set shippingInfo(String? val) => _shippingInfo = val;

  bool hasShippingInfo() => _shippingInfo != null;

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

  // "viewsCount" field.
  int? _viewsCount;
  int get viewsCount => _viewsCount ?? 0;
  set viewsCount(int? val) => _viewsCount = val;

  void incrementViewsCount(int amount) => viewsCount = viewsCount + amount;

  bool hasViewsCount() => _viewsCount != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "conditions" field.
  List<ConditionStruct>? _conditions;
  List<ConditionStruct> get conditions => _conditions ?? const [];
  set conditions(List<ConditionStruct>? val) => _conditions = val;

  void updateConditions(Function(List<ConditionStruct>) updateFn) {
    updateFn(_conditions ??= []);
  }

  bool hasConditions() => _conditions != null;

  // "category" field.
  CategoryStruct? _category;
  CategoryStruct get category => _category ?? CategoryStruct();
  set category(CategoryStruct? val) => _category = val;

  void updateCategory(Function(CategoryStruct) updateFn) {
    updateFn(_category ??= CategoryStruct());
  }

  bool hasCategory() => _category != null;

  // "subcategory" field.
  SubcategoryStruct? _subcategory;
  SubcategoryStruct get subcategory => _subcategory ?? SubcategoryStruct();
  set subcategory(SubcategoryStruct? val) => _subcategory = val;

  void updateSubcategory(Function(SubcategoryStruct) updateFn) {
    updateFn(_subcategory ??= SubcategoryStruct());
  }

  bool hasSubcategory() => _subcategory != null;

  // "seller" field.
  SellerStruct? _seller;
  SellerStruct get seller => _seller ?? SellerStruct();
  set seller(SellerStruct? val) => _seller = val;

  void updateSeller(Function(SellerStruct) updateFn) {
    updateFn(_seller ??= SellerStruct());
  }

  bool hasSeller() => _seller != null;

  // "images" field.
  List<ProductImageStruct>? _images;
  List<ProductImageStruct> get images => _images ?? const [];
  set images(List<ProductImageStruct>? val) => _images = val;

  void updateImages(Function(List<ProductImageStruct>) updateFn) {
    updateFn(_images ??= []);
  }

  bool hasImages() => _images != null;

  // "tags" field.
  List<TagStruct>? _tags;
  List<TagStruct> get tags => _tags ?? const [];
  set tags(List<TagStruct>? val) => _tags = val;

  void updateTags(Function(List<TagStruct>) updateFn) {
    updateFn(_tags ??= []);
  }

  bool hasTags() => _tags != null;

  // "isInWishlist" field.
  bool? _isInWishlist;
  bool get isInWishlist => _isInWishlist ?? false;
  set isInWishlist(bool? val) => _isInWishlist = val;

  bool hasIsInWishlist() => _isInWishlist != null;

  // "isOwnProduct" field.
  bool? _isOwnProduct;
  bool get isOwnProduct => _isOwnProduct ?? false;
  set isOwnProduct(bool? val) => _isOwnProduct = val;

  bool hasIsOwnProduct() => _isOwnProduct != null;

  // "issueNumber" field.
  int? _issueNumber;
  int get issueNumber => _issueNumber ?? 0;
  set issueNumber(int? val) => _issueNumber = val;

  void incrementIssueNumber(int amount) => issueNumber = issueNumber + amount;

  bool hasIssueNumber() => _issueNumber != null;

  // "discountType" field.
  String? _discountType;
  String get discountType => _discountType ?? '';
  set discountType(String? val) => _discountType = val;

  bool hasDiscountType() => _discountType != null;

  // "discountAmount" field.
  double? _discountAmount;
  double get discountAmount => _discountAmount ?? 0.0;
  set discountAmount(double? val) => _discountAmount = val;

  void incrementDiscountAmount(double amount) =>
      discountAmount = discountAmount + amount;

  bool hasDiscountAmount() => _discountAmount != null;

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

  // "shortlistId" field.
  String? _shortlistId;
  String get shortlistId => _shortlistId ?? '';
  set shortlistId(String? val) => _shortlistId = val;

  bool hasShortlistId() => _shortlistId != null;

  static ProductDetailsStruct fromMap(Map<String, dynamic> data) =>
      ProductDetailsStruct(
        id: data['id'] as String?,
        title: data['title'] as String?,
        description: data['description'] as String?,
        price: castToType<double>(data['price']),
        originalPrice: castToType<double>(data['originalPrice']),
        flashSaleEnabled: data['flashSaleEnabled'] as bool?,
        flashSalePrice: castToType<double>(data['flashSalePrice']),
        flashSaleEndsAt: data['flashSaleEndsAt'] as DateTime?,
        quantity: castToType<int>(data['quantity']),
        year: castToType<int>(data['year']),
        sku: data['sku'] as String?,
        skuNumber: data['skuNumber'] as String?,
        shippingInfo: data['shippingInfo'] as String?,
        shippingPrice: castToType<double>(data['shippingPrice']),
        freeShipping: data['freeShipping'] as bool?,
        viewsCount: castToType<int>(data['viewsCount']),
        status: data['status'] as String?,
        createdAt: data['createdAt'] as DateTime?,
        conditions: getStructList(
          data['conditions'],
          ConditionStruct.fromMap,
        ),
        category: data['category'] is CategoryStruct
            ? data['category']
            : CategoryStruct.maybeFromMap(data['category']),
        subcategory: data['subcategory'] is SubcategoryStruct
            ? data['subcategory']
            : SubcategoryStruct.maybeFromMap(data['subcategory']),
        seller: data['seller'] is SellerStruct
            ? data['seller']
            : SellerStruct.maybeFromMap(data['seller']),
        images: getStructList(
          data['images'],
          ProductImageStruct.fromMap,
        ),
        tags: getStructList(
          data['tags'],
          TagStruct.fromMap,
        ),
        isInWishlist: data['isInWishlist'] as bool?,
        isOwnProduct: data['isOwnProduct'] as bool?,
        issueNumber: castToType<int>(data['issueNumber']),
        discountType: data['discountType'] as String?,
        discountAmount: castToType<double>(data['discountAmount']),
        useSellerShipping: data['useSellerShipping'] as bool?,
        customFlatRate: castToType<double>(data['customFlatRate']),
        customAdditionalItemFee:
            castToType<double>(data['customAdditionalItemFee']),
        shortlistId: data['shortlistId'] as String?,
      );

  static ProductDetailsStruct? maybeFromMap(dynamic data) => data is Map
      ? ProductDetailsStruct.fromMap(data.cast<String, dynamic>())
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
        'quantity': _quantity,
        'year': _year,
        'sku': _sku,
        'skuNumber': _skuNumber,
        'shippingInfo': _shippingInfo,
        'shippingPrice': _shippingPrice,
        'freeShipping': _freeShipping,
        'viewsCount': _viewsCount,
        'status': _status,
        'createdAt': _createdAt,
        'conditions': _conditions?.map((e) => e.toMap()).toList(),
        'category': _category?.toMap(),
        'subcategory': _subcategory?.toMap(),
        'seller': _seller?.toMap(),
        'images': _images?.map((e) => e.toMap()).toList(),
        'tags': _tags?.map((e) => e.toMap()).toList(),
        'isInWishlist': _isInWishlist,
        'isOwnProduct': _isOwnProduct,
        'issueNumber': _issueNumber,
        'discountType': _discountType,
        'discountAmount': _discountAmount,
        'useSellerShipping': _useSellerShipping,
        'customFlatRate': _customFlatRate,
        'customAdditionalItemFee': _customAdditionalItemFee,
        'shortlistId': _shortlistId,
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
        'quantity': serializeParam(
          _quantity,
          ParamType.int,
        ),
        'year': serializeParam(
          _year,
          ParamType.int,
        ),
        'sku': serializeParam(
          _sku,
          ParamType.String,
        ),
        'skuNumber': serializeParam(
          _skuNumber,
          ParamType.String,
        ),
        'shippingInfo': serializeParam(
          _shippingInfo,
          ParamType.String,
        ),
        'shippingPrice': serializeParam(
          _shippingPrice,
          ParamType.double,
        ),
        'freeShipping': serializeParam(
          _freeShipping,
          ParamType.bool,
        ),
        'viewsCount': serializeParam(
          _viewsCount,
          ParamType.int,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'createdAt': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
        'conditions': serializeParam(
          _conditions,
          ParamType.DataStruct,
          isList: true,
        ),
        'category': serializeParam(
          _category,
          ParamType.DataStruct,
        ),
        'subcategory': serializeParam(
          _subcategory,
          ParamType.DataStruct,
        ),
        'seller': serializeParam(
          _seller,
          ParamType.DataStruct,
        ),
        'images': serializeParam(
          _images,
          ParamType.DataStruct,
          isList: true,
        ),
        'tags': serializeParam(
          _tags,
          ParamType.DataStruct,
          isList: true,
        ),
        'isInWishlist': serializeParam(
          _isInWishlist,
          ParamType.bool,
        ),
        'isOwnProduct': serializeParam(
          _isOwnProduct,
          ParamType.bool,
        ),
        'issueNumber': serializeParam(
          _issueNumber,
          ParamType.int,
        ),
        'discountType': serializeParam(
          _discountType,
          ParamType.String,
        ),
        'discountAmount': serializeParam(
          _discountAmount,
          ParamType.double,
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
        'shortlistId': serializeParam(
          _shortlistId,
          ParamType.String,
        ),
      }.withoutNulls;

  static ProductDetailsStruct fromSerializableMap(Map<String, dynamic> data) =>
      ProductDetailsStruct(
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
        quantity: deserializeParam(
          data['quantity'],
          ParamType.int,
          false,
        ),
        year: deserializeParam(
          data['year'],
          ParamType.int,
          false,
        ),
        sku: deserializeParam(
          data['sku'],
          ParamType.String,
          false,
        ),
        skuNumber: deserializeParam(
          data['skuNumber'],
          ParamType.String,
          false,
        ),
        shippingInfo: deserializeParam(
          data['shippingInfo'],
          ParamType.String,
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
        viewsCount: deserializeParam(
          data['viewsCount'],
          ParamType.int,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['createdAt'],
          ParamType.DateTime,
          false,
        ),
        conditions: deserializeStructParam<ConditionStruct>(
          data['conditions'],
          ParamType.DataStruct,
          true,
          structBuilder: ConditionStruct.fromSerializableMap,
        ),
        category: deserializeStructParam(
          data['category'],
          ParamType.DataStruct,
          false,
          structBuilder: CategoryStruct.fromSerializableMap,
        ),
        subcategory: deserializeStructParam(
          data['subcategory'],
          ParamType.DataStruct,
          false,
          structBuilder: SubcategoryStruct.fromSerializableMap,
        ),
        seller: deserializeStructParam(
          data['seller'],
          ParamType.DataStruct,
          false,
          structBuilder: SellerStruct.fromSerializableMap,
        ),
        images: deserializeStructParam<ProductImageStruct>(
          data['images'],
          ParamType.DataStruct,
          true,
          structBuilder: ProductImageStruct.fromSerializableMap,
        ),
        tags: deserializeStructParam<TagStruct>(
          data['tags'],
          ParamType.DataStruct,
          true,
          structBuilder: TagStruct.fromSerializableMap,
        ),
        isInWishlist: deserializeParam(
          data['isInWishlist'],
          ParamType.bool,
          false,
        ),
        isOwnProduct: deserializeParam(
          data['isOwnProduct'],
          ParamType.bool,
          false,
        ),
        issueNumber: deserializeParam(
          data['issueNumber'],
          ParamType.int,
          false,
        ),
        discountType: deserializeParam(
          data['discountType'],
          ParamType.String,
          false,
        ),
        discountAmount: deserializeParam(
          data['discountAmount'],
          ParamType.double,
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
        shortlistId: deserializeParam(
          data['shortlistId'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ProductDetailsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ProductDetailsStruct &&
        id == other.id &&
        title == other.title &&
        description == other.description &&
        price == other.price &&
        originalPrice == other.originalPrice &&
        flashSaleEnabled == other.flashSaleEnabled &&
        flashSalePrice == other.flashSalePrice &&
        flashSaleEndsAt == other.flashSaleEndsAt &&
        quantity == other.quantity &&
        year == other.year &&
        sku == other.sku &&
        skuNumber == other.skuNumber &&
        shippingInfo == other.shippingInfo &&
        shippingPrice == other.shippingPrice &&
        freeShipping == other.freeShipping &&
        viewsCount == other.viewsCount &&
        status == other.status &&
        createdAt == other.createdAt &&
        listEquality.equals(conditions, other.conditions) &&
        category == other.category &&
        subcategory == other.subcategory &&
        seller == other.seller &&
        listEquality.equals(images, other.images) &&
        listEquality.equals(tags, other.tags) &&
        isInWishlist == other.isInWishlist &&
        isOwnProduct == other.isOwnProduct &&
        issueNumber == other.issueNumber &&
        discountType == other.discountType &&
        discountAmount == other.discountAmount &&
        useSellerShipping == other.useSellerShipping &&
        customFlatRate == other.customFlatRate &&
        customAdditionalItemFee == other.customAdditionalItemFee &&
        shortlistId == other.shortlistId;
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
        quantity,
        year,
        sku,
        skuNumber,
        shippingInfo,
        shippingPrice,
        freeShipping,
        viewsCount,
        status,
        createdAt,
        conditions,
        category,
        subcategory,
        seller,
        images,
        tags,
        isInWishlist,
        isOwnProduct,
        issueNumber,
        discountType,
        discountAmount,
        useSellerShipping,
        customFlatRate,
        customAdditionalItemFee,
        shortlistId
      ]);
}

ProductDetailsStruct createProductDetailsStruct({
  String? id,
  String? title,
  String? description,
  double? price,
  double? originalPrice,
  bool? flashSaleEnabled,
  double? flashSalePrice,
  DateTime? flashSaleEndsAt,
  int? quantity,
  int? year,
  String? sku,
  String? skuNumber,
  String? shippingInfo,
  double? shippingPrice,
  bool? freeShipping,
  int? viewsCount,
  String? status,
  DateTime? createdAt,
  CategoryStruct? category,
  SubcategoryStruct? subcategory,
  SellerStruct? seller,
  bool? isInWishlist,
  bool? isOwnProduct,
  int? issueNumber,
  String? discountType,
  double? discountAmount,
  bool? useSellerShipping,
  double? customFlatRate,
  double? customAdditionalItemFee,
  String? shortlistId,
}) =>
    ProductDetailsStruct(
      id: id,
      title: title,
      description: description,
      price: price,
      originalPrice: originalPrice,
      flashSaleEnabled: flashSaleEnabled,
      flashSalePrice: flashSalePrice,
      flashSaleEndsAt: flashSaleEndsAt,
      quantity: quantity,
      year: year,
      sku: sku,
      skuNumber: skuNumber,
      shippingInfo: shippingInfo,
      shippingPrice: shippingPrice,
      freeShipping: freeShipping,
      viewsCount: viewsCount,
      status: status,
      createdAt: createdAt,
      category: category ?? CategoryStruct(),
      subcategory: subcategory ?? SubcategoryStruct(),
      seller: seller ?? SellerStruct(),
      isInWishlist: isInWishlist,
      isOwnProduct: isOwnProduct,
      issueNumber: issueNumber,
      discountType: discountType,
      discountAmount: discountAmount,
      useSellerShipping: useSellerShipping,
      customFlatRate: customFlatRate,
      customAdditionalItemFee: customAdditionalItemFee,
      shortlistId: shortlistId,
    );

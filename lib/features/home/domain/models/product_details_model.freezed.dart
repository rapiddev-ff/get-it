// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductDetails _$ProductDetailsFromJson(Map<String, dynamic> json) {
  return _ProductDetails.fromJson(json);
}

/// @nodoc
mixin _$ProductDetails {
  String get id => throw _privateConstructorUsedError;
  String get sellerId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double? get originalPrice => throw _privateConstructorUsedError;
  bool get flashSaleEnabled => throw _privateConstructorUsedError;
  double? get flashSalePrice => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get flashSaleEndsAt => throw _privateConstructorUsedError;
  String? get discountType => throw _privateConstructorUsedError;
  double? get discountAmount => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int? get year => throw _privateConstructorUsedError;
  int? get issueNumber => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  String? get skuNumber => throw _privateConstructorUsedError;
  String? get shippingInfo => throw _privateConstructorUsedError;
  double get shippingPrice => throw _privateConstructorUsedError;
  bool get freeShipping => throw _privateConstructorUsedError;
  bool get useSellerShipping => throw _privateConstructorUsedError;
  double? get customFlatRate => throw _privateConstructorUsedError;
  double? get customAdditionalItemFee => throw _privateConstructorUsedError;
  String? get shortlistId => throw _privateConstructorUsedError;
  int get viewsCount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get mainImageUrl => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  String get subcategoryId => throw _privateConstructorUsedError;
  String get subcategoryName => throw _privateConstructorUsedError;
  String get conditionId => throw _privateConstructorUsedError;
  String get conditionName => throw _privateConstructorUsedError;
  String get sellerUsername => throw _privateConstructorUsedError;
  String get sellerAvatarUrl => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  List<ProductImage> get images => throw _privateConstructorUsedError;
  List<Condition> get conditions => throw _privateConstructorUsedError;
  Category? get category => throw _privateConstructorUsedError;
  Subcategory? get subcategory => throw _privateConstructorUsedError;
  Seller? get seller => throw _privateConstructorUsedError;
  List<Tag> get tags => throw _privateConstructorUsedError;
  bool get isInWishlist => throw _privateConstructorUsedError;
  bool get isOwnProduct => throw _privateConstructorUsedError;

  /// Serializes this ProductDetails to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductDetailsCopyWith<ProductDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductDetailsCopyWith<$Res> {
  factory $ProductDetailsCopyWith(
          ProductDetails value, $Res Function(ProductDetails) then) =
      _$ProductDetailsCopyWithImpl<$Res, ProductDetails>;
  @useResult
  $Res call(
      {String id,
      String sellerId,
      String title,
      String description,
      double price,
      double? originalPrice,
      bool flashSaleEnabled,
      double? flashSalePrice,
      @DateTimeConverter() DateTime? flashSaleEndsAt,
      String? discountType,
      double? discountAmount,
      int quantity,
      int? year,
      int? issueNumber,
      String? sku,
      String? skuNumber,
      String? shippingInfo,
      double shippingPrice,
      bool freeShipping,
      bool useSellerShipping,
      double? customFlatRate,
      double? customAdditionalItemFee,
      String? shortlistId,
      int viewsCount,
      String status,
      String mainImageUrl,
      String categoryId,
      String categoryName,
      String subcategoryId,
      String subcategoryName,
      String conditionId,
      String conditionName,
      String sellerUsername,
      String sellerAvatarUrl,
      @DateTimeConverter() DateTime? createdAt,
      List<ProductImage> images,
      List<Condition> conditions,
      Category? category,
      Subcategory? subcategory,
      Seller? seller,
      List<Tag> tags,
      bool isInWishlist,
      bool isOwnProduct});

  $CategoryCopyWith<$Res>? get category;
  $SubcategoryCopyWith<$Res>? get subcategory;
  $SellerCopyWith<$Res>? get seller;
}

/// @nodoc
class _$ProductDetailsCopyWithImpl<$Res, $Val extends ProductDetails>
    implements $ProductDetailsCopyWith<$Res> {
  _$ProductDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerId = null,
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? originalPrice = freezed,
    Object? flashSaleEnabled = null,
    Object? flashSalePrice = freezed,
    Object? flashSaleEndsAt = freezed,
    Object? discountType = freezed,
    Object? discountAmount = freezed,
    Object? quantity = null,
    Object? year = freezed,
    Object? issueNumber = freezed,
    Object? sku = freezed,
    Object? skuNumber = freezed,
    Object? shippingInfo = freezed,
    Object? shippingPrice = null,
    Object? freeShipping = null,
    Object? useSellerShipping = null,
    Object? customFlatRate = freezed,
    Object? customAdditionalItemFee = freezed,
    Object? shortlistId = freezed,
    Object? viewsCount = null,
    Object? status = null,
    Object? mainImageUrl = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? subcategoryId = null,
    Object? subcategoryName = null,
    Object? conditionId = null,
    Object? conditionName = null,
    Object? sellerUsername = null,
    Object? sellerAvatarUrl = null,
    Object? createdAt = freezed,
    Object? images = null,
    Object? conditions = null,
    Object? category = freezed,
    Object? subcategory = freezed,
    Object? seller = freezed,
    Object? tags = null,
    Object? isInWishlist = null,
    Object? isOwnProduct = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      flashSaleEnabled: null == flashSaleEnabled
          ? _value.flashSaleEnabled
          : flashSaleEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      flashSalePrice: freezed == flashSalePrice
          ? _value.flashSalePrice
          : flashSalePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      flashSaleEndsAt: freezed == flashSaleEndsAt
          ? _value.flashSaleEndsAt
          : flashSaleEndsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      discountType: freezed == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String?,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int?,
      issueNumber: freezed == issueNumber
          ? _value.issueNumber
          : issueNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      skuNumber: freezed == skuNumber
          ? _value.skuNumber
          : skuNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingInfo: freezed == shippingInfo
          ? _value.shippingInfo
          : shippingInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingPrice: null == shippingPrice
          ? _value.shippingPrice
          : shippingPrice // ignore: cast_nullable_to_non_nullable
              as double,
      freeShipping: null == freeShipping
          ? _value.freeShipping
          : freeShipping // ignore: cast_nullable_to_non_nullable
              as bool,
      useSellerShipping: null == useSellerShipping
          ? _value.useSellerShipping
          : useSellerShipping // ignore: cast_nullable_to_non_nullable
              as bool,
      customFlatRate: freezed == customFlatRate
          ? _value.customFlatRate
          : customFlatRate // ignore: cast_nullable_to_non_nullable
              as double?,
      customAdditionalItemFee: freezed == customAdditionalItemFee
          ? _value.customAdditionalItemFee
          : customAdditionalItemFee // ignore: cast_nullable_to_non_nullable
              as double?,
      shortlistId: freezed == shortlistId
          ? _value.shortlistId
          : shortlistId // ignore: cast_nullable_to_non_nullable
              as String?,
      viewsCount: null == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      mainImageUrl: null == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      subcategoryId: null == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as String,
      subcategoryName: null == subcategoryName
          ? _value.subcategoryName
          : subcategoryName // ignore: cast_nullable_to_non_nullable
              as String,
      conditionId: null == conditionId
          ? _value.conditionId
          : conditionId // ignore: cast_nullable_to_non_nullable
              as String,
      conditionName: null == conditionName
          ? _value.conditionName
          : conditionName // ignore: cast_nullable_to_non_nullable
              as String,
      sellerUsername: null == sellerUsername
          ? _value.sellerUsername
          : sellerUsername // ignore: cast_nullable_to_non_nullable
              as String,
      sellerAvatarUrl: null == sellerAvatarUrl
          ? _value.sellerAvatarUrl
          : sellerAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ProductImage>,
      conditions: null == conditions
          ? _value.conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as List<Condition>,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      subcategory: freezed == subcategory
          ? _value.subcategory
          : subcategory // ignore: cast_nullable_to_non_nullable
              as Subcategory?,
      seller: freezed == seller
          ? _value.seller
          : seller // ignore: cast_nullable_to_non_nullable
              as Seller?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
      isInWishlist: null == isInWishlist
          ? _value.isInWishlist
          : isInWishlist // ignore: cast_nullable_to_non_nullable
              as bool,
      isOwnProduct: null == isOwnProduct
          ? _value.isOwnProduct
          : isOwnProduct // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of ProductDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategoryCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $CategoryCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
  }

  /// Create a copy of ProductDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubcategoryCopyWith<$Res>? get subcategory {
    if (_value.subcategory == null) {
      return null;
    }

    return $SubcategoryCopyWith<$Res>(_value.subcategory!, (value) {
      return _then(_value.copyWith(subcategory: value) as $Val);
    });
  }

  /// Create a copy of ProductDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SellerCopyWith<$Res>? get seller {
    if (_value.seller == null) {
      return null;
    }

    return $SellerCopyWith<$Res>(_value.seller!, (value) {
      return _then(_value.copyWith(seller: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProductDetailsImplCopyWith<$Res>
    implements $ProductDetailsCopyWith<$Res> {
  factory _$$ProductDetailsImplCopyWith(_$ProductDetailsImpl value,
          $Res Function(_$ProductDetailsImpl) then) =
      __$$ProductDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String sellerId,
      String title,
      String description,
      double price,
      double? originalPrice,
      bool flashSaleEnabled,
      double? flashSalePrice,
      @DateTimeConverter() DateTime? flashSaleEndsAt,
      String? discountType,
      double? discountAmount,
      int quantity,
      int? year,
      int? issueNumber,
      String? sku,
      String? skuNumber,
      String? shippingInfo,
      double shippingPrice,
      bool freeShipping,
      bool useSellerShipping,
      double? customFlatRate,
      double? customAdditionalItemFee,
      String? shortlistId,
      int viewsCount,
      String status,
      String mainImageUrl,
      String categoryId,
      String categoryName,
      String subcategoryId,
      String subcategoryName,
      String conditionId,
      String conditionName,
      String sellerUsername,
      String sellerAvatarUrl,
      @DateTimeConverter() DateTime? createdAt,
      List<ProductImage> images,
      List<Condition> conditions,
      Category? category,
      Subcategory? subcategory,
      Seller? seller,
      List<Tag> tags,
      bool isInWishlist,
      bool isOwnProduct});

  @override
  $CategoryCopyWith<$Res>? get category;
  @override
  $SubcategoryCopyWith<$Res>? get subcategory;
  @override
  $SellerCopyWith<$Res>? get seller;
}

/// @nodoc
class __$$ProductDetailsImplCopyWithImpl<$Res>
    extends _$ProductDetailsCopyWithImpl<$Res, _$ProductDetailsImpl>
    implements _$$ProductDetailsImplCopyWith<$Res> {
  __$$ProductDetailsImplCopyWithImpl(
      _$ProductDetailsImpl _value, $Res Function(_$ProductDetailsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductDetails
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sellerId = null,
    Object? title = null,
    Object? description = null,
    Object? price = null,
    Object? originalPrice = freezed,
    Object? flashSaleEnabled = null,
    Object? flashSalePrice = freezed,
    Object? flashSaleEndsAt = freezed,
    Object? discountType = freezed,
    Object? discountAmount = freezed,
    Object? quantity = null,
    Object? year = freezed,
    Object? issueNumber = freezed,
    Object? sku = freezed,
    Object? skuNumber = freezed,
    Object? shippingInfo = freezed,
    Object? shippingPrice = null,
    Object? freeShipping = null,
    Object? useSellerShipping = null,
    Object? customFlatRate = freezed,
    Object? customAdditionalItemFee = freezed,
    Object? shortlistId = freezed,
    Object? viewsCount = null,
    Object? status = null,
    Object? mainImageUrl = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? subcategoryId = null,
    Object? subcategoryName = null,
    Object? conditionId = null,
    Object? conditionName = null,
    Object? sellerUsername = null,
    Object? sellerAvatarUrl = null,
    Object? createdAt = freezed,
    Object? images = null,
    Object? conditions = null,
    Object? category = freezed,
    Object? subcategory = freezed,
    Object? seller = freezed,
    Object? tags = null,
    Object? isInWishlist = null,
    Object? isOwnProduct = null,
  }) {
    return _then(_$ProductDetailsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sellerId: null == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      originalPrice: freezed == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      flashSaleEnabled: null == flashSaleEnabled
          ? _value.flashSaleEnabled
          : flashSaleEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      flashSalePrice: freezed == flashSalePrice
          ? _value.flashSalePrice
          : flashSalePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      flashSaleEndsAt: freezed == flashSaleEndsAt
          ? _value.flashSaleEndsAt
          : flashSaleEndsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      discountType: freezed == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String?,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int?,
      issueNumber: freezed == issueNumber
          ? _value.issueNumber
          : issueNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      skuNumber: freezed == skuNumber
          ? _value.skuNumber
          : skuNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingInfo: freezed == shippingInfo
          ? _value.shippingInfo
          : shippingInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      shippingPrice: null == shippingPrice
          ? _value.shippingPrice
          : shippingPrice // ignore: cast_nullable_to_non_nullable
              as double,
      freeShipping: null == freeShipping
          ? _value.freeShipping
          : freeShipping // ignore: cast_nullable_to_non_nullable
              as bool,
      useSellerShipping: null == useSellerShipping
          ? _value.useSellerShipping
          : useSellerShipping // ignore: cast_nullable_to_non_nullable
              as bool,
      customFlatRate: freezed == customFlatRate
          ? _value.customFlatRate
          : customFlatRate // ignore: cast_nullable_to_non_nullable
              as double?,
      customAdditionalItemFee: freezed == customAdditionalItemFee
          ? _value.customAdditionalItemFee
          : customAdditionalItemFee // ignore: cast_nullable_to_non_nullable
              as double?,
      shortlistId: freezed == shortlistId
          ? _value.shortlistId
          : shortlistId // ignore: cast_nullable_to_non_nullable
              as String?,
      viewsCount: null == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      mainImageUrl: null == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      subcategoryId: null == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as String,
      subcategoryName: null == subcategoryName
          ? _value.subcategoryName
          : subcategoryName // ignore: cast_nullable_to_non_nullable
              as String,
      conditionId: null == conditionId
          ? _value.conditionId
          : conditionId // ignore: cast_nullable_to_non_nullable
              as String,
      conditionName: null == conditionName
          ? _value.conditionName
          : conditionName // ignore: cast_nullable_to_non_nullable
              as String,
      sellerUsername: null == sellerUsername
          ? _value.sellerUsername
          : sellerUsername // ignore: cast_nullable_to_non_nullable
              as String,
      sellerAvatarUrl: null == sellerAvatarUrl
          ? _value.sellerAvatarUrl
          : sellerAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<ProductImage>,
      conditions: null == conditions
          ? _value._conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as List<Condition>,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as Category?,
      subcategory: freezed == subcategory
          ? _value.subcategory
          : subcategory // ignore: cast_nullable_to_non_nullable
              as Subcategory?,
      seller: freezed == seller
          ? _value.seller
          : seller // ignore: cast_nullable_to_non_nullable
              as Seller?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
      isInWishlist: null == isInWishlist
          ? _value.isInWishlist
          : isInWishlist // ignore: cast_nullable_to_non_nullable
              as bool,
      isOwnProduct: null == isOwnProduct
          ? _value.isOwnProduct
          : isOwnProduct // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductDetailsImpl extends _ProductDetails {
  const _$ProductDetailsImpl(
      {this.id = '',
      this.sellerId = '',
      this.title = '',
      this.description = '',
      this.price = 0.0,
      this.originalPrice,
      this.flashSaleEnabled = false,
      this.flashSalePrice,
      @DateTimeConverter() this.flashSaleEndsAt,
      this.discountType,
      this.discountAmount,
      this.quantity = 0,
      this.year,
      this.issueNumber,
      this.sku,
      this.skuNumber,
      this.shippingInfo,
      this.shippingPrice = 0.0,
      this.freeShipping = false,
      this.useSellerShipping = false,
      this.customFlatRate,
      this.customAdditionalItemFee,
      this.shortlistId,
      this.viewsCount = 0,
      this.status = '',
      this.mainImageUrl = '',
      this.categoryId = '',
      this.categoryName = '',
      this.subcategoryId = '',
      this.subcategoryName = '',
      this.conditionId = '',
      this.conditionName = '',
      this.sellerUsername = '',
      this.sellerAvatarUrl = '',
      @DateTimeConverter() this.createdAt,
      final List<ProductImage> images = const [],
      final List<Condition> conditions = const [],
      this.category,
      this.subcategory,
      this.seller,
      final List<Tag> tags = const [],
      this.isInWishlist = false,
      this.isOwnProduct = false})
      : _images = images,
        _conditions = conditions,
        _tags = tags,
        super._();

  factory _$ProductDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductDetailsImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String sellerId;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final double price;
  @override
  final double? originalPrice;
  @override
  @JsonKey()
  final bool flashSaleEnabled;
  @override
  final double? flashSalePrice;
  @override
  @DateTimeConverter()
  final DateTime? flashSaleEndsAt;
  @override
  final String? discountType;
  @override
  final double? discountAmount;
  @override
  @JsonKey()
  final int quantity;
  @override
  final int? year;
  @override
  final int? issueNumber;
  @override
  final String? sku;
  @override
  final String? skuNumber;
  @override
  final String? shippingInfo;
  @override
  @JsonKey()
  final double shippingPrice;
  @override
  @JsonKey()
  final bool freeShipping;
  @override
  @JsonKey()
  final bool useSellerShipping;
  @override
  final double? customFlatRate;
  @override
  final double? customAdditionalItemFee;
  @override
  final String? shortlistId;
  @override
  @JsonKey()
  final int viewsCount;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String mainImageUrl;
  @override
  @JsonKey()
  final String categoryId;
  @override
  @JsonKey()
  final String categoryName;
  @override
  @JsonKey()
  final String subcategoryId;
  @override
  @JsonKey()
  final String subcategoryName;
  @override
  @JsonKey()
  final String conditionId;
  @override
  @JsonKey()
  final String conditionName;
  @override
  @JsonKey()
  final String sellerUsername;
  @override
  @JsonKey()
  final String sellerAvatarUrl;
  @override
  @DateTimeConverter()
  final DateTime? createdAt;
  final List<ProductImage> _images;
  @override
  @JsonKey()
  List<ProductImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<Condition> _conditions;
  @override
  @JsonKey()
  List<Condition> get conditions {
    if (_conditions is EqualUnmodifiableListView) return _conditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conditions);
  }

  @override
  final Category? category;
  @override
  final Subcategory? subcategory;
  @override
  final Seller? seller;
  final List<Tag> _tags;
  @override
  @JsonKey()
  List<Tag> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool isInWishlist;
  @override
  @JsonKey()
  final bool isOwnProduct;

  @override
  String toString() {
    return 'ProductDetails(id: $id, sellerId: $sellerId, title: $title, description: $description, price: $price, originalPrice: $originalPrice, flashSaleEnabled: $flashSaleEnabled, flashSalePrice: $flashSalePrice, flashSaleEndsAt: $flashSaleEndsAt, discountType: $discountType, discountAmount: $discountAmount, quantity: $quantity, year: $year, issueNumber: $issueNumber, sku: $sku, skuNumber: $skuNumber, shippingInfo: $shippingInfo, shippingPrice: $shippingPrice, freeShipping: $freeShipping, useSellerShipping: $useSellerShipping, customFlatRate: $customFlatRate, customAdditionalItemFee: $customAdditionalItemFee, shortlistId: $shortlistId, viewsCount: $viewsCount, status: $status, mainImageUrl: $mainImageUrl, categoryId: $categoryId, categoryName: $categoryName, subcategoryId: $subcategoryId, subcategoryName: $subcategoryName, conditionId: $conditionId, conditionName: $conditionName, sellerUsername: $sellerUsername, sellerAvatarUrl: $sellerAvatarUrl, createdAt: $createdAt, images: $images, conditions: $conditions, category: $category, subcategory: $subcategory, seller: $seller, tags: $tags, isInWishlist: $isInWishlist, isOwnProduct: $isOwnProduct)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductDetailsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.flashSaleEnabled, flashSaleEnabled) ||
                other.flashSaleEnabled == flashSaleEnabled) &&
            (identical(other.flashSalePrice, flashSalePrice) ||
                other.flashSalePrice == flashSalePrice) &&
            (identical(other.flashSaleEndsAt, flashSaleEndsAt) ||
                other.flashSaleEndsAt == flashSaleEndsAt) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.issueNumber, issueNumber) ||
                other.issueNumber == issueNumber) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.skuNumber, skuNumber) ||
                other.skuNumber == skuNumber) &&
            (identical(other.shippingInfo, shippingInfo) ||
                other.shippingInfo == shippingInfo) &&
            (identical(other.shippingPrice, shippingPrice) ||
                other.shippingPrice == shippingPrice) &&
            (identical(other.freeShipping, freeShipping) ||
                other.freeShipping == freeShipping) &&
            (identical(other.useSellerShipping, useSellerShipping) ||
                other.useSellerShipping == useSellerShipping) &&
            (identical(other.customFlatRate, customFlatRate) ||
                other.customFlatRate == customFlatRate) &&
            (identical(
                    other.customAdditionalItemFee, customAdditionalItemFee) ||
                other.customAdditionalItemFee == customAdditionalItemFee) &&
            (identical(other.shortlistId, shortlistId) ||
                other.shortlistId == shortlistId) &&
            (identical(other.viewsCount, viewsCount) ||
                other.viewsCount == viewsCount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.mainImageUrl, mainImageUrl) ||
                other.mainImageUrl == mainImageUrl) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            (identical(other.subcategoryName, subcategoryName) ||
                other.subcategoryName == subcategoryName) &&
            (identical(other.conditionId, conditionId) ||
                other.conditionId == conditionId) &&
            (identical(other.conditionName, conditionName) ||
                other.conditionName == conditionName) &&
            (identical(other.sellerUsername, sellerUsername) ||
                other.sellerUsername == sellerUsername) &&
            (identical(other.sellerAvatarUrl, sellerAvatarUrl) ||
                other.sellerAvatarUrl == sellerAvatarUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality()
                .equals(other._conditions, _conditions) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.subcategory, subcategory) ||
                other.subcategory == subcategory) &&
            (identical(other.seller, seller) || other.seller == seller) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isInWishlist, isInWishlist) ||
                other.isInWishlist == isInWishlist) &&
            (identical(other.isOwnProduct, isOwnProduct) ||
                other.isOwnProduct == isOwnProduct));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        sellerId,
        title,
        description,
        price,
        originalPrice,
        flashSaleEnabled,
        flashSalePrice,
        flashSaleEndsAt,
        discountType,
        discountAmount,
        quantity,
        year,
        issueNumber,
        sku,
        skuNumber,
        shippingInfo,
        shippingPrice,
        freeShipping,
        useSellerShipping,
        customFlatRate,
        customAdditionalItemFee,
        shortlistId,
        viewsCount,
        status,
        mainImageUrl,
        categoryId,
        categoryName,
        subcategoryId,
        subcategoryName,
        conditionId,
        conditionName,
        sellerUsername,
        sellerAvatarUrl,
        createdAt,
        const DeepCollectionEquality().hash(_images),
        const DeepCollectionEquality().hash(_conditions),
        category,
        subcategory,
        seller,
        const DeepCollectionEquality().hash(_tags),
        isInWishlist,
        isOwnProduct
      ]);

  /// Create a copy of ProductDetails
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductDetailsImplCopyWith<_$ProductDetailsImpl> get copyWith =>
      __$$ProductDetailsImplCopyWithImpl<_$ProductDetailsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductDetailsImplToJson(
      this,
    );
  }
}

abstract class _ProductDetails extends ProductDetails {
  const factory _ProductDetails(
      {final String id,
      final String sellerId,
      final String title,
      final String description,
      final double price,
      final double? originalPrice,
      final bool flashSaleEnabled,
      final double? flashSalePrice,
      @DateTimeConverter() final DateTime? flashSaleEndsAt,
      final String? discountType,
      final double? discountAmount,
      final int quantity,
      final int? year,
      final int? issueNumber,
      final String? sku,
      final String? skuNumber,
      final String? shippingInfo,
      final double shippingPrice,
      final bool freeShipping,
      final bool useSellerShipping,
      final double? customFlatRate,
      final double? customAdditionalItemFee,
      final String? shortlistId,
      final int viewsCount,
      final String status,
      final String mainImageUrl,
      final String categoryId,
      final String categoryName,
      final String subcategoryId,
      final String subcategoryName,
      final String conditionId,
      final String conditionName,
      final String sellerUsername,
      final String sellerAvatarUrl,
      @DateTimeConverter() final DateTime? createdAt,
      final List<ProductImage> images,
      final List<Condition> conditions,
      final Category? category,
      final Subcategory? subcategory,
      final Seller? seller,
      final List<Tag> tags,
      final bool isInWishlist,
      final bool isOwnProduct}) = _$ProductDetailsImpl;
  const _ProductDetails._() : super._();

  factory _ProductDetails.fromJson(Map<String, dynamic> json) =
      _$ProductDetailsImpl.fromJson;

  @override
  String get id;
  @override
  String get sellerId;
  @override
  String get title;
  @override
  String get description;
  @override
  double get price;
  @override
  double? get originalPrice;
  @override
  bool get flashSaleEnabled;
  @override
  double? get flashSalePrice;
  @override
  @DateTimeConverter()
  DateTime? get flashSaleEndsAt;
  @override
  String? get discountType;
  @override
  double? get discountAmount;
  @override
  int get quantity;
  @override
  int? get year;
  @override
  int? get issueNumber;
  @override
  String? get sku;
  @override
  String? get skuNumber;
  @override
  String? get shippingInfo;
  @override
  double get shippingPrice;
  @override
  bool get freeShipping;
  @override
  bool get useSellerShipping;
  @override
  double? get customFlatRate;
  @override
  double? get customAdditionalItemFee;
  @override
  String? get shortlistId;
  @override
  int get viewsCount;
  @override
  String get status;
  @override
  String get mainImageUrl;
  @override
  String get categoryId;
  @override
  String get categoryName;
  @override
  String get subcategoryId;
  @override
  String get subcategoryName;
  @override
  String get conditionId;
  @override
  String get conditionName;
  @override
  String get sellerUsername;
  @override
  String get sellerAvatarUrl;
  @override
  @DateTimeConverter()
  DateTime? get createdAt;
  @override
  List<ProductImage> get images;
  @override
  List<Condition> get conditions;
  @override
  Category? get category;
  @override
  Subcategory? get subcategory;
  @override
  Seller? get seller;
  @override
  List<Tag> get tags;
  @override
  bool get isInWishlist;
  @override
  bool get isOwnProduct;

  /// Create a copy of ProductDetails
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductDetailsImplCopyWith<_$ProductDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

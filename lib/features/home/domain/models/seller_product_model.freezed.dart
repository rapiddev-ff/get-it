// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seller_product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SellerProduct _$SellerProductFromJson(Map<String, dynamic> json) {
  return _SellerProduct.fromJson(json);
}

/// @nodoc
mixin _$SellerProduct {
  String get id => throw _privateConstructorUsedError;
  String get orderId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get originalPrice => throw _privateConstructorUsedError;
  bool get flashSaleEnabled => throw _privateConstructorUsedError;
  double? get flashSalePrice => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get flashSaleEndsAt => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get viewsCount => throw _privateConstructorUsedError;
  String get conditionName => throw _privateConstructorUsedError;
  String get mainImageUrl => throw _privateConstructorUsedError;
  bool get isInWishlist => throw _privateConstructorUsedError;
  String? get discountType => throw _privateConstructorUsedError;
  double? get discountAmount => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;

  /// Serializes this SellerProduct to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SellerProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SellerProductCopyWith<SellerProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SellerProductCopyWith<$Res> {
  factory $SellerProductCopyWith(
          SellerProduct value, $Res Function(SellerProduct) then) =
      _$SellerProductCopyWithImpl<$Res, SellerProduct>;
  @useResult
  $Res call(
      {String id,
      String orderId,
      String title,
      double price,
      double originalPrice,
      bool flashSaleEnabled,
      double? flashSalePrice,
      @DateTimeConverter() DateTime? flashSaleEndsAt,
      String status,
      int viewsCount,
      String conditionName,
      String mainImageUrl,
      bool isInWishlist,
      String? discountType,
      double? discountAmount,
      @DateTimeConverter() DateTime? createdAt,
      int quantity,
      String categoryId,
      String categoryName});
}

/// @nodoc
class _$SellerProductCopyWithImpl<$Res, $Val extends SellerProduct>
    implements $SellerProductCopyWith<$Res> {
  _$SellerProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SellerProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? title = null,
    Object? price = null,
    Object? originalPrice = null,
    Object? flashSaleEnabled = null,
    Object? flashSalePrice = freezed,
    Object? flashSaleEndsAt = freezed,
    Object? status = null,
    Object? viewsCount = null,
    Object? conditionName = null,
    Object? mainImageUrl = null,
    Object? isInWishlist = null,
    Object? discountType = freezed,
    Object? discountAmount = freezed,
    Object? createdAt = freezed,
    Object? quantity = null,
    Object? categoryId = null,
    Object? categoryName = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      viewsCount: null == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      conditionName: null == conditionName
          ? _value.conditionName
          : conditionName // ignore: cast_nullable_to_non_nullable
              as String,
      mainImageUrl: null == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isInWishlist: null == isInWishlist
          ? _value.isInWishlist
          : isInWishlist // ignore: cast_nullable_to_non_nullable
              as bool,
      discountType: freezed == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String?,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SellerProductImplCopyWith<$Res>
    implements $SellerProductCopyWith<$Res> {
  factory _$$SellerProductImplCopyWith(
          _$SellerProductImpl value, $Res Function(_$SellerProductImpl) then) =
      __$$SellerProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String orderId,
      String title,
      double price,
      double originalPrice,
      bool flashSaleEnabled,
      double? flashSalePrice,
      @DateTimeConverter() DateTime? flashSaleEndsAt,
      String status,
      int viewsCount,
      String conditionName,
      String mainImageUrl,
      bool isInWishlist,
      String? discountType,
      double? discountAmount,
      @DateTimeConverter() DateTime? createdAt,
      int quantity,
      String categoryId,
      String categoryName});
}

/// @nodoc
class __$$SellerProductImplCopyWithImpl<$Res>
    extends _$SellerProductCopyWithImpl<$Res, _$SellerProductImpl>
    implements _$$SellerProductImplCopyWith<$Res> {
  __$$SellerProductImplCopyWithImpl(
      _$SellerProductImpl _value, $Res Function(_$SellerProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of SellerProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderId = null,
    Object? title = null,
    Object? price = null,
    Object? originalPrice = null,
    Object? flashSaleEnabled = null,
    Object? flashSalePrice = freezed,
    Object? flashSaleEndsAt = freezed,
    Object? status = null,
    Object? viewsCount = null,
    Object? conditionName = null,
    Object? mainImageUrl = null,
    Object? isInWishlist = null,
    Object? discountType = freezed,
    Object? discountAmount = freezed,
    Object? createdAt = freezed,
    Object? quantity = null,
    Object? categoryId = null,
    Object? categoryName = null,
  }) {
    return _then(_$SellerProductImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      orderId: null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
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
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      viewsCount: null == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      conditionName: null == conditionName
          ? _value.conditionName
          : conditionName // ignore: cast_nullable_to_non_nullable
              as String,
      mainImageUrl: null == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      isInWishlist: null == isInWishlist
          ? _value.isInWishlist
          : isInWishlist // ignore: cast_nullable_to_non_nullable
              as bool,
      discountType: freezed == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String?,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SellerProductImpl extends _SellerProduct {
  const _$SellerProductImpl(
      {this.id = '',
      this.orderId = '',
      this.title = '',
      this.price = 0.0,
      this.originalPrice = 0.0,
      this.flashSaleEnabled = false,
      this.flashSalePrice,
      @DateTimeConverter() this.flashSaleEndsAt,
      this.status = '',
      this.viewsCount = 0,
      this.conditionName = '',
      this.mainImageUrl = '',
      this.isInWishlist = false,
      this.discountType,
      this.discountAmount,
      @DateTimeConverter() this.createdAt,
      this.quantity = 0,
      this.categoryId = '',
      this.categoryName = ''})
      : super._();

  factory _$SellerProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$SellerProductImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String orderId;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final double price;
  @override
  @JsonKey()
  final double originalPrice;
  @override
  @JsonKey()
  final bool flashSaleEnabled;
  @override
  final double? flashSalePrice;
  @override
  @DateTimeConverter()
  final DateTime? flashSaleEndsAt;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final int viewsCount;
  @override
  @JsonKey()
  final String conditionName;
  @override
  @JsonKey()
  final String mainImageUrl;
  @override
  @JsonKey()
  final bool isInWishlist;
  @override
  final String? discountType;
  @override
  final double? discountAmount;
  @override
  @DateTimeConverter()
  final DateTime? createdAt;
  @override
  @JsonKey()
  final int quantity;
  @override
  @JsonKey()
  final String categoryId;
  @override
  @JsonKey()
  final String categoryName;

  @override
  String toString() {
    return 'SellerProduct(id: $id, orderId: $orderId, title: $title, price: $price, originalPrice: $originalPrice, flashSaleEnabled: $flashSaleEnabled, flashSalePrice: $flashSalePrice, flashSaleEndsAt: $flashSaleEndsAt, status: $status, viewsCount: $viewsCount, conditionName: $conditionName, mainImageUrl: $mainImageUrl, isInWishlist: $isInWishlist, discountType: $discountType, discountAmount: $discountAmount, createdAt: $createdAt, quantity: $quantity, categoryId: $categoryId, categoryName: $categoryName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SellerProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.flashSaleEnabled, flashSaleEnabled) ||
                other.flashSaleEnabled == flashSaleEnabled) &&
            (identical(other.flashSalePrice, flashSalePrice) ||
                other.flashSalePrice == flashSalePrice) &&
            (identical(other.flashSaleEndsAt, flashSaleEndsAt) ||
                other.flashSaleEndsAt == flashSaleEndsAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.viewsCount, viewsCount) ||
                other.viewsCount == viewsCount) &&
            (identical(other.conditionName, conditionName) ||
                other.conditionName == conditionName) &&
            (identical(other.mainImageUrl, mainImageUrl) ||
                other.mainImageUrl == mainImageUrl) &&
            (identical(other.isInWishlist, isInWishlist) ||
                other.isInWishlist == isInWishlist) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        orderId,
        title,
        price,
        originalPrice,
        flashSaleEnabled,
        flashSalePrice,
        flashSaleEndsAt,
        status,
        viewsCount,
        conditionName,
        mainImageUrl,
        isInWishlist,
        discountType,
        discountAmount,
        createdAt,
        quantity,
        categoryId,
        categoryName
      ]);

  /// Create a copy of SellerProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SellerProductImplCopyWith<_$SellerProductImpl> get copyWith =>
      __$$SellerProductImplCopyWithImpl<_$SellerProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SellerProductImplToJson(
      this,
    );
  }
}

abstract class _SellerProduct extends SellerProduct {
  const factory _SellerProduct(
      {final String id,
      final String orderId,
      final String title,
      final double price,
      final double originalPrice,
      final bool flashSaleEnabled,
      final double? flashSalePrice,
      @DateTimeConverter() final DateTime? flashSaleEndsAt,
      final String status,
      final int viewsCount,
      final String conditionName,
      final String mainImageUrl,
      final bool isInWishlist,
      final String? discountType,
      final double? discountAmount,
      @DateTimeConverter() final DateTime? createdAt,
      final int quantity,
      final String categoryId,
      final String categoryName}) = _$SellerProductImpl;
  const _SellerProduct._() : super._();

  factory _SellerProduct.fromJson(Map<String, dynamic> json) =
      _$SellerProductImpl.fromJson;

  @override
  String get id;
  @override
  String get orderId;
  @override
  String get title;
  @override
  double get price;
  @override
  double get originalPrice;
  @override
  bool get flashSaleEnabled;
  @override
  double? get flashSalePrice;
  @override
  @DateTimeConverter()
  DateTime? get flashSaleEndsAt;
  @override
  String get status;
  @override
  int get viewsCount;
  @override
  String get conditionName;
  @override
  String get mainImageUrl;
  @override
  bool get isInWishlist;
  @override
  String? get discountType;
  @override
  double? get discountAmount;
  @override
  @DateTimeConverter()
  DateTime? get createdAt;
  @override
  int get quantity;
  @override
  String get categoryId;
  @override
  String get categoryName;

  /// Create a copy of SellerProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SellerProductImplCopyWith<_$SellerProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

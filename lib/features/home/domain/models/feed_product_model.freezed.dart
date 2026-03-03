// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FeedProduct _$FeedProductFromJson(Map<String, dynamic> json) {
  return _FeedProduct.fromJson(json);
}

/// @nodoc
mixin _$FeedProduct {
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
  String get mainImageUrl => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  String get conditionName => throw _privateConstructorUsedError;
  String get sellerUsername => throw _privateConstructorUsedError;
  String? get sellerAvatarUrl => throw _privateConstructorUsedError;
  double get sellerRating => throw _privateConstructorUsedError;
  int get sellerTotalReviews => throw _privateConstructorUsedError;
  bool get isInWishlist => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  double get shippingPrice => throw _privateConstructorUsedError;
  bool get freeShipping => throw _privateConstructorUsedError;
  bool get useSellerShipping => throw _privateConstructorUsedError;
  double? get customFlatRate => throw _privateConstructorUsedError;
  double? get customAdditionalItemFee => throw _privateConstructorUsedError;

  /// Serializes this FeedProduct to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedProductCopyWith<FeedProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedProductCopyWith<$Res> {
  factory $FeedProductCopyWith(
          FeedProduct value, $Res Function(FeedProduct) then) =
      _$FeedProductCopyWithImpl<$Res, FeedProduct>;
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
      String mainImageUrl,
      String categoryName,
      String conditionName,
      String sellerUsername,
      String? sellerAvatarUrl,
      double sellerRating,
      int sellerTotalReviews,
      bool isInWishlist,
      @DateTimeConverter() DateTime? createdAt,
      double shippingPrice,
      bool freeShipping,
      bool useSellerShipping,
      double? customFlatRate,
      double? customAdditionalItemFee});
}

/// @nodoc
class _$FeedProductCopyWithImpl<$Res, $Val extends FeedProduct>
    implements $FeedProductCopyWith<$Res> {
  _$FeedProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedProduct
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
    Object? mainImageUrl = null,
    Object? categoryName = null,
    Object? conditionName = null,
    Object? sellerUsername = null,
    Object? sellerAvatarUrl = freezed,
    Object? sellerRating = null,
    Object? sellerTotalReviews = null,
    Object? isInWishlist = null,
    Object? createdAt = freezed,
    Object? shippingPrice = null,
    Object? freeShipping = null,
    Object? useSellerShipping = null,
    Object? customFlatRate = freezed,
    Object? customAdditionalItemFee = freezed,
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
      mainImageUrl: null == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      conditionName: null == conditionName
          ? _value.conditionName
          : conditionName // ignore: cast_nullable_to_non_nullable
              as String,
      sellerUsername: null == sellerUsername
          ? _value.sellerUsername
          : sellerUsername // ignore: cast_nullable_to_non_nullable
              as String,
      sellerAvatarUrl: freezed == sellerAvatarUrl
          ? _value.sellerAvatarUrl
          : sellerAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sellerRating: null == sellerRating
          ? _value.sellerRating
          : sellerRating // ignore: cast_nullable_to_non_nullable
              as double,
      sellerTotalReviews: null == sellerTotalReviews
          ? _value.sellerTotalReviews
          : sellerTotalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      isInWishlist: null == isInWishlist
          ? _value.isInWishlist
          : isInWishlist // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeedProductImplCopyWith<$Res>
    implements $FeedProductCopyWith<$Res> {
  factory _$$FeedProductImplCopyWith(
          _$FeedProductImpl value, $Res Function(_$FeedProductImpl) then) =
      __$$FeedProductImplCopyWithImpl<$Res>;
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
      String mainImageUrl,
      String categoryName,
      String conditionName,
      String sellerUsername,
      String? sellerAvatarUrl,
      double sellerRating,
      int sellerTotalReviews,
      bool isInWishlist,
      @DateTimeConverter() DateTime? createdAt,
      double shippingPrice,
      bool freeShipping,
      bool useSellerShipping,
      double? customFlatRate,
      double? customAdditionalItemFee});
}

/// @nodoc
class __$$FeedProductImplCopyWithImpl<$Res>
    extends _$FeedProductCopyWithImpl<$Res, _$FeedProductImpl>
    implements _$$FeedProductImplCopyWith<$Res> {
  __$$FeedProductImplCopyWithImpl(
      _$FeedProductImpl _value, $Res Function(_$FeedProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeedProduct
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
    Object? mainImageUrl = null,
    Object? categoryName = null,
    Object? conditionName = null,
    Object? sellerUsername = null,
    Object? sellerAvatarUrl = freezed,
    Object? sellerRating = null,
    Object? sellerTotalReviews = null,
    Object? isInWishlist = null,
    Object? createdAt = freezed,
    Object? shippingPrice = null,
    Object? freeShipping = null,
    Object? useSellerShipping = null,
    Object? customFlatRate = freezed,
    Object? customAdditionalItemFee = freezed,
  }) {
    return _then(_$FeedProductImpl(
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
      mainImageUrl: null == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      conditionName: null == conditionName
          ? _value.conditionName
          : conditionName // ignore: cast_nullable_to_non_nullable
              as String,
      sellerUsername: null == sellerUsername
          ? _value.sellerUsername
          : sellerUsername // ignore: cast_nullable_to_non_nullable
              as String,
      sellerAvatarUrl: freezed == sellerAvatarUrl
          ? _value.sellerAvatarUrl
          : sellerAvatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sellerRating: null == sellerRating
          ? _value.sellerRating
          : sellerRating // ignore: cast_nullable_to_non_nullable
              as double,
      sellerTotalReviews: null == sellerTotalReviews
          ? _value.sellerTotalReviews
          : sellerTotalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      isInWishlist: null == isInWishlist
          ? _value.isInWishlist
          : isInWishlist // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedProductImpl extends _FeedProduct {
  const _$FeedProductImpl(
      {this.id = '',
      this.sellerId = '',
      this.title = '',
      this.description = '',
      this.price = 0.0,
      this.originalPrice,
      this.flashSaleEnabled = false,
      this.flashSalePrice,
      @DateTimeConverter() this.flashSaleEndsAt,
      this.mainImageUrl = '',
      this.categoryName = '',
      this.conditionName = '',
      this.sellerUsername = '',
      this.sellerAvatarUrl,
      this.sellerRating = 0.0,
      this.sellerTotalReviews = 0,
      this.isInWishlist = false,
      @DateTimeConverter() this.createdAt,
      this.shippingPrice = 0.0,
      this.freeShipping = false,
      this.useSellerShipping = false,
      this.customFlatRate,
      this.customAdditionalItemFee})
      : super._();

  factory _$FeedProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedProductImplFromJson(json);

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
  @JsonKey()
  final String mainImageUrl;
  @override
  @JsonKey()
  final String categoryName;
  @override
  @JsonKey()
  final String conditionName;
  @override
  @JsonKey()
  final String sellerUsername;
  @override
  final String? sellerAvatarUrl;
  @override
  @JsonKey()
  final double sellerRating;
  @override
  @JsonKey()
  final int sellerTotalReviews;
  @override
  @JsonKey()
  final bool isInWishlist;
  @override
  @DateTimeConverter()
  final DateTime? createdAt;
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
  String toString() {
    return 'FeedProduct(id: $id, sellerId: $sellerId, title: $title, description: $description, price: $price, originalPrice: $originalPrice, flashSaleEnabled: $flashSaleEnabled, flashSalePrice: $flashSalePrice, flashSaleEndsAt: $flashSaleEndsAt, mainImageUrl: $mainImageUrl, categoryName: $categoryName, conditionName: $conditionName, sellerUsername: $sellerUsername, sellerAvatarUrl: $sellerAvatarUrl, sellerRating: $sellerRating, sellerTotalReviews: $sellerTotalReviews, isInWishlist: $isInWishlist, createdAt: $createdAt, shippingPrice: $shippingPrice, freeShipping: $freeShipping, useSellerShipping: $useSellerShipping, customFlatRate: $customFlatRate, customAdditionalItemFee: $customAdditionalItemFee)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedProductImpl &&
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
            (identical(other.mainImageUrl, mainImageUrl) ||
                other.mainImageUrl == mainImageUrl) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.conditionName, conditionName) ||
                other.conditionName == conditionName) &&
            (identical(other.sellerUsername, sellerUsername) ||
                other.sellerUsername == sellerUsername) &&
            (identical(other.sellerAvatarUrl, sellerAvatarUrl) ||
                other.sellerAvatarUrl == sellerAvatarUrl) &&
            (identical(other.sellerRating, sellerRating) ||
                other.sellerRating == sellerRating) &&
            (identical(other.sellerTotalReviews, sellerTotalReviews) ||
                other.sellerTotalReviews == sellerTotalReviews) &&
            (identical(other.isInWishlist, isInWishlist) ||
                other.isInWishlist == isInWishlist) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
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
                other.customAdditionalItemFee == customAdditionalItemFee));
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
        mainImageUrl,
        categoryName,
        conditionName,
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

  /// Create a copy of FeedProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedProductImplCopyWith<_$FeedProductImpl> get copyWith =>
      __$$FeedProductImplCopyWithImpl<_$FeedProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedProductImplToJson(
      this,
    );
  }
}

abstract class _FeedProduct extends FeedProduct {
  const factory _FeedProduct(
      {final String id,
      final String sellerId,
      final String title,
      final String description,
      final double price,
      final double? originalPrice,
      final bool flashSaleEnabled,
      final double? flashSalePrice,
      @DateTimeConverter() final DateTime? flashSaleEndsAt,
      final String mainImageUrl,
      final String categoryName,
      final String conditionName,
      final String sellerUsername,
      final String? sellerAvatarUrl,
      final double sellerRating,
      final int sellerTotalReviews,
      final bool isInWishlist,
      @DateTimeConverter() final DateTime? createdAt,
      final double shippingPrice,
      final bool freeShipping,
      final bool useSellerShipping,
      final double? customFlatRate,
      final double? customAdditionalItemFee}) = _$FeedProductImpl;
  const _FeedProduct._() : super._();

  factory _FeedProduct.fromJson(Map<String, dynamic> json) =
      _$FeedProductImpl.fromJson;

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
  String get mainImageUrl;
  @override
  String get categoryName;
  @override
  String get conditionName;
  @override
  String get sellerUsername;
  @override
  String? get sellerAvatarUrl;
  @override
  double get sellerRating;
  @override
  int get sellerTotalReviews;
  @override
  bool get isInWishlist;
  @override
  @DateTimeConverter()
  DateTime? get createdAt;
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

  /// Create a copy of FeedProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedProductImplCopyWith<_$FeedProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

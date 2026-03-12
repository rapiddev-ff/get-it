// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'browse_product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BrowseProduct _$BrowseProductFromJson(Map<String, dynamic> json) {
  return _BrowseProduct.fromJson(json);
}

/// @nodoc
mixin _$BrowseProduct {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get originalPrice => throw _privateConstructorUsedError;
  bool get flashSaleEnabled => throw _privateConstructorUsedError;
  double? get flashSalePrice => throw _privateConstructorUsedError;
  String get mainImageUrl => throw _privateConstructorUsedError;
  String get conditionName => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  bool get isInWishlist => throw _privateConstructorUsedError;
  String get sellerUsername => throw _privateConstructorUsedError;
  String? get discountType => throw _privateConstructorUsedError;
  double? get discountAmount => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this BrowseProduct to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BrowseProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BrowseProductCopyWith<BrowseProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BrowseProductCopyWith<$Res> {
  factory $BrowseProductCopyWith(
          BrowseProduct value, $Res Function(BrowseProduct) then) =
      _$BrowseProductCopyWithImpl<$Res, BrowseProduct>;
  @useResult
  $Res call(
      {String id,
      String title,
      double price,
      double originalPrice,
      bool flashSaleEnabled,
      double? flashSalePrice,
      String mainImageUrl,
      String conditionName,
      String categoryName,
      bool isInWishlist,
      String sellerUsername,
      String? discountType,
      double? discountAmount,
      @DateTimeConverter() DateTime? createdAt});
}

/// @nodoc
class _$BrowseProductCopyWithImpl<$Res, $Val extends BrowseProduct>
    implements $BrowseProductCopyWith<$Res> {
  _$BrowseProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BrowseProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? price = null,
    Object? originalPrice = null,
    Object? flashSaleEnabled = null,
    Object? flashSalePrice = freezed,
    Object? mainImageUrl = null,
    Object? conditionName = null,
    Object? categoryName = null,
    Object? isInWishlist = null,
    Object? sellerUsername = null,
    Object? discountType = freezed,
    Object? discountAmount = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
      mainImageUrl: null == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      conditionName: null == conditionName
          ? _value.conditionName
          : conditionName // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      isInWishlist: null == isInWishlist
          ? _value.isInWishlist
          : isInWishlist // ignore: cast_nullable_to_non_nullable
              as bool,
      sellerUsername: null == sellerUsername
          ? _value.sellerUsername
          : sellerUsername // ignore: cast_nullable_to_non_nullable
              as String,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BrowseProductImplCopyWith<$Res>
    implements $BrowseProductCopyWith<$Res> {
  factory _$$BrowseProductImplCopyWith(
          _$BrowseProductImpl value, $Res Function(_$BrowseProductImpl) then) =
      __$$BrowseProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      double price,
      double originalPrice,
      bool flashSaleEnabled,
      double? flashSalePrice,
      String mainImageUrl,
      String conditionName,
      String categoryName,
      bool isInWishlist,
      String sellerUsername,
      String? discountType,
      double? discountAmount,
      @DateTimeConverter() DateTime? createdAt});
}

/// @nodoc
class __$$BrowseProductImplCopyWithImpl<$Res>
    extends _$BrowseProductCopyWithImpl<$Res, _$BrowseProductImpl>
    implements _$$BrowseProductImplCopyWith<$Res> {
  __$$BrowseProductImplCopyWithImpl(
      _$BrowseProductImpl _value, $Res Function(_$BrowseProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of BrowseProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? price = null,
    Object? originalPrice = null,
    Object? flashSaleEnabled = null,
    Object? flashSalePrice = freezed,
    Object? mainImageUrl = null,
    Object? conditionName = null,
    Object? categoryName = null,
    Object? isInWishlist = null,
    Object? sellerUsername = null,
    Object? discountType = freezed,
    Object? discountAmount = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$BrowseProductImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
      mainImageUrl: null == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      conditionName: null == conditionName
          ? _value.conditionName
          : conditionName // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      isInWishlist: null == isInWishlist
          ? _value.isInWishlist
          : isInWishlist // ignore: cast_nullable_to_non_nullable
              as bool,
      sellerUsername: null == sellerUsername
          ? _value.sellerUsername
          : sellerUsername // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$BrowseProductImpl extends _BrowseProduct {
  const _$BrowseProductImpl(
      {this.id = '',
      this.title = '',
      this.price = 0.0,
      this.originalPrice = 0.0,
      this.flashSaleEnabled = false,
      this.flashSalePrice,
      this.mainImageUrl = '',
      this.conditionName = '',
      this.categoryName = '',
      this.isInWishlist = false,
      this.sellerUsername = '',
      this.discountType,
      this.discountAmount,
      @DateTimeConverter() this.createdAt})
      : super._();

  factory _$BrowseProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$BrowseProductImplFromJson(json);

  @override
  @JsonKey()
  final String id;
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
  @JsonKey()
  final String mainImageUrl;
  @override
  @JsonKey()
  final String conditionName;
  @override
  @JsonKey()
  final String categoryName;
  @override
  @JsonKey()
  final bool isInWishlist;
  @override
  @JsonKey()
  final String sellerUsername;
  @override
  final String? discountType;
  @override
  final double? discountAmount;
  @override
  @DateTimeConverter()
  final DateTime? createdAt;

  @override
  String toString() {
    return 'BrowseProduct(id: $id, title: $title, price: $price, originalPrice: $originalPrice, flashSaleEnabled: $flashSaleEnabled, flashSalePrice: $flashSalePrice, mainImageUrl: $mainImageUrl, conditionName: $conditionName, categoryName: $categoryName, isInWishlist: $isInWishlist, sellerUsername: $sellerUsername, discountType: $discountType, discountAmount: $discountAmount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BrowseProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.flashSaleEnabled, flashSaleEnabled) ||
                other.flashSaleEnabled == flashSaleEnabled) &&
            (identical(other.flashSalePrice, flashSalePrice) ||
                other.flashSalePrice == flashSalePrice) &&
            (identical(other.mainImageUrl, mainImageUrl) ||
                other.mainImageUrl == mainImageUrl) &&
            (identical(other.conditionName, conditionName) ||
                other.conditionName == conditionName) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.isInWishlist, isInWishlist) ||
                other.isInWishlist == isInWishlist) &&
            (identical(other.sellerUsername, sellerUsername) ||
                other.sellerUsername == sellerUsername) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      price,
      originalPrice,
      flashSaleEnabled,
      flashSalePrice,
      mainImageUrl,
      conditionName,
      categoryName,
      isInWishlist,
      sellerUsername,
      discountType,
      discountAmount,
      createdAt);

  /// Create a copy of BrowseProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BrowseProductImplCopyWith<_$BrowseProductImpl> get copyWith =>
      __$$BrowseProductImplCopyWithImpl<_$BrowseProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BrowseProductImplToJson(
      this,
    );
  }
}

abstract class _BrowseProduct extends BrowseProduct {
  const factory _BrowseProduct(
      {final String id,
      final String title,
      final double price,
      final double originalPrice,
      final bool flashSaleEnabled,
      final double? flashSalePrice,
      final String mainImageUrl,
      final String conditionName,
      final String categoryName,
      final bool isInWishlist,
      final String sellerUsername,
      final String? discountType,
      final double? discountAmount,
      @DateTimeConverter() final DateTime? createdAt}) = _$BrowseProductImpl;
  const _BrowseProduct._() : super._();

  factory _BrowseProduct.fromJson(Map<String, dynamic> json) =
      _$BrowseProductImpl.fromJson;

  @override
  String get id;
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
  String get mainImageUrl;
  @override
  String get conditionName;
  @override
  String get categoryName;
  @override
  bool get isInWishlist;
  @override
  String get sellerUsername;
  @override
  String? get discountType;
  @override
  double? get discountAmount;
  @override
  @DateTimeConverter()
  DateTime? get createdAt;

  /// Create a copy of BrowseProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BrowseProductImplCopyWith<_$BrowseProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shortlist_product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShortlistProduct _$ShortlistProductFromJson(Map<String, dynamic> json) {
  return _ShortlistProduct.fromJson(json);
}

/// @nodoc
mixin _$ShortlistProduct {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get originalPrice => throw _privateConstructorUsedError;
  bool get flashSaleEnabled => throw _privateConstructorUsedError;
  double? get flashSalePrice => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get flashSaleEndsAt => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  int get reservedQuantity => throw _privateConstructorUsedError;
  int get availableQuantity => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  String get subcategoryId => throw _privateConstructorUsedError;
  String get subcategoryName => throw _privateConstructorUsedError;
  String get mainImageUrl => throw _privateConstructorUsedError;
  String? get discountType => throw _privateConstructorUsedError;
  double? get discountAmount => throw _privateConstructorUsedError;

  /// Serializes this ShortlistProduct to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShortlistProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShortlistProductCopyWith<ShortlistProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShortlistProductCopyWith<$Res> {
  factory $ShortlistProductCopyWith(
          ShortlistProduct value, $Res Function(ShortlistProduct) then) =
      _$ShortlistProductCopyWithImpl<$Res, ShortlistProduct>;
  @useResult
  $Res call(
      {String id,
      String title,
      double price,
      double originalPrice,
      bool flashSaleEnabled,
      double? flashSalePrice,
      @DateTimeConverter() DateTime? flashSaleEndsAt,
      int quantity,
      int reservedQuantity,
      int availableQuantity,
      String categoryId,
      String categoryName,
      String subcategoryId,
      String subcategoryName,
      String mainImageUrl,
      String? discountType,
      double? discountAmount});
}

/// @nodoc
class _$ShortlistProductCopyWithImpl<$Res, $Val extends ShortlistProduct>
    implements $ShortlistProductCopyWith<$Res> {
  _$ShortlistProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShortlistProduct
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
    Object? flashSaleEndsAt = freezed,
    Object? quantity = null,
    Object? reservedQuantity = null,
    Object? availableQuantity = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? subcategoryId = null,
    Object? subcategoryName = null,
    Object? mainImageUrl = null,
    Object? discountType = freezed,
    Object? discountAmount = freezed,
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
      flashSaleEndsAt: freezed == flashSaleEndsAt
          ? _value.flashSaleEndsAt
          : flashSaleEndsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      reservedQuantity: null == reservedQuantity
          ? _value.reservedQuantity
          : reservedQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      availableQuantity: null == availableQuantity
          ? _value.availableQuantity
          : availableQuantity // ignore: cast_nullable_to_non_nullable
              as int,
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
      mainImageUrl: null == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      discountType: freezed == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String?,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShortlistProductImplCopyWith<$Res>
    implements $ShortlistProductCopyWith<$Res> {
  factory _$$ShortlistProductImplCopyWith(_$ShortlistProductImpl value,
          $Res Function(_$ShortlistProductImpl) then) =
      __$$ShortlistProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      double price,
      double originalPrice,
      bool flashSaleEnabled,
      double? flashSalePrice,
      @DateTimeConverter() DateTime? flashSaleEndsAt,
      int quantity,
      int reservedQuantity,
      int availableQuantity,
      String categoryId,
      String categoryName,
      String subcategoryId,
      String subcategoryName,
      String mainImageUrl,
      String? discountType,
      double? discountAmount});
}

/// @nodoc
class __$$ShortlistProductImplCopyWithImpl<$Res>
    extends _$ShortlistProductCopyWithImpl<$Res, _$ShortlistProductImpl>
    implements _$$ShortlistProductImplCopyWith<$Res> {
  __$$ShortlistProductImplCopyWithImpl(_$ShortlistProductImpl _value,
      $Res Function(_$ShortlistProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShortlistProduct
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
    Object? flashSaleEndsAt = freezed,
    Object? quantity = null,
    Object? reservedQuantity = null,
    Object? availableQuantity = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? subcategoryId = null,
    Object? subcategoryName = null,
    Object? mainImageUrl = null,
    Object? discountType = freezed,
    Object? discountAmount = freezed,
  }) {
    return _then(_$ShortlistProductImpl(
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
      flashSaleEndsAt: freezed == flashSaleEndsAt
          ? _value.flashSaleEndsAt
          : flashSaleEndsAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      reservedQuantity: null == reservedQuantity
          ? _value.reservedQuantity
          : reservedQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      availableQuantity: null == availableQuantity
          ? _value.availableQuantity
          : availableQuantity // ignore: cast_nullable_to_non_nullable
              as int,
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
      mainImageUrl: null == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      discountType: freezed == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String?,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ShortlistProductImpl extends _ShortlistProduct {
  const _$ShortlistProductImpl(
      {this.id = '',
      this.title = '',
      this.price = 0.0,
      this.originalPrice = 0.0,
      this.flashSaleEnabled = false,
      this.flashSalePrice,
      @DateTimeConverter() this.flashSaleEndsAt,
      this.quantity = 0,
      this.reservedQuantity = 0,
      this.availableQuantity = 0,
      this.categoryId = '',
      this.categoryName = '',
      this.subcategoryId = '',
      this.subcategoryName = '',
      this.mainImageUrl = '',
      this.discountType,
      this.discountAmount})
      : super._();

  factory _$ShortlistProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShortlistProductImplFromJson(json);

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
  @DateTimeConverter()
  final DateTime? flashSaleEndsAt;
  @override
  @JsonKey()
  final int quantity;
  @override
  @JsonKey()
  final int reservedQuantity;
  @override
  @JsonKey()
  final int availableQuantity;
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
  final String mainImageUrl;
  @override
  final String? discountType;
  @override
  final double? discountAmount;

  @override
  String toString() {
    return 'ShortlistProduct(id: $id, title: $title, price: $price, originalPrice: $originalPrice, flashSaleEnabled: $flashSaleEnabled, flashSalePrice: $flashSalePrice, flashSaleEndsAt: $flashSaleEndsAt, quantity: $quantity, reservedQuantity: $reservedQuantity, availableQuantity: $availableQuantity, categoryId: $categoryId, categoryName: $categoryName, subcategoryId: $subcategoryId, subcategoryName: $subcategoryName, mainImageUrl: $mainImageUrl, discountType: $discountType, discountAmount: $discountAmount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShortlistProductImpl &&
            (identical(other.id, id) || other.id == id) &&
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
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.reservedQuantity, reservedQuantity) ||
                other.reservedQuantity == reservedQuantity) &&
            (identical(other.availableQuantity, availableQuantity) ||
                other.availableQuantity == availableQuantity) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            (identical(other.subcategoryName, subcategoryName) ||
                other.subcategoryName == subcategoryName) &&
            (identical(other.mainImageUrl, mainImageUrl) ||
                other.mainImageUrl == mainImageUrl) &&
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount));
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
      flashSaleEndsAt,
      quantity,
      reservedQuantity,
      availableQuantity,
      categoryId,
      categoryName,
      subcategoryId,
      subcategoryName,
      mainImageUrl,
      discountType,
      discountAmount);

  /// Create a copy of ShortlistProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShortlistProductImplCopyWith<_$ShortlistProductImpl> get copyWith =>
      __$$ShortlistProductImplCopyWithImpl<_$ShortlistProductImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShortlistProductImplToJson(
      this,
    );
  }
}

abstract class _ShortlistProduct extends ShortlistProduct {
  const factory _ShortlistProduct(
      {final String id,
      final String title,
      final double price,
      final double originalPrice,
      final bool flashSaleEnabled,
      final double? flashSalePrice,
      @DateTimeConverter() final DateTime? flashSaleEndsAt,
      final int quantity,
      final int reservedQuantity,
      final int availableQuantity,
      final String categoryId,
      final String categoryName,
      final String subcategoryId,
      final String subcategoryName,
      final String mainImageUrl,
      final String? discountType,
      final double? discountAmount}) = _$ShortlistProductImpl;
  const _ShortlistProduct._() : super._();

  factory _ShortlistProduct.fromJson(Map<String, dynamic> json) =
      _$ShortlistProductImpl.fromJson;

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
  @DateTimeConverter()
  DateTime? get flashSaleEndsAt;
  @override
  int get quantity;
  @override
  int get reservedQuantity;
  @override
  int get availableQuantity;
  @override
  String get categoryId;
  @override
  String get categoryName;
  @override
  String get subcategoryId;
  @override
  String get subcategoryName;
  @override
  String get mainImageUrl;
  @override
  String? get discountType;
  @override
  double? get discountAmount;

  /// Create a copy of ShortlistProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShortlistProductImplCopyWith<_$ShortlistProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

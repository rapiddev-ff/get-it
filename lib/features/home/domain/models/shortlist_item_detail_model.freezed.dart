// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shortlist_item_detail_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShortlistItemDetail _$ShortlistItemDetailFromJson(Map<String, dynamic> json) {
  return _ShortlistItemDetail.fromJson(json);
}

/// @nodoc
mixin _$ShortlistItemDetail {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String get itemStatus => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get reservedAt => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get originalPrice => throw _privateConstructorUsedError;
  bool get flashSaleEnabled => throw _privateConstructorUsedError;
  double? get flashSalePrice => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get flashSaleEndsAt => throw _privateConstructorUsedError;
  String? get discountType => throw _privateConstructorUsedError;
  double? get discountAmount => throw _privateConstructorUsedError;
  String get productStatus => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  String get subcategoryName => throw _privateConstructorUsedError;
  String get mainImageUrl => throw _privateConstructorUsedError;

  /// Serializes this ShortlistItemDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShortlistItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShortlistItemDetailCopyWith<ShortlistItemDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShortlistItemDetailCopyWith<$Res> {
  factory $ShortlistItemDetailCopyWith(
          ShortlistItemDetail value, $Res Function(ShortlistItemDetail) then) =
      _$ShortlistItemDetailCopyWithImpl<$Res, ShortlistItemDetail>;
  @useResult
  $Res call(
      {String id,
      String productId,
      int quantity,
      String itemStatus,
      int sortOrder,
      @DateTimeConverter() DateTime? reservedAt,
      String title,
      double price,
      double originalPrice,
      bool flashSaleEnabled,
      double? flashSalePrice,
      @DateTimeConverter() DateTime? flashSaleEndsAt,
      String? discountType,
      double? discountAmount,
      String productStatus,
      String categoryName,
      String subcategoryName,
      String mainImageUrl});
}

/// @nodoc
class _$ShortlistItemDetailCopyWithImpl<$Res, $Val extends ShortlistItemDetail>
    implements $ShortlistItemDetailCopyWith<$Res> {
  _$ShortlistItemDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShortlistItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? quantity = null,
    Object? itemStatus = null,
    Object? sortOrder = null,
    Object? reservedAt = freezed,
    Object? title = null,
    Object? price = null,
    Object? originalPrice = null,
    Object? flashSaleEnabled = null,
    Object? flashSalePrice = freezed,
    Object? flashSaleEndsAt = freezed,
    Object? discountType = freezed,
    Object? discountAmount = freezed,
    Object? productStatus = null,
    Object? categoryName = null,
    Object? subcategoryName = null,
    Object? mainImageUrl = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      itemStatus: null == itemStatus
          ? _value.itemStatus
          : itemStatus // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      reservedAt: freezed == reservedAt
          ? _value.reservedAt
          : reservedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      discountType: freezed == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String?,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      productStatus: null == productStatus
          ? _value.productStatus
          : productStatus // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      subcategoryName: null == subcategoryName
          ? _value.subcategoryName
          : subcategoryName // ignore: cast_nullable_to_non_nullable
              as String,
      mainImageUrl: null == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShortlistItemDetailImplCopyWith<$Res>
    implements $ShortlistItemDetailCopyWith<$Res> {
  factory _$$ShortlistItemDetailImplCopyWith(_$ShortlistItemDetailImpl value,
          $Res Function(_$ShortlistItemDetailImpl) then) =
      __$$ShortlistItemDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String productId,
      int quantity,
      String itemStatus,
      int sortOrder,
      @DateTimeConverter() DateTime? reservedAt,
      String title,
      double price,
      double originalPrice,
      bool flashSaleEnabled,
      double? flashSalePrice,
      @DateTimeConverter() DateTime? flashSaleEndsAt,
      String? discountType,
      double? discountAmount,
      String productStatus,
      String categoryName,
      String subcategoryName,
      String mainImageUrl});
}

/// @nodoc
class __$$ShortlistItemDetailImplCopyWithImpl<$Res>
    extends _$ShortlistItemDetailCopyWithImpl<$Res, _$ShortlistItemDetailImpl>
    implements _$$ShortlistItemDetailImplCopyWith<$Res> {
  __$$ShortlistItemDetailImplCopyWithImpl(_$ShortlistItemDetailImpl _value,
      $Res Function(_$ShortlistItemDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShortlistItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? quantity = null,
    Object? itemStatus = null,
    Object? sortOrder = null,
    Object? reservedAt = freezed,
    Object? title = null,
    Object? price = null,
    Object? originalPrice = null,
    Object? flashSaleEnabled = null,
    Object? flashSalePrice = freezed,
    Object? flashSaleEndsAt = freezed,
    Object? discountType = freezed,
    Object? discountAmount = freezed,
    Object? productStatus = null,
    Object? categoryName = null,
    Object? subcategoryName = null,
    Object? mainImageUrl = null,
  }) {
    return _then(_$ShortlistItemDetailImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      itemStatus: null == itemStatus
          ? _value.itemStatus
          : itemStatus // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
      reservedAt: freezed == reservedAt
          ? _value.reservedAt
          : reservedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      discountType: freezed == discountType
          ? _value.discountType
          : discountType // ignore: cast_nullable_to_non_nullable
              as String?,
      discountAmount: freezed == discountAmount
          ? _value.discountAmount
          : discountAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      productStatus: null == productStatus
          ? _value.productStatus
          : productStatus // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      subcategoryName: null == subcategoryName
          ? _value.subcategoryName
          : subcategoryName // ignore: cast_nullable_to_non_nullable
              as String,
      mainImageUrl: null == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$ShortlistItemDetailImpl extends _ShortlistItemDetail {
  const _$ShortlistItemDetailImpl(
      {this.id = '',
      this.productId = '',
      this.quantity = 1,
      this.itemStatus = 'active',
      this.sortOrder = 0,
      @DateTimeConverter() this.reservedAt,
      this.title = '',
      this.price = 0.0,
      this.originalPrice = 0.0,
      this.flashSaleEnabled = false,
      this.flashSalePrice,
      @DateTimeConverter() this.flashSaleEndsAt,
      this.discountType,
      this.discountAmount,
      this.productStatus = '',
      this.categoryName = '',
      this.subcategoryName = '',
      this.mainImageUrl = ''})
      : super._();

  factory _$ShortlistItemDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShortlistItemDetailImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String productId;
  @override
  @JsonKey()
  final int quantity;
  @override
  @JsonKey()
  final String itemStatus;
  @override
  @JsonKey()
  final int sortOrder;
  @override
  @DateTimeConverter()
  final DateTime? reservedAt;
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
  final String? discountType;
  @override
  final double? discountAmount;
  @override
  @JsonKey()
  final String productStatus;
  @override
  @JsonKey()
  final String categoryName;
  @override
  @JsonKey()
  final String subcategoryName;
  @override
  @JsonKey()
  final String mainImageUrl;

  @override
  String toString() {
    return 'ShortlistItemDetail(id: $id, productId: $productId, quantity: $quantity, itemStatus: $itemStatus, sortOrder: $sortOrder, reservedAt: $reservedAt, title: $title, price: $price, originalPrice: $originalPrice, flashSaleEnabled: $flashSaleEnabled, flashSalePrice: $flashSalePrice, flashSaleEndsAt: $flashSaleEndsAt, discountType: $discountType, discountAmount: $discountAmount, productStatus: $productStatus, categoryName: $categoryName, subcategoryName: $subcategoryName, mainImageUrl: $mainImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShortlistItemDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.itemStatus, itemStatus) ||
                other.itemStatus == itemStatus) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder) &&
            (identical(other.reservedAt, reservedAt) ||
                other.reservedAt == reservedAt) &&
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
            (identical(other.discountType, discountType) ||
                other.discountType == discountType) &&
            (identical(other.discountAmount, discountAmount) ||
                other.discountAmount == discountAmount) &&
            (identical(other.productStatus, productStatus) ||
                other.productStatus == productStatus) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.subcategoryName, subcategoryName) ||
                other.subcategoryName == subcategoryName) &&
            (identical(other.mainImageUrl, mainImageUrl) ||
                other.mainImageUrl == mainImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      productId,
      quantity,
      itemStatus,
      sortOrder,
      reservedAt,
      title,
      price,
      originalPrice,
      flashSaleEnabled,
      flashSalePrice,
      flashSaleEndsAt,
      discountType,
      discountAmount,
      productStatus,
      categoryName,
      subcategoryName,
      mainImageUrl);

  /// Create a copy of ShortlistItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShortlistItemDetailImplCopyWith<_$ShortlistItemDetailImpl> get copyWith =>
      __$$ShortlistItemDetailImplCopyWithImpl<_$ShortlistItemDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShortlistItemDetailImplToJson(
      this,
    );
  }
}

abstract class _ShortlistItemDetail extends ShortlistItemDetail {
  const factory _ShortlistItemDetail(
      {final String id,
      final String productId,
      final int quantity,
      final String itemStatus,
      final int sortOrder,
      @DateTimeConverter() final DateTime? reservedAt,
      final String title,
      final double price,
      final double originalPrice,
      final bool flashSaleEnabled,
      final double? flashSalePrice,
      @DateTimeConverter() final DateTime? flashSaleEndsAt,
      final String? discountType,
      final double? discountAmount,
      final String productStatus,
      final String categoryName,
      final String subcategoryName,
      final String mainImageUrl}) = _$ShortlistItemDetailImpl;
  const _ShortlistItemDetail._() : super._();

  factory _ShortlistItemDetail.fromJson(Map<String, dynamic> json) =
      _$ShortlistItemDetailImpl.fromJson;

  @override
  String get id;
  @override
  String get productId;
  @override
  int get quantity;
  @override
  String get itemStatus;
  @override
  int get sortOrder;
  @override
  @DateTimeConverter()
  DateTime? get reservedAt;
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
  String? get discountType;
  @override
  double? get discountAmount;
  @override
  String get productStatus;
  @override
  String get categoryName;
  @override
  String get subcategoryName;
  @override
  String get mainImageUrl;

  /// Create a copy of ShortlistItemDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShortlistItemDetailImplCopyWith<_$ShortlistItemDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

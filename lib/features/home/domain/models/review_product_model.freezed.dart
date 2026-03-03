// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReviewProduct _$ReviewProductFromJson(Map<String, dynamic> json) {
  return _ReviewProduct.fromJson(json);
}

/// @nodoc
mixin _$ReviewProduct {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get mainImageUrl => throw _privateConstructorUsedError;

  /// Serializes this ReviewProduct to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewProductCopyWith<ReviewProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewProductCopyWith<$Res> {
  factory $ReviewProductCopyWith(
          ReviewProduct value, $Res Function(ReviewProduct) then) =
      _$ReviewProductCopyWithImpl<$Res, ReviewProduct>;
  @useResult
  $Res call({String id, String title, double price, String mainImageUrl});
}

/// @nodoc
class _$ReviewProductCopyWithImpl<$Res, $Val extends ReviewProduct>
    implements $ReviewProductCopyWith<$Res> {
  _$ReviewProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? price = null,
    Object? mainImageUrl = null,
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
      mainImageUrl: null == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewProductImplCopyWith<$Res>
    implements $ReviewProductCopyWith<$Res> {
  factory _$$ReviewProductImplCopyWith(
          _$ReviewProductImpl value, $Res Function(_$ReviewProductImpl) then) =
      __$$ReviewProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, double price, String mainImageUrl});
}

/// @nodoc
class __$$ReviewProductImplCopyWithImpl<$Res>
    extends _$ReviewProductCopyWithImpl<$Res, _$ReviewProductImpl>
    implements _$$ReviewProductImplCopyWith<$Res> {
  __$$ReviewProductImplCopyWithImpl(
      _$ReviewProductImpl _value, $Res Function(_$ReviewProductImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReviewProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? price = null,
    Object? mainImageUrl = null,
  }) {
    return _then(_$ReviewProductImpl(
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
      mainImageUrl: null == mainImageUrl
          ? _value.mainImageUrl
          : mainImageUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewProductImpl extends _ReviewProduct {
  const _$ReviewProductImpl(
      {this.id = '', this.title = '', this.price = 0.0, this.mainImageUrl = ''})
      : super._();

  factory _$ReviewProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewProductImplFromJson(json);

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
  final String mainImageUrl;

  @override
  String toString() {
    return 'ReviewProduct(id: $id, title: $title, price: $price, mainImageUrl: $mainImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.mainImageUrl, mainImageUrl) ||
                other.mainImageUrl == mainImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, price, mainImageUrl);

  /// Create a copy of ReviewProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewProductImplCopyWith<_$ReviewProductImpl> get copyWith =>
      __$$ReviewProductImplCopyWithImpl<_$ReviewProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewProductImplToJson(
      this,
    );
  }
}

abstract class _ReviewProduct extends ReviewProduct {
  const factory _ReviewProduct(
      {final String id,
      final String title,
      final double price,
      final String mainImageUrl}) = _$ReviewProductImpl;
  const _ReviewProduct._() : super._();

  factory _ReviewProduct.fromJson(Map<String, dynamic> json) =
      _$ReviewProductImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  double get price;
  @override
  String get mainImageUrl;

  /// Create a copy of ReviewProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewProductImplCopyWith<_$ReviewProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shortlist_cover_image_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShortlistCoverImage _$ShortlistCoverImageFromJson(Map<String, dynamic> json) {
  return _ShortlistCoverImage.fromJson(json);
}

/// @nodoc
mixin _$ShortlistCoverImage {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  int get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this ShortlistCoverImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShortlistCoverImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShortlistCoverImageCopyWith<ShortlistCoverImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShortlistCoverImageCopyWith<$Res> {
  factory $ShortlistCoverImageCopyWith(
          ShortlistCoverImage value, $Res Function(ShortlistCoverImage) then) =
      _$ShortlistCoverImageCopyWithImpl<$Res, ShortlistCoverImage>;
  @useResult
  $Res call({String id, String productId, String imageUrl, int sortOrder});
}

/// @nodoc
class _$ShortlistCoverImageCopyWithImpl<$Res, $Val extends ShortlistCoverImage>
    implements $ShortlistCoverImageCopyWith<$Res> {
  _$ShortlistCoverImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShortlistCoverImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? imageUrl = null,
    Object? sortOrder = null,
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
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShortlistCoverImageImplCopyWith<$Res>
    implements $ShortlistCoverImageCopyWith<$Res> {
  factory _$$ShortlistCoverImageImplCopyWith(_$ShortlistCoverImageImpl value,
          $Res Function(_$ShortlistCoverImageImpl) then) =
      __$$ShortlistCoverImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String productId, String imageUrl, int sortOrder});
}

/// @nodoc
class __$$ShortlistCoverImageImplCopyWithImpl<$Res>
    extends _$ShortlistCoverImageCopyWithImpl<$Res, _$ShortlistCoverImageImpl>
    implements _$$ShortlistCoverImageImplCopyWith<$Res> {
  __$$ShortlistCoverImageImplCopyWithImpl(_$ShortlistCoverImageImpl _value,
      $Res Function(_$ShortlistCoverImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ShortlistCoverImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? imageUrl = null,
    Object? sortOrder = null,
  }) {
    return _then(_$ShortlistCoverImageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      sortOrder: null == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShortlistCoverImageImpl extends _ShortlistCoverImage {
  const _$ShortlistCoverImageImpl(
      {this.id = '',
      this.productId = '',
      this.imageUrl = '',
      this.sortOrder = 0})
      : super._();

  factory _$ShortlistCoverImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShortlistCoverImageImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String productId;
  @override
  @JsonKey()
  final String imageUrl;
  @override
  @JsonKey()
  final int sortOrder;

  @override
  String toString() {
    return 'ShortlistCoverImage(id: $id, productId: $productId, imageUrl: $imageUrl, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShortlistCoverImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, productId, imageUrl, sortOrder);

  /// Create a copy of ShortlistCoverImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShortlistCoverImageImplCopyWith<_$ShortlistCoverImageImpl> get copyWith =>
      __$$ShortlistCoverImageImplCopyWithImpl<_$ShortlistCoverImageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShortlistCoverImageImplToJson(
      this,
    );
  }
}

abstract class _ShortlistCoverImage extends ShortlistCoverImage {
  const factory _ShortlistCoverImage(
      {final String id,
      final String productId,
      final String imageUrl,
      final int sortOrder}) = _$ShortlistCoverImageImpl;
  const _ShortlistCoverImage._() : super._();

  factory _ShortlistCoverImage.fromJson(Map<String, dynamic> json) =
      _$ShortlistCoverImageImpl.fromJson;

  @override
  String get id;
  @override
  String get productId;
  @override
  String get imageUrl;
  @override
  int get sortOrder;

  /// Create a copy of ShortlistCoverImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShortlistCoverImageImplCopyWith<_$ShortlistCoverImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

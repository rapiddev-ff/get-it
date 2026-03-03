// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_image_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReviewImage _$ReviewImageFromJson(Map<String, dynamic> json) {
  return _ReviewImage.fromJson(json);
}

/// @nodoc
mixin _$ReviewImage {
  String get id => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get thumbnailUrl => throw _privateConstructorUsedError;

  /// Serializes this ReviewImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewImageCopyWith<ReviewImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewImageCopyWith<$Res> {
  factory $ReviewImageCopyWith(
          ReviewImage value, $Res Function(ReviewImage) then) =
      _$ReviewImageCopyWithImpl<$Res, ReviewImage>;
  @useResult
  $Res call({String id, String imageUrl, String thumbnailUrl});
}

/// @nodoc
class _$ReviewImageCopyWithImpl<$Res, $Val extends ReviewImage>
    implements $ReviewImageCopyWith<$Res> {
  _$ReviewImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? thumbnailUrl = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: null == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewImageImplCopyWith<$Res>
    implements $ReviewImageCopyWith<$Res> {
  factory _$$ReviewImageImplCopyWith(
          _$ReviewImageImpl value, $Res Function(_$ReviewImageImpl) then) =
      __$$ReviewImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String imageUrl, String thumbnailUrl});
}

/// @nodoc
class __$$ReviewImageImplCopyWithImpl<$Res>
    extends _$ReviewImageCopyWithImpl<$Res, _$ReviewImageImpl>
    implements _$$ReviewImageImplCopyWith<$Res> {
  __$$ReviewImageImplCopyWithImpl(
      _$ReviewImageImpl _value, $Res Function(_$ReviewImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReviewImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? thumbnailUrl = null,
  }) {
    return _then(_$ReviewImageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: null == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewImageImpl extends _ReviewImage {
  const _$ReviewImageImpl(
      {this.id = '', this.imageUrl = '', this.thumbnailUrl = ''})
      : super._();

  factory _$ReviewImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewImageImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String imageUrl;
  @override
  @JsonKey()
  final String thumbnailUrl;

  @override
  String toString() {
    return 'ReviewImage(id: $id, imageUrl: $imageUrl, thumbnailUrl: $thumbnailUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, imageUrl, thumbnailUrl);

  /// Create a copy of ReviewImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewImageImplCopyWith<_$ReviewImageImpl> get copyWith =>
      __$$ReviewImageImplCopyWithImpl<_$ReviewImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewImageImplToJson(
      this,
    );
  }
}

abstract class _ReviewImage extends ReviewImage {
  const factory _ReviewImage(
      {final String id,
      final String imageUrl,
      final String thumbnailUrl}) = _$ReviewImageImpl;
  const _ReviewImage._() : super._();

  factory _ReviewImage.fromJson(Map<String, dynamic> json) =
      _$ReviewImageImpl.fromJson;

  @override
  String get id;
  @override
  String get imageUrl;
  @override
  String get thumbnailUrl;

  /// Create a copy of ReviewImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewImageImplCopyWith<_$ReviewImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

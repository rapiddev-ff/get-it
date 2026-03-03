// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_image_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageImage _$MessageImageFromJson(Map<String, dynamic> json) {
  return _MessageImage.fromJson(json);
}

/// @nodoc
mixin _$MessageImage {
  String get id => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  String get thumbnailUrl => throw _privateConstructorUsedError;
  String get width => throw _privateConstructorUsedError;
  String get height => throw _privateConstructorUsedError;

  /// Serializes this MessageImage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageImageCopyWith<MessageImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageImageCopyWith<$Res> {
  factory $MessageImageCopyWith(
          MessageImage value, $Res Function(MessageImage) then) =
      _$MessageImageCopyWithImpl<$Res, MessageImage>;
  @useResult
  $Res call(
      {String id,
      String imageUrl,
      String thumbnailUrl,
      String width,
      String height});
}

/// @nodoc
class _$MessageImageCopyWithImpl<$Res, $Val extends MessageImage>
    implements $MessageImageCopyWith<$Res> {
  _$MessageImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? thumbnailUrl = null,
    Object? width = null,
    Object? height = null,
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
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as String,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageImageImplCopyWith<$Res>
    implements $MessageImageCopyWith<$Res> {
  factory _$$MessageImageImplCopyWith(
          _$MessageImageImpl value, $Res Function(_$MessageImageImpl) then) =
      __$$MessageImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String imageUrl,
      String thumbnailUrl,
      String width,
      String height});
}

/// @nodoc
class __$$MessageImageImplCopyWithImpl<$Res>
    extends _$MessageImageCopyWithImpl<$Res, _$MessageImageImpl>
    implements _$$MessageImageImplCopyWith<$Res> {
  __$$MessageImageImplCopyWithImpl(
      _$MessageImageImpl _value, $Res Function(_$MessageImageImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? imageUrl = null,
    Object? thumbnailUrl = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_$MessageImageImpl(
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
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as String,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageImageImpl extends _MessageImage {
  const _$MessageImageImpl(
      {this.id = '',
      this.imageUrl = '',
      this.thumbnailUrl = '',
      this.width = '',
      this.height = ''})
      : super._();

  factory _$MessageImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageImageImplFromJson(json);

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
  @JsonKey()
  final String width;
  @override
  @JsonKey()
  final String height;

  @override
  String toString() {
    return 'MessageImage(id: $id, imageUrl: $imageUrl, thumbnailUrl: $thumbnailUrl, width: $width, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageImageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, imageUrl, thumbnailUrl, width, height);

  /// Create a copy of MessageImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageImageImplCopyWith<_$MessageImageImpl> get copyWith =>
      __$$MessageImageImplCopyWithImpl<_$MessageImageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageImageImplToJson(
      this,
    );
  }
}

abstract class _MessageImage extends MessageImage {
  const factory _MessageImage(
      {final String id,
      final String imageUrl,
      final String thumbnailUrl,
      final String width,
      final String height}) = _$MessageImageImpl;
  const _MessageImage._() : super._();

  factory _MessageImage.fromJson(Map<String, dynamic> json) =
      _$MessageImageImpl.fromJson;

  @override
  String get id;
  @override
  String get imageUrl;
  @override
  String get thumbnailUrl;
  @override
  String get width;
  @override
  String get height;

  /// Create a copy of MessageImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageImageImplCopyWith<_$MessageImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

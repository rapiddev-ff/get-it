// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_scan_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AiScanResult _$AiScanResultFromJson(Map<String, dynamic> json) {
  return _AiScanResult.fromJson(json);
}

/// @nodoc
mixin _$AiScanResult {
  String get suggestedTitle => throw _privateConstructorUsedError;
  String get suggestedDescription => throw _privateConstructorUsedError;
  String? get categoryId => throw _privateConstructorUsedError;
  String? get categoryName => throw _privateConstructorUsedError;
  String? get subcategoryId => throw _privateConstructorUsedError;
  String? get subcategoryName => throw _privateConstructorUsedError;
  List<AiScanTag> get suggestedTags => throw _privateConstructorUsedError;
  List<String> get labels => throw _privateConstructorUsedError;
  String? get detectedText => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;

  /// Serializes this AiScanResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiScanResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiScanResultCopyWith<AiScanResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiScanResultCopyWith<$Res> {
  factory $AiScanResultCopyWith(
          AiScanResult value, $Res Function(AiScanResult) then) =
      _$AiScanResultCopyWithImpl<$Res, AiScanResult>;
  @useResult
  $Res call(
      {String suggestedTitle,
      String suggestedDescription,
      String? categoryId,
      String? categoryName,
      String? subcategoryId,
      String? subcategoryName,
      List<AiScanTag> suggestedTags,
      List<String> labels,
      String? detectedText,
      double confidence});
}

/// @nodoc
class _$AiScanResultCopyWithImpl<$Res, $Val extends AiScanResult>
    implements $AiScanResultCopyWith<$Res> {
  _$AiScanResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiScanResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? suggestedTitle = null,
    Object? suggestedDescription = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? subcategoryId = freezed,
    Object? subcategoryName = freezed,
    Object? suggestedTags = null,
    Object? labels = null,
    Object? detectedText = freezed,
    Object? confidence = null,
  }) {
    return _then(_value.copyWith(
      suggestedTitle: null == suggestedTitle
          ? _value.suggestedTitle
          : suggestedTitle // ignore: cast_nullable_to_non_nullable
              as String,
      suggestedDescription: null == suggestedDescription
          ? _value.suggestedDescription
          : suggestedDescription // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      subcategoryId: freezed == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      subcategoryName: freezed == subcategoryName
          ? _value.subcategoryName
          : subcategoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      suggestedTags: null == suggestedTags
          ? _value.suggestedTags
          : suggestedTags // ignore: cast_nullable_to_non_nullable
              as List<AiScanTag>,
      labels: null == labels
          ? _value.labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      detectedText: freezed == detectedText
          ? _value.detectedText
          : detectedText // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiScanResultImplCopyWith<$Res>
    implements $AiScanResultCopyWith<$Res> {
  factory _$$AiScanResultImplCopyWith(
          _$AiScanResultImpl value, $Res Function(_$AiScanResultImpl) then) =
      __$$AiScanResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String suggestedTitle,
      String suggestedDescription,
      String? categoryId,
      String? categoryName,
      String? subcategoryId,
      String? subcategoryName,
      List<AiScanTag> suggestedTags,
      List<String> labels,
      String? detectedText,
      double confidence});
}

/// @nodoc
class __$$AiScanResultImplCopyWithImpl<$Res>
    extends _$AiScanResultCopyWithImpl<$Res, _$AiScanResultImpl>
    implements _$$AiScanResultImplCopyWith<$Res> {
  __$$AiScanResultImplCopyWithImpl(
      _$AiScanResultImpl _value, $Res Function(_$AiScanResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiScanResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? suggestedTitle = null,
    Object? suggestedDescription = null,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? subcategoryId = freezed,
    Object? subcategoryName = freezed,
    Object? suggestedTags = null,
    Object? labels = null,
    Object? detectedText = freezed,
    Object? confidence = null,
  }) {
    return _then(_$AiScanResultImpl(
      suggestedTitle: null == suggestedTitle
          ? _value.suggestedTitle
          : suggestedTitle // ignore: cast_nullable_to_non_nullable
              as String,
      suggestedDescription: null == suggestedDescription
          ? _value.suggestedDescription
          : suggestedDescription // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      subcategoryId: freezed == subcategoryId
          ? _value.subcategoryId
          : subcategoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      subcategoryName: freezed == subcategoryName
          ? _value.subcategoryName
          : subcategoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      suggestedTags: null == suggestedTags
          ? _value._suggestedTags
          : suggestedTags // ignore: cast_nullable_to_non_nullable
              as List<AiScanTag>,
      labels: null == labels
          ? _value._labels
          : labels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      detectedText: freezed == detectedText
          ? _value.detectedText
          : detectedText // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiScanResultImpl extends _AiScanResult {
  const _$AiScanResultImpl(
      {this.suggestedTitle = '',
      this.suggestedDescription = '',
      this.categoryId,
      this.categoryName,
      this.subcategoryId,
      this.subcategoryName,
      final List<AiScanTag> suggestedTags = const [],
      final List<String> labels = const [],
      this.detectedText,
      this.confidence = 0.0})
      : _suggestedTags = suggestedTags,
        _labels = labels,
        super._();

  factory _$AiScanResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiScanResultImplFromJson(json);

  @override
  @JsonKey()
  final String suggestedTitle;
  @override
  @JsonKey()
  final String suggestedDescription;
  @override
  final String? categoryId;
  @override
  final String? categoryName;
  @override
  final String? subcategoryId;
  @override
  final String? subcategoryName;
  final List<AiScanTag> _suggestedTags;
  @override
  @JsonKey()
  List<AiScanTag> get suggestedTags {
    if (_suggestedTags is EqualUnmodifiableListView) return _suggestedTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestedTags);
  }

  final List<String> _labels;
  @override
  @JsonKey()
  List<String> get labels {
    if (_labels is EqualUnmodifiableListView) return _labels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_labels);
  }

  @override
  final String? detectedText;
  @override
  @JsonKey()
  final double confidence;

  @override
  String toString() {
    return 'AiScanResult(suggestedTitle: $suggestedTitle, suggestedDescription: $suggestedDescription, categoryId: $categoryId, categoryName: $categoryName, subcategoryId: $subcategoryId, subcategoryName: $subcategoryName, suggestedTags: $suggestedTags, labels: $labels, detectedText: $detectedText, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiScanResultImpl &&
            (identical(other.suggestedTitle, suggestedTitle) ||
                other.suggestedTitle == suggestedTitle) &&
            (identical(other.suggestedDescription, suggestedDescription) ||
                other.suggestedDescription == suggestedDescription) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.subcategoryId, subcategoryId) ||
                other.subcategoryId == subcategoryId) &&
            (identical(other.subcategoryName, subcategoryName) ||
                other.subcategoryName == subcategoryName) &&
            const DeepCollectionEquality()
                .equals(other._suggestedTags, _suggestedTags) &&
            const DeepCollectionEquality().equals(other._labels, _labels) &&
            (identical(other.detectedText, detectedText) ||
                other.detectedText == detectedText) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      suggestedTitle,
      suggestedDescription,
      categoryId,
      categoryName,
      subcategoryId,
      subcategoryName,
      const DeepCollectionEquality().hash(_suggestedTags),
      const DeepCollectionEquality().hash(_labels),
      detectedText,
      confidence);

  /// Create a copy of AiScanResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiScanResultImplCopyWith<_$AiScanResultImpl> get copyWith =>
      __$$AiScanResultImplCopyWithImpl<_$AiScanResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiScanResultImplToJson(
      this,
    );
  }
}

abstract class _AiScanResult extends AiScanResult {
  const factory _AiScanResult(
      {final String suggestedTitle,
      final String suggestedDescription,
      final String? categoryId,
      final String? categoryName,
      final String? subcategoryId,
      final String? subcategoryName,
      final List<AiScanTag> suggestedTags,
      final List<String> labels,
      final String? detectedText,
      final double confidence}) = _$AiScanResultImpl;
  const _AiScanResult._() : super._();

  factory _AiScanResult.fromJson(Map<String, dynamic> json) =
      _$AiScanResultImpl.fromJson;

  @override
  String get suggestedTitle;
  @override
  String get suggestedDescription;
  @override
  String? get categoryId;
  @override
  String? get categoryName;
  @override
  String? get subcategoryId;
  @override
  String? get subcategoryName;
  @override
  List<AiScanTag> get suggestedTags;
  @override
  List<String> get labels;
  @override
  String? get detectedText;
  @override
  double get confidence;

  /// Create a copy of AiScanResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiScanResultImplCopyWith<_$AiScanResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AiScanTag _$AiScanTagFromJson(Map<String, dynamic> json) {
  return _AiScanTag.fromJson(json);
}

/// @nodoc
mixin _$AiScanTag {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get slug => throw _privateConstructorUsedError;

  /// Serializes this AiScanTag to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AiScanTag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AiScanTagCopyWith<AiScanTag> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AiScanTagCopyWith<$Res> {
  factory $AiScanTagCopyWith(AiScanTag value, $Res Function(AiScanTag) then) =
      _$AiScanTagCopyWithImpl<$Res, AiScanTag>;
  @useResult
  $Res call({String id, String name, String slug});
}

/// @nodoc
class _$AiScanTagCopyWithImpl<$Res, $Val extends AiScanTag>
    implements $AiScanTagCopyWith<$Res> {
  _$AiScanTagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AiScanTag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AiScanTagImplCopyWith<$Res>
    implements $AiScanTagCopyWith<$Res> {
  factory _$$AiScanTagImplCopyWith(
          _$AiScanTagImpl value, $Res Function(_$AiScanTagImpl) then) =
      __$$AiScanTagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String slug});
}

/// @nodoc
class __$$AiScanTagImplCopyWithImpl<$Res>
    extends _$AiScanTagCopyWithImpl<$Res, _$AiScanTagImpl>
    implements _$$AiScanTagImplCopyWith<$Res> {
  __$$AiScanTagImplCopyWithImpl(
      _$AiScanTagImpl _value, $Res Function(_$AiScanTagImpl) _then)
      : super(_value, _then);

  /// Create a copy of AiScanTag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? slug = null,
  }) {
    return _then(_$AiScanTagImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      slug: null == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AiScanTagImpl implements _AiScanTag {
  const _$AiScanTagImpl({this.id = '', this.name = '', this.slug = ''});

  factory _$AiScanTagImpl.fromJson(Map<String, dynamic> json) =>
      _$$AiScanTagImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String slug;

  @override
  String toString() {
    return 'AiScanTag(id: $id, name: $name, slug: $slug)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AiScanTagImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.slug, slug) || other.slug == slug));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, slug);

  /// Create a copy of AiScanTag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AiScanTagImplCopyWith<_$AiScanTagImpl> get copyWith =>
      __$$AiScanTagImplCopyWithImpl<_$AiScanTagImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AiScanTagImplToJson(
      this,
    );
  }
}

abstract class _AiScanTag implements AiScanTag {
  const factory _AiScanTag(
      {final String id,
      final String name,
      final String slug}) = _$AiScanTagImpl;

  factory _AiScanTag.fromJson(Map<String, dynamic> json) =
      _$AiScanTagImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get slug;

  /// Create a copy of AiScanTag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AiScanTagImplCopyWith<_$AiScanTagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

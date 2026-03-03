// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seller_shortlist_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SellerShortlist _$SellerShortlistFromJson(Map<String, dynamic> json) {
  return _SellerShortlist.fromJson(json);
}

/// @nodoc
mixin _$SellerShortlist {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get totalItems => throw _privateConstructorUsedError;
  double get discountPercentage => throw _privateConstructorUsedError;
  String get eventName => throw _privateConstructorUsedError;
  String get shareCode => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get startDate => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get endDate => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  List<ShortlistCoverImage> get coverImages =>
      throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  /// Serializes this SellerShortlist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SellerShortlist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SellerShortlistCopyWith<SellerShortlist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SellerShortlistCopyWith<$Res> {
  factory $SellerShortlistCopyWith(
          SellerShortlist value, $Res Function(SellerShortlist) then) =
      _$SellerShortlistCopyWithImpl<$Res, SellerShortlist>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      int totalItems,
      double discountPercentage,
      String eventName,
      String shareCode,
      String status,
      bool isPublic,
      @DateTimeConverter() DateTime? startDate,
      @DateTimeConverter() DateTime? endDate,
      @DateTimeConverter() DateTime? createdAt,
      List<ShortlistCoverImage> coverImages,
      List<String> tags});
}

/// @nodoc
class _$SellerShortlistCopyWithImpl<$Res, $Val extends SellerShortlist>
    implements $SellerShortlistCopyWith<$Res> {
  _$SellerShortlistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SellerShortlist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? totalItems = null,
    Object? discountPercentage = null,
    Object? eventName = null,
    Object? shareCode = null,
    Object? status = null,
    Object? isPublic = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? createdAt = freezed,
    Object? coverImages = null,
    Object? tags = null,
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
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      discountPercentage: null == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      shareCode: null == shareCode
          ? _value.shareCode
          : shareCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      coverImages: null == coverImages
          ? _value.coverImages
          : coverImages // ignore: cast_nullable_to_non_nullable
              as List<ShortlistCoverImage>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SellerShortlistImplCopyWith<$Res>
    implements $SellerShortlistCopyWith<$Res> {
  factory _$$SellerShortlistImplCopyWith(_$SellerShortlistImpl value,
          $Res Function(_$SellerShortlistImpl) then) =
      __$$SellerShortlistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      int totalItems,
      double discountPercentage,
      String eventName,
      String shareCode,
      String status,
      bool isPublic,
      @DateTimeConverter() DateTime? startDate,
      @DateTimeConverter() DateTime? endDate,
      @DateTimeConverter() DateTime? createdAt,
      List<ShortlistCoverImage> coverImages,
      List<String> tags});
}

/// @nodoc
class __$$SellerShortlistImplCopyWithImpl<$Res>
    extends _$SellerShortlistCopyWithImpl<$Res, _$SellerShortlistImpl>
    implements _$$SellerShortlistImplCopyWith<$Res> {
  __$$SellerShortlistImplCopyWithImpl(
      _$SellerShortlistImpl _value, $Res Function(_$SellerShortlistImpl) _then)
      : super(_value, _then);

  /// Create a copy of SellerShortlist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? totalItems = null,
    Object? discountPercentage = null,
    Object? eventName = null,
    Object? shareCode = null,
    Object? status = null,
    Object? isPublic = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? createdAt = freezed,
    Object? coverImages = null,
    Object? tags = null,
  }) {
    return _then(_$SellerShortlistImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      totalItems: null == totalItems
          ? _value.totalItems
          : totalItems // ignore: cast_nullable_to_non_nullable
              as int,
      discountPercentage: null == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      eventName: null == eventName
          ? _value.eventName
          : eventName // ignore: cast_nullable_to_non_nullable
              as String,
      shareCode: null == shareCode
          ? _value.shareCode
          : shareCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      coverImages: null == coverImages
          ? _value._coverImages
          : coverImages // ignore: cast_nullable_to_non_nullable
              as List<ShortlistCoverImage>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SellerShortlistImpl extends _SellerShortlist {
  const _$SellerShortlistImpl(
      {this.id = '',
      this.name = '',
      this.description = '',
      this.totalItems = 0,
      this.discountPercentage = 0.0,
      this.eventName = '',
      this.shareCode = '',
      this.status = '',
      this.isPublic = false,
      @DateTimeConverter() this.startDate,
      @DateTimeConverter() this.endDate,
      @DateTimeConverter() this.createdAt,
      final List<ShortlistCoverImage> coverImages = const [],
      final List<String> tags = const []})
      : _coverImages = coverImages,
        _tags = tags,
        super._();

  factory _$SellerShortlistImpl.fromJson(Map<String, dynamic> json) =>
      _$$SellerShortlistImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final int totalItems;
  @override
  @JsonKey()
  final double discountPercentage;
  @override
  @JsonKey()
  final String eventName;
  @override
  @JsonKey()
  final String shareCode;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final bool isPublic;
  @override
  @DateTimeConverter()
  final DateTime? startDate;
  @override
  @DateTimeConverter()
  final DateTime? endDate;
  @override
  @DateTimeConverter()
  final DateTime? createdAt;
  final List<ShortlistCoverImage> _coverImages;
  @override
  @JsonKey()
  List<ShortlistCoverImage> get coverImages {
    if (_coverImages is EqualUnmodifiableListView) return _coverImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_coverImages);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'SellerShortlist(id: $id, name: $name, description: $description, totalItems: $totalItems, discountPercentage: $discountPercentage, eventName: $eventName, shareCode: $shareCode, status: $status, isPublic: $isPublic, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, coverImages: $coverImages, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SellerShortlistImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.totalItems, totalItems) ||
                other.totalItems == totalItems) &&
            (identical(other.discountPercentage, discountPercentage) ||
                other.discountPercentage == discountPercentage) &&
            (identical(other.eventName, eventName) ||
                other.eventName == eventName) &&
            (identical(other.shareCode, shareCode) ||
                other.shareCode == shareCode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._coverImages, _coverImages) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      totalItems,
      discountPercentage,
      eventName,
      shareCode,
      status,
      isPublic,
      startDate,
      endDate,
      createdAt,
      const DeepCollectionEquality().hash(_coverImages),
      const DeepCollectionEquality().hash(_tags));

  /// Create a copy of SellerShortlist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SellerShortlistImplCopyWith<_$SellerShortlistImpl> get copyWith =>
      __$$SellerShortlistImplCopyWithImpl<_$SellerShortlistImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SellerShortlistImplToJson(
      this,
    );
  }
}

abstract class _SellerShortlist extends SellerShortlist {
  const factory _SellerShortlist(
      {final String id,
      final String name,
      final String description,
      final int totalItems,
      final double discountPercentage,
      final String eventName,
      final String shareCode,
      final String status,
      final bool isPublic,
      @DateTimeConverter() final DateTime? startDate,
      @DateTimeConverter() final DateTime? endDate,
      @DateTimeConverter() final DateTime? createdAt,
      final List<ShortlistCoverImage> coverImages,
      final List<String> tags}) = _$SellerShortlistImpl;
  const _SellerShortlist._() : super._();

  factory _SellerShortlist.fromJson(Map<String, dynamic> json) =
      _$SellerShortlistImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  int get totalItems;
  @override
  double get discountPercentage;
  @override
  String get eventName;
  @override
  String get shareCode;
  @override
  String get status;
  @override
  bool get isPublic;
  @override
  @DateTimeConverter()
  DateTime? get startDate;
  @override
  @DateTimeConverter()
  DateTime? get endDate;
  @override
  @DateTimeConverter()
  DateTime? get createdAt;
  @override
  List<ShortlistCoverImage> get coverImages;
  @override
  List<String> get tags;

  /// Create a copy of SellerShortlist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SellerShortlistImplCopyWith<_$SellerShortlistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_address_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BusinessAddress _$BusinessAddressFromJson(Map<String, dynamic> json) {
  return _BusinessAddress.fromJson(json);
}

/// @nodoc
mixin _$BusinessAddress {
  String get addressLine1 => throw _privateConstructorUsedError;
  String get addressLine2 => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String get zipCode => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;

  /// Serializes this BusinessAddress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BusinessAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BusinessAddressCopyWith<BusinessAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessAddressCopyWith<$Res> {
  factory $BusinessAddressCopyWith(
          BusinessAddress value, $Res Function(BusinessAddress) then) =
      _$BusinessAddressCopyWithImpl<$Res, BusinessAddress>;
  @useResult
  $Res call(
      {String addressLine1,
      String addressLine2,
      String city,
      String state,
      String zipCode,
      String country});
}

/// @nodoc
class _$BusinessAddressCopyWithImpl<$Res, $Val extends BusinessAddress>
    implements $BusinessAddressCopyWith<$Res> {
  _$BusinessAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BusinessAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addressLine1 = null,
    Object? addressLine2 = null,
    Object? city = null,
    Object? state = null,
    Object? zipCode = null,
    Object? country = null,
  }) {
    return _then(_value.copyWith(
      addressLine1: null == addressLine1
          ? _value.addressLine1
          : addressLine1 // ignore: cast_nullable_to_non_nullable
              as String,
      addressLine2: null == addressLine2
          ? _value.addressLine2
          : addressLine2 // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: null == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BusinessAddressImplCopyWith<$Res>
    implements $BusinessAddressCopyWith<$Res> {
  factory _$$BusinessAddressImplCopyWith(_$BusinessAddressImpl value,
          $Res Function(_$BusinessAddressImpl) then) =
      __$$BusinessAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String addressLine1,
      String addressLine2,
      String city,
      String state,
      String zipCode,
      String country});
}

/// @nodoc
class __$$BusinessAddressImplCopyWithImpl<$Res>
    extends _$BusinessAddressCopyWithImpl<$Res, _$BusinessAddressImpl>
    implements _$$BusinessAddressImplCopyWith<$Res> {
  __$$BusinessAddressImplCopyWithImpl(
      _$BusinessAddressImpl _value, $Res Function(_$BusinessAddressImpl) _then)
      : super(_value, _then);

  /// Create a copy of BusinessAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? addressLine1 = null,
    Object? addressLine2 = null,
    Object? city = null,
    Object? state = null,
    Object? zipCode = null,
    Object? country = null,
  }) {
    return _then(_$BusinessAddressImpl(
      addressLine1: null == addressLine1
          ? _value.addressLine1
          : addressLine1 // ignore: cast_nullable_to_non_nullable
              as String,
      addressLine2: null == addressLine2
          ? _value.addressLine2
          : addressLine2 // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      zipCode: null == zipCode
          ? _value.zipCode
          : zipCode // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BusinessAddressImpl extends _BusinessAddress {
  const _$BusinessAddressImpl(
      {this.addressLine1 = '',
      this.addressLine2 = '',
      this.city = '',
      this.state = '',
      this.zipCode = '',
      this.country = ''})
      : super._();

  factory _$BusinessAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$BusinessAddressImplFromJson(json);

  @override
  @JsonKey()
  final String addressLine1;
  @override
  @JsonKey()
  final String addressLine2;
  @override
  @JsonKey()
  final String city;
  @override
  @JsonKey()
  final String state;
  @override
  @JsonKey()
  final String zipCode;
  @override
  @JsonKey()
  final String country;

  @override
  String toString() {
    return 'BusinessAddress(addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, state: $state, zipCode: $zipCode, country: $country)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BusinessAddressImpl &&
            (identical(other.addressLine1, addressLine1) ||
                other.addressLine1 == addressLine1) &&
            (identical(other.addressLine2, addressLine2) ||
                other.addressLine2 == addressLine2) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.zipCode, zipCode) || other.zipCode == zipCode) &&
            (identical(other.country, country) || other.country == country));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, addressLine1, addressLine2, city, state, zipCode, country);

  /// Create a copy of BusinessAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BusinessAddressImplCopyWith<_$BusinessAddressImpl> get copyWith =>
      __$$BusinessAddressImplCopyWithImpl<_$BusinessAddressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BusinessAddressImplToJson(
      this,
    );
  }
}

abstract class _BusinessAddress extends BusinessAddress {
  const factory _BusinessAddress(
      {final String addressLine1,
      final String addressLine2,
      final String city,
      final String state,
      final String zipCode,
      final String country}) = _$BusinessAddressImpl;
  const _BusinessAddress._() : super._();

  factory _BusinessAddress.fromJson(Map<String, dynamic> json) =
      _$BusinessAddressImpl.fromJson;

  @override
  String get addressLine1;
  @override
  String get addressLine2;
  @override
  String get city;
  @override
  String get state;
  @override
  String get zipCode;
  @override
  String get country;

  /// Create a copy of BusinessAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BusinessAddressImplCopyWith<_$BusinessAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

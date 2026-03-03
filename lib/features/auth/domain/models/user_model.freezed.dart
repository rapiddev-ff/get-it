// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return _UserData.fromJson(json);
}

/// @nodoc
mixin _$UserData {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String get avatarUrl => throw _privateConstructorUsedError;
  String get bio => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_verified')
  bool get phoneVerified => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_seller')
  bool get isSeller => throw _privateConstructorUsedError;
  @JsonKey(name: 'seller_since')
  @DateTimeConverter()
  DateTime? get sellerSince => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_name')
  String get businessName => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_address')
  BusinessAddress? get businessAddress => throw _privateConstructorUsedError;
  @JsonKey(name: 'business_email')
  String get businessEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'rating_as_seller')
  double get ratingAsSeller => throw _privateConstructorUsedError;
  @JsonKey(name: 'rating_as_buyer')
  double get ratingAsBuyer => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_reviews_as_seller')
  int get totalReviewsAsSeller => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_reviews_as_buyer')
  int get totalReviewsAsBuyer => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_sales')
  int get totalSales => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_purchases')
  int get totalPurchases => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_refunds')
  int get totalRefunds => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_cancelled')
  int get totalCancelled => throw _privateConstructorUsedError;
  @JsonKey(name: 'followers_count')
  int get followersCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'following_count')
  int get followingCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_private')
  bool get isPrivate => throw _privateConstructorUsedError;
  @JsonKey(name: 'referral_code')
  String get referralCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'referred_by')
  String get referredBy => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  @DateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  @DateTimeConverter()
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  @DateTimeConverter()
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_referrals')
  int get totalReferrals => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  StripeAccountStatus? get stripe => throw _privateConstructorUsedError;
  List<PaymentMethod> get paymentMethod => throw _privateConstructorUsedError;
  bool get hasStripeCustomer => throw _privateConstructorUsedError;
  String get defaultPaymentMethodId => throw _privateConstructorUsedError;
  UserSettings? get userSettings => throw _privateConstructorUsedError;
  ShippingAddress? get shippingAddress => throw _privateConstructorUsedError;

  /// Serializes this UserData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDataCopyWith<UserData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDataCopyWith<$Res> {
  factory $UserDataCopyWith(UserData value, $Res Function(UserData) then) =
      _$UserDataCopyWithImpl<$Res, UserData>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String username,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      @JsonKey(name: 'avatar_url') String avatarUrl,
      String bio,
      String phone,
      @JsonKey(name: 'phone_verified') bool phoneVerified,
      @JsonKey(name: 'is_seller') bool isSeller,
      @JsonKey(name: 'seller_since') @DateTimeConverter() DateTime? sellerSince,
      @JsonKey(name: 'business_name') String businessName,
      @JsonKey(name: 'business_address') BusinessAddress? businessAddress,
      @JsonKey(name: 'business_email') String businessEmail,
      @JsonKey(name: 'rating_as_seller') double ratingAsSeller,
      @JsonKey(name: 'rating_as_buyer') double ratingAsBuyer,
      @JsonKey(name: 'total_reviews_as_seller') int totalReviewsAsSeller,
      @JsonKey(name: 'total_reviews_as_buyer') int totalReviewsAsBuyer,
      @JsonKey(name: 'total_sales') int totalSales,
      @JsonKey(name: 'total_purchases') int totalPurchases,
      @JsonKey(name: 'total_refunds') int totalRefunds,
      @JsonKey(name: 'total_cancelled') int totalCancelled,
      @JsonKey(name: 'followers_count') int followersCount,
      @JsonKey(name: 'following_count') int followingCount,
      @JsonKey(name: 'is_private') bool isPrivate,
      @JsonKey(name: 'referral_code') String referralCode,
      @JsonKey(name: 'referred_by') String referredBy,
      @JsonKey(name: 'created_at') @DateTimeConverter() DateTime? createdAt,
      @JsonKey(name: 'updated_at') @DateTimeConverter() DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') @DateTimeConverter() DateTime? deletedAt,
      @JsonKey(name: 'total_referrals') int totalReferrals,
      String email,
      StripeAccountStatus? stripe,
      List<PaymentMethod> paymentMethod,
      bool hasStripeCustomer,
      String defaultPaymentMethodId,
      UserSettings? userSettings,
      ShippingAddress? shippingAddress});

  $BusinessAddressCopyWith<$Res>? get businessAddress;
  $StripeAccountStatusCopyWith<$Res>? get stripe;
  $UserSettingsCopyWith<$Res>? get userSettings;
  $ShippingAddressCopyWith<$Res>? get shippingAddress;
}

/// @nodoc
class _$UserDataCopyWithImpl<$Res, $Val extends UserData>
    implements $UserDataCopyWith<$Res> {
  _$UserDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? username = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? avatarUrl = null,
    Object? bio = null,
    Object? phone = null,
    Object? phoneVerified = null,
    Object? isSeller = null,
    Object? sellerSince = freezed,
    Object? businessName = null,
    Object? businessAddress = freezed,
    Object? businessEmail = null,
    Object? ratingAsSeller = null,
    Object? ratingAsBuyer = null,
    Object? totalReviewsAsSeller = null,
    Object? totalReviewsAsBuyer = null,
    Object? totalSales = null,
    Object? totalPurchases = null,
    Object? totalRefunds = null,
    Object? totalCancelled = null,
    Object? followersCount = null,
    Object? followingCount = null,
    Object? isPrivate = null,
    Object? referralCode = null,
    Object? referredBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? totalReferrals = null,
    Object? email = null,
    Object? stripe = freezed,
    Object? paymentMethod = null,
    Object? hasStripeCustomer = null,
    Object? defaultPaymentMethodId = null,
    Object? userSettings = freezed,
    Object? shippingAddress = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      bio: null == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneVerified: null == phoneVerified
          ? _value.phoneVerified
          : phoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isSeller: null == isSeller
          ? _value.isSeller
          : isSeller // ignore: cast_nullable_to_non_nullable
              as bool,
      sellerSince: freezed == sellerSince
          ? _value.sellerSince
          : sellerSince // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      businessName: null == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String,
      businessAddress: freezed == businessAddress
          ? _value.businessAddress
          : businessAddress // ignore: cast_nullable_to_non_nullable
              as BusinessAddress?,
      businessEmail: null == businessEmail
          ? _value.businessEmail
          : businessEmail // ignore: cast_nullable_to_non_nullable
              as String,
      ratingAsSeller: null == ratingAsSeller
          ? _value.ratingAsSeller
          : ratingAsSeller // ignore: cast_nullable_to_non_nullable
              as double,
      ratingAsBuyer: null == ratingAsBuyer
          ? _value.ratingAsBuyer
          : ratingAsBuyer // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviewsAsSeller: null == totalReviewsAsSeller
          ? _value.totalReviewsAsSeller
          : totalReviewsAsSeller // ignore: cast_nullable_to_non_nullable
              as int,
      totalReviewsAsBuyer: null == totalReviewsAsBuyer
          ? _value.totalReviewsAsBuyer
          : totalReviewsAsBuyer // ignore: cast_nullable_to_non_nullable
              as int,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as int,
      totalPurchases: null == totalPurchases
          ? _value.totalPurchases
          : totalPurchases // ignore: cast_nullable_to_non_nullable
              as int,
      totalRefunds: null == totalRefunds
          ? _value.totalRefunds
          : totalRefunds // ignore: cast_nullable_to_non_nullable
              as int,
      totalCancelled: null == totalCancelled
          ? _value.totalCancelled
          : totalCancelled // ignore: cast_nullable_to_non_nullable
              as int,
      followersCount: null == followersCount
          ? _value.followersCount
          : followersCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _value.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      referralCode: null == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String,
      referredBy: null == referredBy
          ? _value.referredBy
          : referredBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalReferrals: null == totalReferrals
          ? _value.totalReferrals
          : totalReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      stripe: freezed == stripe
          ? _value.stripe
          : stripe // ignore: cast_nullable_to_non_nullable
              as StripeAccountStatus?,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as List<PaymentMethod>,
      hasStripeCustomer: null == hasStripeCustomer
          ? _value.hasStripeCustomer
          : hasStripeCustomer // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultPaymentMethodId: null == defaultPaymentMethodId
          ? _value.defaultPaymentMethodId
          : defaultPaymentMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      userSettings: freezed == userSettings
          ? _value.userSettings
          : userSettings // ignore: cast_nullable_to_non_nullable
              as UserSettings?,
      shippingAddress: freezed == shippingAddress
          ? _value.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as ShippingAddress?,
    ) as $Val);
  }

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BusinessAddressCopyWith<$Res>? get businessAddress {
    if (_value.businessAddress == null) {
      return null;
    }

    return $BusinessAddressCopyWith<$Res>(_value.businessAddress!, (value) {
      return _then(_value.copyWith(businessAddress: value) as $Val);
    });
  }

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StripeAccountStatusCopyWith<$Res>? get stripe {
    if (_value.stripe == null) {
      return null;
    }

    return $StripeAccountStatusCopyWith<$Res>(_value.stripe!, (value) {
      return _then(_value.copyWith(stripe: value) as $Val);
    });
  }

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserSettingsCopyWith<$Res>? get userSettings {
    if (_value.userSettings == null) {
      return null;
    }

    return $UserSettingsCopyWith<$Res>(_value.userSettings!, (value) {
      return _then(_value.copyWith(userSettings: value) as $Val);
    });
  }

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShippingAddressCopyWith<$Res>? get shippingAddress {
    if (_value.shippingAddress == null) {
      return null;
    }

    return $ShippingAddressCopyWith<$Res>(_value.shippingAddress!, (value) {
      return _then(_value.copyWith(shippingAddress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserDataImplCopyWith<$Res>
    implements $UserDataCopyWith<$Res> {
  factory _$$UserDataImplCopyWith(
          _$UserDataImpl value, $Res Function(_$UserDataImpl) then) =
      __$$UserDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String username,
      @JsonKey(name: 'first_name') String firstName,
      @JsonKey(name: 'last_name') String lastName,
      @JsonKey(name: 'avatar_url') String avatarUrl,
      String bio,
      String phone,
      @JsonKey(name: 'phone_verified') bool phoneVerified,
      @JsonKey(name: 'is_seller') bool isSeller,
      @JsonKey(name: 'seller_since') @DateTimeConverter() DateTime? sellerSince,
      @JsonKey(name: 'business_name') String businessName,
      @JsonKey(name: 'business_address') BusinessAddress? businessAddress,
      @JsonKey(name: 'business_email') String businessEmail,
      @JsonKey(name: 'rating_as_seller') double ratingAsSeller,
      @JsonKey(name: 'rating_as_buyer') double ratingAsBuyer,
      @JsonKey(name: 'total_reviews_as_seller') int totalReviewsAsSeller,
      @JsonKey(name: 'total_reviews_as_buyer') int totalReviewsAsBuyer,
      @JsonKey(name: 'total_sales') int totalSales,
      @JsonKey(name: 'total_purchases') int totalPurchases,
      @JsonKey(name: 'total_refunds') int totalRefunds,
      @JsonKey(name: 'total_cancelled') int totalCancelled,
      @JsonKey(name: 'followers_count') int followersCount,
      @JsonKey(name: 'following_count') int followingCount,
      @JsonKey(name: 'is_private') bool isPrivate,
      @JsonKey(name: 'referral_code') String referralCode,
      @JsonKey(name: 'referred_by') String referredBy,
      @JsonKey(name: 'created_at') @DateTimeConverter() DateTime? createdAt,
      @JsonKey(name: 'updated_at') @DateTimeConverter() DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') @DateTimeConverter() DateTime? deletedAt,
      @JsonKey(name: 'total_referrals') int totalReferrals,
      String email,
      StripeAccountStatus? stripe,
      List<PaymentMethod> paymentMethod,
      bool hasStripeCustomer,
      String defaultPaymentMethodId,
      UserSettings? userSettings,
      ShippingAddress? shippingAddress});

  @override
  $BusinessAddressCopyWith<$Res>? get businessAddress;
  @override
  $StripeAccountStatusCopyWith<$Res>? get stripe;
  @override
  $UserSettingsCopyWith<$Res>? get userSettings;
  @override
  $ShippingAddressCopyWith<$Res>? get shippingAddress;
}

/// @nodoc
class __$$UserDataImplCopyWithImpl<$Res>
    extends _$UserDataCopyWithImpl<$Res, _$UserDataImpl>
    implements _$$UserDataImplCopyWith<$Res> {
  __$$UserDataImplCopyWithImpl(
      _$UserDataImpl _value, $Res Function(_$UserDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? username = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? avatarUrl = null,
    Object? bio = null,
    Object? phone = null,
    Object? phoneVerified = null,
    Object? isSeller = null,
    Object? sellerSince = freezed,
    Object? businessName = null,
    Object? businessAddress = freezed,
    Object? businessEmail = null,
    Object? ratingAsSeller = null,
    Object? ratingAsBuyer = null,
    Object? totalReviewsAsSeller = null,
    Object? totalReviewsAsBuyer = null,
    Object? totalSales = null,
    Object? totalPurchases = null,
    Object? totalRefunds = null,
    Object? totalCancelled = null,
    Object? followersCount = null,
    Object? followingCount = null,
    Object? isPrivate = null,
    Object? referralCode = null,
    Object? referredBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? totalReferrals = null,
    Object? email = null,
    Object? stripe = freezed,
    Object? paymentMethod = null,
    Object? hasStripeCustomer = null,
    Object? defaultPaymentMethodId = null,
    Object? userSettings = freezed,
    Object? shippingAddress = freezed,
  }) {
    return _then(_$UserDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: null == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String,
      bio: null == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      phoneVerified: null == phoneVerified
          ? _value.phoneVerified
          : phoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isSeller: null == isSeller
          ? _value.isSeller
          : isSeller // ignore: cast_nullable_to_non_nullable
              as bool,
      sellerSince: freezed == sellerSince
          ? _value.sellerSince
          : sellerSince // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      businessName: null == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String,
      businessAddress: freezed == businessAddress
          ? _value.businessAddress
          : businessAddress // ignore: cast_nullable_to_non_nullable
              as BusinessAddress?,
      businessEmail: null == businessEmail
          ? _value.businessEmail
          : businessEmail // ignore: cast_nullable_to_non_nullable
              as String,
      ratingAsSeller: null == ratingAsSeller
          ? _value.ratingAsSeller
          : ratingAsSeller // ignore: cast_nullable_to_non_nullable
              as double,
      ratingAsBuyer: null == ratingAsBuyer
          ? _value.ratingAsBuyer
          : ratingAsBuyer // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviewsAsSeller: null == totalReviewsAsSeller
          ? _value.totalReviewsAsSeller
          : totalReviewsAsSeller // ignore: cast_nullable_to_non_nullable
              as int,
      totalReviewsAsBuyer: null == totalReviewsAsBuyer
          ? _value.totalReviewsAsBuyer
          : totalReviewsAsBuyer // ignore: cast_nullable_to_non_nullable
              as int,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as int,
      totalPurchases: null == totalPurchases
          ? _value.totalPurchases
          : totalPurchases // ignore: cast_nullable_to_non_nullable
              as int,
      totalRefunds: null == totalRefunds
          ? _value.totalRefunds
          : totalRefunds // ignore: cast_nullable_to_non_nullable
              as int,
      totalCancelled: null == totalCancelled
          ? _value.totalCancelled
          : totalCancelled // ignore: cast_nullable_to_non_nullable
              as int,
      followersCount: null == followersCount
          ? _value.followersCount
          : followersCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _value.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      referralCode: null == referralCode
          ? _value.referralCode
          : referralCode // ignore: cast_nullable_to_non_nullable
              as String,
      referredBy: null == referredBy
          ? _value.referredBy
          : referredBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalReferrals: null == totalReferrals
          ? _value.totalReferrals
          : totalReferrals // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      stripe: freezed == stripe
          ? _value.stripe
          : stripe // ignore: cast_nullable_to_non_nullable
              as StripeAccountStatus?,
      paymentMethod: null == paymentMethod
          ? _value._paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as List<PaymentMethod>,
      hasStripeCustomer: null == hasStripeCustomer
          ? _value.hasStripeCustomer
          : hasStripeCustomer // ignore: cast_nullable_to_non_nullable
              as bool,
      defaultPaymentMethodId: null == defaultPaymentMethodId
          ? _value.defaultPaymentMethodId
          : defaultPaymentMethodId // ignore: cast_nullable_to_non_nullable
              as String,
      userSettings: freezed == userSettings
          ? _value.userSettings
          : userSettings // ignore: cast_nullable_to_non_nullable
              as UserSettings?,
      shippingAddress: freezed == shippingAddress
          ? _value.shippingAddress
          : shippingAddress // ignore: cast_nullable_to_non_nullable
              as ShippingAddress?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDataImpl extends _UserData {
  const _$UserDataImpl(
      {this.id = '',
      @JsonKey(name: 'user_id') this.userId = '',
      this.username = '',
      @JsonKey(name: 'first_name') this.firstName = '',
      @JsonKey(name: 'last_name') this.lastName = '',
      @JsonKey(name: 'avatar_url') this.avatarUrl = '',
      this.bio = '',
      this.phone = '',
      @JsonKey(name: 'phone_verified') this.phoneVerified = false,
      @JsonKey(name: 'is_seller') this.isSeller = false,
      @JsonKey(name: 'seller_since') @DateTimeConverter() this.sellerSince,
      @JsonKey(name: 'business_name') this.businessName = '',
      @JsonKey(name: 'business_address') this.businessAddress,
      @JsonKey(name: 'business_email') this.businessEmail = '',
      @JsonKey(name: 'rating_as_seller') this.ratingAsSeller = 0.0,
      @JsonKey(name: 'rating_as_buyer') this.ratingAsBuyer = 0.0,
      @JsonKey(name: 'total_reviews_as_seller') this.totalReviewsAsSeller = 0,
      @JsonKey(name: 'total_reviews_as_buyer') this.totalReviewsAsBuyer = 0,
      @JsonKey(name: 'total_sales') this.totalSales = 0,
      @JsonKey(name: 'total_purchases') this.totalPurchases = 0,
      @JsonKey(name: 'total_refunds') this.totalRefunds = 0,
      @JsonKey(name: 'total_cancelled') this.totalCancelled = 0,
      @JsonKey(name: 'followers_count') this.followersCount = 0,
      @JsonKey(name: 'following_count') this.followingCount = 0,
      @JsonKey(name: 'is_private') this.isPrivate = false,
      @JsonKey(name: 'referral_code') this.referralCode = '',
      @JsonKey(name: 'referred_by') this.referredBy = '',
      @JsonKey(name: 'created_at') @DateTimeConverter() this.createdAt,
      @JsonKey(name: 'updated_at') @DateTimeConverter() this.updatedAt,
      @JsonKey(name: 'deleted_at') @DateTimeConverter() this.deletedAt,
      @JsonKey(name: 'total_referrals') this.totalReferrals = 0,
      this.email = '',
      this.stripe,
      final List<PaymentMethod> paymentMethod = const [],
      this.hasStripeCustomer = false,
      this.defaultPaymentMethodId = '',
      this.userSettings,
      this.shippingAddress})
      : _paymentMethod = paymentMethod,
        super._();

  factory _$UserDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDataImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey()
  final String username;
  @override
  @JsonKey(name: 'first_name')
  final String firstName;
  @override
  @JsonKey(name: 'last_name')
  final String lastName;
  @override
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;
  @override
  @JsonKey()
  final String bio;
  @override
  @JsonKey()
  final String phone;
  @override
  @JsonKey(name: 'phone_verified')
  final bool phoneVerified;
  @override
  @JsonKey(name: 'is_seller')
  final bool isSeller;
  @override
  @JsonKey(name: 'seller_since')
  @DateTimeConverter()
  final DateTime? sellerSince;
  @override
  @JsonKey(name: 'business_name')
  final String businessName;
  @override
  @JsonKey(name: 'business_address')
  final BusinessAddress? businessAddress;
  @override
  @JsonKey(name: 'business_email')
  final String businessEmail;
  @override
  @JsonKey(name: 'rating_as_seller')
  final double ratingAsSeller;
  @override
  @JsonKey(name: 'rating_as_buyer')
  final double ratingAsBuyer;
  @override
  @JsonKey(name: 'total_reviews_as_seller')
  final int totalReviewsAsSeller;
  @override
  @JsonKey(name: 'total_reviews_as_buyer')
  final int totalReviewsAsBuyer;
  @override
  @JsonKey(name: 'total_sales')
  final int totalSales;
  @override
  @JsonKey(name: 'total_purchases')
  final int totalPurchases;
  @override
  @JsonKey(name: 'total_refunds')
  final int totalRefunds;
  @override
  @JsonKey(name: 'total_cancelled')
  final int totalCancelled;
  @override
  @JsonKey(name: 'followers_count')
  final int followersCount;
  @override
  @JsonKey(name: 'following_count')
  final int followingCount;
  @override
  @JsonKey(name: 'is_private')
  final bool isPrivate;
  @override
  @JsonKey(name: 'referral_code')
  final String referralCode;
  @override
  @JsonKey(name: 'referred_by')
  final String referredBy;
  @override
  @JsonKey(name: 'created_at')
  @DateTimeConverter()
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  @DateTimeConverter()
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  @DateTimeConverter()
  final DateTime? deletedAt;
  @override
  @JsonKey(name: 'total_referrals')
  final int totalReferrals;
  @override
  @JsonKey()
  final String email;
  @override
  final StripeAccountStatus? stripe;
  final List<PaymentMethod> _paymentMethod;
  @override
  @JsonKey()
  List<PaymentMethod> get paymentMethod {
    if (_paymentMethod is EqualUnmodifiableListView) return _paymentMethod;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_paymentMethod);
  }

  @override
  @JsonKey()
  final bool hasStripeCustomer;
  @override
  @JsonKey()
  final String defaultPaymentMethodId;
  @override
  final UserSettings? userSettings;
  @override
  final ShippingAddress? shippingAddress;

  @override
  String toString() {
    return 'UserData(id: $id, userId: $userId, username: $username, firstName: $firstName, lastName: $lastName, avatarUrl: $avatarUrl, bio: $bio, phone: $phone, phoneVerified: $phoneVerified, isSeller: $isSeller, sellerSince: $sellerSince, businessName: $businessName, businessAddress: $businessAddress, businessEmail: $businessEmail, ratingAsSeller: $ratingAsSeller, ratingAsBuyer: $ratingAsBuyer, totalReviewsAsSeller: $totalReviewsAsSeller, totalReviewsAsBuyer: $totalReviewsAsBuyer, totalSales: $totalSales, totalPurchases: $totalPurchases, totalRefunds: $totalRefunds, totalCancelled: $totalCancelled, followersCount: $followersCount, followingCount: $followingCount, isPrivate: $isPrivate, referralCode: $referralCode, referredBy: $referredBy, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, totalReferrals: $totalReferrals, email: $email, stripe: $stripe, paymentMethod: $paymentMethod, hasStripeCustomer: $hasStripeCustomer, defaultPaymentMethodId: $defaultPaymentMethodId, userSettings: $userSettings, shippingAddress: $shippingAddress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.phoneVerified, phoneVerified) ||
                other.phoneVerified == phoneVerified) &&
            (identical(other.isSeller, isSeller) ||
                other.isSeller == isSeller) &&
            (identical(other.sellerSince, sellerSince) ||
                other.sellerSince == sellerSince) &&
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.businessAddress, businessAddress) ||
                other.businessAddress == businessAddress) &&
            (identical(other.businessEmail, businessEmail) ||
                other.businessEmail == businessEmail) &&
            (identical(other.ratingAsSeller, ratingAsSeller) ||
                other.ratingAsSeller == ratingAsSeller) &&
            (identical(other.ratingAsBuyer, ratingAsBuyer) ||
                other.ratingAsBuyer == ratingAsBuyer) &&
            (identical(other.totalReviewsAsSeller, totalReviewsAsSeller) ||
                other.totalReviewsAsSeller == totalReviewsAsSeller) &&
            (identical(other.totalReviewsAsBuyer, totalReviewsAsBuyer) ||
                other.totalReviewsAsBuyer == totalReviewsAsBuyer) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.totalPurchases, totalPurchases) ||
                other.totalPurchases == totalPurchases) &&
            (identical(other.totalRefunds, totalRefunds) ||
                other.totalRefunds == totalRefunds) &&
            (identical(other.totalCancelled, totalCancelled) ||
                other.totalCancelled == totalCancelled) &&
            (identical(other.followersCount, followersCount) ||
                other.followersCount == followersCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.referralCode, referralCode) ||
                other.referralCode == referralCode) &&
            (identical(other.referredBy, referredBy) ||
                other.referredBy == referredBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.totalReferrals, totalReferrals) ||
                other.totalReferrals == totalReferrals) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.stripe, stripe) || other.stripe == stripe) &&
            const DeepCollectionEquality()
                .equals(other._paymentMethod, _paymentMethod) &&
            (identical(other.hasStripeCustomer, hasStripeCustomer) ||
                other.hasStripeCustomer == hasStripeCustomer) &&
            (identical(other.defaultPaymentMethodId, defaultPaymentMethodId) ||
                other.defaultPaymentMethodId == defaultPaymentMethodId) &&
            (identical(other.userSettings, userSettings) ||
                other.userSettings == userSettings) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        username,
        firstName,
        lastName,
        avatarUrl,
        bio,
        phone,
        phoneVerified,
        isSeller,
        sellerSince,
        businessName,
        businessAddress,
        businessEmail,
        ratingAsSeller,
        ratingAsBuyer,
        totalReviewsAsSeller,
        totalReviewsAsBuyer,
        totalSales,
        totalPurchases,
        totalRefunds,
        totalCancelled,
        followersCount,
        followingCount,
        isPrivate,
        referralCode,
        referredBy,
        createdAt,
        updatedAt,
        deletedAt,
        totalReferrals,
        email,
        stripe,
        const DeepCollectionEquality().hash(_paymentMethod),
        hasStripeCustomer,
        defaultPaymentMethodId,
        userSettings,
        shippingAddress
      ]);

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      __$$UserDataImplCopyWithImpl<_$UserDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDataImplToJson(
      this,
    );
  }
}

abstract class _UserData extends UserData {
  const factory _UserData(
      {final String id,
      @JsonKey(name: 'user_id') final String userId,
      final String username,
      @JsonKey(name: 'first_name') final String firstName,
      @JsonKey(name: 'last_name') final String lastName,
      @JsonKey(name: 'avatar_url') final String avatarUrl,
      final String bio,
      final String phone,
      @JsonKey(name: 'phone_verified') final bool phoneVerified,
      @JsonKey(name: 'is_seller') final bool isSeller,
      @JsonKey(name: 'seller_since')
      @DateTimeConverter()
      final DateTime? sellerSince,
      @JsonKey(name: 'business_name') final String businessName,
      @JsonKey(name: 'business_address') final BusinessAddress? businessAddress,
      @JsonKey(name: 'business_email') final String businessEmail,
      @JsonKey(name: 'rating_as_seller') final double ratingAsSeller,
      @JsonKey(name: 'rating_as_buyer') final double ratingAsBuyer,
      @JsonKey(name: 'total_reviews_as_seller') final int totalReviewsAsSeller,
      @JsonKey(name: 'total_reviews_as_buyer') final int totalReviewsAsBuyer,
      @JsonKey(name: 'total_sales') final int totalSales,
      @JsonKey(name: 'total_purchases') final int totalPurchases,
      @JsonKey(name: 'total_refunds') final int totalRefunds,
      @JsonKey(name: 'total_cancelled') final int totalCancelled,
      @JsonKey(name: 'followers_count') final int followersCount,
      @JsonKey(name: 'following_count') final int followingCount,
      @JsonKey(name: 'is_private') final bool isPrivate,
      @JsonKey(name: 'referral_code') final String referralCode,
      @JsonKey(name: 'referred_by') final String referredBy,
      @JsonKey(name: 'created_at')
      @DateTimeConverter()
      final DateTime? createdAt,
      @JsonKey(name: 'updated_at')
      @DateTimeConverter()
      final DateTime? updatedAt,
      @JsonKey(name: 'deleted_at')
      @DateTimeConverter()
      final DateTime? deletedAt,
      @JsonKey(name: 'total_referrals') final int totalReferrals,
      final String email,
      final StripeAccountStatus? stripe,
      final List<PaymentMethod> paymentMethod,
      final bool hasStripeCustomer,
      final String defaultPaymentMethodId,
      final UserSettings? userSettings,
      final ShippingAddress? shippingAddress}) = _$UserDataImpl;
  const _UserData._() : super._();

  factory _UserData.fromJson(Map<String, dynamic> json) =
      _$UserDataImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get username;
  @override
  @JsonKey(name: 'first_name')
  String get firstName;
  @override
  @JsonKey(name: 'last_name')
  String get lastName;
  @override
  @JsonKey(name: 'avatar_url')
  String get avatarUrl;
  @override
  String get bio;
  @override
  String get phone;
  @override
  @JsonKey(name: 'phone_verified')
  bool get phoneVerified;
  @override
  @JsonKey(name: 'is_seller')
  bool get isSeller;
  @override
  @JsonKey(name: 'seller_since')
  @DateTimeConverter()
  DateTime? get sellerSince;
  @override
  @JsonKey(name: 'business_name')
  String get businessName;
  @override
  @JsonKey(name: 'business_address')
  BusinessAddress? get businessAddress;
  @override
  @JsonKey(name: 'business_email')
  String get businessEmail;
  @override
  @JsonKey(name: 'rating_as_seller')
  double get ratingAsSeller;
  @override
  @JsonKey(name: 'rating_as_buyer')
  double get ratingAsBuyer;
  @override
  @JsonKey(name: 'total_reviews_as_seller')
  int get totalReviewsAsSeller;
  @override
  @JsonKey(name: 'total_reviews_as_buyer')
  int get totalReviewsAsBuyer;
  @override
  @JsonKey(name: 'total_sales')
  int get totalSales;
  @override
  @JsonKey(name: 'total_purchases')
  int get totalPurchases;
  @override
  @JsonKey(name: 'total_refunds')
  int get totalRefunds;
  @override
  @JsonKey(name: 'total_cancelled')
  int get totalCancelled;
  @override
  @JsonKey(name: 'followers_count')
  int get followersCount;
  @override
  @JsonKey(name: 'following_count')
  int get followingCount;
  @override
  @JsonKey(name: 'is_private')
  bool get isPrivate;
  @override
  @JsonKey(name: 'referral_code')
  String get referralCode;
  @override
  @JsonKey(name: 'referred_by')
  String get referredBy;
  @override
  @JsonKey(name: 'created_at')
  @DateTimeConverter()
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  @DateTimeConverter()
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  @DateTimeConverter()
  DateTime? get deletedAt;
  @override
  @JsonKey(name: 'total_referrals')
  int get totalReferrals;
  @override
  String get email;
  @override
  StripeAccountStatus? get stripe;
  @override
  List<PaymentMethod> get paymentMethod;
  @override
  bool get hasStripeCustomer;
  @override
  String get defaultPaymentMethodId;
  @override
  UserSettings? get userSettings;
  @override
  ShippingAddress? get shippingAddress;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

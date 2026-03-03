// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seller_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Seller _$SellerFromJson(Map<String, dynamic> json) {
  return _Seller.fromJson(json);
}

/// @nodoc
mixin _$Seller {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get firstName => throw _privateConstructorUsedError;
  String get lastName => throw _privateConstructorUsedError;
  String get avatarUrl => throw _privateConstructorUsedError;
  String get bio => throw _privateConstructorUsedError;
  String get businessName => throw _privateConstructorUsedError;
  String get businessEmail => throw _privateConstructorUsedError;
  double get ratingAsSeller => throw _privateConstructorUsedError;
  int get totalReviewsAsSeller => throw _privateConstructorUsedError;
  double get ratingAsBuyer => throw _privateConstructorUsedError;
  int get totalReviewsAsBuyer => throw _privateConstructorUsedError;
  int get totalSales => throw _privateConstructorUsedError;
  int get followersCount => throw _privateConstructorUsedError;
  int get followingCount => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @DateTimeConverter()
  DateTime? get sellerSince => throw _privateConstructorUsedError;
  bool get isPrivate => throw _privateConstructorUsedError;
  int get totalProducts => throw _privateConstructorUsedError;
  int get totalShortlists => throw _privateConstructorUsedError;
  bool get isFollowing => throw _privateConstructorUsedError;
  bool get isOwnProfile => throw _privateConstructorUsedError;
  bool get isBlocked => throw _privateConstructorUsedError;
  List<Review> get reviewsAsSeller => throw _privateConstructorUsedError;
  List<Review> get reviewsAsBuyer => throw _privateConstructorUsedError;
  List<SellerProduct> get purchasedProducts =>
      throw _privateConstructorUsedError;
  List<SellerShortlist> get shortlists => throw _privateConstructorUsedError;

  /// Serializes this Seller to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Seller
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SellerCopyWith<Seller> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SellerCopyWith<$Res> {
  factory $SellerCopyWith(Seller value, $Res Function(Seller) then) =
      _$SellerCopyWithImpl<$Res, Seller>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String username,
      String firstName,
      String lastName,
      String avatarUrl,
      String bio,
      String businessName,
      String businessEmail,
      double ratingAsSeller,
      int totalReviewsAsSeller,
      double ratingAsBuyer,
      int totalReviewsAsBuyer,
      int totalSales,
      int followersCount,
      int followingCount,
      @DateTimeConverter() DateTime? createdAt,
      @DateTimeConverter() DateTime? sellerSince,
      bool isPrivate,
      int totalProducts,
      int totalShortlists,
      bool isFollowing,
      bool isOwnProfile,
      bool isBlocked,
      List<Review> reviewsAsSeller,
      List<Review> reviewsAsBuyer,
      List<SellerProduct> purchasedProducts,
      List<SellerShortlist> shortlists});
}

/// @nodoc
class _$SellerCopyWithImpl<$Res, $Val extends Seller>
    implements $SellerCopyWith<$Res> {
  _$SellerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Seller
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
    Object? businessName = null,
    Object? businessEmail = null,
    Object? ratingAsSeller = null,
    Object? totalReviewsAsSeller = null,
    Object? ratingAsBuyer = null,
    Object? totalReviewsAsBuyer = null,
    Object? totalSales = null,
    Object? followersCount = null,
    Object? followingCount = null,
    Object? createdAt = freezed,
    Object? sellerSince = freezed,
    Object? isPrivate = null,
    Object? totalProducts = null,
    Object? totalShortlists = null,
    Object? isFollowing = null,
    Object? isOwnProfile = null,
    Object? isBlocked = null,
    Object? reviewsAsSeller = null,
    Object? reviewsAsBuyer = null,
    Object? purchasedProducts = null,
    Object? shortlists = null,
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
      businessName: null == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String,
      businessEmail: null == businessEmail
          ? _value.businessEmail
          : businessEmail // ignore: cast_nullable_to_non_nullable
              as String,
      ratingAsSeller: null == ratingAsSeller
          ? _value.ratingAsSeller
          : ratingAsSeller // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviewsAsSeller: null == totalReviewsAsSeller
          ? _value.totalReviewsAsSeller
          : totalReviewsAsSeller // ignore: cast_nullable_to_non_nullable
              as int,
      ratingAsBuyer: null == ratingAsBuyer
          ? _value.ratingAsBuyer
          : ratingAsBuyer // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviewsAsBuyer: null == totalReviewsAsBuyer
          ? _value.totalReviewsAsBuyer
          : totalReviewsAsBuyer // ignore: cast_nullable_to_non_nullable
              as int,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as int,
      followersCount: null == followersCount
          ? _value.followersCount
          : followersCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _value.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sellerSince: freezed == sellerSince
          ? _value.sellerSince
          : sellerSince // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      totalProducts: null == totalProducts
          ? _value.totalProducts
          : totalProducts // ignore: cast_nullable_to_non_nullable
              as int,
      totalShortlists: null == totalShortlists
          ? _value.totalShortlists
          : totalShortlists // ignore: cast_nullable_to_non_nullable
              as int,
      isFollowing: null == isFollowing
          ? _value.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
      isOwnProfile: null == isOwnProfile
          ? _value.isOwnProfile
          : isOwnProfile // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      reviewsAsSeller: null == reviewsAsSeller
          ? _value.reviewsAsSeller
          : reviewsAsSeller // ignore: cast_nullable_to_non_nullable
              as List<Review>,
      reviewsAsBuyer: null == reviewsAsBuyer
          ? _value.reviewsAsBuyer
          : reviewsAsBuyer // ignore: cast_nullable_to_non_nullable
              as List<Review>,
      purchasedProducts: null == purchasedProducts
          ? _value.purchasedProducts
          : purchasedProducts // ignore: cast_nullable_to_non_nullable
              as List<SellerProduct>,
      shortlists: null == shortlists
          ? _value.shortlists
          : shortlists // ignore: cast_nullable_to_non_nullable
              as List<SellerShortlist>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SellerImplCopyWith<$Res> implements $SellerCopyWith<$Res> {
  factory _$$SellerImplCopyWith(
          _$SellerImpl value, $Res Function(_$SellerImpl) then) =
      __$$SellerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String username,
      String firstName,
      String lastName,
      String avatarUrl,
      String bio,
      String businessName,
      String businessEmail,
      double ratingAsSeller,
      int totalReviewsAsSeller,
      double ratingAsBuyer,
      int totalReviewsAsBuyer,
      int totalSales,
      int followersCount,
      int followingCount,
      @DateTimeConverter() DateTime? createdAt,
      @DateTimeConverter() DateTime? sellerSince,
      bool isPrivate,
      int totalProducts,
      int totalShortlists,
      bool isFollowing,
      bool isOwnProfile,
      bool isBlocked,
      List<Review> reviewsAsSeller,
      List<Review> reviewsAsBuyer,
      List<SellerProduct> purchasedProducts,
      List<SellerShortlist> shortlists});
}

/// @nodoc
class __$$SellerImplCopyWithImpl<$Res>
    extends _$SellerCopyWithImpl<$Res, _$SellerImpl>
    implements _$$SellerImplCopyWith<$Res> {
  __$$SellerImplCopyWithImpl(
      _$SellerImpl _value, $Res Function(_$SellerImpl) _then)
      : super(_value, _then);

  /// Create a copy of Seller
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
    Object? businessName = null,
    Object? businessEmail = null,
    Object? ratingAsSeller = null,
    Object? totalReviewsAsSeller = null,
    Object? ratingAsBuyer = null,
    Object? totalReviewsAsBuyer = null,
    Object? totalSales = null,
    Object? followersCount = null,
    Object? followingCount = null,
    Object? createdAt = freezed,
    Object? sellerSince = freezed,
    Object? isPrivate = null,
    Object? totalProducts = null,
    Object? totalShortlists = null,
    Object? isFollowing = null,
    Object? isOwnProfile = null,
    Object? isBlocked = null,
    Object? reviewsAsSeller = null,
    Object? reviewsAsBuyer = null,
    Object? purchasedProducts = null,
    Object? shortlists = null,
  }) {
    return _then(_$SellerImpl(
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
      businessName: null == businessName
          ? _value.businessName
          : businessName // ignore: cast_nullable_to_non_nullable
              as String,
      businessEmail: null == businessEmail
          ? _value.businessEmail
          : businessEmail // ignore: cast_nullable_to_non_nullable
              as String,
      ratingAsSeller: null == ratingAsSeller
          ? _value.ratingAsSeller
          : ratingAsSeller // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviewsAsSeller: null == totalReviewsAsSeller
          ? _value.totalReviewsAsSeller
          : totalReviewsAsSeller // ignore: cast_nullable_to_non_nullable
              as int,
      ratingAsBuyer: null == ratingAsBuyer
          ? _value.ratingAsBuyer
          : ratingAsBuyer // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviewsAsBuyer: null == totalReviewsAsBuyer
          ? _value.totalReviewsAsBuyer
          : totalReviewsAsBuyer // ignore: cast_nullable_to_non_nullable
              as int,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as int,
      followersCount: null == followersCount
          ? _value.followersCount
          : followersCount // ignore: cast_nullable_to_non_nullable
              as int,
      followingCount: null == followingCount
          ? _value.followingCount
          : followingCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sellerSince: freezed == sellerSince
          ? _value.sellerSince
          : sellerSince // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isPrivate: null == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as bool,
      totalProducts: null == totalProducts
          ? _value.totalProducts
          : totalProducts // ignore: cast_nullable_to_non_nullable
              as int,
      totalShortlists: null == totalShortlists
          ? _value.totalShortlists
          : totalShortlists // ignore: cast_nullable_to_non_nullable
              as int,
      isFollowing: null == isFollowing
          ? _value.isFollowing
          : isFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
      isOwnProfile: null == isOwnProfile
          ? _value.isOwnProfile
          : isOwnProfile // ignore: cast_nullable_to_non_nullable
              as bool,
      isBlocked: null == isBlocked
          ? _value.isBlocked
          : isBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      reviewsAsSeller: null == reviewsAsSeller
          ? _value._reviewsAsSeller
          : reviewsAsSeller // ignore: cast_nullable_to_non_nullable
              as List<Review>,
      reviewsAsBuyer: null == reviewsAsBuyer
          ? _value._reviewsAsBuyer
          : reviewsAsBuyer // ignore: cast_nullable_to_non_nullable
              as List<Review>,
      purchasedProducts: null == purchasedProducts
          ? _value._purchasedProducts
          : purchasedProducts // ignore: cast_nullable_to_non_nullable
              as List<SellerProduct>,
      shortlists: null == shortlists
          ? _value._shortlists
          : shortlists // ignore: cast_nullable_to_non_nullable
              as List<SellerShortlist>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SellerImpl extends _Seller {
  const _$SellerImpl(
      {this.id = '',
      this.userId = '',
      this.username = '',
      this.firstName = '',
      this.lastName = '',
      this.avatarUrl = '',
      this.bio = '',
      this.businessName = '',
      this.businessEmail = '',
      this.ratingAsSeller = 0.0,
      this.totalReviewsAsSeller = 0,
      this.ratingAsBuyer = 0.0,
      this.totalReviewsAsBuyer = 0,
      this.totalSales = 0,
      this.followersCount = 0,
      this.followingCount = 0,
      @DateTimeConverter() this.createdAt,
      @DateTimeConverter() this.sellerSince,
      this.isPrivate = false,
      this.totalProducts = 0,
      this.totalShortlists = 0,
      this.isFollowing = false,
      this.isOwnProfile = false,
      this.isBlocked = false,
      final List<Review> reviewsAsSeller = const [],
      final List<Review> reviewsAsBuyer = const [],
      final List<SellerProduct> purchasedProducts = const [],
      final List<SellerShortlist> shortlists = const []})
      : _reviewsAsSeller = reviewsAsSeller,
        _reviewsAsBuyer = reviewsAsBuyer,
        _purchasedProducts = purchasedProducts,
        _shortlists = shortlists,
        super._();

  factory _$SellerImpl.fromJson(Map<String, dynamic> json) =>
      _$$SellerImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String userId;
  @override
  @JsonKey()
  final String username;
  @override
  @JsonKey()
  final String firstName;
  @override
  @JsonKey()
  final String lastName;
  @override
  @JsonKey()
  final String avatarUrl;
  @override
  @JsonKey()
  final String bio;
  @override
  @JsonKey()
  final String businessName;
  @override
  @JsonKey()
  final String businessEmail;
  @override
  @JsonKey()
  final double ratingAsSeller;
  @override
  @JsonKey()
  final int totalReviewsAsSeller;
  @override
  @JsonKey()
  final double ratingAsBuyer;
  @override
  @JsonKey()
  final int totalReviewsAsBuyer;
  @override
  @JsonKey()
  final int totalSales;
  @override
  @JsonKey()
  final int followersCount;
  @override
  @JsonKey()
  final int followingCount;
  @override
  @DateTimeConverter()
  final DateTime? createdAt;
  @override
  @DateTimeConverter()
  final DateTime? sellerSince;
  @override
  @JsonKey()
  final bool isPrivate;
  @override
  @JsonKey()
  final int totalProducts;
  @override
  @JsonKey()
  final int totalShortlists;
  @override
  @JsonKey()
  final bool isFollowing;
  @override
  @JsonKey()
  final bool isOwnProfile;
  @override
  @JsonKey()
  final bool isBlocked;
  final List<Review> _reviewsAsSeller;
  @override
  @JsonKey()
  List<Review> get reviewsAsSeller {
    if (_reviewsAsSeller is EqualUnmodifiableListView) return _reviewsAsSeller;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reviewsAsSeller);
  }

  final List<Review> _reviewsAsBuyer;
  @override
  @JsonKey()
  List<Review> get reviewsAsBuyer {
    if (_reviewsAsBuyer is EqualUnmodifiableListView) return _reviewsAsBuyer;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reviewsAsBuyer);
  }

  final List<SellerProduct> _purchasedProducts;
  @override
  @JsonKey()
  List<SellerProduct> get purchasedProducts {
    if (_purchasedProducts is EqualUnmodifiableListView)
      return _purchasedProducts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_purchasedProducts);
  }

  final List<SellerShortlist> _shortlists;
  @override
  @JsonKey()
  List<SellerShortlist> get shortlists {
    if (_shortlists is EqualUnmodifiableListView) return _shortlists;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_shortlists);
  }

  @override
  String toString() {
    return 'Seller(id: $id, userId: $userId, username: $username, firstName: $firstName, lastName: $lastName, avatarUrl: $avatarUrl, bio: $bio, businessName: $businessName, businessEmail: $businessEmail, ratingAsSeller: $ratingAsSeller, totalReviewsAsSeller: $totalReviewsAsSeller, ratingAsBuyer: $ratingAsBuyer, totalReviewsAsBuyer: $totalReviewsAsBuyer, totalSales: $totalSales, followersCount: $followersCount, followingCount: $followingCount, createdAt: $createdAt, sellerSince: $sellerSince, isPrivate: $isPrivate, totalProducts: $totalProducts, totalShortlists: $totalShortlists, isFollowing: $isFollowing, isOwnProfile: $isOwnProfile, isBlocked: $isBlocked, reviewsAsSeller: $reviewsAsSeller, reviewsAsBuyer: $reviewsAsBuyer, purchasedProducts: $purchasedProducts, shortlists: $shortlists)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SellerImpl &&
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
            (identical(other.businessName, businessName) ||
                other.businessName == businessName) &&
            (identical(other.businessEmail, businessEmail) ||
                other.businessEmail == businessEmail) &&
            (identical(other.ratingAsSeller, ratingAsSeller) ||
                other.ratingAsSeller == ratingAsSeller) &&
            (identical(other.totalReviewsAsSeller, totalReviewsAsSeller) ||
                other.totalReviewsAsSeller == totalReviewsAsSeller) &&
            (identical(other.ratingAsBuyer, ratingAsBuyer) ||
                other.ratingAsBuyer == ratingAsBuyer) &&
            (identical(other.totalReviewsAsBuyer, totalReviewsAsBuyer) ||
                other.totalReviewsAsBuyer == totalReviewsAsBuyer) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.followersCount, followersCount) ||
                other.followersCount == followersCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.sellerSince, sellerSince) ||
                other.sellerSince == sellerSince) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.totalProducts, totalProducts) ||
                other.totalProducts == totalProducts) &&
            (identical(other.totalShortlists, totalShortlists) ||
                other.totalShortlists == totalShortlists) &&
            (identical(other.isFollowing, isFollowing) ||
                other.isFollowing == isFollowing) &&
            (identical(other.isOwnProfile, isOwnProfile) ||
                other.isOwnProfile == isOwnProfile) &&
            (identical(other.isBlocked, isBlocked) ||
                other.isBlocked == isBlocked) &&
            const DeepCollectionEquality()
                .equals(other._reviewsAsSeller, _reviewsAsSeller) &&
            const DeepCollectionEquality()
                .equals(other._reviewsAsBuyer, _reviewsAsBuyer) &&
            const DeepCollectionEquality()
                .equals(other._purchasedProducts, _purchasedProducts) &&
            const DeepCollectionEquality()
                .equals(other._shortlists, _shortlists));
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
        businessName,
        businessEmail,
        ratingAsSeller,
        totalReviewsAsSeller,
        ratingAsBuyer,
        totalReviewsAsBuyer,
        totalSales,
        followersCount,
        followingCount,
        createdAt,
        sellerSince,
        isPrivate,
        totalProducts,
        totalShortlists,
        isFollowing,
        isOwnProfile,
        isBlocked,
        const DeepCollectionEquality().hash(_reviewsAsSeller),
        const DeepCollectionEquality().hash(_reviewsAsBuyer),
        const DeepCollectionEquality().hash(_purchasedProducts),
        const DeepCollectionEquality().hash(_shortlists)
      ]);

  /// Create a copy of Seller
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SellerImplCopyWith<_$SellerImpl> get copyWith =>
      __$$SellerImplCopyWithImpl<_$SellerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SellerImplToJson(
      this,
    );
  }
}

abstract class _Seller extends Seller {
  const factory _Seller(
      {final String id,
      final String userId,
      final String username,
      final String firstName,
      final String lastName,
      final String avatarUrl,
      final String bio,
      final String businessName,
      final String businessEmail,
      final double ratingAsSeller,
      final int totalReviewsAsSeller,
      final double ratingAsBuyer,
      final int totalReviewsAsBuyer,
      final int totalSales,
      final int followersCount,
      final int followingCount,
      @DateTimeConverter() final DateTime? createdAt,
      @DateTimeConverter() final DateTime? sellerSince,
      final bool isPrivate,
      final int totalProducts,
      final int totalShortlists,
      final bool isFollowing,
      final bool isOwnProfile,
      final bool isBlocked,
      final List<Review> reviewsAsSeller,
      final List<Review> reviewsAsBuyer,
      final List<SellerProduct> purchasedProducts,
      final List<SellerShortlist> shortlists}) = _$SellerImpl;
  const _Seller._() : super._();

  factory _Seller.fromJson(Map<String, dynamic> json) = _$SellerImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get username;
  @override
  String get firstName;
  @override
  String get lastName;
  @override
  String get avatarUrl;
  @override
  String get bio;
  @override
  String get businessName;
  @override
  String get businessEmail;
  @override
  double get ratingAsSeller;
  @override
  int get totalReviewsAsSeller;
  @override
  double get ratingAsBuyer;
  @override
  int get totalReviewsAsBuyer;
  @override
  int get totalSales;
  @override
  int get followersCount;
  @override
  int get followingCount;
  @override
  @DateTimeConverter()
  DateTime? get createdAt;
  @override
  @DateTimeConverter()
  DateTime? get sellerSince;
  @override
  bool get isPrivate;
  @override
  int get totalProducts;
  @override
  int get totalShortlists;
  @override
  bool get isFollowing;
  @override
  bool get isOwnProfile;
  @override
  bool get isBlocked;
  @override
  List<Review> get reviewsAsSeller;
  @override
  List<Review> get reviewsAsBuyer;
  @override
  List<SellerProduct> get purchasedProducts;
  @override
  List<SellerShortlist> get shortlists;

  /// Create a copy of Seller
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SellerImplCopyWith<_$SellerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

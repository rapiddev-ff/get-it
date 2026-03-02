// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SellerStruct extends BaseStruct {
  SellerStruct({
    String? id,
    String? username,
    String? avatarUrl,
    double? ratingAsSeller,
    int? totalReviewsAsSeller,
    double? ratingAsBuyer,
    int? totalReviewsAsBuyer,
    int? totalSales,
    DateTime? sellerSince,
    String? bio,
    int? followersCount,
    int? followingCount,
    bool? isPrivate,
    int? totalProducts,
    int? totalShortlists,
    bool? isFollowing,
    bool? isOwnProfile,
    bool? isBlocked,
    List<ReviewStruct>? reviewsAsSeller,
    List<ReviewStruct>? reviewsAsBuyer,
    List<SellerProductStruct>? purchasedProducts,
    List<SellerShortlistStruct>? shortlists,
  })  : _id = id,
        _username = username,
        _avatarUrl = avatarUrl,
        _ratingAsSeller = ratingAsSeller,
        _totalReviewsAsSeller = totalReviewsAsSeller,
        _ratingAsBuyer = ratingAsBuyer,
        _totalReviewsAsBuyer = totalReviewsAsBuyer,
        _totalSales = totalSales,
        _sellerSince = sellerSince,
        _bio = bio,
        _followersCount = followersCount,
        _followingCount = followingCount,
        _isPrivate = isPrivate,
        _totalProducts = totalProducts,
        _totalShortlists = totalShortlists,
        _isFollowing = isFollowing,
        _isOwnProfile = isOwnProfile,
        _isBlocked = isBlocked,
        _reviewsAsSeller = reviewsAsSeller,
        _reviewsAsBuyer = reviewsAsBuyer,
        _purchasedProducts = purchasedProducts,
        _shortlists = shortlists;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "username" field.
  String? _username;
  String get username => _username ?? '';
  set username(String? val) => _username = val;

  bool hasUsername() => _username != null;

  // "avatarUrl" field.
  String? _avatarUrl;
  String get avatarUrl => _avatarUrl ?? '';
  set avatarUrl(String? val) => _avatarUrl = val;

  bool hasAvatarUrl() => _avatarUrl != null;

  // "ratingAsSeller" field.
  double? _ratingAsSeller;
  double get ratingAsSeller => _ratingAsSeller ?? 0.0;
  set ratingAsSeller(double? val) => _ratingAsSeller = val;

  void incrementRatingAsSeller(double amount) =>
      ratingAsSeller = ratingAsSeller + amount;

  bool hasRatingAsSeller() => _ratingAsSeller != null;

  // "totalReviewsAsSeller" field.
  int? _totalReviewsAsSeller;
  int get totalReviewsAsSeller => _totalReviewsAsSeller ?? 0;
  set totalReviewsAsSeller(int? val) => _totalReviewsAsSeller = val;

  void incrementTotalReviewsAsSeller(int amount) =>
      totalReviewsAsSeller = totalReviewsAsSeller + amount;

  bool hasTotalReviewsAsSeller() => _totalReviewsAsSeller != null;

  // "ratingAsBuyer" field.
  double? _ratingAsBuyer;
  double get ratingAsBuyer => _ratingAsBuyer ?? 0.0;
  set ratingAsBuyer(double? val) => _ratingAsBuyer = val;

  void incrementRatingAsBuyer(double amount) =>
      ratingAsBuyer = ratingAsBuyer + amount;

  bool hasRatingAsBuyer() => _ratingAsBuyer != null;

  // "totalReviewsAsBuyer" field.
  int? _totalReviewsAsBuyer;
  int get totalReviewsAsBuyer => _totalReviewsAsBuyer ?? 0;
  set totalReviewsAsBuyer(int? val) => _totalReviewsAsBuyer = val;

  void incrementTotalReviewsAsBuyer(int amount) =>
      totalReviewsAsBuyer = totalReviewsAsBuyer + amount;

  bool hasTotalReviewsAsBuyer() => _totalReviewsAsBuyer != null;

  // "totalSales" field.
  int? _totalSales;
  int get totalSales => _totalSales ?? 0;
  set totalSales(int? val) => _totalSales = val;

  void incrementTotalSales(int amount) => totalSales = totalSales + amount;

  bool hasTotalSales() => _totalSales != null;

  // "sellerSince" field.
  DateTime? _sellerSince;
  DateTime? get sellerSince => _sellerSince;
  set sellerSince(DateTime? val) => _sellerSince = val;

  bool hasSellerSince() => _sellerSince != null;

  // "bio" field.
  String? _bio;
  String get bio => _bio ?? '';
  set bio(String? val) => _bio = val;

  bool hasBio() => _bio != null;

  // "followersCount" field.
  int? _followersCount;
  int get followersCount => _followersCount ?? 0;
  set followersCount(int? val) => _followersCount = val;

  void incrementFollowersCount(int amount) =>
      followersCount = followersCount + amount;

  bool hasFollowersCount() => _followersCount != null;

  // "followingCount" field.
  int? _followingCount;
  int get followingCount => _followingCount ?? 0;
  set followingCount(int? val) => _followingCount = val;

  void incrementFollowingCount(int amount) =>
      followingCount = followingCount + amount;

  bool hasFollowingCount() => _followingCount != null;

  // "isPrivate" field.
  bool? _isPrivate;
  bool get isPrivate => _isPrivate ?? false;
  set isPrivate(bool? val) => _isPrivate = val;

  bool hasIsPrivate() => _isPrivate != null;

  // "totalProducts" field.
  int? _totalProducts;
  int get totalProducts => _totalProducts ?? 0;
  set totalProducts(int? val) => _totalProducts = val;

  void incrementTotalProducts(int amount) =>
      totalProducts = totalProducts + amount;

  bool hasTotalProducts() => _totalProducts != null;

  // "totalShortlists" field.
  int? _totalShortlists;
  int get totalShortlists => _totalShortlists ?? 0;
  set totalShortlists(int? val) => _totalShortlists = val;

  void incrementTotalShortlists(int amount) =>
      totalShortlists = totalShortlists + amount;

  bool hasTotalShortlists() => _totalShortlists != null;

  // "isFollowing" field.
  bool? _isFollowing;
  bool get isFollowing => _isFollowing ?? false;
  set isFollowing(bool? val) => _isFollowing = val;

  bool hasIsFollowing() => _isFollowing != null;

  // "isOwnProfile" field.
  bool? _isOwnProfile;
  bool get isOwnProfile => _isOwnProfile ?? false;
  set isOwnProfile(bool? val) => _isOwnProfile = val;

  bool hasIsOwnProfile() => _isOwnProfile != null;

  // "isBlocked" field.
  bool? _isBlocked;
  bool get isBlocked => _isBlocked ?? false;
  set isBlocked(bool? val) => _isBlocked = val;

  bool hasIsBlocked() => _isBlocked != null;

  // "reviewsAsSeller" field.
  List<ReviewStruct>? _reviewsAsSeller;
  List<ReviewStruct> get reviewsAsSeller => _reviewsAsSeller ?? const [];
  set reviewsAsSeller(List<ReviewStruct>? val) => _reviewsAsSeller = val;

  void updateReviewsAsSeller(Function(List<ReviewStruct>) updateFn) {
    updateFn(_reviewsAsSeller ??= []);
  }

  bool hasReviewsAsSeller() => _reviewsAsSeller != null;

  // "reviewsAsBuyer" field.
  List<ReviewStruct>? _reviewsAsBuyer;
  List<ReviewStruct> get reviewsAsBuyer => _reviewsAsBuyer ?? const [];
  set reviewsAsBuyer(List<ReviewStruct>? val) => _reviewsAsBuyer = val;

  void updateReviewsAsBuyer(Function(List<ReviewStruct>) updateFn) {
    updateFn(_reviewsAsBuyer ??= []);
  }

  bool hasReviewsAsBuyer() => _reviewsAsBuyer != null;

  // "purchasedProducts" field.
  List<SellerProductStruct>? _purchasedProducts;
  List<SellerProductStruct> get purchasedProducts =>
      _purchasedProducts ?? const [];
  set purchasedProducts(List<SellerProductStruct>? val) =>
      _purchasedProducts = val;

  void updatePurchasedProducts(Function(List<SellerProductStruct>) updateFn) {
    updateFn(_purchasedProducts ??= []);
  }

  bool hasPurchasedProducts() => _purchasedProducts != null;

  // "shortlists" field.
  List<SellerShortlistStruct>? _shortlists;
  List<SellerShortlistStruct> get shortlists => _shortlists ?? const [];
  set shortlists(List<SellerShortlistStruct>? val) => _shortlists = val;

  void updateShortlists(Function(List<SellerShortlistStruct>) updateFn) {
    updateFn(_shortlists ??= []);
  }

  bool hasShortlists() => _shortlists != null;

  static SellerStruct fromMap(Map<String, dynamic> data) => SellerStruct(
        id: data['id'] as String?,
        username: data['username'] as String?,
        avatarUrl: data['avatarUrl'] as String?,
        ratingAsSeller: castToType<double>(data['ratingAsSeller']),
        totalReviewsAsSeller: castToType<int>(data['totalReviewsAsSeller']),
        ratingAsBuyer: castToType<double>(data['ratingAsBuyer']),
        totalReviewsAsBuyer: castToType<int>(data['totalReviewsAsBuyer']),
        totalSales: castToType<int>(data['totalSales']),
        sellerSince: data['sellerSince'] as DateTime?,
        bio: data['bio'] as String?,
        followersCount: castToType<int>(data['followersCount']),
        followingCount: castToType<int>(data['followingCount']),
        isPrivate: data['isPrivate'] as bool?,
        totalProducts: castToType<int>(data['totalProducts']),
        totalShortlists: castToType<int>(data['totalShortlists']),
        isFollowing: data['isFollowing'] as bool?,
        isOwnProfile: data['isOwnProfile'] as bool?,
        isBlocked: data['isBlocked'] as bool?,
        reviewsAsSeller: getStructList(
          data['reviewsAsSeller'],
          ReviewStruct.fromMap,
        ),
        reviewsAsBuyer: getStructList(
          data['reviewsAsBuyer'],
          ReviewStruct.fromMap,
        ),
        purchasedProducts: getStructList(
          data['purchasedProducts'],
          SellerProductStruct.fromMap,
        ),
        shortlists: getStructList(
          data['shortlists'],
          SellerShortlistStruct.fromMap,
        ),
      );

  static SellerStruct? maybeFromMap(dynamic data) =>
      data is Map ? SellerStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'username': _username,
        'avatarUrl': _avatarUrl,
        'ratingAsSeller': _ratingAsSeller,
        'totalReviewsAsSeller': _totalReviewsAsSeller,
        'ratingAsBuyer': _ratingAsBuyer,
        'totalReviewsAsBuyer': _totalReviewsAsBuyer,
        'totalSales': _totalSales,
        'sellerSince': _sellerSince,
        'bio': _bio,
        'followersCount': _followersCount,
        'followingCount': _followingCount,
        'isPrivate': _isPrivate,
        'totalProducts': _totalProducts,
        'totalShortlists': _totalShortlists,
        'isFollowing': _isFollowing,
        'isOwnProfile': _isOwnProfile,
        'isBlocked': _isBlocked,
        'reviewsAsSeller': _reviewsAsSeller?.map((e) => e.toMap()).toList(),
        'reviewsAsBuyer': _reviewsAsBuyer?.map((e) => e.toMap()).toList(),
        'purchasedProducts': _purchasedProducts?.map((e) => e.toMap()).toList(),
        'shortlists': _shortlists?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'username': serializeParam(
          _username,
          ParamType.String,
        ),
        'avatarUrl': serializeParam(
          _avatarUrl,
          ParamType.String,
        ),
        'ratingAsSeller': serializeParam(
          _ratingAsSeller,
          ParamType.double,
        ),
        'totalReviewsAsSeller': serializeParam(
          _totalReviewsAsSeller,
          ParamType.int,
        ),
        'ratingAsBuyer': serializeParam(
          _ratingAsBuyer,
          ParamType.double,
        ),
        'totalReviewsAsBuyer': serializeParam(
          _totalReviewsAsBuyer,
          ParamType.int,
        ),
        'totalSales': serializeParam(
          _totalSales,
          ParamType.int,
        ),
        'sellerSince': serializeParam(
          _sellerSince,
          ParamType.DateTime,
        ),
        'bio': serializeParam(
          _bio,
          ParamType.String,
        ),
        'followersCount': serializeParam(
          _followersCount,
          ParamType.int,
        ),
        'followingCount': serializeParam(
          _followingCount,
          ParamType.int,
        ),
        'isPrivate': serializeParam(
          _isPrivate,
          ParamType.bool,
        ),
        'totalProducts': serializeParam(
          _totalProducts,
          ParamType.int,
        ),
        'totalShortlists': serializeParam(
          _totalShortlists,
          ParamType.int,
        ),
        'isFollowing': serializeParam(
          _isFollowing,
          ParamType.bool,
        ),
        'isOwnProfile': serializeParam(
          _isOwnProfile,
          ParamType.bool,
        ),
        'isBlocked': serializeParam(
          _isBlocked,
          ParamType.bool,
        ),
        'reviewsAsSeller': serializeParam(
          _reviewsAsSeller,
          ParamType.DataStruct,
          isList: true,
        ),
        'reviewsAsBuyer': serializeParam(
          _reviewsAsBuyer,
          ParamType.DataStruct,
          isList: true,
        ),
        'purchasedProducts': serializeParam(
          _purchasedProducts,
          ParamType.DataStruct,
          isList: true,
        ),
        'shortlists': serializeParam(
          _shortlists,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static SellerStruct fromSerializableMap(Map<String, dynamic> data) =>
      SellerStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        username: deserializeParam(
          data['username'],
          ParamType.String,
          false,
        ),
        avatarUrl: deserializeParam(
          data['avatarUrl'],
          ParamType.String,
          false,
        ),
        ratingAsSeller: deserializeParam(
          data['ratingAsSeller'],
          ParamType.double,
          false,
        ),
        totalReviewsAsSeller: deserializeParam(
          data['totalReviewsAsSeller'],
          ParamType.int,
          false,
        ),
        ratingAsBuyer: deserializeParam(
          data['ratingAsBuyer'],
          ParamType.double,
          false,
        ),
        totalReviewsAsBuyer: deserializeParam(
          data['totalReviewsAsBuyer'],
          ParamType.int,
          false,
        ),
        totalSales: deserializeParam(
          data['totalSales'],
          ParamType.int,
          false,
        ),
        sellerSince: deserializeParam(
          data['sellerSince'],
          ParamType.DateTime,
          false,
        ),
        bio: deserializeParam(
          data['bio'],
          ParamType.String,
          false,
        ),
        followersCount: deserializeParam(
          data['followersCount'],
          ParamType.int,
          false,
        ),
        followingCount: deserializeParam(
          data['followingCount'],
          ParamType.int,
          false,
        ),
        isPrivate: deserializeParam(
          data['isPrivate'],
          ParamType.bool,
          false,
        ),
        totalProducts: deserializeParam(
          data['totalProducts'],
          ParamType.int,
          false,
        ),
        totalShortlists: deserializeParam(
          data['totalShortlists'],
          ParamType.int,
          false,
        ),
        isFollowing: deserializeParam(
          data['isFollowing'],
          ParamType.bool,
          false,
        ),
        isOwnProfile: deserializeParam(
          data['isOwnProfile'],
          ParamType.bool,
          false,
        ),
        isBlocked: deserializeParam(
          data['isBlocked'],
          ParamType.bool,
          false,
        ),
        reviewsAsSeller: deserializeStructParam<ReviewStruct>(
          data['reviewsAsSeller'],
          ParamType.DataStruct,
          true,
          structBuilder: ReviewStruct.fromSerializableMap,
        ),
        reviewsAsBuyer: deserializeStructParam<ReviewStruct>(
          data['reviewsAsBuyer'],
          ParamType.DataStruct,
          true,
          structBuilder: ReviewStruct.fromSerializableMap,
        ),
        purchasedProducts: deserializeStructParam<SellerProductStruct>(
          data['purchasedProducts'],
          ParamType.DataStruct,
          true,
          structBuilder: SellerProductStruct.fromSerializableMap,
        ),
        shortlists: deserializeStructParam<SellerShortlistStruct>(
          data['shortlists'],
          ParamType.DataStruct,
          true,
          structBuilder: SellerShortlistStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'SellerStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SellerStruct &&
        id == other.id &&
        username == other.username &&
        avatarUrl == other.avatarUrl &&
        ratingAsSeller == other.ratingAsSeller &&
        totalReviewsAsSeller == other.totalReviewsAsSeller &&
        ratingAsBuyer == other.ratingAsBuyer &&
        totalReviewsAsBuyer == other.totalReviewsAsBuyer &&
        totalSales == other.totalSales &&
        sellerSince == other.sellerSince &&
        bio == other.bio &&
        followersCount == other.followersCount &&
        followingCount == other.followingCount &&
        isPrivate == other.isPrivate &&
        totalProducts == other.totalProducts &&
        totalShortlists == other.totalShortlists &&
        isFollowing == other.isFollowing &&
        isOwnProfile == other.isOwnProfile &&
        isBlocked == other.isBlocked &&
        listEquality.equals(reviewsAsSeller, other.reviewsAsSeller) &&
        listEquality.equals(reviewsAsBuyer, other.reviewsAsBuyer) &&
        listEquality.equals(purchasedProducts, other.purchasedProducts) &&
        listEquality.equals(shortlists, other.shortlists);
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        username,
        avatarUrl,
        ratingAsSeller,
        totalReviewsAsSeller,
        ratingAsBuyer,
        totalReviewsAsBuyer,
        totalSales,
        sellerSince,
        bio,
        followersCount,
        followingCount,
        isPrivate,
        totalProducts,
        totalShortlists,
        isFollowing,
        isOwnProfile,
        isBlocked,
        reviewsAsSeller,
        reviewsAsBuyer,
        purchasedProducts,
        shortlists
      ]);
}

SellerStruct createSellerStruct({
  String? id,
  String? username,
  String? avatarUrl,
  double? ratingAsSeller,
  int? totalReviewsAsSeller,
  double? ratingAsBuyer,
  int? totalReviewsAsBuyer,
  int? totalSales,
  DateTime? sellerSince,
  String? bio,
  int? followersCount,
  int? followingCount,
  bool? isPrivate,
  int? totalProducts,
  int? totalShortlists,
  bool? isFollowing,
  bool? isOwnProfile,
  bool? isBlocked,
}) =>
    SellerStruct(
      id: id,
      username: username,
      avatarUrl: avatarUrl,
      ratingAsSeller: ratingAsSeller,
      totalReviewsAsSeller: totalReviewsAsSeller,
      ratingAsBuyer: ratingAsBuyer,
      totalReviewsAsBuyer: totalReviewsAsBuyer,
      totalSales: totalSales,
      sellerSince: sellerSince,
      bio: bio,
      followersCount: followersCount,
      followingCount: followingCount,
      isPrivate: isPrivate,
      totalProducts: totalProducts,
      totalShortlists: totalShortlists,
      isFollowing: isFollowing,
      isOwnProfile: isOwnProfile,
      isBlocked: isBlocked,
    );

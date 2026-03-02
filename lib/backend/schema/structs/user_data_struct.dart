// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UserDataStruct extends BaseStruct {
  UserDataStruct({
    String? id,
    String? userId,
    String? username,
    String? firstName,
    String? lastName,
    String? avatarUrl,
    String? bio,
    String? phone,
    bool? phoneVerified,
    bool? isSeller,
    DateTime? sellerSince,
    String? businessName,
    BusinessAddressStruct? businessAddress,
    String? businessEmail,
    double? ratingAsSeller,
    double? ratingAsBuyer,
    int? totalReviewsAsSeller,
    int? totalReviewsAsBuyer,
    int? totalSales,
    int? totalPurchases,
    int? totalRefunds,
    int? totalCancelled,
    int? followersCount,
    int? followingCount,
    bool? isPrivate,
    String? referralCode,
    String? referredBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? totalReferrals,
    String? email,
    StripeAccountStatusStruct? stripe,
    List<PaymentMethodStruct>? paymentMethod,
    bool? hasStripeCustomer,
    String? defaultPaymentMethodId,
    UserSettingsStruct? userSettings,
    ShippingAddressStruct? shippingAddress,
  })  : _id = id,
        _userId = userId,
        _username = username,
        _firstName = firstName,
        _lastName = lastName,
        _avatarUrl = avatarUrl,
        _bio = bio,
        _phone = phone,
        _phoneVerified = phoneVerified,
        _isSeller = isSeller,
        _sellerSince = sellerSince,
        _businessName = businessName,
        _businessAddress = businessAddress,
        _businessEmail = businessEmail,
        _ratingAsSeller = ratingAsSeller,
        _ratingAsBuyer = ratingAsBuyer,
        _totalReviewsAsSeller = totalReviewsAsSeller,
        _totalReviewsAsBuyer = totalReviewsAsBuyer,
        _totalSales = totalSales,
        _totalPurchases = totalPurchases,
        _totalRefunds = totalRefunds,
        _totalCancelled = totalCancelled,
        _followersCount = followersCount,
        _followingCount = followingCount,
        _isPrivate = isPrivate,
        _referralCode = referralCode,
        _referredBy = referredBy,
        _createdAt = createdAt,
        _updatedAt = updatedAt,
        _deletedAt = deletedAt,
        _totalReferrals = totalReferrals,
        _email = email,
        _stripe = stripe,
        _paymentMethod = paymentMethod,
        _hasStripeCustomer = hasStripeCustomer,
        _defaultPaymentMethodId = defaultPaymentMethodId,
        _userSettings = userSettings,
        _shippingAddress = shippingAddress;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "user_id" field.
  String? _userId;
  String get userId => _userId ?? '';
  set userId(String? val) => _userId = val;

  bool hasUserId() => _userId != null;

  // "username" field.
  String? _username;
  String get username => _username ?? '';
  set username(String? val) => _username = val;

  bool hasUsername() => _username != null;

  // "first_name" field.
  String? _firstName;
  String get firstName => _firstName ?? '';
  set firstName(String? val) => _firstName = val;

  bool hasFirstName() => _firstName != null;

  // "last_name" field.
  String? _lastName;
  String get lastName => _lastName ?? '';
  set lastName(String? val) => _lastName = val;

  bool hasLastName() => _lastName != null;

  // "avatar_url" field.
  String? _avatarUrl;
  String get avatarUrl => _avatarUrl ?? '';
  set avatarUrl(String? val) => _avatarUrl = val;

  bool hasAvatarUrl() => _avatarUrl != null;

  // "bio" field.
  String? _bio;
  String get bio => _bio ?? '';
  set bio(String? val) => _bio = val;

  bool hasBio() => _bio != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  set phone(String? val) => _phone = val;

  bool hasPhone() => _phone != null;

  // "phone_verified" field.
  bool? _phoneVerified;
  bool get phoneVerified => _phoneVerified ?? false;
  set phoneVerified(bool? val) => _phoneVerified = val;

  bool hasPhoneVerified() => _phoneVerified != null;

  // "is_seller" field.
  bool? _isSeller;
  bool get isSeller => _isSeller ?? false;
  set isSeller(bool? val) => _isSeller = val;

  bool hasIsSeller() => _isSeller != null;

  // "seller_since" field.
  DateTime? _sellerSince;
  DateTime? get sellerSince => _sellerSince;
  set sellerSince(DateTime? val) => _sellerSince = val;

  bool hasSellerSince() => _sellerSince != null;

  // "business_name" field.
  String? _businessName;
  String get businessName => _businessName ?? '';
  set businessName(String? val) => _businessName = val;

  bool hasBusinessName() => _businessName != null;

  // "business_address" field.
  BusinessAddressStruct? _businessAddress;
  BusinessAddressStruct get businessAddress =>
      _businessAddress ?? BusinessAddressStruct();
  set businessAddress(BusinessAddressStruct? val) => _businessAddress = val;

  void updateBusinessAddress(Function(BusinessAddressStruct) updateFn) {
    updateFn(_businessAddress ??= BusinessAddressStruct());
  }

  bool hasBusinessAddress() => _businessAddress != null;

  // "business_email" field.
  String? _businessEmail;
  String get businessEmail => _businessEmail ?? '';
  set businessEmail(String? val) => _businessEmail = val;

  bool hasBusinessEmail() => _businessEmail != null;

  // "rating_as_seller" field.
  double? _ratingAsSeller;
  double get ratingAsSeller => _ratingAsSeller ?? 0.0;
  set ratingAsSeller(double? val) => _ratingAsSeller = val;

  void incrementRatingAsSeller(double amount) =>
      ratingAsSeller = ratingAsSeller + amount;

  bool hasRatingAsSeller() => _ratingAsSeller != null;

  // "rating_as_buyer" field.
  double? _ratingAsBuyer;
  double get ratingAsBuyer => _ratingAsBuyer ?? 0.0;
  set ratingAsBuyer(double? val) => _ratingAsBuyer = val;

  void incrementRatingAsBuyer(double amount) =>
      ratingAsBuyer = ratingAsBuyer + amount;

  bool hasRatingAsBuyer() => _ratingAsBuyer != null;

  // "total_reviews_as_seller" field.
  int? _totalReviewsAsSeller;
  int get totalReviewsAsSeller => _totalReviewsAsSeller ?? 0;
  set totalReviewsAsSeller(int? val) => _totalReviewsAsSeller = val;

  void incrementTotalReviewsAsSeller(int amount) =>
      totalReviewsAsSeller = totalReviewsAsSeller + amount;

  bool hasTotalReviewsAsSeller() => _totalReviewsAsSeller != null;

  // "total_reviews_as_buyer" field.
  int? _totalReviewsAsBuyer;
  int get totalReviewsAsBuyer => _totalReviewsAsBuyer ?? 0;
  set totalReviewsAsBuyer(int? val) => _totalReviewsAsBuyer = val;

  void incrementTotalReviewsAsBuyer(int amount) =>
      totalReviewsAsBuyer = totalReviewsAsBuyer + amount;

  bool hasTotalReviewsAsBuyer() => _totalReviewsAsBuyer != null;

  // "total_sales" field.
  int? _totalSales;
  int get totalSales => _totalSales ?? 0;
  set totalSales(int? val) => _totalSales = val;

  void incrementTotalSales(int amount) => totalSales = totalSales + amount;

  bool hasTotalSales() => _totalSales != null;

  // "total_purchases" field.
  int? _totalPurchases;
  int get totalPurchases => _totalPurchases ?? 0;
  set totalPurchases(int? val) => _totalPurchases = val;

  void incrementTotalPurchases(int amount) =>
      totalPurchases = totalPurchases + amount;

  bool hasTotalPurchases() => _totalPurchases != null;

  // "total_refunds" field.
  int? _totalRefunds;
  int get totalRefunds => _totalRefunds ?? 0;
  set totalRefunds(int? val) => _totalRefunds = val;

  void incrementTotalRefunds(int amount) =>
      totalRefunds = totalRefunds + amount;

  bool hasTotalRefunds() => _totalRefunds != null;

  // "total_cancelled" field.
  int? _totalCancelled;
  int get totalCancelled => _totalCancelled ?? 0;
  set totalCancelled(int? val) => _totalCancelled = val;

  void incrementTotalCancelled(int amount) =>
      totalCancelled = totalCancelled + amount;

  bool hasTotalCancelled() => _totalCancelled != null;

  // "followers_count" field.
  int? _followersCount;
  int get followersCount => _followersCount ?? 0;
  set followersCount(int? val) => _followersCount = val;

  void incrementFollowersCount(int amount) =>
      followersCount = followersCount + amount;

  bool hasFollowersCount() => _followersCount != null;

  // "following_count" field.
  int? _followingCount;
  int get followingCount => _followingCount ?? 0;
  set followingCount(int? val) => _followingCount = val;

  void incrementFollowingCount(int amount) =>
      followingCount = followingCount + amount;

  bool hasFollowingCount() => _followingCount != null;

  // "is_private" field.
  bool? _isPrivate;
  bool get isPrivate => _isPrivate ?? false;
  set isPrivate(bool? val) => _isPrivate = val;

  bool hasIsPrivate() => _isPrivate != null;

  // "referral_code" field.
  String? _referralCode;
  String get referralCode => _referralCode ?? '';
  set referralCode(String? val) => _referralCode = val;

  bool hasReferralCode() => _referralCode != null;

  // "referred_by" field.
  String? _referredBy;
  String get referredBy => _referredBy ?? '';
  set referredBy(String? val) => _referredBy = val;

  bool hasReferredBy() => _referredBy != null;

  // "created_at" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "updated_at" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  set updatedAt(DateTime? val) => _updatedAt = val;

  bool hasUpdatedAt() => _updatedAt != null;

  // "deleted_at" field.
  DateTime? _deletedAt;
  DateTime? get deletedAt => _deletedAt;
  set deletedAt(DateTime? val) => _deletedAt = val;

  bool hasDeletedAt() => _deletedAt != null;

  // "total_referrals" field.
  int? _totalReferrals;
  int get totalReferrals => _totalReferrals ?? 0;
  set totalReferrals(int? val) => _totalReferrals = val;

  void incrementTotalReferrals(int amount) =>
      totalReferrals = totalReferrals + amount;

  bool hasTotalReferrals() => _totalReferrals != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "stripe" field.
  StripeAccountStatusStruct? _stripe;
  StripeAccountStatusStruct get stripe =>
      _stripe ?? StripeAccountStatusStruct();
  set stripe(StripeAccountStatusStruct? val) => _stripe = val;

  void updateStripe(Function(StripeAccountStatusStruct) updateFn) {
    updateFn(_stripe ??= StripeAccountStatusStruct());
  }

  bool hasStripe() => _stripe != null;

  // "paymentMethod" field.
  List<PaymentMethodStruct>? _paymentMethod;
  List<PaymentMethodStruct> get paymentMethod => _paymentMethod ?? const [];
  set paymentMethod(List<PaymentMethodStruct>? val) => _paymentMethod = val;

  void updatePaymentMethod(Function(List<PaymentMethodStruct>) updateFn) {
    updateFn(_paymentMethod ??= []);
  }

  bool hasPaymentMethod() => _paymentMethod != null;

  // "hasStripeCustomer" field.
  bool? _hasStripeCustomer;
  bool get hasStripeCustomer => _hasStripeCustomer ?? false;
  set hasStripeCustomer(bool? val) => _hasStripeCustomer = val;

  bool hasHasStripeCustomer() => _hasStripeCustomer != null;

  // "defaultPaymentMethodId" field.
  String? _defaultPaymentMethodId;
  String get defaultPaymentMethodId => _defaultPaymentMethodId ?? '';
  set defaultPaymentMethodId(String? val) => _defaultPaymentMethodId = val;

  bool hasDefaultPaymentMethodId() => _defaultPaymentMethodId != null;

  // "userSettings" field.
  UserSettingsStruct? _userSettings;
  UserSettingsStruct get userSettings => _userSettings ?? UserSettingsStruct();
  set userSettings(UserSettingsStruct? val) => _userSettings = val;

  void updateUserSettings(Function(UserSettingsStruct) updateFn) {
    updateFn(_userSettings ??= UserSettingsStruct());
  }

  bool hasUserSettings() => _userSettings != null;

  // "shippingAddress" field.
  ShippingAddressStruct? _shippingAddress;
  ShippingAddressStruct get shippingAddress =>
      _shippingAddress ?? ShippingAddressStruct();
  set shippingAddress(ShippingAddressStruct? val) => _shippingAddress = val;

  void updateShippingAddress(Function(ShippingAddressStruct) updateFn) {
    updateFn(_shippingAddress ??= ShippingAddressStruct());
  }

  bool hasShippingAddress() => _shippingAddress != null;

  static UserDataStruct fromMap(Map<String, dynamic> data) => UserDataStruct(
        id: data['id'] as String?,
        userId: data['user_id'] as String?,
        username: data['username'] as String?,
        firstName: data['first_name'] as String?,
        lastName: data['last_name'] as String?,
        avatarUrl: data['avatar_url'] as String?,
        bio: data['bio'] as String?,
        phone: data['phone'] as String?,
        phoneVerified: data['phone_verified'] as bool?,
        isSeller: data['is_seller'] as bool?,
        sellerSince: data['seller_since'] as DateTime?,
        businessName: data['business_name'] as String?,
        businessAddress: data['business_address'] is BusinessAddressStruct
            ? data['business_address']
            : BusinessAddressStruct.maybeFromMap(data['business_address']),
        businessEmail: data['business_email'] as String?,
        ratingAsSeller: castToType<double>(data['rating_as_seller']),
        ratingAsBuyer: castToType<double>(data['rating_as_buyer']),
        totalReviewsAsSeller: castToType<int>(data['total_reviews_as_seller']),
        totalReviewsAsBuyer: castToType<int>(data['total_reviews_as_buyer']),
        totalSales: castToType<int>(data['total_sales']),
        totalPurchases: castToType<int>(data['total_purchases']),
        totalRefunds: castToType<int>(data['total_refunds']),
        totalCancelled: castToType<int>(data['total_cancelled']),
        followersCount: castToType<int>(data['followers_count']),
        followingCount: castToType<int>(data['following_count']),
        isPrivate: data['is_private'] as bool?,
        referralCode: data['referral_code'] as String?,
        referredBy: data['referred_by'] as String?,
        createdAt: data['created_at'] as DateTime?,
        updatedAt: data['updated_at'] as DateTime?,
        deletedAt: data['deleted_at'] as DateTime?,
        totalReferrals: castToType<int>(data['total_referrals']),
        email: data['email'] as String?,
        stripe: data['stripe'] is StripeAccountStatusStruct
            ? data['stripe']
            : StripeAccountStatusStruct.maybeFromMap(data['stripe']),
        paymentMethod: getStructList(
          data['paymentMethod'],
          PaymentMethodStruct.fromMap,
        ),
        hasStripeCustomer: data['hasStripeCustomer'] as bool?,
        defaultPaymentMethodId: data['defaultPaymentMethodId'] as String?,
        userSettings: data['userSettings'] is UserSettingsStruct
            ? data['userSettings']
            : UserSettingsStruct.maybeFromMap(data['userSettings']),
        shippingAddress: data['shippingAddress'] is ShippingAddressStruct
            ? data['shippingAddress']
            : ShippingAddressStruct.maybeFromMap(data['shippingAddress']),
      );

  static UserDataStruct? maybeFromMap(dynamic data) =>
      data is Map ? UserDataStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'user_id': _userId,
        'username': _username,
        'first_name': _firstName,
        'last_name': _lastName,
        'avatar_url': _avatarUrl,
        'bio': _bio,
        'phone': _phone,
        'phone_verified': _phoneVerified,
        'is_seller': _isSeller,
        'seller_since': _sellerSince,
        'business_name': _businessName,
        'business_address': _businessAddress?.toMap(),
        'business_email': _businessEmail,
        'rating_as_seller': _ratingAsSeller,
        'rating_as_buyer': _ratingAsBuyer,
        'total_reviews_as_seller': _totalReviewsAsSeller,
        'total_reviews_as_buyer': _totalReviewsAsBuyer,
        'total_sales': _totalSales,
        'total_purchases': _totalPurchases,
        'total_refunds': _totalRefunds,
        'total_cancelled': _totalCancelled,
        'followers_count': _followersCount,
        'following_count': _followingCount,
        'is_private': _isPrivate,
        'referral_code': _referralCode,
        'referred_by': _referredBy,
        'created_at': _createdAt,
        'updated_at': _updatedAt,
        'deleted_at': _deletedAt,
        'total_referrals': _totalReferrals,
        'email': _email,
        'stripe': _stripe?.toMap(),
        'paymentMethod': _paymentMethod?.map((e) => e.toMap()).toList(),
        'hasStripeCustomer': _hasStripeCustomer,
        'defaultPaymentMethodId': _defaultPaymentMethodId,
        'userSettings': _userSettings?.toMap(),
        'shippingAddress': _shippingAddress?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'user_id': serializeParam(
          _userId,
          ParamType.String,
        ),
        'username': serializeParam(
          _username,
          ParamType.String,
        ),
        'first_name': serializeParam(
          _firstName,
          ParamType.String,
        ),
        'last_name': serializeParam(
          _lastName,
          ParamType.String,
        ),
        'avatar_url': serializeParam(
          _avatarUrl,
          ParamType.String,
        ),
        'bio': serializeParam(
          _bio,
          ParamType.String,
        ),
        'phone': serializeParam(
          _phone,
          ParamType.String,
        ),
        'phone_verified': serializeParam(
          _phoneVerified,
          ParamType.bool,
        ),
        'is_seller': serializeParam(
          _isSeller,
          ParamType.bool,
        ),
        'seller_since': serializeParam(
          _sellerSince,
          ParamType.DateTime,
        ),
        'business_name': serializeParam(
          _businessName,
          ParamType.String,
        ),
        'business_address': serializeParam(
          _businessAddress,
          ParamType.DataStruct,
        ),
        'business_email': serializeParam(
          _businessEmail,
          ParamType.String,
        ),
        'rating_as_seller': serializeParam(
          _ratingAsSeller,
          ParamType.double,
        ),
        'rating_as_buyer': serializeParam(
          _ratingAsBuyer,
          ParamType.double,
        ),
        'total_reviews_as_seller': serializeParam(
          _totalReviewsAsSeller,
          ParamType.int,
        ),
        'total_reviews_as_buyer': serializeParam(
          _totalReviewsAsBuyer,
          ParamType.int,
        ),
        'total_sales': serializeParam(
          _totalSales,
          ParamType.int,
        ),
        'total_purchases': serializeParam(
          _totalPurchases,
          ParamType.int,
        ),
        'total_refunds': serializeParam(
          _totalRefunds,
          ParamType.int,
        ),
        'total_cancelled': serializeParam(
          _totalCancelled,
          ParamType.int,
        ),
        'followers_count': serializeParam(
          _followersCount,
          ParamType.int,
        ),
        'following_count': serializeParam(
          _followingCount,
          ParamType.int,
        ),
        'is_private': serializeParam(
          _isPrivate,
          ParamType.bool,
        ),
        'referral_code': serializeParam(
          _referralCode,
          ParamType.String,
        ),
        'referred_by': serializeParam(
          _referredBy,
          ParamType.String,
        ),
        'created_at': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
        'updated_at': serializeParam(
          _updatedAt,
          ParamType.DateTime,
        ),
        'deleted_at': serializeParam(
          _deletedAt,
          ParamType.DateTime,
        ),
        'total_referrals': serializeParam(
          _totalReferrals,
          ParamType.int,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'stripe': serializeParam(
          _stripe,
          ParamType.DataStruct,
        ),
        'paymentMethod': serializeParam(
          _paymentMethod,
          ParamType.DataStruct,
          isList: true,
        ),
        'hasStripeCustomer': serializeParam(
          _hasStripeCustomer,
          ParamType.bool,
        ),
        'defaultPaymentMethodId': serializeParam(
          _defaultPaymentMethodId,
          ParamType.String,
        ),
        'userSettings': serializeParam(
          _userSettings,
          ParamType.DataStruct,
        ),
        'shippingAddress': serializeParam(
          _shippingAddress,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static UserDataStruct fromSerializableMap(Map<String, dynamic> data) =>
      UserDataStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        userId: deserializeParam(
          data['user_id'],
          ParamType.String,
          false,
        ),
        username: deserializeParam(
          data['username'],
          ParamType.String,
          false,
        ),
        firstName: deserializeParam(
          data['first_name'],
          ParamType.String,
          false,
        ),
        lastName: deserializeParam(
          data['last_name'],
          ParamType.String,
          false,
        ),
        avatarUrl: deserializeParam(
          data['avatar_url'],
          ParamType.String,
          false,
        ),
        bio: deserializeParam(
          data['bio'],
          ParamType.String,
          false,
        ),
        phone: deserializeParam(
          data['phone'],
          ParamType.String,
          false,
        ),
        phoneVerified: deserializeParam(
          data['phone_verified'],
          ParamType.bool,
          false,
        ),
        isSeller: deserializeParam(
          data['is_seller'],
          ParamType.bool,
          false,
        ),
        sellerSince: deserializeParam(
          data['seller_since'],
          ParamType.DateTime,
          false,
        ),
        businessName: deserializeParam(
          data['business_name'],
          ParamType.String,
          false,
        ),
        businessAddress: deserializeStructParam(
          data['business_address'],
          ParamType.DataStruct,
          false,
          structBuilder: BusinessAddressStruct.fromSerializableMap,
        ),
        businessEmail: deserializeParam(
          data['business_email'],
          ParamType.String,
          false,
        ),
        ratingAsSeller: deserializeParam(
          data['rating_as_seller'],
          ParamType.double,
          false,
        ),
        ratingAsBuyer: deserializeParam(
          data['rating_as_buyer'],
          ParamType.double,
          false,
        ),
        totalReviewsAsSeller: deserializeParam(
          data['total_reviews_as_seller'],
          ParamType.int,
          false,
        ),
        totalReviewsAsBuyer: deserializeParam(
          data['total_reviews_as_buyer'],
          ParamType.int,
          false,
        ),
        totalSales: deserializeParam(
          data['total_sales'],
          ParamType.int,
          false,
        ),
        totalPurchases: deserializeParam(
          data['total_purchases'],
          ParamType.int,
          false,
        ),
        totalRefunds: deserializeParam(
          data['total_refunds'],
          ParamType.int,
          false,
        ),
        totalCancelled: deserializeParam(
          data['total_cancelled'],
          ParamType.int,
          false,
        ),
        followersCount: deserializeParam(
          data['followers_count'],
          ParamType.int,
          false,
        ),
        followingCount: deserializeParam(
          data['following_count'],
          ParamType.int,
          false,
        ),
        isPrivate: deserializeParam(
          data['is_private'],
          ParamType.bool,
          false,
        ),
        referralCode: deserializeParam(
          data['referral_code'],
          ParamType.String,
          false,
        ),
        referredBy: deserializeParam(
          data['referred_by'],
          ParamType.String,
          false,
        ),
        createdAt: deserializeParam(
          data['created_at'],
          ParamType.DateTime,
          false,
        ),
        updatedAt: deserializeParam(
          data['updated_at'],
          ParamType.DateTime,
          false,
        ),
        deletedAt: deserializeParam(
          data['deleted_at'],
          ParamType.DateTime,
          false,
        ),
        totalReferrals: deserializeParam(
          data['total_referrals'],
          ParamType.int,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        stripe: deserializeStructParam(
          data['stripe'],
          ParamType.DataStruct,
          false,
          structBuilder: StripeAccountStatusStruct.fromSerializableMap,
        ),
        paymentMethod: deserializeStructParam<PaymentMethodStruct>(
          data['paymentMethod'],
          ParamType.DataStruct,
          true,
          structBuilder: PaymentMethodStruct.fromSerializableMap,
        ),
        hasStripeCustomer: deserializeParam(
          data['hasStripeCustomer'],
          ParamType.bool,
          false,
        ),
        defaultPaymentMethodId: deserializeParam(
          data['defaultPaymentMethodId'],
          ParamType.String,
          false,
        ),
        userSettings: deserializeStructParam(
          data['userSettings'],
          ParamType.DataStruct,
          false,
          structBuilder: UserSettingsStruct.fromSerializableMap,
        ),
        shippingAddress: deserializeStructParam(
          data['shippingAddress'],
          ParamType.DataStruct,
          false,
          structBuilder: ShippingAddressStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'UserDataStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is UserDataStruct &&
        id == other.id &&
        userId == other.userId &&
        username == other.username &&
        firstName == other.firstName &&
        lastName == other.lastName &&
        avatarUrl == other.avatarUrl &&
        bio == other.bio &&
        phone == other.phone &&
        phoneVerified == other.phoneVerified &&
        isSeller == other.isSeller &&
        sellerSince == other.sellerSince &&
        businessName == other.businessName &&
        businessAddress == other.businessAddress &&
        businessEmail == other.businessEmail &&
        ratingAsSeller == other.ratingAsSeller &&
        ratingAsBuyer == other.ratingAsBuyer &&
        totalReviewsAsSeller == other.totalReviewsAsSeller &&
        totalReviewsAsBuyer == other.totalReviewsAsBuyer &&
        totalSales == other.totalSales &&
        totalPurchases == other.totalPurchases &&
        totalRefunds == other.totalRefunds &&
        totalCancelled == other.totalCancelled &&
        followersCount == other.followersCount &&
        followingCount == other.followingCount &&
        isPrivate == other.isPrivate &&
        referralCode == other.referralCode &&
        referredBy == other.referredBy &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        deletedAt == other.deletedAt &&
        totalReferrals == other.totalReferrals &&
        email == other.email &&
        stripe == other.stripe &&
        listEquality.equals(paymentMethod, other.paymentMethod) &&
        hasStripeCustomer == other.hasStripeCustomer &&
        defaultPaymentMethodId == other.defaultPaymentMethodId &&
        userSettings == other.userSettings &&
        shippingAddress == other.shippingAddress;
  }

  @override
  int get hashCode => const ListEquality().hash([
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
        paymentMethod,
        hasStripeCustomer,
        defaultPaymentMethodId,
        userSettings,
        shippingAddress
      ]);
}

UserDataStruct createUserDataStruct({
  String? id,
  String? userId,
  String? username,
  String? firstName,
  String? lastName,
  String? avatarUrl,
  String? bio,
  String? phone,
  bool? phoneVerified,
  bool? isSeller,
  DateTime? sellerSince,
  String? businessName,
  BusinessAddressStruct? businessAddress,
  String? businessEmail,
  double? ratingAsSeller,
  double? ratingAsBuyer,
  int? totalReviewsAsSeller,
  int? totalReviewsAsBuyer,
  int? totalSales,
  int? totalPurchases,
  int? totalRefunds,
  int? totalCancelled,
  int? followersCount,
  int? followingCount,
  bool? isPrivate,
  String? referralCode,
  String? referredBy,
  DateTime? createdAt,
  DateTime? updatedAt,
  DateTime? deletedAt,
  int? totalReferrals,
  String? email,
  StripeAccountStatusStruct? stripe,
  bool? hasStripeCustomer,
  String? defaultPaymentMethodId,
  UserSettingsStruct? userSettings,
  ShippingAddressStruct? shippingAddress,
}) =>
    UserDataStruct(
      id: id,
      userId: userId,
      username: username,
      firstName: firstName,
      lastName: lastName,
      avatarUrl: avatarUrl,
      bio: bio,
      phone: phone,
      phoneVerified: phoneVerified,
      isSeller: isSeller,
      sellerSince: sellerSince,
      businessName: businessName,
      businessAddress: businessAddress ?? BusinessAddressStruct(),
      businessEmail: businessEmail,
      ratingAsSeller: ratingAsSeller,
      ratingAsBuyer: ratingAsBuyer,
      totalReviewsAsSeller: totalReviewsAsSeller,
      totalReviewsAsBuyer: totalReviewsAsBuyer,
      totalSales: totalSales,
      totalPurchases: totalPurchases,
      totalRefunds: totalRefunds,
      totalCancelled: totalCancelled,
      followersCount: followersCount,
      followingCount: followingCount,
      isPrivate: isPrivate,
      referralCode: referralCode,
      referredBy: referredBy,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      totalReferrals: totalReferrals,
      email: email,
      stripe: stripe ?? StripeAccountStatusStruct(),
      hasStripeCustomer: hasStripeCustomer,
      defaultPaymentMethodId: defaultPaymentMethodId,
      userSettings: userSettings ?? UserSettingsStruct(),
      shippingAddress: shippingAddress ?? ShippingAddressStruct(),
    );

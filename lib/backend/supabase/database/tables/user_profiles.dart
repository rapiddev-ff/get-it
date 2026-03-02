import '../database.dart';

class UserProfilesTable extends SupabaseTable<UserProfilesRow> {
  @override
  String get tableName => 'user_profiles';

  @override
  UserProfilesRow createRow(Map<String, dynamic> data) => UserProfilesRow(data);
}

class UserProfilesRow extends SupabaseDataRow {
  UserProfilesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserProfilesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get username => getField<String>('username');
  set username(String? value) => setField<String>('username', value);

  String? get firstName => getField<String>('first_name');
  set firstName(String? value) => setField<String>('first_name', value);

  String? get lastName => getField<String>('last_name');
  set lastName(String? value) => setField<String>('last_name', value);

  String? get avatarUrl => getField<String>('avatar_url');
  set avatarUrl(String? value) => setField<String>('avatar_url', value);

  String? get bio => getField<String>('bio');
  set bio(String? value) => setField<String>('bio', value);

  String? get phone => getField<String>('phone');
  set phone(String? value) => setField<String>('phone', value);

  bool? get phoneVerified => getField<bool>('phone_verified');
  set phoneVerified(bool? value) => setField<bool>('phone_verified', value);

  bool? get isSeller => getField<bool>('is_seller');
  set isSeller(bool? value) => setField<bool>('is_seller', value);

  DateTime? get sellerSince => getField<DateTime>('seller_since');
  set sellerSince(DateTime? value) => setField<DateTime>('seller_since', value);

  String? get businessName => getField<String>('business_name');
  set businessName(String? value) => setField<String>('business_name', value);

  String? get businessAddress => getField<String>('business_address');
  set businessAddress(String? value) =>
      setField<String>('business_address', value);

  String? get businessEmail => getField<String>('business_email');
  set businessEmail(String? value) => setField<String>('business_email', value);

  double? get ratingAsSeller => getField<double>('rating_as_seller');
  set ratingAsSeller(double? value) =>
      setField<double>('rating_as_seller', value);

  double? get ratingAsBuyer => getField<double>('rating_as_buyer');
  set ratingAsBuyer(double? value) =>
      setField<double>('rating_as_buyer', value);

  int? get totalReviewsAsSeller => getField<int>('total_reviews_as_seller');
  set totalReviewsAsSeller(int? value) =>
      setField<int>('total_reviews_as_seller', value);

  int? get totalReviewsAsBuyer => getField<int>('total_reviews_as_buyer');
  set totalReviewsAsBuyer(int? value) =>
      setField<int>('total_reviews_as_buyer', value);

  int? get totalSales => getField<int>('total_sales');
  set totalSales(int? value) => setField<int>('total_sales', value);

  int? get totalPurchases => getField<int>('total_purchases');
  set totalPurchases(int? value) => setField<int>('total_purchases', value);

  int? get totalRefunds => getField<int>('total_refunds');
  set totalRefunds(int? value) => setField<int>('total_refunds', value);

  int? get totalCancelled => getField<int>('total_cancelled');
  set totalCancelled(int? value) => setField<int>('total_cancelled', value);

  int? get followersCount => getField<int>('followers_count');
  set followersCount(int? value) => setField<int>('followers_count', value);

  int? get followingCount => getField<int>('following_count');
  set followingCount(int? value) => setField<int>('following_count', value);

  bool? get isPrivate => getField<bool>('is_private');
  set isPrivate(bool? value) => setField<bool>('is_private', value);

  String? get referralCode => getField<String>('referral_code');
  set referralCode(String? value) => setField<String>('referral_code', value);

  String? get referredBy => getField<String>('referred_by');
  set referredBy(String? value) => setField<String>('referred_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);

  int? get totalReferrals => getField<int>('total_referrals');
  set totalReferrals(int? value) => setField<int>('total_referrals', value);

  String get email => getField<String>('email')!;
  set email(String value) => setField<String>('email', value);

  bool? get isDeactivated => getField<bool>('is_deactivated');
  set isDeactivated(bool? value) => setField<bool>('is_deactivated', value);

  String? get businessAddressLine1 =>
      getField<String>('business_address_line1');
  set businessAddressLine1(String? value) =>
      setField<String>('business_address_line1', value);

  String? get businessAddressLine2 =>
      getField<String>('business_address_line2');
  set businessAddressLine2(String? value) =>
      setField<String>('business_address_line2', value);

  String? get businessCountry => getField<String>('business_country');
  set businessCountry(String? value) =>
      setField<String>('business_country', value);

  String? get businessState => getField<String>('business_state');
  set businessState(String? value) => setField<String>('business_state', value);

  String? get businessCity => getField<String>('business_city');
  set businessCity(String? value) => setField<String>('business_city', value);

  String? get businessZip => getField<String>('business_zip');
  set businessZip(String? value) => setField<String>('business_zip', value);

  DateTime? get lastActiveAt => getField<DateTime>('last_active_at');
  set lastActiveAt(DateTime? value) =>
      setField<DateTime>('last_active_at', value);
}

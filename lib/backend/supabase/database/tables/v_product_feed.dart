import '../database.dart';

class VProductFeedTable extends SupabaseTable<VProductFeedRow> {
  @override
  String get tableName => 'v_product_feed';

  @override
  VProductFeedRow createRow(Map<String, dynamic> data) => VProductFeedRow(data);
}

class VProductFeedRow extends SupabaseDataRow {
  VProductFeedRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => VProductFeedTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get title => getField<String>('title');
  set title(String? value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  double? get price => getField<double>('price');
  set price(double? value) => setField<double>('price', value);

  double? get originalPrice => getField<double>('original_price');
  set originalPrice(double? value) => setField<double>('original_price', value);

  bool? get flashSaleEnabled => getField<bool>('flash_sale_enabled');
  set flashSaleEnabled(bool? value) =>
      setField<bool>('flash_sale_enabled', value);

  double? get flashSalePrice => getField<double>('flash_sale_price');
  set flashSalePrice(double? value) =>
      setField<double>('flash_sale_price', value);

  DateTime? get flashSaleEndsAt => getField<DateTime>('flash_sale_ends_at');
  set flashSaleEndsAt(DateTime? value) =>
      setField<DateTime>('flash_sale_ends_at', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  int? get viewsCount => getField<int>('views_count');
  set viewsCount(int? value) => setField<int>('views_count', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get categoryId => getField<String>('category_id');
  set categoryId(String? value) => setField<String>('category_id', value);

  String? get subcategoryId => getField<String>('subcategory_id');
  set subcategoryId(String? value) => setField<String>('subcategory_id', value);

  String? get conditionId => getField<String>('condition_id');
  set conditionId(String? value) => setField<String>('condition_id', value);

  int? get year => getField<int>('year');
  set year(int? value) => setField<int>('year', value);

  String? get categoryName => getField<String>('category_name');
  set categoryName(String? value) => setField<String>('category_name', value);

  String? get subcategoryName => getField<String>('subcategory_name');
  set subcategoryName(String? value) =>
      setField<String>('subcategory_name', value);

  String? get conditionName => getField<String>('condition_name');
  set conditionName(String? value) => setField<String>('condition_name', value);

  String? get sellerId => getField<String>('seller_id');
  set sellerId(String? value) => setField<String>('seller_id', value);

  String? get sellerUsername => getField<String>('seller_username');
  set sellerUsername(String? value) =>
      setField<String>('seller_username', value);

  String? get sellerAvatar => getField<String>('seller_avatar');
  set sellerAvatar(String? value) => setField<String>('seller_avatar', value);

  double? get sellerRating => getField<double>('seller_rating');
  set sellerRating(double? value) => setField<double>('seller_rating', value);

  int? get sellerReviewCount => getField<int>('seller_review_count');
  set sellerReviewCount(int? value) =>
      setField<int>('seller_review_count', value);

  String? get mainImageUrl => getField<String>('main_image_url');
  set mainImageUrl(String? value) => setField<String>('main_image_url', value);
}

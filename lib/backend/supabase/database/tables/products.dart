import '../database.dart';

class ProductsTable extends SupabaseTable<ProductsRow> {
  @override
  String get tableName => 'products';

  @override
  ProductsRow createRow(Map<String, dynamic> data) => ProductsRow(data);
}

class ProductsRow extends SupabaseDataRow {
  ProductsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProductsTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get sellerId => getField<String>('seller_id')!;
  set sellerId(String value) => setField<String>('seller_id', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  String? get sku => getField<String>('sku');
  set sku(String? value) => setField<String>('sku', value);

  String get categoryId => getField<String>('category_id')!;
  set categoryId(String value) => setField<String>('category_id', value);

  String? get subcategoryId => getField<String>('subcategory_id');
  set subcategoryId(String? value) => setField<String>('subcategory_id', value);

  String? get conditionId => getField<String>('condition_id');
  set conditionId(String? value) => setField<String>('condition_id', value);

  int? get year => getField<int>('year');
  set year(int? value) => setField<int>('year', value);

  double get price => getField<double>('price')!;
  set price(double value) => setField<double>('price', value);

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

  int? get quantity => getField<int>('quantity');
  set quantity(int? value) => setField<int>('quantity', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  int? get viewsCount => getField<int>('views_count');
  set viewsCount(int? value) => setField<int>('views_count', value);

  String? get shippingInfo => getField<String>('shipping_info');
  set shippingInfo(String? value) => setField<String>('shipping_info', value);

  bool? get freeShipping => getField<bool>('free_shipping');
  set freeShipping(bool? value) => setField<bool>('free_shipping', value);

  double? get shippingPrice => getField<double>('shipping_price');
  set shippingPrice(double? value) => setField<double>('shipping_price', value);

  bool? get shopifySyncEnabled => getField<bool>('shopify_sync_enabled');
  set shopifySyncEnabled(bool? value) =>
      setField<bool>('shopify_sync_enabled', value);

  DateTime? get shopifyLastSyncedAt =>
      getField<DateTime>('shopify_last_synced_at');
  set shopifyLastSyncedAt(DateTime? value) =>
      setField<DateTime>('shopify_last_synced_at', value);

  String? get shopifySyncError => getField<String>('shopify_sync_error');
  set shopifySyncError(String? value) =>
      setField<String>('shopify_sync_error', value);

  String? get searchVector => getField<String>('search_vector');
  set searchVector(String? value) => setField<String>('search_vector', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  DateTime? get publishedAt => getField<DateTime>('published_at');
  set publishedAt(DateTime? value) => setField<DateTime>('published_at', value);

  DateTime? get soldAt => getField<DateTime>('sold_at');
  set soldAt(DateTime? value) => setField<DateTime>('sold_at', value);

  int get reservedQuantity => getField<int>('reserved_quantity') ?? 0;
  set reservedQuantity(int value) => setField<int>('reserved_quantity', value);

  int get availableQuantity => (quantity ?? 0) - reservedQuantity;

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);

  bool? get useSellerDefaultShipping =>
      getField<bool>('use_seller_default_shipping');
  set useSellerDefaultShipping(bool? value) =>
      setField<bool>('use_seller_default_shipping', value);

  double? get customFlatShippingCost =>
      getField<double>('custom_flat_shipping_cost');
  set customFlatShippingCost(double? value) =>
      setField<double>('custom_flat_shipping_cost', value);

  double? get customAdditionalItemFee =>
      getField<double>('custom_additional_item_fee');
  set customAdditionalItemFee(double? value) =>
      setField<double>('custom_additional_item_fee', value);
}

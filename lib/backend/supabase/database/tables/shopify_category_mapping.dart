import '../database.dart';

class ShopifyCategoryMappingTable
    extends SupabaseTable<ShopifyCategoryMappingRow> {
  @override
  String get tableName => 'shopify_category_mapping';

  @override
  ShopifyCategoryMappingRow createRow(Map<String, dynamic> data) =>
      ShopifyCategoryMappingRow(data);
}

class ShopifyCategoryMappingRow extends SupabaseDataRow {
  ShopifyCategoryMappingRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ShopifyCategoryMappingTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get integrationId => getField<String>('integration_id')!;
  set integrationId(String value) => setField<String>('integration_id', value);

  String? get shopifyProductType => getField<String>('shopify_product_type');
  set shopifyProductType(String? value) =>
      setField<String>('shopify_product_type', value);

  String? get shopifyCollectionId => getField<String>('shopify_collection_id');
  set shopifyCollectionId(String? value) =>
      setField<String>('shopify_collection_id', value);

  List<String> get shopifyTags => getListField<String>('shopify_tags');
  set shopifyTags(List<String>? value) =>
      setListField<String>('shopify_tags', value);

  String? get categoryId => getField<String>('category_id');
  set categoryId(String? value) => setField<String>('category_id', value);

  String? get subcategoryId => getField<String>('subcategory_id');
  set subcategoryId(String? value) => setField<String>('subcategory_id', value);

  String? get conditionId => getField<String>('condition_id');
  set conditionId(String? value) => setField<String>('condition_id', value);

  int? get priority => getField<int>('priority');
  set priority(int? value) => setField<int>('priority', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}

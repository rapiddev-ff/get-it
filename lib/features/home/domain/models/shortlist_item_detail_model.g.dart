// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortlist_item_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShortlistItemDetailImpl _$$ShortlistItemDetailImplFromJson(
        Map<String, dynamic> json) =>
    _$ShortlistItemDetailImpl(
      id: json['id'] as String? ?? '',
      productId: json['product_id'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      itemStatus: json['item_status'] as String? ?? 'active',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      reservedAt: const DateTimeConverter().fromJson(json['reserved_at']),
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['original_price'] as num?)?.toDouble() ?? 0.0,
      flashSaleEnabled: json['flash_sale_enabled'] as bool? ?? false,
      flashSalePrice: (json['flash_sale_price'] as num?)?.toDouble(),
      flashSaleEndsAt:
          const DateTimeConverter().fromJson(json['flash_sale_ends_at']),
      discountType: json['discount_type'] as String?,
      discountAmount: (json['discount_amount'] as num?)?.toDouble(),
      productStatus: json['product_status'] as String? ?? '',
      categoryName: json['category_name'] as String? ?? '',
      subcategoryName: json['subcategory_name'] as String? ?? '',
      mainImageUrl: json['main_image_url'] as String? ?? '',
    );

Map<String, dynamic> _$$ShortlistItemDetailImplToJson(
        _$ShortlistItemDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'quantity': instance.quantity,
      'item_status': instance.itemStatus,
      'sort_order': instance.sortOrder,
      'reserved_at': const DateTimeConverter().toJson(instance.reservedAt),
      'title': instance.title,
      'price': instance.price,
      'original_price': instance.originalPrice,
      'flash_sale_enabled': instance.flashSaleEnabled,
      'flash_sale_price': instance.flashSalePrice,
      'flash_sale_ends_at':
          const DateTimeConverter().toJson(instance.flashSaleEndsAt),
      'discount_type': instance.discountType,
      'discount_amount': instance.discountAmount,
      'product_status': instance.productStatus,
      'category_name': instance.categoryName,
      'subcategory_name': instance.subcategoryName,
      'main_image_url': instance.mainImageUrl,
    };

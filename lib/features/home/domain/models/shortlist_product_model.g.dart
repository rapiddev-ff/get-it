// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortlist_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShortlistProductImpl _$$ShortlistProductImplFromJson(
        Map<String, dynamic> json) =>
    _$ShortlistProductImpl(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['original_price'] as num?)?.toDouble() ?? 0.0,
      flashSaleEnabled: json['flash_sale_enabled'] as bool? ?? false,
      flashSalePrice: (json['flash_sale_price'] as num?)?.toDouble(),
      flashSaleEndsAt:
          const DateTimeConverter().fromJson(json['flash_sale_ends_at']),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      reservedQuantity: (json['reserved_quantity'] as num?)?.toInt() ?? 0,
      availableQuantity: (json['available_quantity'] as num?)?.toInt() ?? 0,
      categoryId: json['category_id'] as String? ?? '',
      categoryName: json['category_name'] as String? ?? '',
      subcategoryId: json['subcategory_id'] as String? ?? '',
      subcategoryName: json['subcategory_name'] as String? ?? '',
      mainImageUrl: json['main_image_url'] as String? ?? '',
      discountType: json['discount_type'] as String?,
      discountAmount: (json['discount_amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$ShortlistProductImplToJson(
        _$ShortlistProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'original_price': instance.originalPrice,
      'flash_sale_enabled': instance.flashSaleEnabled,
      'flash_sale_price': instance.flashSalePrice,
      'flash_sale_ends_at':
          const DateTimeConverter().toJson(instance.flashSaleEndsAt),
      'quantity': instance.quantity,
      'reserved_quantity': instance.reservedQuantity,
      'available_quantity': instance.availableQuantity,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'subcategory_id': instance.subcategoryId,
      'subcategory_name': instance.subcategoryName,
      'main_image_url': instance.mainImageUrl,
      'discount_type': instance.discountType,
      'discount_amount': instance.discountAmount,
    };

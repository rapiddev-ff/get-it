// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'browse_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BrowseProductImpl _$$BrowseProductImplFromJson(Map<String, dynamic> json) =>
    _$BrowseProductImpl(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['original_price'] as num?)?.toDouble() ?? 0.0,
      flashSaleEnabled: json['flash_sale_enabled'] as bool? ?? false,
      flashSalePrice: (json['flash_sale_price'] as num?)?.toDouble(),
      flashSaleEndsAt:
          const DateTimeConverter().fromJson(json['flash_sale_ends_at']),
      mainImageUrl: json['main_image_url'] as String? ?? '',
      conditionName: json['condition_name'] as String? ?? '',
      categoryName: json['category_name'] as String? ?? '',
      isInWishlist: json['is_in_wishlist'] as bool? ?? false,
      sellerUsername: json['seller_username'] as String? ?? '',
      discountType: json['discount_type'] as String?,
      discountAmount: (json['discount_amount'] as num?)?.toDouble(),
      createdAt: const DateTimeConverter().fromJson(json['created_at']),
    );

Map<String, dynamic> _$$BrowseProductImplToJson(_$BrowseProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'original_price': instance.originalPrice,
      'flash_sale_enabled': instance.flashSaleEnabled,
      'flash_sale_price': instance.flashSalePrice,
      'flash_sale_ends_at':
          const DateTimeConverter().toJson(instance.flashSaleEndsAt),
      'main_image_url': instance.mainImageUrl,
      'condition_name': instance.conditionName,
      'category_name': instance.categoryName,
      'is_in_wishlist': instance.isInWishlist,
      'seller_username': instance.sellerUsername,
      'discount_type': instance.discountType,
      'discount_amount': instance.discountAmount,
      'created_at': const DateTimeConverter().toJson(instance.createdAt),
    };

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
      mainImageUrl: json['main_image_url'] as String? ?? '',
      conditionName: json['condition_name'] as String? ?? '',
      categoryName: json['category_name'] as String? ?? '',
      isInWishlist: json['is_in_wishlist'] as bool? ?? false,
      sellerUsername: json['seller_username'] as String? ?? '',
      createdAt: const DateTimeConverter().fromJson(json['created_at']),
    );

Map<String, dynamic> _$$BrowseProductImplToJson(_$BrowseProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'original_price': instance.originalPrice,
      'main_image_url': instance.mainImageUrl,
      'condition_name': instance.conditionName,
      'category_name': instance.categoryName,
      'is_in_wishlist': instance.isInWishlist,
      'seller_username': instance.sellerUsername,
      'created_at': const DateTimeConverter().toJson(instance.createdAt),
    };

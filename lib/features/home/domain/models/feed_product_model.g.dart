// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FeedProductImpl _$$FeedProductImplFromJson(Map<String, dynamic> json) =>
    _$FeedProductImpl(
      id: json['id'] as String? ?? '',
      sellerId: json['sellerId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      flashSaleEnabled: json['flashSaleEnabled'] as bool? ?? false,
      flashSalePrice: (json['flashSalePrice'] as num?)?.toDouble(),
      flashSaleEndsAt:
          const DateTimeConverter().fromJson(json['flashSaleEndsAt']),
      mainImageUrl: json['mainImageUrl'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      conditionName: json['conditionName'] as String? ?? '',
      sellerUsername: json['sellerUsername'] as String? ?? '',
      sellerAvatarUrl: json['sellerAvatarUrl'] as String?,
      sellerRating: (json['sellerRating'] as num?)?.toDouble() ?? 0.0,
      sellerTotalReviews: (json['sellerTotalReviews'] as num?)?.toInt() ?? 0,
      isInWishlist: json['isInWishlist'] as bool? ?? false,
      createdAt: const DateTimeConverter().fromJson(json['createdAt']),
      shippingPrice: (json['shippingPrice'] as num?)?.toDouble() ?? 0.0,
      freeShipping: json['freeShipping'] as bool? ?? false,
      useSellerShipping: json['useSellerShipping'] as bool? ?? false,
      customFlatRate: (json['customFlatRate'] as num?)?.toDouble(),
      customAdditionalItemFee:
          (json['customAdditionalItemFee'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$FeedProductImplToJson(_$FeedProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sellerId': instance.sellerId,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'flashSaleEnabled': instance.flashSaleEnabled,
      'flashSalePrice': instance.flashSalePrice,
      'flashSaleEndsAt':
          const DateTimeConverter().toJson(instance.flashSaleEndsAt),
      'mainImageUrl': instance.mainImageUrl,
      'categoryName': instance.categoryName,
      'conditionName': instance.conditionName,
      'sellerUsername': instance.sellerUsername,
      'sellerAvatarUrl': instance.sellerAvatarUrl,
      'sellerRating': instance.sellerRating,
      'sellerTotalReviews': instance.sellerTotalReviews,
      'isInWishlist': instance.isInWishlist,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'shippingPrice': instance.shippingPrice,
      'freeShipping': instance.freeShipping,
      'useSellerShipping': instance.useSellerShipping,
      'customFlatRate': instance.customFlatRate,
      'customAdditionalItemFee': instance.customAdditionalItemFee,
    };

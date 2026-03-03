// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductDetailsImpl _$$ProductDetailsImplFromJson(Map<String, dynamic> json) =>
    _$ProductDetailsImpl(
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
      discountType: json['discountType'] as String?,
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      year: (json['year'] as num?)?.toInt(),
      issueNumber: (json['issueNumber'] as num?)?.toInt(),
      sku: json['sku'] as String?,
      skuNumber: json['skuNumber'] as String?,
      shippingInfo: json['shippingInfo'] as String?,
      shippingPrice: (json['shippingPrice'] as num?)?.toDouble() ?? 0.0,
      freeShipping: json['freeShipping'] as bool? ?? false,
      useSellerShipping: json['useSellerShipping'] as bool? ?? false,
      customFlatRate: (json['customFlatRate'] as num?)?.toDouble(),
      customAdditionalItemFee:
          (json['customAdditionalItemFee'] as num?)?.toDouble(),
      shortlistId: json['shortlistId'] as String?,
      viewsCount: (json['viewsCount'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      mainImageUrl: json['mainImageUrl'] as String? ?? '',
      categoryId: json['categoryId'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      subcategoryId: json['subcategoryId'] as String? ?? '',
      subcategoryName: json['subcategoryName'] as String? ?? '',
      conditionId: json['conditionId'] as String? ?? '',
      conditionName: json['conditionName'] as String? ?? '',
      sellerUsername: json['sellerUsername'] as String? ?? '',
      sellerAvatarUrl: json['sellerAvatarUrl'] as String? ?? '',
      createdAt: const DateTimeConverter().fromJson(json['createdAt']),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      conditions: (json['conditions'] as List<dynamic>?)
              ?.map((e) => Condition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      subcategory: json['subcategory'] == null
          ? null
          : Subcategory.fromJson(json['subcategory'] as Map<String, dynamic>),
      seller: json['seller'] == null
          ? null
          : Seller.fromJson(json['seller'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isInWishlist: json['isInWishlist'] as bool? ?? false,
      isOwnProduct: json['isOwnProduct'] as bool? ?? false,
    );

Map<String, dynamic> _$$ProductDetailsImplToJson(
        _$ProductDetailsImpl instance) =>
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
      'discountType': instance.discountType,
      'discountAmount': instance.discountAmount,
      'quantity': instance.quantity,
      'year': instance.year,
      'issueNumber': instance.issueNumber,
      'sku': instance.sku,
      'skuNumber': instance.skuNumber,
      'shippingInfo': instance.shippingInfo,
      'shippingPrice': instance.shippingPrice,
      'freeShipping': instance.freeShipping,
      'useSellerShipping': instance.useSellerShipping,
      'customFlatRate': instance.customFlatRate,
      'customAdditionalItemFee': instance.customAdditionalItemFee,
      'shortlistId': instance.shortlistId,
      'viewsCount': instance.viewsCount,
      'status': instance.status,
      'mainImageUrl': instance.mainImageUrl,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'subcategoryId': instance.subcategoryId,
      'subcategoryName': instance.subcategoryName,
      'conditionId': instance.conditionId,
      'conditionName': instance.conditionName,
      'sellerUsername': instance.sellerUsername,
      'sellerAvatarUrl': instance.sellerAvatarUrl,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'images': instance.images,
      'conditions': instance.conditions,
      'category': instance.category,
      'subcategory': instance.subcategory,
      'seller': instance.seller,
      'tags': instance.tags,
      'isInWishlist': instance.isInWishlist,
      'isOwnProduct': instance.isOwnProduct,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seller_product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SellerProductImpl _$$SellerProductImplFromJson(Map<String, dynamic> json) =>
    _$SellerProductImpl(
      id: json['id'] as String? ?? '',
      orderId: json['orderId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      flashSaleEnabled: json['flashSaleEnabled'] as bool? ?? false,
      flashSalePrice: (json['flashSalePrice'] as num?)?.toDouble(),
      status: json['status'] as String? ?? '',
      viewsCount: (json['viewsCount'] as num?)?.toInt() ?? 0,
      conditionName: json['conditionName'] as String? ?? '',
      mainImageUrl: json['mainImageUrl'] as String? ?? '',
      isInWishlist: json['isInWishlist'] as bool? ?? false,
      discountType: json['discountType'] as String?,
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      createdAt: const DateTimeConverter().fromJson(json['createdAt']),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      categoryId: json['categoryId'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
    );

Map<String, dynamic> _$$SellerProductImplToJson(_$SellerProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'title': instance.title,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'flashSaleEnabled': instance.flashSaleEnabled,
      'flashSalePrice': instance.flashSalePrice,
      'status': instance.status,
      'viewsCount': instance.viewsCount,
      'conditionName': instance.conditionName,
      'mainImageUrl': instance.mainImageUrl,
      'isInWishlist': instance.isInWishlist,
      'discountType': instance.discountType,
      'discountAmount': instance.discountAmount,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'quantity': instance.quantity,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
    };

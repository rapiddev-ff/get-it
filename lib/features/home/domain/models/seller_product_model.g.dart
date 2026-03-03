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
      status: json['status'] as String? ?? '',
      viewsCount: (json['viewsCount'] as num?)?.toInt() ?? 0,
      conditionName: json['conditionName'] as String? ?? '',
      mainImageUrl: json['mainImageUrl'] as String? ?? '',
      isInWishlist: json['isInWishlist'] as bool? ?? false,
      createdAt: const DateTimeConverter().fromJson(json['createdAt']),
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      categoryId: json['categoryId'] as String? ?? '',
    );

Map<String, dynamic> _$$SellerProductImplToJson(_$SellerProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'title': instance.title,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'status': instance.status,
      'viewsCount': instance.viewsCount,
      'conditionName': instance.conditionName,
      'mainImageUrl': instance.mainImageUrl,
      'isInWishlist': instance.isInWishlist,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'quantity': instance.quantity,
      'categoryId': instance.categoryId,
    };

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
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      mainImageUrl: json['mainImageUrl'] as String? ?? '',
      conditionName: json['conditionName'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      isInWishlist: json['isInWishlist'] as bool? ?? false,
      sellerUsername: json['sellerUsername'] as String? ?? '',
      createdAt: const DateTimeConverter().fromJson(json['createdAt']),
    );

Map<String, dynamic> _$$BrowseProductImplToJson(_$BrowseProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'mainImageUrl': instance.mainImageUrl,
      'conditionName': instance.conditionName,
      'categoryName': instance.categoryName,
      'isInWishlist': instance.isInWishlist,
      'sellerUsername': instance.sellerUsername,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
    };

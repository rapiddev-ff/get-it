// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationPreferencesImpl _$$NotificationPreferencesImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationPreferencesImpl(
      orderShipped: json['order_shipped'] as bool? ?? false,
      orderDelivered: json['order_delivered'] as bool? ?? false,
      newMessage: json['new_message'] as bool? ?? false,
      counterOffer: json['counter_offer'] as bool? ?? false,
      inventoryLow: json['inventory_low'] as bool? ?? false,
      newFollower: json['new_follower'] as bool? ?? false,
      itemSold: json['item_sold'] as bool? ?? false,
      priceDrop: json['price_drop'] as bool? ?? false,
      newReview: json['new_review'] as bool? ?? false,
      shopifySync: json['shopify_sync'] as bool? ?? false,
      shortlistScan: json['shortlist_scan'] as bool? ?? false,
      referralSale: json['referral_sale'] as bool? ?? false,
    );

Map<String, dynamic> _$$NotificationPreferencesImplToJson(
        _$NotificationPreferencesImpl instance) =>
    <String, dynamic>{
      'order_shipped': instance.orderShipped,
      'order_delivered': instance.orderDelivered,
      'new_message': instance.newMessage,
      'counter_offer': instance.counterOffer,
      'inventory_low': instance.inventoryLow,
      'new_follower': instance.newFollower,
      'item_sold': instance.itemSold,
      'price_drop': instance.priceDrop,
      'new_review': instance.newReview,
      'shopify_sync': instance.shopifySync,
      'shortlist_scan': instance.shortlistScan,
      'referral_sale': instance.referralSale,
    };

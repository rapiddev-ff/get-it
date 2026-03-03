import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_preferences_model.freezed.dart';
part 'notification_preferences_model.g.dart';

@freezed
class NotificationPreferences with _$NotificationPreferences {
  const NotificationPreferences._();
  const factory NotificationPreferences({
    @Default(false) @JsonKey(name: 'order_shipped') bool orderShipped,
    @Default(false) @JsonKey(name: 'order_delivered') bool orderDelivered,
    @Default(false) @JsonKey(name: 'new_message') bool newMessage,
    @Default(false) @JsonKey(name: 'counter_offer') bool counterOffer,
    @Default(false) @JsonKey(name: 'inventory_low') bool inventoryLow,
    @Default(false) @JsonKey(name: 'new_follower') bool newFollower,
    @Default(false) @JsonKey(name: 'item_sold') bool itemSold,
    @Default(false) @JsonKey(name: 'price_drop') bool priceDrop,
    @Default(false) @JsonKey(name: 'new_review') bool newReview,
    @Default(false) @JsonKey(name: 'shopify_sync') bool shopifySync,
    @Default(false) @JsonKey(name: 'shortlist_scan') bool shortlistScan,
    @Default(false) @JsonKey(name: 'referral_sale') bool referralSale,
  }) = _NotificationPreferences;

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);

  String serialize() => jsonEncode(toJson());
  static NotificationPreferences fromSerializableMap(
          Map<String, dynamic> data) =>
      NotificationPreferences.fromJson(data);
}

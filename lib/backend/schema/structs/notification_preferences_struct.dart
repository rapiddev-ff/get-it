// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NotificationPreferencesStruct extends BaseStruct {
  NotificationPreferencesStruct({
    bool? orderShipped,
    bool? orderDelivered,
    bool? newMessage,
    bool? counterOffer,
    bool? inventoryLow,
    bool? newFollower,
    bool? itemSold,
    bool? priceDrop,
    bool? newReview,
    bool? shopifySync,
    bool? shortlistScan,
    bool? referralSale,
  })  : _orderShipped = orderShipped,
        _orderDelivered = orderDelivered,
        _newMessage = newMessage,
        _counterOffer = counterOffer,
        _inventoryLow = inventoryLow,
        _newFollower = newFollower,
        _itemSold = itemSold,
        _priceDrop = priceDrop,
        _newReview = newReview,
        _shopifySync = shopifySync,
        _shortlistScan = shortlistScan,
        _referralSale = referralSale;

  // "order_shipped" field.
  bool? _orderShipped;
  bool get orderShipped => _orderShipped ?? false;
  set orderShipped(bool? val) => _orderShipped = val;

  bool hasOrderShipped() => _orderShipped != null;

  // "order_delivered" field.
  bool? _orderDelivered;
  bool get orderDelivered => _orderDelivered ?? false;
  set orderDelivered(bool? val) => _orderDelivered = val;

  bool hasOrderDelivered() => _orderDelivered != null;

  // "new_message" field.
  bool? _newMessage;
  bool get newMessage => _newMessage ?? false;
  set newMessage(bool? val) => _newMessage = val;

  bool hasNewMessage() => _newMessage != null;

  // "counter_offer" field.
  bool? _counterOffer;
  bool get counterOffer => _counterOffer ?? false;
  set counterOffer(bool? val) => _counterOffer = val;

  bool hasCounterOffer() => _counterOffer != null;

  // "inventory_low" field.
  bool? _inventoryLow;
  bool get inventoryLow => _inventoryLow ?? false;
  set inventoryLow(bool? val) => _inventoryLow = val;

  bool hasInventoryLow() => _inventoryLow != null;

  // "new_follower" field.
  bool? _newFollower;
  bool get newFollower => _newFollower ?? false;
  set newFollower(bool? val) => _newFollower = val;

  bool hasNewFollower() => _newFollower != null;

  // "item_sold" field.
  bool? _itemSold;
  bool get itemSold => _itemSold ?? false;
  set itemSold(bool? val) => _itemSold = val;

  bool hasItemSold() => _itemSold != null;

  // "price_drop" field.
  bool? _priceDrop;
  bool get priceDrop => _priceDrop ?? false;
  set priceDrop(bool? val) => _priceDrop = val;

  bool hasPriceDrop() => _priceDrop != null;

  // "new_review" field.
  bool? _newReview;
  bool get newReview => _newReview ?? false;
  set newReview(bool? val) => _newReview = val;

  bool hasNewReview() => _newReview != null;

  // "shopify_sync" field.
  bool? _shopifySync;
  bool get shopifySync => _shopifySync ?? false;
  set shopifySync(bool? val) => _shopifySync = val;

  bool hasShopifySync() => _shopifySync != null;

  // "shortlist_scan" field.
  bool? _shortlistScan;
  bool get shortlistScan => _shortlistScan ?? false;
  set shortlistScan(bool? val) => _shortlistScan = val;

  bool hasShortlistScan() => _shortlistScan != null;

  // "referral_sale" field.
  bool? _referralSale;
  bool get referralSale => _referralSale ?? false;
  set referralSale(bool? val) => _referralSale = val;

  bool hasReferralSale() => _referralSale != null;

  static NotificationPreferencesStruct fromMap(Map<String, dynamic> data) =>
      NotificationPreferencesStruct(
        orderShipped: data['order_shipped'] as bool?,
        orderDelivered: data['order_delivered'] as bool?,
        newMessage: data['new_message'] as bool?,
        counterOffer: data['counter_offer'] as bool?,
        inventoryLow: data['inventory_low'] as bool?,
        newFollower: data['new_follower'] as bool?,
        itemSold: data['item_sold'] as bool?,
        priceDrop: data['price_drop'] as bool?,
        newReview: data['new_review'] as bool?,
        shopifySync: data['shopify_sync'] as bool?,
        shortlistScan: data['shortlist_scan'] as bool?,
        referralSale: data['referral_sale'] as bool?,
      );

  static NotificationPreferencesStruct? maybeFromMap(dynamic data) =>
      data is Map
          ? NotificationPreferencesStruct.fromMap(data.cast<String, dynamic>())
          : null;

  Map<String, dynamic> toMap() => {
        'order_shipped': _orderShipped,
        'order_delivered': _orderDelivered,
        'new_message': _newMessage,
        'counter_offer': _counterOffer,
        'inventory_low': _inventoryLow,
        'new_follower': _newFollower,
        'item_sold': _itemSold,
        'price_drop': _priceDrop,
        'new_review': _newReview,
        'shopify_sync': _shopifySync,
        'shortlist_scan': _shortlistScan,
        'referral_sale': _referralSale,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'order_shipped': serializeParam(
          _orderShipped,
          ParamType.bool,
        ),
        'order_delivered': serializeParam(
          _orderDelivered,
          ParamType.bool,
        ),
        'new_message': serializeParam(
          _newMessage,
          ParamType.bool,
        ),
        'counter_offer': serializeParam(
          _counterOffer,
          ParamType.bool,
        ),
        'inventory_low': serializeParam(
          _inventoryLow,
          ParamType.bool,
        ),
        'new_follower': serializeParam(
          _newFollower,
          ParamType.bool,
        ),
        'item_sold': serializeParam(
          _itemSold,
          ParamType.bool,
        ),
        'price_drop': serializeParam(
          _priceDrop,
          ParamType.bool,
        ),
        'new_review': serializeParam(
          _newReview,
          ParamType.bool,
        ),
        'shopify_sync': serializeParam(
          _shopifySync,
          ParamType.bool,
        ),
        'shortlist_scan': serializeParam(
          _shortlistScan,
          ParamType.bool,
        ),
        'referral_sale': serializeParam(
          _referralSale,
          ParamType.bool,
        ),
      }.withoutNulls;

  static NotificationPreferencesStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      NotificationPreferencesStruct(
        orderShipped: deserializeParam(
          data['order_shipped'],
          ParamType.bool,
          false,
        ),
        orderDelivered: deserializeParam(
          data['order_delivered'],
          ParamType.bool,
          false,
        ),
        newMessage: deserializeParam(
          data['new_message'],
          ParamType.bool,
          false,
        ),
        counterOffer: deserializeParam(
          data['counter_offer'],
          ParamType.bool,
          false,
        ),
        inventoryLow: deserializeParam(
          data['inventory_low'],
          ParamType.bool,
          false,
        ),
        newFollower: deserializeParam(
          data['new_follower'],
          ParamType.bool,
          false,
        ),
        itemSold: deserializeParam(
          data['item_sold'],
          ParamType.bool,
          false,
        ),
        priceDrop: deserializeParam(
          data['price_drop'],
          ParamType.bool,
          false,
        ),
        newReview: deserializeParam(
          data['new_review'],
          ParamType.bool,
          false,
        ),
        shopifySync: deserializeParam(
          data['shopify_sync'],
          ParamType.bool,
          false,
        ),
        shortlistScan: deserializeParam(
          data['shortlist_scan'],
          ParamType.bool,
          false,
        ),
        referralSale: deserializeParam(
          data['referral_sale'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'NotificationPreferencesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is NotificationPreferencesStruct &&
        orderShipped == other.orderShipped &&
        orderDelivered == other.orderDelivered &&
        newMessage == other.newMessage &&
        counterOffer == other.counterOffer &&
        inventoryLow == other.inventoryLow &&
        newFollower == other.newFollower &&
        itemSold == other.itemSold &&
        priceDrop == other.priceDrop &&
        newReview == other.newReview &&
        shopifySync == other.shopifySync &&
        shortlistScan == other.shortlistScan &&
        referralSale == other.referralSale;
  }

  @override
  int get hashCode => const ListEquality().hash([
        orderShipped,
        orderDelivered,
        newMessage,
        counterOffer,
        inventoryLow,
        newFollower,
        itemSold,
        priceDrop,
        newReview,
        shopifySync,
        shortlistScan,
        referralSale
      ]);
}

NotificationPreferencesStruct createNotificationPreferencesStruct({
  bool? orderShipped,
  bool? orderDelivered,
  bool? newMessage,
  bool? counterOffer,
  bool? inventoryLow,
  bool? newFollower,
  bool? itemSold,
  bool? priceDrop,
  bool? newReview,
  bool? shopifySync,
  bool? shortlistScan,
  bool? referralSale,
}) =>
    NotificationPreferencesStruct(
      orderShipped: orderShipped,
      orderDelivered: orderDelivered,
      newMessage: newMessage,
      counterOffer: counterOffer,
      inventoryLow: inventoryLow,
      newFollower: newFollower,
      itemSold: itemSold,
      priceDrop: priceDrop,
      newReview: newReview,
      shopifySync: shopifySync,
      shortlistScan: shortlistScan,
      referralSale: referralSale,
    );

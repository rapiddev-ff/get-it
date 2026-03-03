// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preferences_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationPreferences _$NotificationPreferencesFromJson(
    Map<String, dynamic> json) {
  return _NotificationPreferences.fromJson(json);
}

/// @nodoc
mixin _$NotificationPreferences {
  @JsonKey(name: 'order_shipped')
  bool get orderShipped => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_delivered')
  bool get orderDelivered => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_message')
  bool get newMessage => throw _privateConstructorUsedError;
  @JsonKey(name: 'counter_offer')
  bool get counterOffer => throw _privateConstructorUsedError;
  @JsonKey(name: 'inventory_low')
  bool get inventoryLow => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_follower')
  bool get newFollower => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_sold')
  bool get itemSold => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_drop')
  bool get priceDrop => throw _privateConstructorUsedError;
  @JsonKey(name: 'new_review')
  bool get newReview => throw _privateConstructorUsedError;
  @JsonKey(name: 'shopify_sync')
  bool get shopifySync => throw _privateConstructorUsedError;
  @JsonKey(name: 'shortlist_scan')
  bool get shortlistScan => throw _privateConstructorUsedError;
  @JsonKey(name: 'referral_sale')
  bool get referralSale => throw _privateConstructorUsedError;

  /// Serializes this NotificationPreferences to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationPreferencesCopyWith<NotificationPreferences> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPreferencesCopyWith<$Res> {
  factory $NotificationPreferencesCopyWith(NotificationPreferences value,
          $Res Function(NotificationPreferences) then) =
      _$NotificationPreferencesCopyWithImpl<$Res, NotificationPreferences>;
  @useResult
  $Res call(
      {@JsonKey(name: 'order_shipped') bool orderShipped,
      @JsonKey(name: 'order_delivered') bool orderDelivered,
      @JsonKey(name: 'new_message') bool newMessage,
      @JsonKey(name: 'counter_offer') bool counterOffer,
      @JsonKey(name: 'inventory_low') bool inventoryLow,
      @JsonKey(name: 'new_follower') bool newFollower,
      @JsonKey(name: 'item_sold') bool itemSold,
      @JsonKey(name: 'price_drop') bool priceDrop,
      @JsonKey(name: 'new_review') bool newReview,
      @JsonKey(name: 'shopify_sync') bool shopifySync,
      @JsonKey(name: 'shortlist_scan') bool shortlistScan,
      @JsonKey(name: 'referral_sale') bool referralSale});
}

/// @nodoc
class _$NotificationPreferencesCopyWithImpl<$Res,
        $Val extends NotificationPreferences>
    implements $NotificationPreferencesCopyWith<$Res> {
  _$NotificationPreferencesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderShipped = null,
    Object? orderDelivered = null,
    Object? newMessage = null,
    Object? counterOffer = null,
    Object? inventoryLow = null,
    Object? newFollower = null,
    Object? itemSold = null,
    Object? priceDrop = null,
    Object? newReview = null,
    Object? shopifySync = null,
    Object? shortlistScan = null,
    Object? referralSale = null,
  }) {
    return _then(_value.copyWith(
      orderShipped: null == orderShipped
          ? _value.orderShipped
          : orderShipped // ignore: cast_nullable_to_non_nullable
              as bool,
      orderDelivered: null == orderDelivered
          ? _value.orderDelivered
          : orderDelivered // ignore: cast_nullable_to_non_nullable
              as bool,
      newMessage: null == newMessage
          ? _value.newMessage
          : newMessage // ignore: cast_nullable_to_non_nullable
              as bool,
      counterOffer: null == counterOffer
          ? _value.counterOffer
          : counterOffer // ignore: cast_nullable_to_non_nullable
              as bool,
      inventoryLow: null == inventoryLow
          ? _value.inventoryLow
          : inventoryLow // ignore: cast_nullable_to_non_nullable
              as bool,
      newFollower: null == newFollower
          ? _value.newFollower
          : newFollower // ignore: cast_nullable_to_non_nullable
              as bool,
      itemSold: null == itemSold
          ? _value.itemSold
          : itemSold // ignore: cast_nullable_to_non_nullable
              as bool,
      priceDrop: null == priceDrop
          ? _value.priceDrop
          : priceDrop // ignore: cast_nullable_to_non_nullable
              as bool,
      newReview: null == newReview
          ? _value.newReview
          : newReview // ignore: cast_nullable_to_non_nullable
              as bool,
      shopifySync: null == shopifySync
          ? _value.shopifySync
          : shopifySync // ignore: cast_nullable_to_non_nullable
              as bool,
      shortlistScan: null == shortlistScan
          ? _value.shortlistScan
          : shortlistScan // ignore: cast_nullable_to_non_nullable
              as bool,
      referralSale: null == referralSale
          ? _value.referralSale
          : referralSale // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationPreferencesImplCopyWith<$Res>
    implements $NotificationPreferencesCopyWith<$Res> {
  factory _$$NotificationPreferencesImplCopyWith(
          _$NotificationPreferencesImpl value,
          $Res Function(_$NotificationPreferencesImpl) then) =
      __$$NotificationPreferencesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'order_shipped') bool orderShipped,
      @JsonKey(name: 'order_delivered') bool orderDelivered,
      @JsonKey(name: 'new_message') bool newMessage,
      @JsonKey(name: 'counter_offer') bool counterOffer,
      @JsonKey(name: 'inventory_low') bool inventoryLow,
      @JsonKey(name: 'new_follower') bool newFollower,
      @JsonKey(name: 'item_sold') bool itemSold,
      @JsonKey(name: 'price_drop') bool priceDrop,
      @JsonKey(name: 'new_review') bool newReview,
      @JsonKey(name: 'shopify_sync') bool shopifySync,
      @JsonKey(name: 'shortlist_scan') bool shortlistScan,
      @JsonKey(name: 'referral_sale') bool referralSale});
}

/// @nodoc
class __$$NotificationPreferencesImplCopyWithImpl<$Res>
    extends _$NotificationPreferencesCopyWithImpl<$Res,
        _$NotificationPreferencesImpl>
    implements _$$NotificationPreferencesImplCopyWith<$Res> {
  __$$NotificationPreferencesImplCopyWithImpl(
      _$NotificationPreferencesImpl _value,
      $Res Function(_$NotificationPreferencesImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderShipped = null,
    Object? orderDelivered = null,
    Object? newMessage = null,
    Object? counterOffer = null,
    Object? inventoryLow = null,
    Object? newFollower = null,
    Object? itemSold = null,
    Object? priceDrop = null,
    Object? newReview = null,
    Object? shopifySync = null,
    Object? shortlistScan = null,
    Object? referralSale = null,
  }) {
    return _then(_$NotificationPreferencesImpl(
      orderShipped: null == orderShipped
          ? _value.orderShipped
          : orderShipped // ignore: cast_nullable_to_non_nullable
              as bool,
      orderDelivered: null == orderDelivered
          ? _value.orderDelivered
          : orderDelivered // ignore: cast_nullable_to_non_nullable
              as bool,
      newMessage: null == newMessage
          ? _value.newMessage
          : newMessage // ignore: cast_nullable_to_non_nullable
              as bool,
      counterOffer: null == counterOffer
          ? _value.counterOffer
          : counterOffer // ignore: cast_nullable_to_non_nullable
              as bool,
      inventoryLow: null == inventoryLow
          ? _value.inventoryLow
          : inventoryLow // ignore: cast_nullable_to_non_nullable
              as bool,
      newFollower: null == newFollower
          ? _value.newFollower
          : newFollower // ignore: cast_nullable_to_non_nullable
              as bool,
      itemSold: null == itemSold
          ? _value.itemSold
          : itemSold // ignore: cast_nullable_to_non_nullable
              as bool,
      priceDrop: null == priceDrop
          ? _value.priceDrop
          : priceDrop // ignore: cast_nullable_to_non_nullable
              as bool,
      newReview: null == newReview
          ? _value.newReview
          : newReview // ignore: cast_nullable_to_non_nullable
              as bool,
      shopifySync: null == shopifySync
          ? _value.shopifySync
          : shopifySync // ignore: cast_nullable_to_non_nullable
              as bool,
      shortlistScan: null == shortlistScan
          ? _value.shortlistScan
          : shortlistScan // ignore: cast_nullable_to_non_nullable
              as bool,
      referralSale: null == referralSale
          ? _value.referralSale
          : referralSale // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationPreferencesImpl extends _NotificationPreferences {
  const _$NotificationPreferencesImpl(
      {@JsonKey(name: 'order_shipped') this.orderShipped = false,
      @JsonKey(name: 'order_delivered') this.orderDelivered = false,
      @JsonKey(name: 'new_message') this.newMessage = false,
      @JsonKey(name: 'counter_offer') this.counterOffer = false,
      @JsonKey(name: 'inventory_low') this.inventoryLow = false,
      @JsonKey(name: 'new_follower') this.newFollower = false,
      @JsonKey(name: 'item_sold') this.itemSold = false,
      @JsonKey(name: 'price_drop') this.priceDrop = false,
      @JsonKey(name: 'new_review') this.newReview = false,
      @JsonKey(name: 'shopify_sync') this.shopifySync = false,
      @JsonKey(name: 'shortlist_scan') this.shortlistScan = false,
      @JsonKey(name: 'referral_sale') this.referralSale = false})
      : super._();

  factory _$NotificationPreferencesImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationPreferencesImplFromJson(json);

  @override
  @JsonKey(name: 'order_shipped')
  final bool orderShipped;
  @override
  @JsonKey(name: 'order_delivered')
  final bool orderDelivered;
  @override
  @JsonKey(name: 'new_message')
  final bool newMessage;
  @override
  @JsonKey(name: 'counter_offer')
  final bool counterOffer;
  @override
  @JsonKey(name: 'inventory_low')
  final bool inventoryLow;
  @override
  @JsonKey(name: 'new_follower')
  final bool newFollower;
  @override
  @JsonKey(name: 'item_sold')
  final bool itemSold;
  @override
  @JsonKey(name: 'price_drop')
  final bool priceDrop;
  @override
  @JsonKey(name: 'new_review')
  final bool newReview;
  @override
  @JsonKey(name: 'shopify_sync')
  final bool shopifySync;
  @override
  @JsonKey(name: 'shortlist_scan')
  final bool shortlistScan;
  @override
  @JsonKey(name: 'referral_sale')
  final bool referralSale;

  @override
  String toString() {
    return 'NotificationPreferences(orderShipped: $orderShipped, orderDelivered: $orderDelivered, newMessage: $newMessage, counterOffer: $counterOffer, inventoryLow: $inventoryLow, newFollower: $newFollower, itemSold: $itemSold, priceDrop: $priceDrop, newReview: $newReview, shopifySync: $shopifySync, shortlistScan: $shortlistScan, referralSale: $referralSale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPreferencesImpl &&
            (identical(other.orderShipped, orderShipped) ||
                other.orderShipped == orderShipped) &&
            (identical(other.orderDelivered, orderDelivered) ||
                other.orderDelivered == orderDelivered) &&
            (identical(other.newMessage, newMessage) ||
                other.newMessage == newMessage) &&
            (identical(other.counterOffer, counterOffer) ||
                other.counterOffer == counterOffer) &&
            (identical(other.inventoryLow, inventoryLow) ||
                other.inventoryLow == inventoryLow) &&
            (identical(other.newFollower, newFollower) ||
                other.newFollower == newFollower) &&
            (identical(other.itemSold, itemSold) ||
                other.itemSold == itemSold) &&
            (identical(other.priceDrop, priceDrop) ||
                other.priceDrop == priceDrop) &&
            (identical(other.newReview, newReview) ||
                other.newReview == newReview) &&
            (identical(other.shopifySync, shopifySync) ||
                other.shopifySync == shopifySync) &&
            (identical(other.shortlistScan, shortlistScan) ||
                other.shortlistScan == shortlistScan) &&
            (identical(other.referralSale, referralSale) ||
                other.referralSale == referralSale));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
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
      referralSale);

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationPreferencesImplCopyWith<_$NotificationPreferencesImpl>
      get copyWith => __$$NotificationPreferencesImplCopyWithImpl<
          _$NotificationPreferencesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationPreferencesImplToJson(
      this,
    );
  }
}

abstract class _NotificationPreferences extends NotificationPreferences {
  const factory _NotificationPreferences(
          {@JsonKey(name: 'order_shipped') final bool orderShipped,
          @JsonKey(name: 'order_delivered') final bool orderDelivered,
          @JsonKey(name: 'new_message') final bool newMessage,
          @JsonKey(name: 'counter_offer') final bool counterOffer,
          @JsonKey(name: 'inventory_low') final bool inventoryLow,
          @JsonKey(name: 'new_follower') final bool newFollower,
          @JsonKey(name: 'item_sold') final bool itemSold,
          @JsonKey(name: 'price_drop') final bool priceDrop,
          @JsonKey(name: 'new_review') final bool newReview,
          @JsonKey(name: 'shopify_sync') final bool shopifySync,
          @JsonKey(name: 'shortlist_scan') final bool shortlistScan,
          @JsonKey(name: 'referral_sale') final bool referralSale}) =
      _$NotificationPreferencesImpl;
  const _NotificationPreferences._() : super._();

  factory _NotificationPreferences.fromJson(Map<String, dynamic> json) =
      _$NotificationPreferencesImpl.fromJson;

  @override
  @JsonKey(name: 'order_shipped')
  bool get orderShipped;
  @override
  @JsonKey(name: 'order_delivered')
  bool get orderDelivered;
  @override
  @JsonKey(name: 'new_message')
  bool get newMessage;
  @override
  @JsonKey(name: 'counter_offer')
  bool get counterOffer;
  @override
  @JsonKey(name: 'inventory_low')
  bool get inventoryLow;
  @override
  @JsonKey(name: 'new_follower')
  bool get newFollower;
  @override
  @JsonKey(name: 'item_sold')
  bool get itemSold;
  @override
  @JsonKey(name: 'price_drop')
  bool get priceDrop;
  @override
  @JsonKey(name: 'new_review')
  bool get newReview;
  @override
  @JsonKey(name: 'shopify_sync')
  bool get shopifySync;
  @override
  @JsonKey(name: 'shortlist_scan')
  bool get shortlistScan;
  @override
  @JsonKey(name: 'referral_sale')
  bool get referralSale;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationPreferencesImplCopyWith<_$NotificationPreferencesImpl>
      get copyWith => throw _privateConstructorUsedError;
}

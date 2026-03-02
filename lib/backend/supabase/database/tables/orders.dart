import '../database.dart';

class OrdersTable extends SupabaseTable<OrdersRow> {
  @override
  String get tableName => 'orders';

  @override
  OrdersRow createRow(Map<String, dynamic> data) => OrdersRow(data);
}

class OrdersRow extends SupabaseDataRow {
  OrdersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => OrdersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String get orderNumber => getField<String>('order_number')!;
  set orderNumber(String value) => setField<String>('order_number', value);

  String get buyerId => getField<String>('buyer_id')!;
  set buyerId(String value) => setField<String>('buyer_id', value);

  String get sellerId => getField<String>('seller_id')!;
  set sellerId(String value) => setField<String>('seller_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  double get subtotal => getField<double>('subtotal')!;
  set subtotal(double value) => setField<double>('subtotal', value);

  double? get shippingCost => getField<double>('shipping_cost');
  set shippingCost(double? value) => setField<double>('shipping_cost', value);

  double? get taxAmount => getField<double>('tax_amount');
  set taxAmount(double? value) => setField<double>('tax_amount', value);

  double? get platformFee => getField<double>('platform_fee');
  set platformFee(double? value) => setField<double>('platform_fee', value);

  double get totalAmount => getField<double>('total_amount')!;
  set totalAmount(double value) => setField<double>('total_amount', value);

  String? get shippingAddressId => getField<String>('shipping_address_id');
  set shippingAddressId(String? value) =>
      setField<String>('shipping_address_id', value);

  dynamic get shippingAddressSnapshot =>
      getField<dynamic>('shipping_address_snapshot');
  set shippingAddressSnapshot(dynamic value) =>
      setField<dynamic>('shipping_address_snapshot', value);

  String? get trackingNumber => getField<String>('tracking_number');
  set trackingNumber(String? value) =>
      setField<String>('tracking_number', value);

  String? get shippingCarrier => getField<String>('shipping_carrier');
  set shippingCarrier(String? value) =>
      setField<String>('shipping_carrier', value);

  String? get shippingStatus => getField<String>('shipping_status');
  set shippingStatus(String? value) =>
      setField<String>('shipping_status', value);

  String? get paymentMethodId => getField<String>('payment_method_id');
  set paymentMethodId(String? value) =>
      setField<String>('payment_method_id', value);

  String? get stripePaymentIntentId =>
      getField<String>('stripe_payment_intent_id');
  set stripePaymentIntentId(String? value) =>
      setField<String>('stripe_payment_intent_id', value);

  String? get shortlistId => getField<String>('shortlist_id');
  set shortlistId(String? value) => setField<String>('shortlist_id', value);

  String? get buyerNotes => getField<String>('buyer_notes');
  set buyerNotes(String? value) => setField<String>('buyer_notes', value);

  String? get sellerNotes => getField<String>('seller_notes');
  set sellerNotes(String? value) => setField<String>('seller_notes', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  DateTime? get paidAt => getField<DateTime>('paid_at');
  set paidAt(DateTime? value) => setField<DateTime>('paid_at', value);

  DateTime? get shippedAt => getField<DateTime>('shipped_at');
  set shippedAt(DateTime? value) => setField<DateTime>('shipped_at', value);

  DateTime? get deliveredAt => getField<DateTime>('delivered_at');
  set deliveredAt(DateTime? value) => setField<DateTime>('delivered_at', value);

  DateTime? get refundedAt => getField<DateTime>('refunded_at');
  set refundedAt(DateTime? value) => setField<DateTime>('refunded_at', value);

  DateTime? get cancelledAt => getField<DateTime>('cancelled_at');
  set cancelledAt(DateTime? value) => setField<DateTime>('cancelled_at', value);

  DateTime? get deletedAt => getField<DateTime>('deleted_at');
  set deletedAt(DateTime? value) => setField<DateTime>('deleted_at', value);
}

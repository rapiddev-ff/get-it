import '/features/home/data/repositories/order_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _repository = OrderRepository(Supabase.instance.client);

/// Marks an order as shipped, saving tracking number and carrier.
/// Returns null on success, or an error message string on failure.
Future<String?> markOrderShipped({
  required String orderId,
  required String sellerId,
  String? trackingNumber,
  String? shippingCarrier,
}) async {
  return _repository.markOrderShipped(
    orderId: orderId,
    sellerId: sellerId,
    trackingNumber: trackingNumber,
    shippingCarrier: shippingCarrier,
  );
}

/// Updates tracking number for an already-shipped order.
Future<String?> updateTrackingNumber({
  required String orderId,
  required String sellerId,
  required String trackingNumber,
  String? shippingCarrier,
}) async {
  return _repository.updateTrackingNumber(
    orderId: orderId,
    sellerId: sellerId,
    trackingNumber: trackingNumber,
    shippingCarrier: shippingCarrier,
  );
}

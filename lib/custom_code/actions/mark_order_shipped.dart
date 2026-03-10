import '/backend/supabase/supabase.dart';

/// Detects shipping carrier from tracking number format.
String? _detectCarrier(String trackingNumber) {
  final tn = trackingNumber.replaceAll(RegExp(r'\s'), '').toUpperCase();

  // UPS: 1Z + 16 alphanumeric
  if (RegExp(r'^1Z[A-Z0-9]{16}$').hasMatch(tn)) return 'ups';

  // FedEx: 12, 15, 20, or 22 digits
  if (RegExp(r'^\d{12}$').hasMatch(tn) ||
      RegExp(r'^\d{15}$').hasMatch(tn) ||
      RegExp(r'^\d{20}$').hasMatch(tn) ||
      RegExp(r'^\d{22}$').hasMatch(tn)) {
    return 'fedex';
  }

  // USPS: 20-22 digits or specific prefixes
  if (RegExp(r'^\d{20,22}$').hasMatch(tn)) return 'usps';
  if (RegExp(r'^(94|93|92|91|90)\d{18,20}$').hasMatch(tn)) return 'usps';
  if (RegExp(r'^[A-Z]{2}\d{9}US$', caseSensitive: false).hasMatch(tn)) {
    return 'usps';
  }

  return null;
}

/// Marks an order as shipped, saving tracking number and carrier.
/// Returns null on success, or an error message string on failure.
///
/// Tracking number is required for orders with total_amount > $15.00.
/// For orders <= $15.00, tracking number is optional.
Future<String?> markOrderShipped({
  required String orderId,
  String? trackingNumber,
  String? shippingCarrier,
}) async {
  final client = SupaFlow.client;

  try {
    // Fetch order to validate
    final orderData = await client
        .from('orders')
        .select('status, total_amount')
        .eq('id', orderId)
        .single();

    final status = orderData['status'] as String?;
    if (status == 'sale_pending') {
      return 'Order is still pending confirmation. Please wait for the 5-minute buyer cancellation window to expire.';
    }
    if (status != 'paid') {
      return 'Order is not in a shippable state';
    }

    final totalAmount = (orderData['total_amount'] as num?)?.toDouble() ?? 0.0;

    // Validate tracking number for orders > $15
    if (totalAmount > 15.0 &&
        (trackingNumber == null || trackingNumber.trim().isEmpty)) {
      return 'Tracking number is required for orders over \$15.00';
    }

    // Update order
    final updateData = <String, dynamic>{
      'status': 'shipped',
      'shipped_at': DateTime.now().toUtc().toIso8601String(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };

    if (trackingNumber != null && trackingNumber.trim().isNotEmpty) {
      updateData['tracking_number'] = trackingNumber.trim();
    }

    // Auto-detect carrier if not provided
    final carrier = shippingCarrier?.trim().isNotEmpty == true
        ? shippingCarrier!.trim()
        : (trackingNumber != null ? _detectCarrier(trackingNumber.trim()) : null);
    if (carrier != null) {
      updateData['shipping_carrier'] = carrier;
    }

    await client.from('orders').update(updateData).eq('id', orderId);

    return null;
  } catch (e) {
    return e.toString();
  }
}

/// Updates tracking number for an already-shipped order.
/// Only allowed for orders with status 'shipped'.
Future<String?> updateTrackingNumber({
  required String orderId,
  required String trackingNumber,
  String? shippingCarrier,
}) async {
  final client = SupaFlow.client;

  try {
    final orderData = await client
        .from('orders')
        .select('status')
        .eq('id', orderId)
        .single();

    final status = orderData['status'] as String?;
    if (status != 'shipped') {
      return 'Tracking can only be edited for shipped orders';
    }

    final updateData = <String, dynamic>{
      'tracking_number': trackingNumber.trim(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    };

    final carrier = shippingCarrier?.trim().isNotEmpty == true
        ? shippingCarrier!.trim()
        : _detectCarrier(trackingNumber.trim());
    if (carrier != null) {
      updateData['shipping_carrier'] = carrier;
    }

    await client.from('orders').update(updateData).eq('id', orderId);

    return null;
  } catch (e) {
    return e.toString();
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:get_it/features/checkout/data/repositories/checkout_repository.dart';
import '../helpers/mock_supabase.dart';

void main() {
  late MockSupabaseClient mockClient;
  late CheckoutRepository repository;

  setUp(() {
    mockClient = MockSupabaseClient();
    repository = CheckoutRepository(mockClient);
  });

  // ---------------------------------------------------------------------------
  // calculateTotals
  // ---------------------------------------------------------------------------
  group('calculateTotals', () {
    final successResponse = <String, dynamic>{
      'success': true,
      'effective_price': 29.99,
      'original_price': 39.99,
      'is_flash_sale': true,
      'subtotal': 59.98,
      'shipping_cost': 5.99,
      'free_shipping': false,
      'tax_amount': 4.80,
      'platform_fee': 1.50,
      'total_amount': 72.27,
      'available_quantity': 10,
    };

    test('returns CheckoutTotals on success with Map response', () async {
      stubRpcSuccess(mockClient, 'calculate_checkout_totals', successResponse);

      final result = await repository.calculateTotals('prod-1', 2);

      expect(result, isNotNull);
      expect(result!.effectivePrice, 29.99);
      expect(result.originalPrice, 39.99);
      expect(result.isFlashSale, isTrue);
      expect(result.subtotal, 59.98);
      expect(result.shippingCost, 5.99);
      expect(result.freeShipping, isFalse);
      expect(result.taxAmount, 4.80);
      expect(result.platformFee, 1.50);
      expect(result.totalAmount, 72.27);
      expect(result.availableQuantity, 10);
    });

    test('returns CheckoutTotals when response is a List with one element',
        () async {
      stubRpcSuccess(
          mockClient, 'calculate_checkout_totals', [successResponse]);

      final result = await repository.calculateTotals('prod-1', 2);

      expect(result, isNotNull);
      expect(result!.effectivePrice, 29.99);
      expect(result.totalAmount, 72.27);
    });

    test('returns null when response is null', () async {
      stubRpcSuccess(mockClient, 'calculate_checkout_totals', null);

      final result = await repository.calculateTotals('prod-1', 1);

      expect(result, isNull);
    });

    test('returns null when success is false', () async {
      stubRpcSuccess(mockClient, 'calculate_checkout_totals', {
        'success': false,
        'error': 'product not found',
      });

      final result = await repository.calculateTotals('invalid', 1);

      expect(result, isNull);
    });

    test('returns null when response is empty list', () async {
      stubRpcSuccess(mockClient, 'calculate_checkout_totals', []);

      final result = await repository.calculateTotals('prod-1', 1);

      expect(result, isNull);
    });

    test('returns null on exception', () async {
      stubRpcError(mockClient, 'calculate_checkout_totals',
          Exception('network error'));

      final result = await repository.calculateTotals('prod-1', 1);

      expect(result, isNull);
    });

    test('handles numeric string values via _toDouble', () async {
      stubRpcSuccess(mockClient, 'calculate_checkout_totals', {
        'success': true,
        'effective_price': '15.50',
        'original_price': '20.00',
        'is_flash_sale': false,
        'subtotal': '15.50',
        'shipping_cost': '0',
        'free_shipping': true,
        'tax_amount': '1.24',
        'platform_fee': '0.50',
        'total_amount': '17.24',
        'available_quantity': '5',
      });

      final result = await repository.calculateTotals('prod-1', 1);

      expect(result, isNotNull);
      expect(result!.effectivePrice, 15.50);
      expect(result.freeShipping, isTrue);
      expect(result.availableQuantity, 5);
    });

    test('passes correct params to RPC', () async {
      stubRpcSuccess(mockClient, 'calculate_checkout_totals', successResponse);

      await repository.calculateTotals('prod-abc', 3);

      final captured = verify(
        () => mockClient.rpc(
          'calculate_checkout_totals',
          params: captureAny(named: 'params'),
        ),
      ).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_product_id'], 'prod-abc');
      expect(params['p_quantity'], 3);
    });
  });

  // ---------------------------------------------------------------------------
  // calculateOrderTax
  // ---------------------------------------------------------------------------
  group('calculateOrderTax', () {
    test('returns tax when response is a number', () async {
      stubRpcSuccess(mockClient, 'calculate_order_tax', 4.80);

      final result = await repository.calculateOrderTax(50.0, 5.99, 'CA');

      expect(result, 4.80);
    });

    test('returns tax from Map response with tax_amount key', () async {
      stubRpcSuccess(mockClient, 'calculate_order_tax', {
        'tax_amount': 3.25,
      });

      final result = await repository.calculateOrderTax(40.0, 5.0, 'NY');

      expect(result, 3.25);
    });

    test('returns 0.0 when response is null', () async {
      stubRpcSuccess(mockClient, 'calculate_order_tax', null);

      final result = await repository.calculateOrderTax(50.0, 5.99, null);

      expect(result, 0.0);
    });

    test('returns 0.0 on exception', () async {
      stubRpcError(
          mockClient, 'calculate_order_tax', Exception('network error'));

      final result = await repository.calculateOrderTax(50.0, 5.0, 'TX');

      expect(result, 0.0);
    });

    test('passes correct params including null stateCode', () async {
      stubRpcSuccess(mockClient, 'calculate_order_tax', 0.0);

      await repository.calculateOrderTax(100.0, 10.0, null);

      final captured = verify(
        () => mockClient.rpc(
          'calculate_order_tax',
          params: captureAny(named: 'params'),
        ),
      ).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_subtotal'], 100.0);
      expect(params['p_shipping_cost'], 10.0);
      expect(params['p_state_code'], isNull);
    });

    test('returns integer response as double', () async {
      stubRpcSuccess(mockClient, 'calculate_order_tax', 5);

      final result = await repository.calculateOrderTax(60.0, 5.0, 'WA');

      expect(result, 5.0);
    });
  });

  // ---------------------------------------------------------------------------
  // createOrder
  // ---------------------------------------------------------------------------
  group('createOrder', () {
    final successResponse = <String, dynamic>{
      'success': true,
      'order_id': 'ord-123',
      'order_number': 'ORD-2024-001',
      'subtotal': 29.99,
      'shipping_cost': 5.99,
      'tax_amount': 2.88,
      'platform_fee': 1.00,
      'total_amount': 39.86,
      'seller_id': 'seller-1',
      'product_title': 'Vintage Sneakers',
    };

    test('returns CheckoutOrderResult on success', () async {
      stubRpcSuccess(mockClient, 'create_checkout_order', successResponse);

      final result = await repository.createOrder(
        'prod-1',
        1,
        'addr-1',
        'pm-1',
        'Please ship fast',
        null,
      );

      expect(result, isNotNull);
      expect(result!.success, isTrue);
      expect(result.orderId, 'ord-123');
      expect(result.orderNumber, 'ORD-2024-001');
      expect(result.subtotal, 29.99);
      expect(result.shippingCost, 5.99);
      expect(result.taxAmount, 2.88);
      expect(result.platformFee, 1.00);
      expect(result.totalAmount, 39.86);
      expect(result.sellerId, 'seller-1');
      expect(result.productTitle, 'Vintage Sneakers');
    });

    test('returns null when success is false', () async {
      stubRpcSuccess(mockClient, 'create_checkout_order', {
        'success': false,
        'error': 'insufficient stock',
      });

      final result =
          await repository.createOrder('prod-1', 5, null, null, null, null);

      expect(result, isNull);
    });

    test('returns null when response is null', () async {
      stubRpcSuccess(mockClient, 'create_checkout_order', null);

      final result =
          await repository.createOrder('prod-1', 1, null, null, null, null);

      expect(result, isNull);
    });

    test('returns null on exception', () async {
      stubRpcError(
          mockClient, 'create_checkout_order', Exception('network error'));

      final result =
          await repository.createOrder('prod-1', 1, null, null, null, null);

      expect(result, isNull);
    });

    test('passes all params correctly', () async {
      stubRpcSuccess(mockClient, 'create_checkout_order', successResponse);

      await repository.createOrder(
        'prod-abc',
        2,
        'addr-xyz',
        'pm-456',
        'Rush order',
        'shortlist-1',
      );

      final captured = verify(
        () => mockClient.rpc(
          'create_checkout_order',
          params: captureAny(named: 'params'),
        ),
      ).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_product_id'], 'prod-abc');
      expect(params['p_quantity'], 2);
      expect(params['p_shipping_address_id'], 'addr-xyz');
      expect(params['p_payment_method_id'], 'pm-456');
      expect(params['p_buyer_notes'], 'Rush order');
      expect(params['p_shortlist_id'], 'shortlist-1');
    });

    test('handles missing optional fields with defaults', () async {
      stubRpcSuccess(mockClient, 'create_checkout_order', {
        'success': true,
      });

      final result =
          await repository.createOrder('prod-1', 1, null, null, null, null);

      expect(result, isNotNull);
      expect(result!.orderId, '');
      expect(result.orderNumber, '');
      expect(result.subtotal, 0.0);
      expect(result.sellerId, '');
      expect(result.productTitle, '');
    });
  });
}

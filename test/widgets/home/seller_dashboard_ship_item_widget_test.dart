import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:get_it/core/theme/app_theme.dart';
import 'package:get_it/features/home/presentation/widgets/components/seller_dashboard_ship_item_widget.dart';

void main() {
  final baseOrder = <String, dynamic>{
    'id': 'order-1',
    'order_number': 'ORD-001',
    'status': 'paid',
    'total_amount': 49.99,
    'buyer': {
      'id': 'buyer-1',
      'username': 'jane_buyer',
      'photo_url': 'https://example.com/avatar.jpg',
    },
    'order_items': [
      {
        'product_id': 'prod-1',
        'product_title': 'Vintage Watch',
        'product_price': 49.99,
        'quantity': 1,
        'products': {
          'main_image_url': 'https://example.com/watch.jpg',
        },
      },
    ],
  };

  Widget buildTestWidget(Map<String, dynamic> order,
      {VoidCallback? onShipped}) {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: SellerDashboardShipItemWidget(
              order: order,
              onShipped: onShipped,
            ),
          ),
        ),
      ],
    );

    return MaterialApp.router(
      theme: AppTheme.dark,
      routerConfig: router,
    );
  }

  group('SellerDashboardShipItemWidget', () {
    // -----------------------------------------------------------------------
    // Rendering
    // -----------------------------------------------------------------------
    testWidgets('displays product title', (tester) async {
      await tester.pumpWidget(buildTestWidget(baseOrder));
      await tester.pumpAndSettle();

      expect(find.text('Vintage Watch'), findsOneWidget);
    });

    testWidgets('displays buyer username with "Sold to @" prefix',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(baseOrder));
      await tester.pumpAndSettle();

      expect(find.text('Sold to @jane_buyer'), findsOneWidget);
    });

    testWidgets('displays order number and total amount', (tester) async {
      await tester.pumpWidget(buildTestWidget(baseOrder));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('ORD-001'),
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('\$49.99'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows "Ship" badge when status is paid', (tester) async {
      await tester.pumpWidget(buildTestWidget(baseOrder));
      await tester.pumpAndSettle();

      expect(find.text('Ship'), findsOneWidget);
      expect(find.text('Pending'), findsNothing);
    });

    testWidgets('shows "Pending" badge when status is sale_pending',
        (tester) async {
      final pendingOrder = Map<String, dynamic>.from(baseOrder);
      pendingOrder['status'] = 'sale_pending';

      await tester.pumpWidget(buildTestWidget(pendingOrder));
      await tester.pumpAndSettle();

      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Ship'), findsNothing);
    });

    // -----------------------------------------------------------------------
    // Edge cases
    // -----------------------------------------------------------------------
    testWidgets('displays "Unknown Product" when order_items is empty',
        (tester) async {
      final emptyOrder = Map<String, dynamic>.from(baseOrder);
      emptyOrder['order_items'] = [];

      await tester.pumpWidget(buildTestWidget(emptyOrder));
      await tester.pumpAndSettle();

      expect(find.text('Unknown Product'), findsOneWidget);
    });

    testWidgets('displays "unknown" buyer when buyer data is missing',
        (tester) async {
      final noBuyer = Map<String, dynamic>.from(baseOrder);
      noBuyer['buyer'] = null;

      await tester.pumpWidget(buildTestWidget(noBuyer));
      await tester.pumpAndSettle();

      expect(find.text('Sold to @unknown'), findsOneWidget);
    });

    testWidgets('shows placeholder when product has no image', (tester) async {
      final noImage = Map<String, dynamic>.from(baseOrder);
      noImage['order_items'] = [
        {
          'product_id': 'prod-1',
          'product_title': 'No Image Product',
          'product_price': 10.0,
          'quantity': 1,
          'products': {'main_image_url': null},
        },
      ];

      await tester.pumpWidget(buildTestWidget(noImage));
      await tester.pumpAndSettle();

      // Should show placeholder icon
      expect(find.byIcon(Icons.image), findsOneWidget);
    });

    testWidgets('formats price with two decimal places', (tester) async {
      final order = Map<String, dynamic>.from(baseOrder);
      order['total_amount'] = 1234.5;

      await tester.pumpWidget(buildTestWidget(order));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RichText && w.text.toPlainText().contains('\$1,234.50'),
        ),
        findsOneWidget,
      );
    });
  });
}

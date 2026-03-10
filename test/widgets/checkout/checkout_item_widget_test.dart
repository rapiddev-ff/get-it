import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get_it/core/theme/app_theme.dart';
import 'package:get_it/features/checkout/presentation/widgets/checkout_item/checkout_item_widget.dart';
import 'package:get_it/features/home/domain/models/feed_product_model.dart';

void main() {
  const testProduct = FeedProduct(
    id: 'prod-1',
    title: 'Vintage Sneakers',
    price: 49.99,
    conditionName: 'Like New',
    sellerUsername: 'john_doe',
    mainImageUrl: 'https://example.com/shoe.jpg',
  );

  Widget buildTestWidget({
    FeedProduct? feedProduct = testProduct,
    int? quantity = 1,
    Future Function()? addQuantityAction,
    Future Function()? minusQuantityAction,
  }) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(
          body: CheckoutItemWidget(
            feedProduct: feedProduct,
            quantity: quantity,
            addQuantityAction: addQuantityAction,
            minusQuantityAction: minusQuantityAction,
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Rendering
  // -------------------------------------------------------------------------
  group('CheckoutItemWidget', () {
    testWidgets('displays product title', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Vintage Sneakers'), findsOneWidget);
    });

    testWidgets('displays product condition', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('Like New'), findsOneWidget);
    });

    testWidgets('displays seller username with @ prefix', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // Seller info is in RichText with TextSpan children
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is RichText && w.text.toPlainText().contains('@john_doe'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('displays "Seller: " label', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('Seller:'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('displays calculated price (price x quantity)',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(quantity: 2));
      await tester.pumpAndSettle();

      // 49.99 * 2 = 99.98
      expect(find.text('99.98'), findsOneWidget);
    });

    testWidgets('displays quantity value', (tester) async {
      await tester.pumpWidget(buildTestWidget(quantity: 3));
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('displays close icon', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close_outlined), findsOneWidget);
    });

    testWidgets('displays plus and minus quantity icons', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      // FaIcon is not a standard Icon widget, find by type
      expect(find.byType(FaIcon), findsNWidgets(2));
    });

    // -----------------------------------------------------------------------
    // Interactions
    // -----------------------------------------------------------------------
    testWidgets('tapping plus calls addQuantityAction', (tester) async {
      var addCalled = false;

      await tester.pumpWidget(buildTestWidget(
        addQuantityAction: () async {
          addCalled = true;
        },
      ));
      await tester.pumpAndSettle();

      // FaIcon squarePlus is the second FaIcon in the widget tree
      final faIcons = find.byType(FaIcon);
      await tester.tap(faIcons.last);
      await tester.pumpAndSettle();

      expect(addCalled, isTrue);
    });

    testWidgets('tapping minus calls minusQuantityAction', (tester) async {
      var minusCalled = false;

      await tester.pumpWidget(buildTestWidget(
        minusQuantityAction: () async {
          minusCalled = true;
        },
      ));
      await tester.pumpAndSettle();

      // FaIcon squareMinus is the first FaIcon in the widget tree
      final faIcons = find.byType(FaIcon);
      await tester.tap(faIcons.first);
      await tester.pumpAndSettle();

      expect(minusCalled, isTrue);
    });

    testWidgets('displays single unit price for quantity 1', (tester) async {
      await tester.pumpWidget(buildTestWidget(quantity: 1));
      await tester.pumpAndSettle();

      // 49.99 * 1 = 49.99
      expect(find.text('49.99'), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:get_it/core/theme/app_theme.dart';
import 'package:get_it/features/home/presentation/widgets/empty_state/empty_state_widget.dart';

void main() {
  Widget buildTestWidget({
    Widget? icon,
    String? title,
    String? description,
    bool? hasButton,
    String? buttonText,
    Future Function()? buttonAction,
    double? sidePadding,
  }) {
    return MaterialApp(
      theme: AppTheme.dark,
      home: Scaffold(
        body: EmptyStateWidget(
          icon: icon ?? const Icon(Icons.inbox, size: 48),
          title: title,
          description: description,
          hasButton: hasButton,
          buttonText: buttonText,
          buttonAction: buttonAction,
          sidePadding: sidePadding,
        ),
      ),
    );
  }

  group('EmptyStateWidget', () {
    // -----------------------------------------------------------------------
    // Rendering
    // -----------------------------------------------------------------------
    testWidgets('displays icon', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        icon: const Icon(Icons.favorite, size: 48),
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('displays title text', (tester) async {
      await tester.pumpWidget(buildTestWidget(title: 'No Items'));
      await tester.pumpAndSettle();

      expect(find.text('No Items'), findsOneWidget);
    });

    testWidgets('displays description text', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        description: 'Your wishlist is empty',
      ));
      await tester.pumpAndSettle();

      expect(find.text('Your wishlist is empty'), findsOneWidget);
    });

    testWidgets('uses default title "n/a" when not provided', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.text('n/a'), findsWidgets);
    });

    // -----------------------------------------------------------------------
    // Button
    // -----------------------------------------------------------------------
    testWidgets('does not show button when hasButton is false',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(
        hasButton: false,
        buttonText: 'Browse',
      ));
      await tester.pumpAndSettle();

      expect(find.text('Browse'), findsNothing);
    });

    testWidgets('shows button when hasButton is true', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        hasButton: true,
        buttonText: 'Start Shopping',
      ));
      await tester.pumpAndSettle();

      expect(find.text('Start Shopping'), findsOneWidget);
    });

    testWidgets('tapping button calls buttonAction', (tester) async {
      var actionCalled = false;

      await tester.pumpWidget(buildTestWidget(
        hasButton: true,
        buttonText: 'Retry',
        buttonAction: () async {
          actionCalled = true;
        },
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(actionCalled, isTrue);
    });

    // -----------------------------------------------------------------------
    // Layout
    // -----------------------------------------------------------------------
    testWidgets('centers content vertically', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        title: 'Centered',
      ));
      await tester.pumpAndSettle();

      final column = tester.widget<Column>(find.byType(Column).first);
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });

    testWidgets('does not show button by default', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        title: 'Test',
        description: 'Desc',
        buttonText: 'Action',
      ));
      await tester.pumpAndSettle();

      // hasButton defaults to false, so button text should not appear
      expect(find.text('Action'), findsNothing);
    });
  });
}

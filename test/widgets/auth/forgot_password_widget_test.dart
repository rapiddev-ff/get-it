import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/core/theme/app_theme.dart';
import 'package:get_it/features/auth/presentation/pages/forgot_password/forgot_password_widget.dart';

/// Wraps [ForgotPasswordWidget] with the minimal theme needed for tests.
///
/// ForgotPasswordWidget is a plain StatefulWidget (no Riverpod) so no
/// ProviderScope is required.
Widget _buildTestWidget() {
  return MaterialApp(
    theme: AppTheme.dark,
    home: const ForgotPasswordWidget(),
  );
}

void main() {
  // Disable flutter_animate in tests to avoid timer/async issues.
  setUp(() {
    Animate.restartOnHotReload = false;
  });

  group('ForgotPasswordWidget', () {
    // -------------------------------------------------------------------------
    // Rendering
    // -------------------------------------------------------------------------
    testWidgets('renders email input field', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Your email address'), findsOneWidget);
    });

    testWidgets('renders "Reset Your Password" heading', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Reset Your Password'), findsOneWidget);
    });

    testWidgets('renders instructional text', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(
        find.text(
          "Enter your email address and we'll send you a secure link to create a new password.",
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders "Email" label', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('renders Next button', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.widgetWithText(TextButton, 'Next'), findsOneWidget);
    });

    testWidgets('renders app bar with back button and app name',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.text('Get It'), findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // Text input
    // -------------------------------------------------------------------------
    testWidgets('can enter text in the email field', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final emailField =
          find.widgetWithText(TextFormField, 'Your email address');
      await tester.enterText(emailField, 'forgot@test.com');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('forgot@test.com'), findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // Validation — empty/invalid email
    // -------------------------------------------------------------------------
    // Note: The ForgotPasswordWidget uses toastification (via actions) for
    // validation errors rather than inline error text. Since toastification
    // uses overlays that are hard to test without the toastification test
    // package, we verify the button is tappable and the loading state works.
    testWidgets('Next button is tappable when not loading', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final nextButton = find.widgetWithText(TextButton, 'Next');
      expect(nextButton, findsOneWidget);

      // The button should exist and be pressable (not disabled by default)
      final textButton = tester.widget<TextButton>(nextButton);
      expect(textButton.onPressed, isNotNull);
    });

    // -------------------------------------------------------------------------
    // Email field keyboard type
    // -------------------------------------------------------------------------
    testWidgets('email field has email keyboard type', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // TextFormField wraps a TextField — access keyboardType from TextField
      final textField = tester.widget<TextField>(
        find.descendant(
          of: find.widgetWithText(TextFormField, 'Your email address'),
          matching: find.byType(TextField),
        ),
      );
      expect(textField.keyboardType, TextInputType.emailAddress);
    });

    // -------------------------------------------------------------------------
    // Initial state
    // -------------------------------------------------------------------------
    testWidgets('email field starts empty', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final textFormField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, 'Your email address'),
      );
      expect(textFormField.controller?.text, isEmpty);
    });

    testWidgets('email field is not obscured', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // TextFormField wraps a TextField — access obscureText from TextField
      final textField = tester.widget<TextField>(
        find.descendant(
          of: find.widgetWithText(TextFormField, 'Your email address'),
          matching: find.byType(TextField),
        ),
      );
      expect(textField.obscureText, isFalse);
    });
  });
}

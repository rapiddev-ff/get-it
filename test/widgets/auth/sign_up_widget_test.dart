import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/core/theme/app_theme.dart';
import 'package:get_it/features/auth/presentation/pages/sign_up/sign_up_widget.dart';

/// Wraps [SignUpWidget] with the minimal providers and theme needed for tests.
Widget _buildTestWidget() {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.dark,
      home: const SignUpWidget(),
    ),
  );
}

void main() {
  setUp(() {
    Animate.restartOnHotReload = false;
  });

  group('SignUpWidget', () {
    // -------------------------------------------------------------------------
    // Rendering
    // -------------------------------------------------------------------------
    testWidgets('renders email, password, and confirm password fields',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Your email address'), findsOneWidget);
      expect(find.text('Your Password'), findsOneWidget);
      expect(find.text('Confirm Your Password'), findsOneWidget);
    });

    testWidgets('renders "Create Your Account" heading', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Create Your Account '), findsOneWidget);
    });

    testWidgets('renders subtitle text', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text("Let's get you started."), findsOneWidget);
    });

    testWidgets('renders field labels (Email, Password, Confirm Password)',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('renders Create Account button', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(
          find.widgetWithText(TextButton, 'Create Account'), findsOneWidget);
    });

    testWidgets('renders password requirement indicators', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Minimum 8 characters'), findsOneWidget);
      expect(find.text('One uppercase letter (A-Z)'), findsOneWidget);
      expect(find.text('One number (0-9)'), findsOneWidget);
      expect(find.text(r'One special character (!@#$%)'), findsOneWidget);
      expect(find.text('Passwords match'), findsOneWidget);
    });

    testWidgets('renders terms and conditions checkbox area', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Terms text is in a RichText with TextSpan children, not plain Text widgets
      final richTexts = find.byWidgetPredicate((w) {
        if (w is! RichText) return false;
        final text = w.text.toPlainText();
        return text.contains('I accept the') &&
            text.contains('Terms & Conditions') &&
            text.contains('Privacy Policy');
      });
      expect(richTexts, findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // Validation — empty fields
    // -------------------------------------------------------------------------
    testWidgets('shows email required error when submitting with empty email',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final createButton =
          find.widgetWithText(TextButton, 'Create Account');
      await tester.tap(createButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Please enter your email.'), findsOneWidget);
    });

    testWidgets(
        'shows email format error when submitting with invalid email format',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Enter an invalid email
      final emailField =
          find.widgetWithText(TextFormField, 'Your email address');
      await tester.enterText(emailField, 'bademail');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final createButton =
          find.widgetWithText(TextButton, 'Create Account');
      await tester.tap(createButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Check your email format.'), findsOneWidget);
    });

    // Note: Testing password required and confirm password required errors
    // would require the email check (checkIsEmailRegistered) to pass first,
    // which makes a Supabase call. We skip those validation-chain tests
    // since they need backend mocking.

    // -------------------------------------------------------------------------
    // Password visibility toggles
    // -------------------------------------------------------------------------
    testWidgets('password fields start obscured', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Both visibility_off icons present (password + confirm password)
      expect(find.byIcon(Icons.visibility_off_outlined), findsNWidgets(2));
    });

    testWidgets(
        'tapping password visibility icon toggles first password field',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Tap the first visibility toggle (password field)
      final visibilityIcons = find.byIcon(Icons.visibility_off_outlined);
      await tester.tap(visibilityIcons.first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // First field now shows visibility_outlined, second still shows off
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets(
        'tapping confirm password visibility icon toggles second field',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Tap the second visibility toggle (confirm password field)
      final visibilityIcons = find.byIcon(Icons.visibility_off_outlined);
      await tester.tap(visibilityIcons.last);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Second field now shows visibility_outlined, first still shows off
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // Terms checkbox
    // -------------------------------------------------------------------------
    testWidgets('terms checkbox starts unchecked', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // No check_sharp icon when unchecked
      expect(find.byIcon(Icons.check_sharp), findsNothing);
    });

    testWidgets('tapping terms checkbox toggles it', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find InkWell widgets wrapping a 22x22 Container (the checkbox)
      final checkboxInkWells = find.byWidgetPredicate(
        (w) => w is InkWell && _hasChild22x22(w),
      );
      expect(checkboxInkWells, findsWidgets);

      // Tap the first one (terms checkbox)
      await tester.tap(checkboxInkWells.first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Check icon appears
      expect(find.byIcon(Icons.check_sharp), findsOneWidget);

      // Tap again to uncheck
      final checkedInkWells = find.byWidgetPredicate(
        (w) => w is InkWell && _hasChild22x22(w),
      );
      await tester.tap(checkedInkWells.first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byIcon(Icons.check_sharp), findsNothing);
    });

    // -------------------------------------------------------------------------
    // Password requirement indicators
    // -------------------------------------------------------------------------
    testWidgets(
        'password requirement indicators update as password is entered',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Initially no check icons (all requirements unmet)
      expect(find.byIcon(Icons.check_sharp), findsNothing);

      // Enter a password that satisfies some requirements
      final passwordField =
          find.widgetWithText(TextFormField, 'Your Password');
      await tester.enterText(passwordField, 'Abcdefg1!');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // check_sharp should appear for met requirements:
      // >= 8 chars, uppercase, number, special char (4 of 5)
      // "Passwords match" is NOT met (confirm is still empty)
      expect(find.byIcon(Icons.check_sharp), findsNWidgets(4));
    });

    testWidgets('passwords match indicator activates when both fields match',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final passwordField =
          find.widgetWithText(TextFormField, 'Your Password');
      final confirmField =
          find.widgetWithText(TextFormField, 'Confirm Your Password');

      await tester.enterText(passwordField, 'Test123!@');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.enterText(confirmField, 'Test123!@');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // All 5 requirement checks should be active
      expect(find.byIcon(Icons.check_sharp), findsNWidgets(5));
    });

    // -------------------------------------------------------------------------
    // Text input
    // -------------------------------------------------------------------------
    testWidgets('can enter text in all three fields', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Your email address'),
        'test@example.com',
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Your Password'),
        'Password1!',
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Your Password'),
        'Password1!',
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('Password1!'), findsNWidgets(2));
    });

    // -------------------------------------------------------------------------
    // App bar
    // -------------------------------------------------------------------------
    testWidgets('renders app bar with back button and app name',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.text('Get It'), findsOneWidget);
    });
  });
}

/// Checks whether an InkWell's child is a Container with 22x22 constraints.
bool _hasChild22x22(InkWell inkWell) {
  final child = inkWell.child;
  if (child is Container) {
    final constraints = child.constraints;
    if (constraints != null) {
      return constraints.maxWidth == 22.0 && constraints.maxHeight == 22.0;
    }
  }
  return false;
}

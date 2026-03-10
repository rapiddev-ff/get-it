import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/core/theme/app_theme.dart';
import 'package:get_it/features/auth/presentation/pages/sign_in/sign_in_widget.dart';

/// Wraps [SignInWidget] with the minimal providers and theme needed for tests.
///
/// Uses [MaterialApp] (not router) so that GoRouter navigation calls are
/// no-ops and we don't need to wire up real routes.
Widget _buildTestWidget() {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.dark,
      home: const SignInWidget(),
    ),
  );
}

void main() {
  // Disable flutter_animate in tests to avoid timer/async issues.
  setUp(() {
    Animate.restartOnHotReload = false;
  });

  group('SignInWidget', () {
    // -------------------------------------------------------------------------
    // Rendering
    // -------------------------------------------------------------------------
    testWidgets('renders email and password text fields', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Your email address'), findsOneWidget);
      expect(find.text('Your Password'), findsOneWidget);
    });

    testWidgets('renders "Sign In" heading', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // "Sign In" appears as heading and as button text
      expect(find.text('Sign In'), findsWidgets);
    });

    testWidgets('renders "Keep me signed in" label', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Keep me signed in'), findsOneWidget);
    });

    testWidgets('renders "Forgot Password?" link', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('renders app bar with back button and app name',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
      expect(find.text('Get It'), findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // Validation — empty fields
    // -------------------------------------------------------------------------
    testWidgets('shows email format error when submitting empty email',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final signInButton = find.widgetWithText(TextButton, 'Sign In');
      expect(signInButton, findsOneWidget);
      await tester.tap(signInButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Check your email format.'), findsOneWidget);
    });

    testWidgets(
        'shows password required error when email is valid but password empty',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final emailField =
          find.widgetWithText(TextFormField, 'Your email address');
      await tester.enterText(emailField, 'test@example.com');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final signInButton = find.widgetWithText(TextButton, 'Sign In');
      await tester.tap(signInButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Password is required.'), findsOneWidget);
    });

    testWidgets('shows email format error for invalid email', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final emailField =
          find.widgetWithText(TextFormField, 'Your email address');
      await tester.enterText(emailField, 'notanemail');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final signInButton = find.widgetWithText(TextButton, 'Sign In');
      await tester.tap(signInButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Check your email format.'), findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // Password visibility toggle
    // -------------------------------------------------------------------------
    testWidgets('password field starts obscured', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final editableTexts = tester.widgetList<EditableText>(
        find.byType(EditableText),
      );
      // The second EditableText is the password field
      final passwordEditable = editableTexts.elementAt(1);
      expect(passwordEditable.obscureText, isTrue);
    });

    testWidgets('tapping visibility icon toggles password visibility',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Initially shows visibility_off icon
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsNothing);

      // Tap the visibility toggle
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Now shows visibility icon
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);

      // Verify the EditableText is no longer obscured
      final editableTexts = tester.widgetList<EditableText>(
        find.byType(EditableText),
      );
      final passwordEditable = editableTexts.elementAt(1);
      expect(passwordEditable.obscureText, isFalse);
    });

    // -------------------------------------------------------------------------
    // Keep signed in checkbox
    // -------------------------------------------------------------------------
    testWidgets('keep signed in checkbox starts unchecked', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byIcon(Icons.check_sharp), findsNothing);
    });

    testWidgets('tapping keep signed in checkbox toggles it', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find the 22x22 Container that acts as the checkbox.
      // It is wrapped in an InkWell.
      final checkboxFinder = find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.constraints != null &&
            w.constraints!.maxWidth == 22.0 &&
            w.constraints!.maxHeight == 22.0,
      );
      expect(checkboxFinder, findsWidgets);

      // Tap to check
      await tester.tap(checkboxFinder.first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byIcon(Icons.check_sharp), findsOneWidget);

      // Tap again to uncheck — the checked checkbox now contains the icon
      await tester.tap(find.byIcon(Icons.check_sharp));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byIcon(Icons.check_sharp), findsNothing);
    });

    // -------------------------------------------------------------------------
    // Text input
    // -------------------------------------------------------------------------
    testWidgets('can enter text in email and password fields', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final emailField =
          find.widgetWithText(TextFormField, 'Your email address');
      await tester.enterText(emailField, 'user@test.com');
      // Pump past EasyDebounce timer (100ms)
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final passwordField =
          find.widgetWithText(TextFormField, 'Your Password');
      await tester.enterText(passwordField, 'Secret123!');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('user@test.com'), findsOneWidget);
      expect(find.text('Secret123!'), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/core/theme/app_theme.dart';
import 'package:get_it/features/profile/presentation/pages/settings_change_password/settings_change_password_widget.dart';

/// Wraps [SettingsChangePasswordWidget] with the minimal theme needed for
/// tests. This widget is a plain [StatefulWidget] with no Riverpod providers,
/// so no [ProviderScope] is required.
Widget _buildTestWidget() {
  return MaterialApp(
    theme: AppTheme.dark,
    home: const SettingsChangePasswordWidget(),
  );
}

void main() {
  // Disable flutter_animate in tests to avoid timer/async issues.
  setUp(() {
    Animate.restartOnHotReload = false;
  });

  group('SettingsChangePasswordWidget', () {
    // -------------------------------------------------------------------------
    // Rendering
    // -------------------------------------------------------------------------
    testWidgets('renders app bar with Change Password title', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Change Password'), findsWidgets);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('renders Current Password label and field', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Current Password'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'Enter Current Password'),
        findsOneWidget,
      );
    });

    testWidgets('renders New Password label and field', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('New Password'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'Enter New Password'),
        findsOneWidget,
      );
    });

    testWidgets('renders Confirm Password label and field', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Confirm Password'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'Confirm New Password'),
        findsOneWidget,
      );
    });

    testWidgets('renders password requirement hints', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Minimum 8 characters'), findsOneWidget);
      expect(find.text('One uppercase letter (A-Z)'), findsOneWidget);
      expect(find.text('One number (0-9)'), findsOneWidget);
      expect(find.textContaining('One special character'), findsOneWidget);
      expect(find.text('Passwords match'), findsOneWidget);
    });

    testWidgets('renders Change Password button', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.widgetWithText(TextButton, 'Change Password'), findsOneWidget);
    });

    testWidgets('renders Cancel button', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Cancel is rendered by AppOutlineButton which uses OutlinedButton.
      expect(find.widgetWithText(OutlinedButton, 'Cancel'), findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // Password fields start obscured
    // -------------------------------------------------------------------------
    testWidgets('all three password fields start obscured', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final editableTexts =
          tester.widgetList<EditableText>(find.byType(EditableText)).toList();
      // There are three password fields
      expect(editableTexts.length, greaterThanOrEqualTo(3));
      expect(editableTexts[0].obscureText, isTrue);
      expect(editableTexts[1].obscureText, isTrue);
      expect(editableTexts[2].obscureText, isTrue);
    });

    // -------------------------------------------------------------------------
    // Password visibility toggles
    // -------------------------------------------------------------------------
    testWidgets('tapping visibility icon on current password field toggles visibility',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // All three fields show visibility_off initially
      final visibilityOffIcons =
          find.byIcon(Icons.visibility_off_outlined).evaluate().toList();
      expect(visibilityOffIcons.length, greaterThanOrEqualTo(1));

      // Tap the first visibility toggle (current password)
      await tester.tap(find.byIcon(Icons.visibility_off_outlined).first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // At least one visibility_outlined should now be visible
      expect(find.byIcon(Icons.visibility_outlined), findsWidgets);
    });

    testWidgets('tapping visibility icon on new password field toggles visibility',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Tap the second visibility toggle (new password)
      await tester.tap(find.byIcon(Icons.visibility_off_outlined).at(1));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // The tapped field should now show visibility icon
      expect(find.byIcon(Icons.visibility_outlined), findsWidgets);

      // Tap again to hide
      await tester.tap(find.byIcon(Icons.visibility_outlined).first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.byIcon(Icons.visibility_off_outlined),
          findsNWidgets(3));
    });

    // -------------------------------------------------------------------------
    // Validation — empty fields
    // -------------------------------------------------------------------------
    testWidgets('shows current password required error when submitting empty fields',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.widgetWithText(TextButton, 'Change Password'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Current Password is required.'), findsOneWidget);
    });

    testWidgets(
        'shows new password required error when only current password is filled',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter Current Password'),
        'currentPass1!',
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.widgetWithText(TextButton, 'Change Password'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('New Password is required.'), findsOneWidget);
    });

    testWidgets(
        'shows confirm password required error when current and new passwords are filled',
        (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter Current Password'),
        'currentPass1!',
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter New Password'),
        'NewPass1!',
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.tap(find.widgetWithText(TextButton, 'Change Password'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Confirm Password is required.'), findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // Text input
    // -------------------------------------------------------------------------
    testWidgets('can enter text into all three password fields', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter Current Password'),
        'OldPass1!',
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter New Password'),
        'NewPass1!',
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm New Password'),
        'NewPass1!',
      );
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Since fields are obscured we verify via controllers indirectly —
      // at least no exception should be thrown and fields exist.
      expect(
        find.widgetWithText(TextFormField, 'Enter Current Password'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, 'Enter New Password'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, 'Confirm New Password'),
        findsOneWidget,
      );
    });
  });
}

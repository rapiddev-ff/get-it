import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/core/theme/app_theme.dart';
import 'package:get_it/features/profile/presentation/pages/settings_edit_profile/settings_edit_profile_widget.dart';

/// Wraps [SettingsEditProfileWidget] with the minimal providers and theme
/// needed for tests.
Widget _buildTestWidget() {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.dark,
      home: const SettingsEditProfileWidget(),
    ),
  );
}

void main() {
  // Disable flutter_animate in tests to avoid timer/async issues.
  setUp(() {
    Animate.restartOnHotReload = false;
  });

  group('SettingsEditProfileWidget', () {
    // -------------------------------------------------------------------------
    // Rendering
    // -------------------------------------------------------------------------
    testWidgets('renders app bar with Edit Profile title', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Edit Profile'), findsWidgets);
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    });

    testWidgets('renders Public Profile section header', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Public Profile'), findsOneWidget);
      expect(find.text('This info is visible to other users.'), findsOneWidget);
    });

    testWidgets('renders Private Account Details section header', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Private Account Details'), findsOneWidget);
      expect(find.text('For verification and security'), findsOneWidget);
    });

    testWidgets('renders Username field', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 'Username' appears as both a label Text and as the hint in the field.
      expect(find.text('Username'), findsWidgets);
      expect(
        find.widgetWithText(TextFormField, 'Username'),
        findsOneWidget,
      );
    });

    testWidgets('renders Bio field', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Bio'), findsOneWidget);
      expect(
        find.widgetWithText(
            TextFormField, 'Describe yourself or your collection focus'),
        findsOneWidget,
      );
    });

    testWidgets('renders First Name field', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 'First Name' appears as both the section label and the field hint.
      expect(find.text('First Name'), findsWidgets);
      expect(
        find.widgetWithText(TextFormField, 'First Name'),
        findsOneWidget,
      );
    });

    testWidgets('renders Last Name field', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // 'Last Name' appears as both the section label and the field hint.
      expect(find.text('Last Name'), findsWidgets);
      expect(
        find.widgetWithText(TextFormField, 'Last Name'),
        findsOneWidget,
      );
    });

    testWidgets('renders Save Changes button', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.widgetWithText(TextButton, 'Save Changes'), findsOneWidget);
    });

    testWidgets('renders Cancel button', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.widgetWithText(TextButton, 'Cancel'), findsOneWidget);
    });

    // -------------------------------------------------------------------------
    // Text input
    // -------------------------------------------------------------------------
    testWidgets('can enter text in the Bio field', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final bioField = find.widgetWithText(
          TextFormField, 'Describe yourself or your collection focus');
      await tester.enterText(bioField, 'I collect rare sneakers.');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('I collect rare sneakers.'), findsOneWidget);
    });

    testWidgets('can enter text in the First Name field', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final firstNameField =
          find.widgetWithText(TextFormField, 'First Name');
      await tester.enterText(firstNameField, 'Alice');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Alice'), findsOneWidget);
    });

    testWidgets('can enter text in the Last Name field', (tester) async {
      await tester.pumpWidget(_buildTestWidget());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final lastNameField =
          find.widgetWithText(TextFormField, 'Last Name');
      await tester.enterText(lastNameField, 'Smith');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Smith'), findsOneWidget);
    });
  });
}

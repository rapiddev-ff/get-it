# Flutter Clean Architecture Migration

You are a senior Flutter architect performing a production migration.

This project is a FlutterFlow-exported Flutter marketplace app ("Get It") backed by Supabase.
You have already analyzed the project structure. The stats:
- 379 Dart files, ~5100 FlutterFlow references outside flutter_flow/
- 92 page widgets, 93 page models, 65 custom code files
- Features: auth, home/feed, browse, messages, wishlist, notifications, profile, seller dashboard, checkout, stripe, videos

---

## WHAT TO PRESERVE — READ THIS FIRST

**DO NOT touch or delete these directories. They contain manually written production code:**

- `lib/custom_code/actions/` — 50+ custom Dart actions (Stripe, Supabase auth, realtime, checkout, etc.)
- `lib/custom_code/widgets/` — 5 production widgets (SwipeableProductStack, InfiniteProductGrid, BrowseProductsGrid, SellerProductsGrid, InfiniteMessageList)
- `lib/custom_code/realtime_service.dart` — RealtimeService singleton
- `lib/backend/supabase/database/tables/` — typed Supabase datasources (30+ table classes), migrate them, don't rewrite
- `lib/backend/api_requests/` — external API calls (Stripe, etc.), migrate them, don't rewrite
- `assets/` — all assets stay as-is

---

## GOAL

Remove all FlutterFlow scaffolding. The result must look like a project written by a professional Flutter team from scratch:

- Zero FlutterFlow imports
- Zero `flutter_flow/` folder
- Zero `FFAppState`, `FlutterFlowTheme`, `FFButtonWidget`, `FFLocalizations`, `FlutterFlowModel`, `FFDevEnvironmentValues`
- Clean architecture folder structure
- Riverpod state management throughout
- `Theme.of(context)` + `AppColors` instead of `FlutterFlowTheme.of(context)`
- Proper env config instead of `FFDevEnvironmentValues`

---

## STEP 0 — ADD DEPENDENCIES FIRST (do this before touching any other file)

Add to `pubspec.yaml` under `dependencies`:
```yaml
flutter_riverpod: ^2.6.1
riverpod_annotation: ^2.4.1
freezed_annotation: ^2.4.4
flutter_dotenv: ^5.1.0
```

Add to `dev_dependencies`:
```yaml
build_runner: ^2.4.13
freezed: ^2.5.7
riverpod_generator: ^2.4.4
```

Remove from `pubspec.yaml`:
- `provider: 6.1.5` (replaced by Riverpod)

Run: `flutter pub get`

---

## STEP 1 — CREATE CORE INFRASTRUCTURE

Create the following files before migrating any feature. Every subsequent step depends on these.

### 1a. `lib/core/theme/app_colors.dart`

Extract ALL color values from `lib/flutter_flow/flutter_flow_theme.dart` → `LightModeTheme`.
The app has a dark theme (primaryBackground = 0xFF000000). Preserve every named color exactly.

Structure:
```dart
abstract class AppColors {
  // Brand
  static const Color primary = Color(0xFF8E6CFF);
  static const Color secondary = Color(0xFF8E6CFF);
  static const Color tertiary = Color(0xFFEE8B60);

  // Backgrounds
  static const Color backgroundPrimary = Color(0xFF000000);
  static const Color backgroundSecondary = Color(0xFF252525);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAFAFB4);
  static const Color textInactive = Color(0xFF536676);
  static const Color textPlaceholder = Color(0xFFB1BFC8);
  static const Color textDisabled = Color(0xFF879CA9);

  // Borders
  static const Color borderInactive = Color(0xFF879CA9);
  static const Color borderActive = Color(0xFF343D46);
  static const Color borderDisabled = Color(0xFFB1BFC8);

  // Icons
  static const Color iconPrimary = Color(0xFF23292E);
  static const Color iconSecondary = Color(0xFF3B4751);
  static const Color iconInactive = Color(0xFF536676);
  static const Color iconDisabled = Color(0xFF879CA9);
  static const Color iconAccent = Color(0xFF007EFF);
  static const Color iconInvert = Color(0xFFFFFFFF);

  // Semantic
  static const Color success = Color(0xFF249689);
  static const Color warning = Color(0xFFF9CF58);
  static const Color error = Color(0xFFF87171);
  static const Color info = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Neutral scale
  static const Color neutral50 = Color(0xFFF6F8F9);
  static const Color neutral100 = Color(0xFFF1F3F5);
  static const Color neutral200 = Color(0xFFD6DCE1);
  static const Color neutral300 = Color(0xFFB1BFC8);
  static const Color neutral400 = Color(0xFF879CA9);
  static const Color neutral500 = Color(0xFF687F8F);
  static const Color neutral600 = Color(0xFF536676);
  static const Color neutral700 = Color(0xFF7B7B7B);
  static const Color neutral800 = Color(0xFF676767);
  static const Color neutral900 = Color(0xFF343D46);
  static const Color neutral950 = Color(0xFF23292E);

  // Destructive scale
  static const Color destructive50 = Color(0xFFFEF2F2);
  static const Color destructive100 = Color(0xFFFEE2E2);
  static const Color destructive200 = Color(0xFFFECACA);
  static const Color destructive300 = Color(0xFFFCA5A5);
  static const Color destructive400 = Color(0xFFF87171);
  static const Color destructive500 = Color(0xFFEF4444);
  static const Color destructive600 = Color(0xFFDC2626);
  static const Color destructive700 = Color(0xFFB91C1C);
  static const Color destructive800 = Color(0xFF991B1B);
  static const Color destructive900 = Color(0xFF7F1D1D);
  static const Color destructive950 = Color(0xFF450A0A);

  // Primary scale
  static const Color primary400 = Color(0xFF99CBFF);
  static const Color primary600 = Color(0xFF66B2FF);
  static const Color primary700 = Color(0xFF4DA5FF);
  static const Color primary800 = Color(0xFF007EFF);

  // Accent overlays
  static const Color accent1 = Color(0x4C4B39EF);
  static const Color accent2 = Color(0x4D39D2C0);
  static const Color accent3 = Color(0x4DEE8B60);
  static const Color accent4 = Color(0xCCFFFFFF);

  // Alternate
  static const Color alternate = Color(0xFFE0E3E7);
}
```

### 1b. `lib/core/theme/app_theme.dart`

All fonts are Inter (Google Fonts). The app is dark-only (no light mode in FlutterFlow config).

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.backgroundSecondary,
      error: AppColors.error,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.textPrimary,
      onError: AppColors.white,
    ),
    scaffoldBackgroundColor: AppColors.backgroundPrimary,
    textTheme: _buildTextTheme(),
    // add AppBarTheme, ElevatedButtonTheme, InputDecorationTheme etc.
  );

  static TextTheme _buildTextTheme() => TextTheme(
    displayLarge: GoogleFonts.inter(fontSize: 64, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    displayMedium: GoogleFonts.inter(fontSize: 44, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    displaySmall: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    headlineLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    headlineMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    headlineSmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    titleLarge: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    titleMedium: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    titleSmall: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    labelLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textSecondary),
    labelMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textSecondary),
    labelSmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.textSecondary),
    bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.normal, color: AppColors.textPrimary),
    bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal, color: AppColors.textPrimary),
    bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.normal, color: AppColors.textPrimary),
  );
}
```

### 1c. `lib/core/constants/app_constants.dart`

Move content from `lib/app_constants.dart` here. Replace `FFAppConstants` with `AppConstants`.

### 1d. `lib/core/config/app_config.dart`

Replace `FFDevEnvironmentValues` and `assets/environment_values/environment.json`:

```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static String get stripePublishable => dotenv.env['STRIPE_PUBLISHABLE'] ?? '';
  static String get stripeSecret => dotenv.env['STRIPE_SECRET'] ?? '';
  static String get twillioSid => dotenv.env['TWILLIO_SID'] ?? '';
  static String get twillioAuth => dotenv.env['TWILLIO_AUTH'] ?? '';
  static String get twillioBase64 => dotenv.env['TWILLIO_BASE64'] ?? '';
  static String get serviceSid => dotenv.env['SERVICE_SID'] ?? '';
  static String get google => dotenv.env['GOOGLE'] ?? '';
}
```

Create `.env` at project root with the values from `assets/environment_values/environment.json`.
Add `.env` to `.gitignore`.
Load it in `main()`: `await dotenv.load(fileName: '.env');`

### 1e. `lib/core/utils/` — extract utilities before deleting `flutter_flow_util.dart`

From `lib/flutter_flow/flutter_flow_util.dart`, extract to:
- `lib/core/utils/date_utils.dart` → `dateTimeFormat()`, timeago setup
- `lib/core/utils/value_utils.dart` → `valueOrDefault<T>()`
- `lib/core/utils/url_utils.dart` → `launchURL()`
- `lib/core/extensions/secure_storage_extensions.dart` → `FlutterSecureStorageExtensions`

### 1f. `lib/core/extensions/context_extensions.dart`

```dart
extension AppThemeContext on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
```

---

## STEP 2 — MIGRATE STATE MANAGEMENT

Use **Riverpod exclusively**. Do not mix with Provider or BLoC.

Wrap `main()` with `ProviderScope`. Remove `ChangeNotifierProvider<FFAppState>`.

Migrate each piece of `FFAppState` to its owning feature's provider:

| FFAppState field | Riverpod provider location |
|---|---|
| `userData` | `features/auth/presentation/providers/auth_provider.dart` |
| `feedProducts`, `feedHasMore`, `swipedProductIds`, `currentCardIndex` | `features/home/presentation/providers/feed_provider.dart` |
| `wishlistProducts` | `features/wishlist/presentation/providers/wishlist_provider.dart` |
| `conversations`, `currentChatMessages`, `currentConversation`, `totalUnreadCount` | `features/messages/presentation/providers/messages_provider.dart` |
| `categories`, `conditions`, `choosenTags` | `features/browse/presentation/providers/browse_provider.dart` |
| `choosenPaymentMethod` | `features/checkout/presentation/providers/checkout_provider.dart` |
| `keepSignedIn`, `isHomeViewed`, `isPasswordRecovery` | `features/auth/presentation/providers/auth_settings_provider.dart` |
| `activeTabIndex` | `lib/core/providers/navigation_provider.dart` |

For persisted fields (`keepSignedIn`, `isHomeViewed`, `categories`, `conditions`, `isPasswordRecovery`):
Use `AsyncNotifier` with `flutter_secure_storage`. Keep the same storage keys (`ff_keepSignedIn` etc.) so existing users don't lose data.

---

## STEP 3 — UPDATE MAIN.DART

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await dotenv.load(fileName: '.env');
  await SupaFlow.initialize();          // keep as-is, just update to use AppConfig
  await actions.lockOrientation();
  await actions.setStatusbarColor();
  await actions.checkReminderMeAuth();

  runApp(const ProviderScope(child: MyApp()));
}
```

Remove all `FFDevEnvironmentValues`, `FFAppState`, `ChangeNotifierProvider` references.
Update `MyApp` to use `ConsumerStatefulWidget`. Keep GoRouter setup — it already works.

---

## STEP 4 — RESTRUCTURE FOLDERS

Target structure:

```
lib/
├── core/
│    ├── config/        (app_config.dart)
│    ├── constants/     (app_constants.dart)
│    ├── extensions/    (context_extensions.dart, secure_storage_extensions.dart)
│    ├── providers/     (navigation_provider.dart)
│    ├── router/        (move nav/nav.dart here, rename to app_router.dart)
│    ├── theme/         (app_colors.dart, app_theme.dart)
│    └── utils/         (date_utils.dart, value_utils.dart, url_utils.dart)
│
├── features/
│    ├── auth/
│    │    ├── data/datasources/         (supabase_auth_datasource.dart)
│    │    ├── domain/models/            (user_model.dart — from UserDataStruct)
│    │    └── presentation/
│    │         ├── pages/               (move auth/* widgets here)
│    │         ├── providers/
│    │         └── widgets/
│    │
│    ├── home/          (home_page, home_product, seller_dashboard, checkout)
│    ├── browse/        (browse, categories, subcategories)
│    ├── messages/      (messages, chat_page, chat_buyer_profile)
│    ├── wishlist/      (wishlist)
│    ├── notifications/ (notification, notification_settings)
│    ├── profile/       (all settings_* screens)
│    ├── videos/        (videos)
│    └── stripe/        (stripe_success, stripe_refresh, stripe_create_checkout)
│
├── backend/
│    ├── supabase/      (KEEP AS-IS, migrate table classes to feature datasources gradually)
│    └── api_requests/  (KEEP AS-IS, migrate to feature datasources gradually)
│
├── custom_code/        (KEEP AS-IS — do not restructure yet, import from new locations)
│
└── main.dart
```

### FILE MOVE PROTOCOL — follow this for every single file, no exceptions

Moving a file is a 5-step atomic operation. Do NOT proceed to the next file until all 5 steps pass.

```
Step A. Use git mv to move the file (preserves git history):
        git mv lib/old/path/file.dart lib/new/path/file.dart

Step B. Find every file that imports the old path:
        grep -rn "old/path/file" lib/ --include="*.dart"
        Update each found import to the new path.

Step C. Update lib/index.dart if it exports the old path.

Step D. Update lib/flutter_flow/nav/nav.dart if it references the old path.

Step E. Verify zero errors:
        flutter analyze 2>&1 | grep "error:"
        If errors exist — fix them NOW. Do not move to the next file.
```

**Never create a copy and leave the original in place.**
**Never move a file without updating all its importers.**

---

## STEP 5 — MIGRATE FEATURES (one at a time, in this order)

For each feature, apply this checklist to every file before moving to the next file:

1. Move the file using `git mv` (Step A–E from FILE MOVE PROTOCOL above)
2. Replace `FlutterFlowTheme.of(context).X` → `AppColors.X` or `Theme.of(context).textTheme.X`
3. Replace `FFAppState().X` or `context.watch<FFAppState>().X` → `ref.watch(provider).X`
4. Replace FlutterFlow widgets:
   - `FFButtonWidget` → `ElevatedButton` or `FilledButton`
   - `FlutterFlowIconButton` → `IconButton`
   - `FlutterFlowDropDown` → `DropdownButton` or `DropdownMenu`
   - `FFButtonWidget` with `options.type == ButtonType.outlined` → `OutlinedButton`
5. Replace `FlutterFlowModel` + `createModel()` boilerplate with a Riverpod `Notifier`
6. Remove all remaining `import '/flutter_flow/...'` lines from the file
7. Run `flutter analyze 2>&1 | grep "error:"` — zero errors before touching the next file

After completing ALL files in a feature:
- Verify the original directory is gone (deleted by git mv): `ls lib/<feature>/`
- Verify zero flutter_flow imports remain in the feature: `grep -rn "flutter_flow" lib/features/<feature>/ --include="*.dart"`
- Verify lib/index.dart has no remaining references to the old path

**Migration order:**
1. `auth` (sign_in, sign_up, forgot_password, phone_verification, permissions, additional_info)
2. `core/check_data`
3. `home` (home_page only first)
4. `browse`
5. `messages`
6. `wishlist`
7. `notifications`
8. `profile` (all settings_* screens)
9. `home/seller_dashboard`
10. `home/checkout`
11. `stripe`
12. `videos`

---

## STEP 6 — MIGRATE MODELS

Convert `lib/backend/schema/structs/` to Freezed models in `features/*/domain/models/`.
Use `git mv` for each struct file. After moving, delete the original from `lib/backend/schema/structs/`.

For each struct:

Before:
```dart
class UserDataStruct extends BaseStruct {
  UserDataStruct({this.id, this.username, ...});
  final String? id;
  ...
}
```

After:
```dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    String? id,
    String? username,
    ...
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
```

Run `dart run build_runner build --delete-conflicting-outputs` after each batch.

Assign each struct to its feature:
- `UserDataStruct`, `UserSettingsStruct` → `features/auth/domain/models/`
- `FeedProductStruct`, `ProductDetailsStruct`, `ProductImageStruct`, `SellerProductStruct`, `ReviewStruct`, etc. → `features/home/domain/models/`
- `CategoryStruct`, `SubcategoryStruct`, `ConditionStruct`, `TagStruct`, `BrowseProductStruct` → `features/browse/domain/models/`
- `ConversationStruct`, `MessageStruct`, `MessageImageStruct` → `features/messages/domain/models/`
- `PaymentMethodStruct`, `PaymentCardStruct`, `BillingDetailsStruct`, `ShippingAddressStruct`, `CheckoutOrderResultStruct`, `CheckoutTotalsStruct`, `StripePaymentResultStruct`, `StripeAccountStatusStruct` → `features/checkout/domain/models/`
- `SellerStruct`, `SellerShortlistStruct`, `ShortlistCoverImageStruct`, `CounterOfferStruct`, `ReviewProductStruct`, `ReviewImageStruct`, `ReviewerStruct` → `features/home/domain/models/`
- `NotificationPreferencesStruct` → `features/notifications/domain/models/`

---

## STEP 7 — DELETE FLUTTERFLOW FOLDER

Only do this after ALL features compile cleanly without importing from `flutter_flow/`.

Delete:
- `lib/flutter_flow/` (entire directory)
- `lib/app_state.dart`
- `lib/environment_values.dart`
- `lib/index.dart` (replace with proper feature barrel exports if needed)
- `lib/backend/schema/` (after all structs migrated to Freezed models)

Run final check:
```
flutter analyze --no-fatal-infos
flutter build apk --debug
```

Zero errors required before proceeding.

---

## STEP 8 — DEPENDENCIES CLEANUP

Remove from `pubspec.yaml` after confirming nothing uses them:
- `provider` (replaced by Riverpod)
- `aligned_dialog` (replace usages with `showDialog`)
- Any other packages only used by FlutterFlow utilities

Keep:
- `supabase_flutter`, `supabase`, `realtime_client`, `postgrest`, `gotrue`, `storage_client`
- `go_router`
- `flutter_stripe`
- `google_fonts`
- `flutter_secure_storage`
- `image_picker`, `cached_network_image`
- `flutter_animate`
- `hive` (if used for local caching)
- All others that custom_code or features actively import

---

## STEP 9 — CODE QUALITY PASS

After migration is complete:

- Add `const` constructors everywhere possible
- Extract magic numbers to `AppConstants`
- Replace `print()` with proper logging or remove
- Ensure `async` gaps have mounted checks (`if (!mounted) return;`)
- Remove `lib/test/test_widget.dart` and `lib/test/test_model.dart` (FlutterFlow test scaffolding)
- Run `dart format lib/`
- Run `flutter analyze` — target zero warnings

---

## EXECUTION RULES

- Work **feature by feature**, **file by file**. Never leave a feature half-migrated.
- **Move = git mv + update importers + delete original.** Never copy-and-leave.
- After every file change, verify: `flutter analyze 2>&1 | grep "error:"` — zero errors before next file.
- Fix all errors immediately. Never skip to the next file while errors exist.
- When you find a pattern repeated across many files (e.g. `FlutterFlowTheme.of(context).primaryText`), define the replacement once then apply it consistently everywhere in that feature.
- Make architectural decisions without asking — use the structure defined in this prompt.
- Untouched features may keep FlutterFlow patterns temporarily — the app must always compile.
- Do NOT rewrite `custom_code/` files. Move them only if needed, update imports.
- After every feature is done, confirm:
  1. `ls lib/<old_feature>/` → directory must not exist
  2. `grep -rn "flutter_flow" lib/features/<feature>/ --include="*.dart"` → zero results
  3. `flutter analyze 2>&1 | grep "error:"` → zero results

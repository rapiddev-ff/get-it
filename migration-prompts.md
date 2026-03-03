# Migration Prompts

FlutterFlow → Clean Architecture. Run each prompt in a **new Claude Code session**.
Do not proceed to the next until `flutter analyze` shows 0 errors.

```bash
git checkout -b clean-arch-migration
```

---

## Промпт 0 — Зависимости

```
Read prompt.MD Step 0.

Add to pubspec.yaml dependencies:
  flutter_riverpod: ^2.6.1
  riverpod_annotation: ^2.4.1
  freezed_annotation: ^2.4.4
  flutter_dotenv: ^5.1.0

Add to dev_dependencies:
  build_runner: ^2.4.13
  freezed: ^2.5.7
  riverpod_generator: ^2.4.4

Remove: provider: 6.1.5

Run: flutter pub get
Verify: flutter analyze 2>&1 | grep "error:" — must be zero.
Do not touch any other files.
```

```bash
git add pubspec.yaml pubspec.lock && git commit -m "migration: step 0 - add riverpod/freezed/dotenv deps"
```

---

## Промпт 1 — Core infrastructure

```
Read prompt.MD Step 1 fully. Create ALL of these files:

1. lib/core/theme/app_colors.dart — extract every color from LightModeTheme in
   lib/flutter_flow/flutter_flow_theme.dart. Use exact hex values. All static const.

2. lib/core/theme/app_theme.dart — ThemeData with ColorScheme.dark, all Inter fonts,
   exact sizes from ThemeTypography in flutter_flow_theme.dart.

3. lib/core/constants/app_constants.dart — copy content from lib/app_constants.dart,
   rename FFAppConstants → AppConstants.

4. lib/core/config/app_config.dart — flutter_dotenv wrapper replacing FFDevEnvironmentValues.
   Read lib/environment_values.dart to get all field names.
   Create .env at project root with values from assets/environment_values/environment.json.
   Add .env to .gitignore.

5. lib/core/utils/date_utils.dart — extract dateTimeFormat() + timeago setup from
   lib/flutter_flow/flutter_flow_util.dart.

6. lib/core/utils/value_utils.dart — extract valueOrDefault<T>() from flutter_flow_util.dart.

7. lib/core/utils/url_utils.dart — extract launchURL() from flutter_flow_util.dart.

8. lib/core/extensions/secure_storage_extensions.dart — extract FlutterSecureStorageExtensions
   from lib/app_state.dart.

9. lib/core/extensions/context_extensions.dart — AppThemeContext extension with
   textTheme and colorScheme getters.

Do NOT delete any old files. Do NOT modify any existing files.
Only create new files in lib/core/.

Verify: flutter analyze lib/core/ 2>&1 | grep "error:" — must be zero.
```

```bash
git add lib/core/ .env .gitignore && git commit -m "migration: step 1 - core infrastructure"
```

---

## Промпт 2 — Riverpod providers

```
Read prompt.MD Step 2. Read lib/app_state.dart fully.

Create Riverpod providers, one file per feature. Do NOT modify app_state.dart.

Create these files:
1. lib/features/auth/presentation/providers/auth_provider.dart
   — manages userData (UserDataStruct)

2. lib/features/auth/presentation/providers/auth_settings_provider.dart
   — manages keepSignedIn, isHomeViewed, isPasswordRecovery (persisted via flutter_secure_storage)

3. lib/features/home/presentation/providers/feed_provider.dart
   — manages feedProducts, feedHasMore, swipedProductIds, currentCardIndex

4. lib/features/wishlist/presentation/providers/wishlist_provider.dart
   — manages wishlistProducts

5. lib/features/messages/presentation/providers/messages_provider.dart
   — manages conversations, currentChatMessages, currentConversation, totalUnreadCount

6. lib/features/browse/presentation/providers/browse_provider.dart
   — manages categories, conditions, choosenTags

7. lib/features/checkout/presentation/providers/checkout_provider.dart
   — manages choosenPaymentMethod

8. lib/core/providers/navigation_provider.dart
   — manages activeTabIndex

For persisted fields, use AsyncNotifier + flutter_secure_storage.
Keep same storage keys (ff_keepSignedIn etc.) so existing users don't lose data.
Import structs from /backend/schema/structs/index.dart for now.

Do NOT modify any existing files. Only create new provider files.
Verify: flutter analyze lib/features/ lib/core/providers/ 2>&1 | grep "error:"
```

```bash
git add lib/features/ lib/core/providers/ && git commit -m "migration: step 2 - riverpod providers"
```

---

## Промпт 3 — main.dart + router

```
Read prompt.MD Step 3. Read lib/main.dart and lib/flutter_flow/nav/nav.dart fully.

1. Copy lib/flutter_flow/nav/nav.dart → lib/core/router/app_router.dart using git mv.
   Also copy lib/flutter_flow/nav/serialization_util.dart → lib/core/router/serialization_util.dart.
   Update internal imports in the copied files.
   Update any file that imports the old nav path to use the new path.

2. Rewrite lib/main.dart:
   - Replace ChangeNotifierProvider<FFAppState> → ProviderScope
   - Replace FFDevEnvironmentValues → dotenv.load() + AppConfig
   - Import AppTheme from lib/core/theme/app_theme.dart
   - Use AppTheme.dark in MaterialApp.router theme
   - Remove FlutterFlowTheme import (keep using it in nav for now — other files still need it)
   - Keep all custom actions calls (lockOrientation, setStatusbarColor, checkReminderMeAuth)
   - Keep GoRouter setup — import from new lib/core/router/app_router.dart
   - Update MyApp to ConsumerStatefulWidget

3. Update lib/backend/supabase/supabase.dart to use AppConfig instead of FFDevEnvironmentValues.

Verify:
flutter analyze 2>&1 | grep "error:" — fix ALL errors before stopping.
flutter run --no-hot-reload (verify app starts without crash, then stop it)
```

```bash
git add -A && git commit -m "migration: step 3 - main.dart + router"
```

---

## Промпт 5a — Feature: auth

```
Read prompt.MD (FILE MOVE PROTOCOL + Step 5).

Migrate the auth feature. For EVERY file use the FILE MOVE PROTOCOL from prompt.MD:
  A. git mv old/path new/path
  B. grep -rn "old/path" lib/ — update ALL importers
  C. Update lib/index.dart exports
  D. Update lib/core/router/app_router.dart if it references the file
  E. flutter analyze 2>&1 | grep "error:" — zero before next file

Files to move:
- lib/auth/sign_in/ → lib/features/auth/presentation/pages/sign_in/
- lib/auth/sign_up/ → lib/features/auth/presentation/pages/sign_up/
- lib/auth/welcome/ → lib/features/auth/presentation/pages/welcome/
- lib/auth/forgot_password/ → lib/features/auth/presentation/pages/forgot_password/
- lib/auth/forgot_password_step2/ → lib/features/auth/presentation/pages/forgot_password_step2/
- lib/auth/forgot_password_step3/ → lib/features/auth/presentation/pages/forgot_password_step3/
- lib/auth/phone_verification_page/ → lib/features/auth/presentation/pages/phone_verification_page/
- lib/auth/phone_verification_page2/ → lib/features/auth/presentation/pages/phone_verification_page2/
- lib/auth/permissions/ → lib/features/auth/presentation/pages/permissions/
- lib/auth/additional_info/ → lib/features/auth/presentation/pages/additional_info/
- lib/auth/password_component/ → lib/features/auth/presentation/widgets/password_component/
- lib/auth/supabase_auth/ → lib/features/auth/data/supabase_auth/
- lib/auth/auth_manager.dart → lib/features/auth/data/auth_manager.dart
- lib/auth/base_auth_user_provider.dart → lib/features/auth/data/base_auth_user_provider.dart

After moving each file, apply replacements:
1. FlutterFlowTheme.of(context).X → AppColors.X or Theme.of(context).textTheme.X
2. FFAppState() → ref.watch(authProvider) / ref.watch(authSettingsProvider)
3. FFButtonWidget → ElevatedButton/FilledButton
4. FlutterFlowIconButton → IconButton
5. FlutterFlowModel + createModel() → remove boilerplate, use Riverpod Notifier
6. Remove all import '/flutter_flow/...' lines (except nav — already moved)

After ALL files:
ls lib/auth/              → must not exist
grep -rn "flutter_flow" lib/features/auth/ --include="*.dart" → zero results
flutter analyze 2>&1 | grep "error:" → zero results
```

```bash
git add -A && git commit -m "migration: step 5a - auth feature"
```

---

## Промпт 5b — Feature: browse

```
Read prompt.MD (FILE MOVE PROTOCOL + Step 5).

Migrate the browse feature using git mv for each file.

Files to move:
- lib/browse/browse/ → lib/features/browse/presentation/pages/browse/
- lib/browse/browse_products_item/ → lib/features/browse/presentation/widgets/browse_products_item/

After moving, apply replacements in each file:
1. FlutterFlowTheme → AppColors / Theme.of(context).textTheme
2. FFAppState().categories / conditions / choosenTags → ref.watch(browseProvider)
3. FFButtonWidget → ElevatedButton, FlutterFlowIconButton → IconButton,
   FlutterFlowDropDown → DropdownButton
4. FlutterFlowModel → Riverpod Notifier
5. Remove all flutter_flow/ imports
6. Update lib/index.dart exports
7. Update lib/core/router/app_router.dart if needed

After all files:
ls lib/browse/           → must not exist
grep -rn "flutter_flow" lib/features/browse/ --include="*.dart" → zero results
flutter analyze 2>&1 | grep "error:" → zero results
```

```bash
git add -A && git commit -m "migration: step 5b - browse feature"
```

---

## Промпт 5c — Feature: messages

```
Read prompt.MD (FILE MOVE PROTOCOL + Step 5).

Migrate the messages feature using git mv for each file.

Files to move:
- lib/messages/messages/ → lib/features/messages/presentation/pages/messages/
- lib/messages/chat_page/ → lib/features/messages/presentation/pages/chat_page/
- lib/messages/chat_buyer_profile/ → lib/features/messages/presentation/pages/chat_buyer_profile/
- lib/messages/chat_item/ → lib/features/messages/presentation/widgets/chat_item/
- lib/messages/chat_more/ → lib/features/messages/presentation/widgets/chat_more/
- lib/messages/message_item/ → lib/features/messages/presentation/widgets/message_item/

After moving, apply replacements:
1. FlutterFlowTheme → AppColors / Theme.of(context).textTheme
2. FFAppState().conversations / currentChatMessages / currentConversation /
   totalUnreadCount → ref.watch(messagesProvider)
3. FlutterFlow widgets → standard Flutter widgets
4. FlutterFlowModel → Riverpod Notifier
5. Remove all flutter_flow/ imports
6. RealtimeService → import from lib/custom_code/realtime_service.dart as-is
7. Custom actions (subscribe_to_conversations, load_messages, send_message etc.)
   → import from lib/custom_code/actions/ as-is
8. Update lib/index.dart + lib/core/router/app_router.dart

After all files:
ls lib/messages/         → must not exist
flutter analyze 2>&1 | grep "error:" → zero results
```

```bash
git add -A && git commit -m "migration: step 5c - messages feature"
```

---

## Промпт 5d — Feature: wishlist

```
Read prompt.MD (FILE MOVE PROTOCOL + Step 5).

Migrate using git mv:
- lib/wishlist/wishlist/ → lib/features/wishlist/presentation/pages/wishlist/

Apply replacements:
1. FlutterFlowTheme → AppColors / Theme.of(context).textTheme
2. FFAppState().wishlistProducts → ref.watch(wishlistProvider)
3. FlutterFlow widgets → standard Flutter widgets
4. FlutterFlowModel → Riverpod Notifier
5. Remove flutter_flow/ imports
6. toggle_wishlist → import from lib/custom_code/actions/ as-is
7. Update lib/index.dart + router

After: ls lib/wishlist/ → must not exist
flutter analyze 2>&1 | grep "error:" → zero results
```

```bash
git add -A && git commit -m "migration: step 5d - wishlist feature"
```

---

## Промпт 5e — Feature: notifications

```
Read prompt.MD (FILE MOVE PROTOCOL + Step 5).

Migrate using git mv:
- lib/notifications/notification/ → lib/features/notifications/presentation/pages/notification/
- lib/notifications/notification_settings/ → lib/features/notifications/presentation/pages/notification_settings/

Apply all standard replacements. Update lib/index.dart + router.

After: ls lib/notifications/ → must not exist
flutter analyze 2>&1 | grep "error:" → zero results
```

```bash
git add -A && git commit -m "migration: step 5e - notifications feature"
```

---

## Промпт 5f — Feature: profile

```
Read prompt.MD (FILE MOVE PROTOCOL + Step 5).

Migrate the profile feature (52 files, 26 folders). Work folder by folder.

Move each folder from lib/profile/<name>/ → lib/features/profile/presentation/pages/<name>/
using git mv. Full list:
settings, settings_block_list, settings_blocked_user_item, settings_business,
settings_business_address, settings_change_email, settings_change_password,
settings_change_phone, settings_daily_budget, settings_deactivate_account,
settings_delete_account, settings_dialog, settings_edit_profile, settings_item,
settings_my_profile, settings_my_profile_followers, settings_payment_card_item,
settings_payment_method, settings_payment_method_add, settings_payment_method_edit,
settings_privacy, settings_referral, settings_report, settings_shipping_defaults,
settings_terms, review_item

After moving each folder, apply replacements:
1. FlutterFlowTheme → AppColors / Theme.of(context).textTheme
2. FFAppState().userData / choosenPaymentMethod → ref.watch(authProvider) / ref.watch(checkoutProvider)
3. FlutterFlow widgets → ElevatedButton, OutlinedButton, IconButton, DropdownButton
4. FlutterFlowModel → Riverpod Notifier
5. Remove flutter_flow/ imports
6. Payment actions → import from lib/custom_code/actions/ as-is
7. Run flutter analyze 2>&1 | grep "error:" every 3 folders — fix before continuing
8. Update lib/index.dart exports as you go

After ALL folders:
ls lib/profile/          → must not exist
grep -rn "flutter_flow" lib/features/profile/ --include="*.dart" → zero results
flutter analyze 2>&1 | grep "error:" → zero results
```

```bash
git add -A && git commit -m "migration: step 5f - profile feature"
```

---

## Промпт 5g — Feature: videos

```
Read prompt.MD (FILE MOVE PROTOCOL + Step 5).

Migrate using git mv:
- lib/videos/videos/ → lib/features/videos/presentation/pages/videos/

Apply all standard replacements. Update lib/index.dart + router.

After: ls lib/videos/ → must not exist
flutter analyze 2>&1 | grep "error:" → zero results
```

```bash
git add -A && git commit -m "migration: step 5g - videos feature"
```

---

## Промпт 5h — Feature: home (основные экраны)

```
Read prompt.MD (FILE MOVE PROTOCOL + Step 5).

Migrate main home screens (not seller_dashboard, not checkout). Use git mv.

NOTE: lib/features/home/presentation/pages/home_page/ already has orphaned copies.
Delete them first: rm -rf lib/features/home/presentation/pages/home_page/
Then do proper git mv.

Also delete orphaned files:
rm -rf lib/core/empty_state/ lib/core/nav_bar/ lib/core/dialog/ lib/core/check_data/

Files to move:
- lib/home/home_page/ → lib/features/home/presentation/pages/home_page/
- lib/home/home_product/ → lib/features/home/presentation/pages/home_product/
- lib/home/home_seller_profile/ → lib/features/home/presentation/pages/home_seller_profile/
- lib/home/home_seller_profile_more/ → lib/features/home/presentation/pages/home_seller_profile_more/
- lib/home/home_seller_profile_reviews/ → lib/features/home/presentation/pages/home_seller_profile_reviews/
- lib/home/home_seller_profile_reviews_step1/ → lib/features/home/presentation/pages/home_seller_profile_reviews_step1/
- lib/home/home_seller_profile_reviews_step2/ → lib/features/home/presentation/pages/home_seller_profile_reviews_step2/
- lib/home/home_seller_product/ → lib/features/home/presentation/pages/home_seller_product/
- lib/core/check_data/ → lib/features/home/presentation/pages/check_data/
- lib/core/nav_bar/ → lib/features/home/presentation/widgets/nav_bar/
- lib/core/empty_state/ → lib/features/home/presentation/widgets/empty_state/
- lib/core/dialog/ → lib/features/home/presentation/widgets/dialog/
- lib/components/ → lib/features/home/presentation/widgets/components/

After moving, apply replacements:
1. FlutterFlowTheme → AppColors / Theme.of(context).textTheme
2. FFAppState().feedProducts / swipedProductIds / currentCardIndex / feedHasMore
   → ref.watch(feedProvider)
3. FFAppState().userData → ref.watch(authProvider)
4. SwipeableProductStack, InfiniteProductGrid, BrowseProductsGrid in lib/custom_code/widgets/
   — import as-is, do not move
5. FlutterFlow widgets → standard Flutter widgets
6. FlutterFlowModel → Riverpod Notifier
7. Remove flutter_flow/ imports
8. Update lib/index.dart + router

Run flutter analyze 2>&1 | grep "error:" after every 2 files.
```

```bash
git add -A && git commit -m "migration: step 5h - home main screens"
```

---

## Промпт 5i — Feature: seller_dashboard

```
Read prompt.MD (FILE MOVE PROTOCOL + Step 5).

Migrate seller dashboard using git mv. Files from lib/home/seller_dashboard/:
- home_dashoard_earnings/ → lib/features/home/presentation/pages/seller_dashboard/earnings/
- home_dashoard_shipping/ → .../seller_dashboard/shipping/
- home_dashoard_shipping_detailed/ → .../seller_dashboard/shipping_detailed/
- home_dashoard_inventory/ → .../seller_dashboard/inventory/
- home_dashoard_inventory_add/ → .../seller_dashboard/inventory_add/
- home_dashoard_inventory_add_tags/ → .../seller_dashboard/inventory_add_tags/
- home_dashoard_promote_step1/ → .../seller_dashboard/promote_step1/
- home_dashoard_promote_step2/ → .../seller_dashboard/promote_step2/
- shortlist/home_dashoard_shortlist/ → .../seller_dashboard/shortlist/
- shortlist/home_dashoard_shortlist_create/ → .../seller_dashboard/shortlist_create/
- shortlist/home_dashoard_shortlist_create_step2/ → .../seller_dashboard/shortlist_create_step2/
- shortlist/home_dashoard_shortlist_add/ → .../seller_dashboard/shortlist_add/

Apply all standard replacements. Seller custom actions in lib/custom_code/actions/ — import as-is.
Run flutter analyze 2>&1 | grep "error:" after every 2 files. Update index.dart + router.

After: ls lib/home/seller_dashboard/ → must not exist
flutter analyze 2>&1 | grep "error:" → zero results
```

```bash
git add -A && git commit -m "migration: step 5i - seller dashboard"
```

---

## Промпт 5j — Feature: checkout + stripe

```
Read prompt.MD (FILE MOVE PROTOCOL + Step 5).

Migrate using git mv:
- lib/home/checkout/checkout/ → lib/features/checkout/presentation/pages/checkout/
- lib/home/checkout/checkout_edit_shipping_address/ → lib/features/checkout/presentation/pages/checkout_edit_shipping_address/
- lib/stripe/stripe_success/ → lib/features/stripe/presentation/pages/stripe_success/
- lib/stripe/stripe_refresh/ → lib/features/stripe/presentation/pages/stripe_refresh/
- lib/stripe/stripe_create_chek_out/ → lib/features/stripe/presentation/pages/stripe_create_checkout/
- lib/stripe/stripe_success_copy/ → lib/features/stripe/presentation/pages/stripe_success_copy/

Apply replacements:
1. All standard replacements
2. FFAppState().choosenPaymentMethod → ref.watch(checkoutProvider)
3. Stripe actions in lib/custom_code/actions/ — import as-is
4. Update index.dart + router

After:
ls lib/home/   → must not exist (all sub-features migrated by now)
ls lib/stripe/ → must not exist
flutter analyze 2>&1 | grep "error:" → zero results
```

```bash
git add -A && git commit -m "migration: step 5j - checkout and stripe"
```

---

## Промпт 6 — Freezed модели

```
Read prompt.MD Step 6.

Convert lib/backend/schema/structs/ to Freezed models in feature directories.
Use git mv to move each struct file, then convert to Freezed syntax.

Batch 1 — auth:
- UserDataStruct → lib/features/auth/domain/models/user_model.dart
- UserSettingsStruct → lib/features/auth/domain/models/user_settings_model.dart

Batch 2 — browse:
- CategoryStruct, SubcategoryStruct, ConditionStruct, TagStruct, BrowseProductStruct
  → lib/features/browse/domain/models/

Batch 3 — home/product:
- FeedProductStruct, ProductDetailsStruct, ProductImageStruct, SellerProductStruct,
  ReviewStruct, ReviewImageStruct, ReviewerStruct, ReviewProductStruct,
  SellerStruct, SellerShortlistStruct, ShortlistCoverImageStruct, CounterOfferStruct
  → lib/features/home/domain/models/

Batch 4 — messages:
- ConversationStruct, MessageStruct, MessageImageStruct
  → lib/features/messages/domain/models/

Batch 5 — checkout:
- PaymentMethodStruct, PaymentCardStruct, BillingDetailsStruct, ShippingAddressStruct,
  CheckoutOrderResultStruct, CheckoutTotalsStruct, StripePaymentResultStruct,
  StripeAccountStatusStruct → lib/features/checkout/domain/models/

Batch 6:
- NotificationPreferencesStruct → lib/features/notifications/domain/models/

For each struct:
1. Create @freezed class with factory constructor
2. Add fromJson factory
3. Run: dart run build_runner build --delete-conflicting-outputs
4. Update ALL files that imported the old struct
5. Delete original with git rm
6. flutter analyze 2>&1 | grep "error:" — fix before next batch

After all: ls lib/backend/schema/structs/ → empty or deleted
flutter analyze 2>&1 | grep "error:" → zero results
```

```bash
git add -A && git commit -m "migration: step 6 - freezed models"
```

---

## Промпт 7 — Удаление FlutterFlow

```
Read prompt.MD Step 7.

Pre-flight checks (do NOT delete anything until both pass):
1. grep -rn "flutter_flow" lib/ --include="*.dart" | grep -v "^lib/flutter_flow/" → must be empty
2. grep -n "/auth/\|/profile/\|/browse/\|/messages/\|/wishlist/\|/notifications/\|/home/\|/stripe/\|/videos/" lib/index.dart → must be empty

If checks fail — fix remaining references first.

Only after both pass, delete:
git rm -r lib/flutter_flow/
git rm lib/app_state.dart
git rm lib/environment_values.dart
git rm lib/index.dart (replace with proper barrel exports if needed)
git rm lib/app_constants.dart
git rm -r lib/backend/schema/ (only if step 6 complete)
git rm lib/test/test_widget.dart lib/test/test_model.dart

Verify:
flutter analyze --no-fatal-infos 2>&1 | grep "error:" → zero
flutter build apk --debug 2>&1 | tail -20 → must succeed
```

```bash
git add -A && git commit -m "migration: step 7 - remove FlutterFlow entirely"
```

---

## Промпт 8 — Cleanup зависимостей

```
Read prompt.MD Step 8.

For each candidate, check usage first:
grep -rn "package:provider" lib/ --include="*.dart" | wc -l
grep -rn "aligned_dialog" lib/ --include="*.dart" | wc -l

Remove from pubspec.yaml only if zero usages. Candidates:
provider, aligned_dialog, easy_debounce, expandable, smooth_page_indicator

After each: flutter pub get && flutter analyze 2>&1 | grep "error:"
```

```bash
git add -A && git commit -m "migration: step 8 - cleanup deps"
```

---

## Промпт 9 — Финальный проход

```
Read prompt.MD Step 9.

1. dart format lib/
2. flutter analyze --no-fatal-infos — fix ALL warnings
3. grep -rn "FlutterFlow\|FFApp\|flutter_flow\|FFButton\|FFIcon" lib/ --include="*.dart"
   → must return zero
4. grep -rn "print(" lib/ --include="*.dart" — remove debug prints
5. flutter build apk --debug — must succeed
6. flutter build ios --debug --no-codesign — must succeed

Report remaining issues with file paths and line numbers.
```

```bash
git add -A && git commit -m "migration: complete - clean architecture, zero FlutterFlow"
```

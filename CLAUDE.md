# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Get It** is a Flutter marketplace app (buyer/seller platform) backed by Supabase. Targets Flutter stable channel on iOS, Android, and Web. Migrated from FlutterFlow to clean Flutter + Riverpod architecture (migration complete).

## Commands

```bash
flutter pub get                          # Install dependencies
flutter run                              # Run app (debug)
flutter build apk                        # Build Android
flutter build ios                        # Build iOS
flutter test                             # Run all tests
flutter test test/widget_test.dart       # Run single test
flutter analyze                          # Analyze code
dart format lib/                         # Format code
dart run build_runner build              # Generate freezed/json code
dart run build_runner watch              # Watch mode for code generation
```

## Architecture

### Directory Structure

```
lib/
├── main.dart              # Entry point (ConsumerStatefulWidget + ProviderScope)
├── index.dart             # Central exports for all page widgets
├── core/                  # Shared infrastructure
│   ├── config/            # AppConfig (env vars from .env via flutter_dotenv)
│   ├── constants/         # AppConstants (padding, radius, app name)
│   ├── theme/             # AppColors, AppTheme (dark theme, GoogleFonts.inter)
│   ├── router/            # GoRouter config, AppStateNotifier, serialization
│   ├── utils/             # Extensions, converters, validators, upload helpers
│   ├── l10n/              # AppLocalizations (English only)
│   ├── providers/         # Shared Riverpod providers
│   └── widgets/           # Shared widget wrappers
├── features/              # Feature modules (clean architecture)
│   ├── auth/              # Sign in/up, phone verification, password recovery
│   ├── home/              # Home feed, product details, seller profiles, seller dashboard
│   ├── browse/            # Product browsing with filters
│   ├── wishlist/          # Wishlist management
│   ├── notifications/     # Push notifications
│   ├── profile/           # User profile, settings (10+ settings pages)
│   ├── videos/            # Video content
│   ├── messages/          # Real-time chat
│   ├── checkout/          # Checkout flow
│   └── stripe/            # Stripe Connect, payment pages
├── backend/
│   ├── supabase/          # SupaFlow client, 54 typed table classes, storage
│   ├── schema/            # Enums, serialization utilities
│   └── api_requests/      # HTTP API calls (Stripe, Twilio, Supabase RPC, Google)
└── custom_code/
    ├── actions/           # 60+ business logic actions (exported via index.dart)
    ├── widgets/           # Custom widgets (swipeable stack, infinite grids, message list)
    └── realtime_service.dart  # RealtimeService singleton for chat subscriptions
```

### Feature Module Structure

Each feature follows: `features/<name>/domain/models/`, `features/<name>/data/`, `features/<name>/presentation/pages/`, `features/<name>/presentation/widgets/`, `features/<name>/presentation/providers/`.

### State Management

- **Riverpod** for all feature-level state. Widgets needing providers extend `ConsumerStatefulWidget`.
- **authProvider** (`NotifierProvider<AuthNotifier, UserData>`) — central user state. Access: `ref.watch(authProvider).field`. Update: `ref.read(authProvider.notifier).updateUser((e) => e.copyWith(...))`.
- **AppStateNotifier** (ChangeNotifier) — splash image + auth gating for GoRouter only. Located in `lib/core/router/app_router.dart`.
- **RealtimeService** singleton — manages Supabase realtime subscriptions for conversations/messages.

### Data Models

32 `@freezed` models in `features/*/domain/models/`. Each generates `.freezed.dart` + `.g.dart` via `build_runner`. Models are immutable — always use `copyWith()`. Nested nullable objects need careful handling: `(e.businessAddress ?? const BusinessAddress()).copyWith(city: x)`.

### Navigation

GoRouter in `lib/core/router/app_router.dart`. Routes use `AppRoute` class. Auth-gated via `AppStateNotifier.loggedIn`. Named navigation: `context.goNamed(WidgetName.routeName, queryParameters: {...})`. Route params serialized via `serialize()`/`fromSerializableMap()` compat methods on models.

### Backend (Supabase)

- Client: `SupaFlow.initialize()` in `lib/backend/supabase/supabase.dart`
- Config: `AppConfig` static getters from `.env` file (via `flutter_dotenv`)
- Tables: typed query classes in `lib/backend/supabase/database/tables/`
- API calls: Twilio (SMS verification), Stripe (payments), Google (geocoding), Supabase RPC

### Environment

Secrets in `.env` (gitignored). Keys: `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `STRIPE_SECRET`, `STRIPE_PUBLISHABLE`, `TWILLIO_SID`, `TWILLIO_AUTH`, `TWILLIO_BASE64`, `SERVICE_SID`, `GOOGLE`. Accessed via `AppConfig.fieldName` (static getters).

### Payments

Stripe via `flutter_stripe`. Custom actions handle checkout creation, saved card payments, Stripe Connect onboarding, and refunds. Stripe keys from `AppConfig`.

### Key Custom Widgets

- `SwipeableProductStack` — Tinder-style product swipe feed
- `InfiniteProductGrid` / `BrowseProductsGrid` / `SellerProductsGrid` — paginated product grids
- `InfiniteMessageList` — paginated chat messages

## UI Rules

- **Never use `ScaffoldMessenger` / `SnackBar`** for user feedback. Always use `toastification` (from the `toastification` package) instead.

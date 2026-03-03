# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Get It** is a Flutter marketplace app (buyer/seller platform) built with FlutterFlow and backed by Supabase. It targets Flutter stable channel and supports iOS, Android, and Web.

## Commands

```bash
# Install dependencies
flutter pub get

# Run app (debug)
flutter run

# Build for iOS
flutter build ios

# Build for Android
flutter build apk

# Run tests
flutter test

# Run a single test
flutter test test/widget_test.dart

# Analyze code
flutter analyze

# Format code
dart format lib/
```

## Architecture

### Code Generation (FlutterFlow)
This project is generated/maintained by FlutterFlow. The `lib/flutter_flow/` directory contains FlutterFlow runtime utilities that should **not be modified manually** — they will be overwritten on the next FlutterFlow export. Custom code goes in `lib/custom_code/`.

### Directory Structure
- `lib/flutter_flow/` — FlutterFlow-generated utilities (theme, animations, widgets, navigation, i18n)
- `lib/backend/supabase/` — Supabase client, database table queries, storage
- `lib/backend/schema/structs/` — Data model structs used throughout the app
- `lib/backend/api_requests/` — External HTTP API calls (Stripe, Twilio, etc.)
- `lib/auth/` — Authentication flows (sign in, sign up, forgot password, phone verification, Supabase auth)
- `lib/custom_code/actions/` — Custom Dart actions (business logic beyond FlutterFlow's built-ins)
- `lib/custom_code/widgets/` — Custom Flutter widgets (swipeable stack, infinite grids, etc.)
- `lib/components/` — Shared reusable UI components
- `lib/` (feature folders) — Pages organized by feature: `home/`, `profile/`, `messages/`, `browse/`, `wishlist/`, `notifications/`, `stripe/`, `videos/`

### State Management
- Global app state: `FFAppState` (ChangeNotifier, singleton) in `lib/app_state.dart`
- Persisted state uses `flutter_secure_storage` with CSV serialization for lists
- Page-level state uses FlutterFlow's `FlutterFlowModel` pattern — each page/component has a paired `*_widget.dart` + `*_model.dart`

### Navigation
GoRouter (`go_router`) with route config in `lib/flutter_flow/nav/nav.dart`. `AppStateNotifier` drives auth-gated routing and splash behavior.

### Backend (Supabase)
- Client initialized via `SupaFlow.initialize()` in `lib/backend/supabase/supabase.dart`
- Credentials loaded from `assets/environment_values/environment.json` at runtime via `FFDevEnvironmentValues`
- Database tables have typed query classes in `lib/backend/supabase/database/tables/`
- Realtime subscriptions (conversations, messages) managed by `RealtimeService` singleton in `lib/custom_code/realtime_service.dart`

### Environment Configuration
Secrets live in `assets/environment_values/environment.json` (gitignored). Keys used:
- `supabaseHost`, `supabaseAnonKey`
- `serviceSid`, `twillioAuth`, `twillioSid`, `twillioBase64`
- `stripeSecret`, `stripePublishable`
- `google`

### Payments
Stripe integration via `flutter_stripe`. Custom actions handle checkout creation, saved card payments, Stripe Connect onboarding, and refunds.

### Key Custom Widgets
- `SwipeableProductStack` — Tinder-style product swipe feed
- `InfiniteProductGrid` / `BrowseProductsGrid` / `SellerProductsGrid` — paginated product grids
- `InfiniteMessageList` — paginated chat messages

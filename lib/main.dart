import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import '/core/config/app_config.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/auth/data/supabase_auth/supabase_user_provider.dart';
import '/features/auth/data/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/core/l10n/internationalization.dart';
import '/core/router/app_router.dart';
import '/core/theme/app_theme.dart';
import '/core/utils/error_handler.dart';
import '/core/utils/widget_extensions.dart';
import '/features/auth/presentation/providers/auth_provider.dart';

void main() {
  AppErrorHandler.runGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    AppErrorHandler.initialize();
    GoRouter.optionURLReflectsImperativeAPIs = true;
    usePathUrlStrategy();

    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      debugPrint('[main] dotenv.load failed: $e');
    }

    await actions.lockOrientation();
    await actions.setStatusbarColor();

    try {
      await SupaFlow.initialize()
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      debugPrint('[main] SupaFlow.initialize failed: $e');
    }

    // Stripe init is non-blocking — failures must not prevent app launch.
    try {
      final stripeKey = AppConfig.stripePublishable;
      if (stripeKey.isNotEmpty) {
        Stripe.publishableKey = stripeKey;
        await Stripe.instance.applySettings()
            .timeout(const Duration(seconds: 5));
      }
    } catch (e) {
      debugPrint('[main] Stripe init failed: $e');
    }

    runApp(ProviderScope(
      child: MyApp(),
    ));
  });
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends ConsumerState<MyApp> {
  Locale? _locale;

  ThemeMode _themeMode = ThemeMode.system;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<BaseAuthUser> userStream;
  StreamSubscription<BaseAuthUser>? _userSubscription;
  StreamSubscription<String?>? _jwtSubscription;

  @override
  void initState() {
    super.initState();

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);

    try {
      userStream = getItSupabaseUserStream();
      _userSubscription = userStream.listen((user) {
        // Clear all user-specific state on logout
        if (!user.loggedIn) {
          ref.read(authProvider.notifier).clear();
        }
        _appStateNotifier.update(user);
      });
      _jwtSubscription = jwtTokenStream.listen((_) {});

      // Check keepSignedIn AFTER ProviderScope and user stream are set up,
      // so that signOut events are properly received by authProvider.
      actions.checkReminderMeAuth();
    } catch (e) {
      debugPrint('[MyApp] Failed to set up auth streams: $e');
    }

    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    _jwtSubscription?.cancel();
    super.dispose();
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Get It',
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
      ],
      theme: AppTheme.dark,
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

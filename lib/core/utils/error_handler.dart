import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Global error boundary for the app.
///
/// Catches three categories of errors:
///   1. Flutter framework errors (widget build failures, rendering errors, etc.)
///   2. Platform-level async errors not caught by the Flutter framework.
///   3. Dart zone errors — anything thrown inside [runGuarded] that escapes
///      all other handlers.
///
/// Extension point: replace the `debugPrint` calls with a crash-reporting
/// service (e.g. Sentry, Firebase Crashlytics) once one is integrated.
class AppErrorHandler {
  AppErrorHandler._();

  /// Call once, immediately after [WidgetsFlutterBinding.ensureInitialized].
  static void initialize() {
    // 1. Flutter framework errors (e.g. widget build exceptions).
    FlutterError.onError = (FlutterErrorDetails details) {
      // In debug mode the default presentError prints a rich error to the
      // console; keep that behaviour so developers see full stack traces.
      if (kDebugMode) {
        FlutterError.presentError(details);
      } else {
        // TODO(crash-reporting): forward `details` to Sentry / Crashlytics.
        debugPrint('[AppErrorHandler] Flutter error: ${details.exceptionAsString()}');
        debugPrint('[AppErrorHandler] Stack:\n${details.stack}');
      }
    };

    // 2. Async errors that escape the Flutter framework entirely (e.g. errors
    //    thrown in platform-channel callbacks or isolate spawned outside zones).
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      // TODO(crash-reporting): forward `error` + `stack` to Sentry / Crashlytics.
      debugPrint('[AppErrorHandler] Platform error: $error');
      debugPrint('[AppErrorHandler] Stack:\n$stack');
      // Return true to mark the error as handled so the platform does not
      // treat it as an unhandled exception and terminate the app.
      return true;
    };
  }

  /// Replaces a bare [runApp] call.
  ///
  /// Wraps [runApp] in [runZonedGuarded] so that any Dart error escaping
  /// both Flutter framework handlers and [PlatformDispatcher.onError] is
  /// still caught and logged rather than crashing silently.
  static void runGuarded(Widget app) {
    runZonedGuarded(
      () => runApp(app),
      (Object error, StackTrace stack) {
        // TODO(crash-reporting): forward `error` + `stack` to Sentry / Crashlytics.
        debugPrint('[AppErrorHandler] Unhandled zone error: $error');
        debugPrint('[AppErrorHandler] Stack:\n$stack');
      },
    );
  }
}

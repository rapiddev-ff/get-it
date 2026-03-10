import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/core/router/app_router.dart' show appNavigatorKey;

StreamSubscription<Uri>? _linkSubscription;
bool _isInitialized = false;

Future<void> initPasswordResetDeepLink(BuildContext context) async {
  if (_isInitialized) {
    return;
  }
  _isInitialized = true;

  final appLinks = AppLinks();
  final prefs = await SharedPreferences.getInstance();

  // Cancel old listener if exists
  await _linkSubscription?.cancel();
  _linkSubscription = null;

  // Check initial link after frame callback
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      final initialUri = await appLinks.getInitialLink();
      if (initialUri != null) {
        await _handleDeepLink(initialUri, prefs);
      }
    } catch (e) {
      debugPrint("Error in init_password_reset_deep_link: $e");
    }
  });

  // Listen for new deep links — use appNavigatorKey to avoid stale context
  _linkSubscription = appLinks.uriLinkStream.listen((Uri uri) async {
    final prefs = await SharedPreferences.getInstance();
    final navContext = appNavigatorKey.currentContext;
    if (navContext != null && navContext.mounted) {
      await _handleDeepLink(uri, prefs);
    } else {
      // Save code for later processing
      final code = uri.queryParameters['code'];
      if (code != null && code.isNotEmpty) {
        await prefs.setString('pending_reset_code', code);
      }
    }
  });

  // Check for saved pending code
  final pendingCode = prefs.getString('pending_reset_code');
  if (pendingCode != null && pendingCode.isNotEmpty) {
    await prefs.remove('pending_reset_code');
    final navContext = appNavigatorKey.currentContext;
    if (navContext != null && navContext.mounted) {
      navContext.go('/forgotPasswordStep3?code=$pendingCode');
    }
  }
}

Future<void> _handleDeepLink(Uri uri, SharedPreferences prefs) async {
  final navContext = appNavigatorKey.currentContext;
  if (navContext == null || !navContext.mounted) {
    // Save code for later processing
    final code = uri.queryParameters['code'];
    if (code != null && code.isNotEmpty) {
      await prefs.setString('pending_reset_code', code);
    }
    return;
  }

  String pageName = uri.host.toLowerCase();
  if (pageName.isEmpty && uri.pathSegments.isNotEmpty) {
    pageName = uri.pathSegments.first.toLowerCase();
  }

  if (pageName == 'resetpassword' ||
      pageName == 'reset-password' ||
      pageName == 'forgotpasswordstep3') {
    final code = uri.queryParameters['code'];

    if (code != null && code.isNotEmpty) {
      final lastUsedCode = prefs.getString('last_used_reset_code');
      if (lastUsedCode == code) {
        return;
      }

      await prefs.setString('last_processed_reset_link', uri.toString());
      await prefs.setString('last_used_reset_code', code);

      if (navContext.mounted) {
        navContext.go('/forgotPasswordStep3?code=$code');
      }
    }
  }
}

// Do NOT reset _isInitialized - it causes issues
Future<void> clearPasswordResetState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('last_processed_reset_link');
  await prefs.remove('last_used_reset_code');
  await prefs.remove('pending_reset_code');
}

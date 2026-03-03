import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

StreamSubscription<Uri>? _linkSubscription;
bool _isInitialized = false;

Future<void> initPasswordResetDeepLink(BuildContext context) async {
  if (_isInitialized) {
    return;
  }
  _isInitialized = true;

  final appLinks = AppLinks();
  final prefs = await SharedPreferences.getInstance();

  // Отменяем старый listener если есть
  await _linkSubscription?.cancel();
  _linkSubscription = null;

  // Проверяем initial link с задержкой
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      final initialUri = await appLinks.getInitialLink();
      if (initialUri != null) {
        if (context.mounted) {
          await _handleDeepLink(initialUri, context, prefs);
        }
      }
    } catch (e) {}
  });

  // Слушаем новые deep links
  _linkSubscription = appLinks.uriLinkStream.listen((Uri uri) async {
    if (context.mounted) {
      final prefs = await SharedPreferences.getInstance();
      await _handleDeepLink(uri, context, prefs);
    } else {
      // Сохраняем код для обработки позже
      final code = uri.queryParameters['code'];
      if (code != null && code.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pending_reset_code', code);
      }
    }
  });

  // Проверяем есть ли сохранённый pending код
  final pendingCode = prefs.getString('pending_reset_code');
  if (pendingCode != null && pendingCode.isNotEmpty && context.mounted) {
    await prefs.remove('pending_reset_code');
    context.go('/forgotPasswordStep3?code=$pendingCode');
  }
}

Future<void> _handleDeepLink(
    Uri uri, BuildContext context, SharedPreferences prefs) async {
  if (!context.mounted) {
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

      if (context.mounted) {
        context.go('/forgotPasswordStep3?code=$code');
      }
    }
  }
}

// НЕ сбрасывай _isInitialized - это вызывает проблемы
Future<void> clearPasswordResetState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('last_processed_reset_link');
  await prefs.remove('last_used_reset_code');
  await prefs.remove('pending_reset_code');
}

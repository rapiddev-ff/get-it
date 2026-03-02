// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

StreamSubscription<Uri>? _linkSubscription;
bool _isInitialized = false;

Future<void> initPasswordResetDeepLink(BuildContext context) async {
  if (_isInitialized) {
    print('⏭️ Already initialized, skipping');
    return;
  }
  _isInitialized = true;

  final appLinks = AppLinks();
  final prefs = await SharedPreferences.getInstance();

  print('🔐 Initializing deep link listener...');

  // Отменяем старый listener если есть
  await _linkSubscription?.cancel();
  _linkSubscription = null;

  // Проверяем initial link с задержкой
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    try {
      final initialUri = await appLinks.getInitialLink();
      if (initialUri != null) {
        print('🔗 Initial deep link: $initialUri');
        if (context.mounted) {
          await _handleDeepLink(initialUri, context, prefs);
        }
      }
    } catch (e) {
      print('⚠️ Error: $e');
    }
  });

  // Слушаем новые deep links
  _linkSubscription = appLinks.uriLinkStream.listen((Uri uri) async {
    print('🔗 Deep link received: $uri');
    // Проверяем mounted перед использованием context
    if (context.mounted) {
      final prefs = await SharedPreferences.getInstance();
      await _handleDeepLink(uri, context, prefs);
    } else {
      print('⚠️ Context not mounted, saving code for later');
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
    print('🔐 Found pending code: $pendingCode');
    await prefs.remove('pending_reset_code');
    context.go('/forgotPasswordStep3?code=$pendingCode');
  }

  print('✅ Deep link listener ready');
}

Future<void> _handleDeepLink(
    Uri uri, BuildContext context, SharedPreferences prefs) async {
  if (!context.mounted) {
    print('⚠️ Context not mounted, skipping');
    return;
  }

  String pageName = uri.host.toLowerCase();
  if (pageName.isEmpty && uri.pathSegments.isNotEmpty) {
    pageName = uri.pathSegments.first.toLowerCase();
  }

  print('📍 Page: $pageName');

  if (pageName == 'resetpassword' ||
      pageName == 'reset-password' ||
      pageName == 'forgotpasswordstep3') {
    final code = uri.queryParameters['code'];

    if (code != null && code.isNotEmpty) {
      final lastUsedCode = prefs.getString('last_used_reset_code');
      if (lastUsedCode == code) {
        print('⏭️ This code already used, skipping');
        return;
      }

      print('🔐 Reset code: $code');
      print('🚀 Navigating to forgotPasswordStep3...');

      await prefs.setString('last_processed_reset_link', uri.toString());
      await prefs.setString('last_used_reset_code', code);

      if (context.mounted) {
        context.go('/forgotPasswordStep3?code=$code');
      }
    } else {
      print('⚠️ No code in URL, skipping navigation');
    }
  }
}

// НЕ сбрасывай _isInitialized - это вызывает проблемы
Future<void> clearPasswordResetState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('last_processed_reset_link');
  await prefs.remove('last_used_reset_code');
  await prefs.remove('pending_reset_code');
  print('🔄 Password reset state cleared');
}

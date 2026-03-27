import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _secureStorage = FlutterSecureStorage();

// --- keepSignedIn ---

class KeepSignedInNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final raw = await _secureStorage.read(key: 'ff_keepSignedIn');
    return raw == 'true';
  }

  Future<void> set(bool value) async {
    await _secureStorage.write(
      key: 'ff_keepSignedIn',
      value: value.toString(),
    );
    state = AsyncData(value);
  }

  Future<void> delete() async {
    await _secureStorage.delete(key: 'ff_keepSignedIn');
    state = const AsyncData(false);
  }
}

final keepSignedInProvider = AsyncNotifierProvider<KeepSignedInNotifier, bool>(
  KeepSignedInNotifier.new,
);

// --- isHomeViewed ---

class IsHomeViewedNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    // Check local cache first (fast)
    final raw = await _secureStorage.read(key: 'ff_isHomeViewed');
    if (raw == 'true') return true;

    // Check server (survives reinstall) — GT-120
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      try {
        final result = await Supabase.instance.client
            .from('user_settings')
            .select('onboarding_completed')
            .eq('user_id', userId)
            .maybeSingle();
        if (result != null && result['onboarding_completed'] == true) {
          // Sync to local cache
          await _secureStorage.write(key: 'ff_isHomeViewed', value: 'true');
          return true;
        }
      } catch (_) {
        // Fallback to local-only
      }
    }
    return false;
  }

  Future<void> set(bool value) async {
    await _secureStorage.write(
      key: 'ff_isHomeViewed',
      value: value.toString(),
    );
    state = AsyncData(value);

    // Persist to server — GT-120
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null && value) {
      try {
        await Supabase.instance.client
            .from('user_settings')
            .update({'onboarding_completed': true})
            .eq('user_id', userId);
      } catch (_) {
        // Best-effort server sync
      }
    }
  }

  Future<void> delete() async {
    await _secureStorage.delete(key: 'ff_isHomeViewed');
    state = const AsyncData(false);
  }
}

final isHomeViewedProvider = AsyncNotifierProvider<IsHomeViewedNotifier, bool>(
  IsHomeViewedNotifier.new,
);

// --- isPasswordRecovery ---

class IsPasswordRecoveryNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final raw = await _secureStorage.read(key: 'ff_isPasswordRecovery');
    return raw == 'true';
  }

  Future<void> set(bool value) async {
    await _secureStorage.write(
      key: 'ff_isPasswordRecovery',
      value: value.toString(),
    );
    state = AsyncData(value);
  }

  Future<void> delete() async {
    await _secureStorage.delete(key: 'ff_isPasswordRecovery');
    state = const AsyncData(false);
  }
}

final isPasswordRecoveryProvider =
    AsyncNotifierProvider<IsPasswordRecoveryNotifier, bool>(
  IsPasswordRecoveryNotifier.new,
);

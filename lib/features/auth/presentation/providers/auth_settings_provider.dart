import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

final keepSignedInProvider =
    AsyncNotifierProvider<KeepSignedInNotifier, bool>(
  KeepSignedInNotifier.new,
);

// --- isHomeViewed ---

class IsHomeViewedNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final raw = await _secureStorage.read(key: 'ff_isHomeViewed');
    return raw == 'true';
  }

  Future<void> set(bool value) async {
    await _secureStorage.write(
      key: 'ff_isHomeViewed',
      value: value.toString(),
    );
    state = AsyncData(value);
  }

  Future<void> delete() async {
    await _secureStorage.delete(key: 'ff_isHomeViewed');
    state = const AsyncData(false);
  }
}

final isHomeViewedProvider =
    AsyncNotifierProvider<IsHomeViewedNotifier, bool>(
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

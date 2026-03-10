import '/backend/supabase/supabase.dart';
import 'supabase_auth_manager.dart';

export 'supabase_auth_manager.dart';

final _authManager = SupabaseAuthManager();
SupabaseAuthManager get authManager => _authManager;

/// @deprecated Use `ref.read(currentUserIdProvider)` from `core/providers/current_user_provider.dart`.
String get currentUserEmail => currentUser?.email ?? '';

/// @deprecated Use `ref.read(currentUserIdProvider)` from `core/providers/current_user_provider.dart`.
String get currentUserUid => currentUser?.uid ?? '';

/// @deprecated Use `ref.read(authProvider).displayName` instead.
String get currentUserDisplayName => currentUser?.displayName ?? '';

/// @deprecated Use `ref.read(authProvider).photoUrl` instead.
String get currentUserPhoto => currentUser?.photoUrl ?? '';

/// @deprecated Use `ref.read(authProvider).phoneNumber` instead.
String get currentPhoneNumber => currentUser?.phoneNumber ?? '';

String get currentJwtToken => _currentJwtToken ?? '';

bool get currentUserEmailVerified => currentUser?.emailVerified ?? false;

/// Create a Stream that listens to the current user's JWT Token.
String? _currentJwtToken;
final jwtTokenStream = SupaFlow.client.auth.onAuthStateChange
    .map(
      (authState) => _currentJwtToken = authState.session?.accessToken,
    )
    .asBroadcastStream();

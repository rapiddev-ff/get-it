import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Provides the current authenticated user's ID from Supabase auth.
/// Prefer this over the global `currentUserUid` getter from auth_util.dart.
///
/// Usage in ConsumerWidget:
///   final userId = ref.watch(currentUserIdProvider);
final currentUserIdProvider = Provider<String>((ref) {
  return Supabase.instance.client.auth.currentUser?.id ?? '';
});

/// Provides the current authenticated user's email.
final currentUserEmailProvider = Provider<String>((ref) {
  return Supabase.instance.client.auth.currentUser?.email ?? '';
});

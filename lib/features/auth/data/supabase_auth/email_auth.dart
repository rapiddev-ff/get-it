import '/backend/supabase/supabase.dart';

Future<User?> emailSignInFunc(
  String email,
  String password,
) async {
  final AuthResponse res = await SupaFlow.client.auth
      .signInWithPassword(email: email, password: password);
  return res.user;
}

Future<User?> emailCreateAccountFunc(
  String email,
  String password,
) async {
  final AuthResponse res =
      await SupaFlow.client.auth.signUp(email: email, password: password);

  // Supabase returns the existing user with empty identities when the email
  // is already registered and email confirmation is disabled. In this case
  // we must NOT log the user in — treat it as a failed sign-up.
  if (res.user != null &&
      (res.user!.identities == null || res.user!.identities!.isEmpty)) {
    // Sign out to clear the session Supabase may have set
    await SupaFlow.client.auth.signOut();
    return null;
  }

  // If email confirmation is required, lastSignInAt will be null —
  // the user shouldn't be signed in yet.
  return res.user?.lastSignInAt == null ? null : res.user;
}

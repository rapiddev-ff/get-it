import 'dart:async';

import 'package:flutter/material.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/auth/data/auth_manager.dart';
import '/backend/supabase/supabase.dart';
import '/core/router/app_router.dart';
import 'email_auth.dart';

import 'supabase_user_provider.dart';

export '/features/auth/data/base_auth_user_provider.dart';

class SupabaseAuthManager extends AuthManager with EmailSignInManager {
  @override
  Future signOut() {
    return SupaFlow.client.auth.signOut();
  }

  @override
  Future deleteUser(BuildContext context) async {
    try {
      if (!loggedIn) {
        return;
      }
      await currentUser?.delete();
    } on AuthException {
      actions.toastificationshow(context, 'Error',
          'Failed to delete account. Please try again', 'error');
    } catch (e) {
      actions.toastificationshow(
          context, 'Error', 'Account deletion is not supported yet', 'error');
    }
  }

  @override
  Future updateEmail({
    required String email,
    required BuildContext context,
  }) async {
    try {
      if (!loggedIn) {
        return;
      }
      await currentUser?.updateEmail(email);
    } on AuthException {
      actions.toastificationshow(context, 'Error',
          'Failed to update email. Please try again', 'error');
      return;
    }
    actions.toastificationshow(
        context, 'Success', 'Email change confirmation email sent', 'success');
  }

  Future updatePassword({
    required String newPassword,
    required BuildContext context,
  }) async {
    try {
      if (!loggedIn) {
        return;
      }
      await currentUser?.updatePassword(newPassword);
    } on AuthException {
      actions.toastificationshow(context, 'Error',
          'Failed to update password. Please try again', 'error');
      return;
    }
    actions.toastificationshow(
        context, 'Success', 'Password updated successfully', 'success');
  }

  @override
  Future resetPassword({
    required String email,
    required BuildContext context,
    String? redirectTo,
  }) async {
    try {
      await SupaFlow.client.auth
          .resetPasswordForEmail(email, redirectTo: redirectTo);
    } on AuthException {
      actions.toastificationshow(context, 'Error',
          'Failed to send password reset email. Please try again', 'error');
      return null;
    }
    actions.toastificationshow(
        context, 'Success', 'Password reset email sent', 'success');
  }

  @override
  Future<BaseAuthUser?> signInWithEmail(
    BuildContext context,
    String email,
    String password,
  ) =>
      _signInOrCreateAccount(
        context,
        () => emailSignInFunc(email, password),
      );

  @override
  Future<BaseAuthUser?> createAccountWithEmail(
    BuildContext context,
    String email,
    String password,
  ) =>
      _signInOrCreateAccount(
        context,
        () => emailCreateAccountFunc(email, password),
      );

  /// Tries to sign in or create an account using Supabase Auth.
  /// Returns the User object if sign in was successful.
  Future<BaseAuthUser?> _signInOrCreateAccount(
    BuildContext context,
    Future<User?> Function() signInFunc,
  ) async {
    try {
      final user = await signInFunc();
      final authUser = user == null ? null : GetItSupabaseUser(user);

      // Update currentUser here in case user info needs to be used immediately
      // after a user is signed in. This should be handled by the user stream,
      // but adding here too in case of a race condition where the user stream
      // doesn't assign the currentUser in time.
      if (authUser != null) {
        currentUser = authUser;
        AppStateNotifier.instance.update(authUser);
      }
      return authUser;
    } on AuthException {
      return null;
    }
  }
}

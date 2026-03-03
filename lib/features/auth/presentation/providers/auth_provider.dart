import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/auth/domain/models/user_model.dart';

class AuthNotifier extends Notifier<UserData> {
  @override
  UserData build() => const UserData();

  void setUser(UserData user) {
    state = user;
  }

  void updateUser(UserData Function(UserData) updateFn) {
    state = updateFn(state);
  }

  void clear() {
    state = const UserData();
  }
}

final authProvider = NotifierProvider<AuthNotifier, UserData>(
  AuthNotifier.new,
);

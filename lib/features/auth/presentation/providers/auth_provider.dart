import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/backend/schema/structs/index.dart';

class AuthNotifier extends Notifier<UserDataStruct> {
  @override
  UserDataStruct build() => UserDataStruct();

  void setUser(UserDataStruct user) {
    state = user;
  }

  void updateUser(Function(UserDataStruct) updateFn) {
    updateFn(state);
    state = state;
  }

  void clear() {
    state = UserDataStruct();
  }
}

final authProvider = NotifierProvider<AuthNotifier, UserDataStruct>(
  AuthNotifier.new,
);

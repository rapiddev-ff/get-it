import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setActiveTab(int index) {
    state = index;
  }
}

final activeTabIndexProvider = NotifierProvider<NavigationNotifier, int>(
  NavigationNotifier.new,
);

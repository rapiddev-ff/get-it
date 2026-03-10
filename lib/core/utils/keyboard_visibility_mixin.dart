import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

/// Mixin that tracks keyboard visibility across web and mobile platforms.
///
/// On mobile: subscribes to [KeyboardVisibilityController].
/// On web: falls back to [MediaQuery.viewInsetsOf] when [isKeyboardShowing] is called.
///
/// Usage:
/// ```dart
/// class _MyWidgetState extends State<MyWidget> with KeyboardVisibilityMixin {
///   @override
///   Widget build(BuildContext context) {
///     if (!isKeyboardShowing(context))
///       // show bottom action buttons
///   }
/// }
/// ```
mixin KeyboardVisibilityMixin<T extends StatefulWidget> on State<T> {
  StreamSubscription<bool>? _keyboardSub;
  bool _isKeyboardVisible = false;

  /// Whether the keyboard is currently visible.
  ///
  /// On web, checks [MediaQuery.viewInsetsOf]. On mobile, uses the
  /// [KeyboardVisibilityController] subscription.
  bool isKeyboardShowing(BuildContext context) {
    if (kIsWeb) {
      return MediaQuery.viewInsetsOf(context).bottom > 0;
    }
    return _isKeyboardVisible;
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _keyboardSub =
          KeyboardVisibilityController().onChange.listen((bool visible) {
        setState(() {
          _isKeyboardVisible = visible;
        });
      });
    }
  }

  @override
  void dispose() {
    _keyboardSub?.cancel();
    super.dispose();
  }
}

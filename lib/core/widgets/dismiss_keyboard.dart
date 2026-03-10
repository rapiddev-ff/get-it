import 'package:flutter/material.dart';

/// Wraps a child widget to dismiss the keyboard when tapping outside
/// focused input fields. Use this around Scaffold widgets.
class DismissKeyboard extends StatelessWidget {
  const DismissKeyboard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}

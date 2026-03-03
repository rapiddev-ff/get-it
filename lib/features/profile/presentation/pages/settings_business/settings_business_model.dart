import 'package:flutter/material.dart';

class SettingsBusinessModel {
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

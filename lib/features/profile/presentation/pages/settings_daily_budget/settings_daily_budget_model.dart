import 'package:flutter/material.dart';

class SettingsDailyBudgetModel {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

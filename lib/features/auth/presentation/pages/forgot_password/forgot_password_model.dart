import 'package:flutter/material.dart';

class ForgotPasswordModel {
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  dynamic requestPasswordReset;
  bool isLoading = false;

  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

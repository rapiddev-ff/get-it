import 'package:flutter/material.dart';

class SettingsChangeEmailModel {
  ///  Local state fields for this page.

  bool errorEmailRequired = false;

  bool errorEmailFormat = false;

  bool emailAlreadyInUse = false;

  bool errorPasswordRequired = false;

  bool errorPassword = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // Stores action output result for [Custom Action - supabaseLogin] action in Button widget.
  dynamic isCorrect;
  // Stores action output result for [Custom Action - checkIsEmailRegistered] action in Button widget.
  bool? isEmailRegistered;
  // Stores action output result for [Custom Action - changeUserEmailWithPasswordCheck] action in Button widget.
  dynamic result;

  SettingsChangeEmailModel() {
    passwordVisibility = false;
  }

  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}

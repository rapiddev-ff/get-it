import 'package:flutter/material.dart';

class SignInModel {
  bool errorEmailRequired = false;
  bool errorEmailFormat = false;
  bool errorPasswordRequired = false;
  bool keepSignedIn = false;
  String? errorSignIn;

  FocusNode? textFieldFocusNode1;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;

  FocusNode? textFieldFocusNode2;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;

  void initState(BuildContext context) {
    passwordVisibility = false;
  }

  void dispose() {
    textFieldFocusNode1?.dispose();
    emailTextController?.dispose();
    textFieldFocusNode2?.dispose();
    passwordTextController?.dispose();
  }
}

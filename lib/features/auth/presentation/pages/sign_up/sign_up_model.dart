import 'package:flutter/material.dart';

class SignUpModel {
  bool errorEmailRequired = false;
  bool errorEmailFormat = false;
  bool errorPasswordRequired = false;
  bool errorConfirmPasswordRequired = false;
  bool emailAlreadyInUse = false;
  bool checkBoxIsActive = false;
  bool errorPaswordsDontMatch = false;

  FocusNode? textFieldFocusNode1;
  TextEditingController? emailTextController;

  FocusNode? textFieldFocusNode2;
  TextEditingController? passwordTextController;
  late bool passwordVisibility1;

  FocusNode? textFieldFocusNode3;
  TextEditingController? confirmPasswordTextController;
  late bool passwordVisibility2;

  bool? isUserExist;

  void initState(BuildContext context) {
    passwordVisibility1 = false;
    passwordVisibility2 = false;
  }

  void dispose() {
    textFieldFocusNode1?.dispose();
    emailTextController?.dispose();
    textFieldFocusNode2?.dispose();
    passwordTextController?.dispose();
    textFieldFocusNode3?.dispose();
    confirmPasswordTextController?.dispose();
  }
}

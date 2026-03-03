import '/features/auth/presentation/widgets/password_component/password_component_widget.dart';
import 'package:flutter/material.dart';

class ForgotPasswordStep3Model {
  bool errorPasswordRequired = false;
  bool errorConfirmPasswordRequired = false;
  bool errorPaswordsDontMatch = false;

  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  late bool passwordVisibility1;
  String? Function(BuildContext, String?)? textController1Validator;

  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  late bool passwordVisibility2;
  String? Function(BuildContext, String?)? textController2Validator;

  late PasswordComponentModel passwordComponentModel1;
  late PasswordComponentModel passwordComponentModel2;
  late PasswordComponentModel passwordComponentModel3;
  late PasswordComponentModel passwordComponentModel4;
  late PasswordComponentModel passwordComponentModel5;

  void initState(BuildContext context) {
    passwordVisibility1 = false;
    passwordVisibility2 = false;
    passwordComponentModel1 = PasswordComponentModel();
    passwordComponentModel2 = PasswordComponentModel();
    passwordComponentModel3 = PasswordComponentModel();
    passwordComponentModel4 = PasswordComponentModel();
    passwordComponentModel5 = PasswordComponentModel();
  }

  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();
    textFieldFocusNode2?.dispose();
    textController2?.dispose();
    passwordComponentModel1.dispose();
    passwordComponentModel2.dispose();
    passwordComponentModel3.dispose();
    passwordComponentModel4.dispose();
    passwordComponentModel5.dispose();
  }
}

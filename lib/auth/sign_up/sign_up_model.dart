import '/auth/password_component/password_component_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'sign_up_widget.dart' show SignUpWidget;
import 'package:flutter/material.dart';

class SignUpModel extends FlutterFlowModel<SignUpWidget> {
  ///  Local state fields for this page.

  bool errorEmailRequired = false;

  bool errorEmailFormat = false;

  bool errorPasswordRequired = false;

  bool errorConfirmPasswordRequired = false;

  bool emailAlreadyInUse = false;

  bool checkBoxIsActive = false;

  bool errorPaswordsDontMatch = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? passwordTextController;
  late bool passwordVisibility1;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? confirmPasswordTextController;
  late bool passwordVisibility2;
  String? Function(BuildContext, String?)?
      confirmPasswordTextControllerValidator;
  // Model for passwordComponent component.
  late PasswordComponentModel passwordComponentModel1;
  // Model for passwordComponent component.
  late PasswordComponentModel passwordComponentModel2;
  // Model for passwordComponent component.
  late PasswordComponentModel passwordComponentModel3;
  // Model for passwordComponent component.
  late PasswordComponentModel passwordComponentModel4;
  // Model for passwordComponent component.
  late PasswordComponentModel passwordComponentModel5;
  // Stores action output result for [Custom Action - checkIsEmailRegistered] action in Button widget.
  bool? isUserExist;

  @override
  void initState(BuildContext context) {
    passwordVisibility1 = false;
    passwordVisibility2 = false;
    passwordComponentModel1 =
        createModel(context, () => PasswordComponentModel());
    passwordComponentModel2 =
        createModel(context, () => PasswordComponentModel());
    passwordComponentModel3 =
        createModel(context, () => PasswordComponentModel());
    passwordComponentModel4 =
        createModel(context, () => PasswordComponentModel());
    passwordComponentModel5 =
        createModel(context, () => PasswordComponentModel());
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    emailTextController?.dispose();

    textFieldFocusNode2?.dispose();
    passwordTextController?.dispose();

    textFieldFocusNode3?.dispose();
    confirmPasswordTextController?.dispose();

    passwordComponentModel1.dispose();
    passwordComponentModel2.dispose();
    passwordComponentModel3.dispose();
    passwordComponentModel4.dispose();
    passwordComponentModel5.dispose();
  }
}

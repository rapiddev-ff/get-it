import '/auth/password_component/password_component_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'forgot_password_step3_widget.dart' show ForgotPasswordStep3Widget;
import 'package:flutter/material.dart';

class ForgotPasswordStep3Model
    extends FlutterFlowModel<ForgotPasswordStep3Widget> {
  ///  Local state fields for this page.

  bool errorPasswordRequired = false;

  bool errorConfirmPasswordRequired = false;

  bool errorPaswordsDontMatch = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  late bool passwordVisibility1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  late bool passwordVisibility2;
  String? Function(BuildContext, String?)? textController2Validator;
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

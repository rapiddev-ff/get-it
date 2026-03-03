import '/features/auth/presentation/widgets/password_component/password_component_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'settings_change_password_widget.dart' show SettingsChangePasswordWidget;
import 'package:flutter/material.dart';

class SettingsChangePasswordModel
    extends FlutterFlowModel<SettingsChangePasswordWidget> {
  ///  Local state fields for this page.

  bool errorConfirmPasswordRequired = false;

  bool errorCurrentPasswordRequired = false;

  bool errorPasswordRequired = false;

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
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  late bool passwordVisibility3;
  String? Function(BuildContext, String?)? textController3Validator;
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
  // Stores action output result for [Custom Action - changePassword] action in Button widget.
  String? result;

  @override
  void initState(BuildContext context) {
    passwordVisibility1 = false;
    passwordVisibility2 = false;
    passwordVisibility3 = false;
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

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    passwordComponentModel1.dispose();
    passwordComponentModel2.dispose();
    passwordComponentModel3.dispose();
    passwordComponentModel4.dispose();
    passwordComponentModel5.dispose();
  }
}

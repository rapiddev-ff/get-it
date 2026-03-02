import '/flutter_flow/flutter_flow_util.dart';
import 'settings_business_widget.dart' show SettingsBusinessWidget;
import 'package:flutter/material.dart';

class SettingsBusinessModel extends FlutterFlowModel<SettingsBusinessWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

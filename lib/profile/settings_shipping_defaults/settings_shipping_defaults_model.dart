import '/flutter_flow/flutter_flow_util.dart';
import 'settings_shipping_defaults_widget.dart'
    show SettingsShippingDefaultsWidget;
import 'package:flutter/material.dart';

class SettingsShippingDefaultsModel
    extends FlutterFlowModel<SettingsShippingDefaultsWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // Stores action output result for [Custom Action - callRpc] action in Button widget.
  dynamic saveShippingSettings;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}

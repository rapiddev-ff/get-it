import '/backend/api_requests/api_calls.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SettingsChangePhoneModel {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  late MaskTextInputFormatter textFieldMask;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Backend Call - API (checkphoneexists)] action in Button widget.
  ApiCallResponse? apiResultzpe;

  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

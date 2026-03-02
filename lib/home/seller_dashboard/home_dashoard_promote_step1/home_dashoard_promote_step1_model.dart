import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home_dashoard_promote_step1_widget.dart'
    show HomeDashoardPromoteStep1Widget;
import 'package:flutter/material.dart';

class HomeDashoardPromoteStep1Model
    extends FlutterFlowModel<HomeDashoardPromoteStep1Widget> {
  ///  Local state fields for this page.

  String state = 'Shop';

  ///  State fields for stateful widgets in this page.

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

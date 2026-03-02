import '/flutter_flow/flutter_flow_util.dart';
import 'home_dashoard_shortlist_add_widget.dart'
    show HomeDashoardShortlistAddWidget;
import 'package:flutter/material.dart';

class HomeDashoardShortlistAddModel
    extends FlutterFlowModel<HomeDashoardShortlistAddWidget> {
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

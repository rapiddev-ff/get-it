import '/flutter_flow/flutter_flow_util.dart';
import 'settings_daily_budget_widget.dart' show SettingsDailyBudgetWidget;
import 'package:flutter/material.dart';

class SettingsDailyBudgetModel
    extends FlutterFlowModel<SettingsDailyBudgetWidget> {
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

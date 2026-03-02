import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home_dashoard_inventory_widget.dart' show HomeDashoardInventoryWidget;
import 'package:flutter/material.dart';

class HomeDashoardInventoryModel
    extends FlutterFlowModel<HomeDashoardInventoryWidget> {
  ///  Local state fields for this page.

  CategoryStruct? choosenCategory;
  void updateChoosenCategoryStruct(Function(CategoryStruct) updateFn) {
    updateFn(choosenCategory ??= CategoryStruct());
  }

  int? itemsCount = 0;

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

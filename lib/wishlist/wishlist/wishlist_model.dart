import '/backend/schema/structs/index.dart';
import '/core/empty_state/empty_state_widget.dart';
import '/core/nav_bar/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'wishlist_widget.dart' show WishlistWidget;
import 'package:flutter/material.dart';

class WishlistModel extends FlutterFlowModel<WishlistWidget> {
  ///  Local state fields for this page.

  CategoryStruct? choosenCategory;
  void updateChoosenCategoryStruct(Function(CategoryStruct) updateFn) {
    updateFn(choosenCategory ??= CategoryStruct());
  }

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for emptyState component.
  late EmptyStateModel emptyStateModel;
  // Model for navBar component.
  late NavBarModel navBarModel;

  @override
  void initState(BuildContext context) {
    emptyStateModel = createModel(context, () => EmptyStateModel());
    navBarModel = createModel(context, () => NavBarModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    emptyStateModel.dispose();
    navBarModel.dispose();
  }
}

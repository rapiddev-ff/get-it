import '/core/nav_bar/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_dashoard_earnings_widget.dart' show HomeDashoardEarningsWidget;
import 'package:flutter/material.dart';

class HomeDashoardEarningsModel
    extends FlutterFlowModel<HomeDashoardEarningsWidget> {
  ///  Local state fields for this page.

  String state = 'Sales';

  ///  State fields for stateful widgets in this page.

  // Model for navBar component.
  late NavBarModel navBarModel;

  @override
  void initState(BuildContext context) {
    navBarModel = createModel(context, () => NavBarModel());
  }

  @override
  void dispose() {
    navBarModel.dispose();
  }
}

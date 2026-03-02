import '/core/nav_bar/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'videos_widget.dart' show VideosWidget;
import 'package:flutter/material.dart';

class VideosModel extends FlutterFlowModel<VideosWidget> {
  ///  Local state fields for this page.

  String state = 'All';

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

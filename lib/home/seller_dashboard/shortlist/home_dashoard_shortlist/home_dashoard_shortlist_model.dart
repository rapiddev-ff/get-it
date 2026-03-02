import '/flutter_flow/flutter_flow_util.dart';
import '/home/seller_dashboard/shortlist/shortlist_item/shortlist_item_widget.dart';
import '/index.dart';
import 'home_dashoard_shortlist_widget.dart' show HomeDashoardShortlistWidget;
import 'package:flutter/material.dart';

class HomeDashoardShortlistModel
    extends FlutterFlowModel<HomeDashoardShortlistWidget> {
  ///  Local state fields for this page.

  String state = 'Shop';

  ///  State fields for stateful widgets in this page.

  // Model for shortlistItem component.
  late ShortlistItemModel shortlistItemModel;

  @override
  void initState(BuildContext context) {
    shortlistItemModel = createModel(context, () => ShortlistItemModel());
  }

  @override
  void dispose() {
    shortlistItemModel.dispose();
  }
}

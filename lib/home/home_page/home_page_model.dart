import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/components/seller_dashboard_ship_item_widget.dart';
import '/core/nav_bar/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  String state = 'Shop';

  bool hasMoreProducts = true;

  bool isLoadingMore = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - initFeedProductsStream] action in homePage widget.
  List<FeedProductStruct>? getFeed;
  // Stores action output result for [Custom Action - callRpc] action in homePage widget.
  dynamic getSellerDashboard;
  // Stores action output result for [Backend Call - Query Rows] action in Column widget.
  List<StripeAccountsRow>? getStripe;
  // Stores action output result for [Backend Call - Insert Row] action in SwipeableProductStack widget.
  OrdersRow? createOrder;
  // Model for sellerDashboardShipItem component.
  late SellerDashboardShipItemModel sellerDashboardShipItemModel;
  // State field(s) for Expandable widget.
  late ExpandableController expandableExpandableController;

  // Model for navBar component.
  late NavBarModel navBarModel;

  @override
  void initState(BuildContext context) {
    sellerDashboardShipItemModel =
        createModel(context, () => SellerDashboardShipItemModel());
    navBarModel = createModel(context, () => NavBarModel());
  }

  @override
  void dispose() {
    sellerDashboardShipItemModel.dispose();
    expandableExpandableController.dispose();
    navBarModel.dispose();
  }
}

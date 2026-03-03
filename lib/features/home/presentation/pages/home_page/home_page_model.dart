import 'package:expandable/expandable.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';

class HomePageModel {
  String state = 'Shop';
  bool hasMoreProducts = true;
  bool isLoadingMore = false;

  List<FeedProductStruct>? getFeed;
  dynamic getSellerDashboard;
  List<StripeAccountsRow>? getStripe;
  OrdersRow? createOrder;

  late ExpandableController expandableExpandableController;

  void dispose() {
    expandableExpandableController.dispose();
  }
}

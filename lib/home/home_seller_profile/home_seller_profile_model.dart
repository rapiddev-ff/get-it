import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home_seller_profile_widget.dart' show HomeSellerProfileWidget;
import 'package:flutter/material.dart';

class HomeSellerProfileModel extends FlutterFlowModel<HomeSellerProfileWidget> {
  ///  Local state fields for this page.

  String state = 'Products';

  String choosenFilter = 'All';

  List<SellerProductStruct> products = [];
  void addToProducts(SellerProductStruct item) => products.add(item);
  void removeFromProducts(SellerProductStruct item) => products.remove(item);
  void removeAtIndexFromProducts(int index) => products.removeAt(index);
  void insertAtIndexInProducts(int index, SellerProductStruct item) =>
      products.insert(index, item);
  void updateProductsAtIndex(
          int index, Function(SellerProductStruct) updateFn) =>
      products[index] = updateFn(products[index]);

  String roleState = 'As Seller';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getSellerInfo] action in homeSellerProfile widget.
  SellerStruct? getSellerData;
  // Stores action output result for [Custom Action - getOrCreateConversation] action in Button widget.
  ConversationStruct? getOrCreateConversation;
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

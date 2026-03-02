import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'home_product_widget.dart' show HomeProductWidget;
import 'package:flutter/material.dart';

class HomeProductModel extends FlutterFlowModel<HomeProductWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getProductDetails] action in homeProduct widget.
  ProductDetailsStruct? getProduct;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Stores action output result for [Custom Action - getOrCreateConversation] action in Button widget.
  ConversationStruct? getOrCreateConversation;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

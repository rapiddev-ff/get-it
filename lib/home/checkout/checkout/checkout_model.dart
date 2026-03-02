import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home/checkout/checkout_item/checkout_item_widget.dart';
import '/index.dart';
import 'checkout_widget.dart' show CheckoutWidget;
import 'package:flutter/material.dart';

class CheckoutModel extends FlutterFlowModel<CheckoutWidget> {
  ///  Local state fields for this page.

  CheckoutTotalsStruct? checkoutTotals;
  void updateCheckoutTotalsStruct(Function(CheckoutTotalsStruct) updateFn) {
    updateFn(checkoutTotals ??= CheckoutTotalsStruct());
  }

  int quantity = 1;

  /// ShippingAddressRow
  String? selectedAddress;

  bool isProcessing = false;

  bool isLoading = true;

  double? tax;

  ///  State fields for stateful widgets in this page.

  // Model for checkoutItem component.
  late CheckoutItemModel checkoutItemModel;
  // Stores action output result for [Custom Action - calculateOrderTax] action in checkoutItem widget.
  double? getTaxFromStripeAdd;
  // Stores action output result for [Custom Action - calculateOrderTax] action in checkoutItem widget.
  double? getTaxFromStripeMinus;
  // Stores action output result for [Custom Action - createCheckoutOrder] action in Button widget.
  CheckoutOrderResultStruct? orderResult;

  @override
  void initState(BuildContext context) {
    checkoutItemModel = createModel(context, () => CheckoutItemModel());
  }

  @override
  void dispose() {
    checkoutItemModel.dispose();
  }
}

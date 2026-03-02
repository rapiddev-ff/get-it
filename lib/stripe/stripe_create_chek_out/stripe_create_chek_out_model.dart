import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'stripe_create_chek_out_widget.dart' show StripeCreateChekOutWidget;
import 'package:flutter/material.dart';

class StripeCreateChekOutModel
    extends FlutterFlowModel<StripeCreateChekOutWidget> {
  ///  State fields for stateful widgets in this page.

  InstantTimer? chekPaid;
  // Stores action output result for [Backend Call - Query Rows] action in stripeCreateChekOut widget.
  List<OrdersRow>? chekoutRowExist;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    chekPaid?.cancel();
  }
}

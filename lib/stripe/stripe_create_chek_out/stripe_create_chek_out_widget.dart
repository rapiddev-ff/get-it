import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import '/flutter_flow/instant_timer.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'stripe_create_chek_out_model.dart';
export 'stripe_create_chek_out_model.dart';

class StripeCreateChekOutWidget extends StatefulWidget {
  const StripeCreateChekOutWidget({
    super.key,
    required this.checkoutDetail,
    required this.amount,
    required this.orderId,
  });

  final dynamic checkoutDetail;
  final double? amount;
  final String? orderId;

  static String routeName = 'stripeCreateChekOut';
  static String routePath = 'stripeCreateChekOut';

  @override
  State<StripeCreateChekOutWidget> createState() =>
      _StripeCreateChekOutWidgetState();
}

class _StripeCreateChekOutWidgetState extends State<StripeCreateChekOutWidget> {
  late StripeCreateChekOutModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StripeCreateChekOutModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        Duration(
          milliseconds: 20000,
        ),
      );
      _model.chekPaid = InstantTimer.periodic(
        duration: Duration(milliseconds: 5000),
        callback: (timer) async {
          _model.chekoutRowExist = await OrdersTable().queryRows(
            queryFn: (q) => q
                .eqOrNull(
                  'id',
                  widget.orderId,
                )
                .eqOrNull(
                  'buyer_id',
                  currentUserUid,
                ),
          );
          if (_model.chekoutRowExist!.length > 0) {
            if (_model.chekoutRowExist?.firstOrNull?.status == 'paid') {
              context.goNamed(StripeSuccessWidget.routeName);
            } else {
              context.goNamed(StripeRefreshWidget.routeName);
            }
          }
        },
        startImmediately: true,
      );
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              FlutterFlowWebView(
                content: getJsonField(
                  widget.checkoutDetail,
                  r'''$.url''',
                ).toString(),
                bypass: false,
                height: MediaQuery.sizeOf(context).height * 1.0,
                verticalScroll: false,
                horizontalScroll: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

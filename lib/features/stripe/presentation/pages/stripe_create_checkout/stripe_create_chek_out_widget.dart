import '/features/auth/data/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/core/widgets/app_web_view.dart';
import '/core/utils/instant_timer.dart';
import '/core/router/app_router.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/stripe/presentation/pages/stripe_success/stripe_success_widget.dart';
import '/features/stripe/presentation/pages/stripe_refresh/stripe_refresh_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
  InstantTimer? chekPaid;
  List<OrdersRow>? chekoutRowExist;

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(
        Duration(
          milliseconds: 20000,
        ),
      );
      chekPaid = InstantTimer.periodic(
        duration: Duration(milliseconds: 5000),
        callback: (timer) async {
          chekoutRowExist = await OrdersTable().queryRows(
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
          if (chekoutRowExist!.length > 0) {
            if (chekoutRowExist?.firstOrNull?.status == 'paid') {
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
    chekPaid?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AppWebView(
                content: ((widget.checkoutDetail is Map)
                        ? widget.checkoutDetail['url']
                        : null)
                    .toString(),
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

import '/features/auth/data/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import '/core/router/app_router.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/home/presentation/pages/home_page/home_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class StripeSuccessWidget extends StatefulWidget {
  const StripeSuccessWidget({super.key});

  static String routeName = 'stripeSuccess';
  static String routePath = 'stripeSuccess';

  @override
  State<StripeSuccessWidget> createState() => _StripeSuccessWidgetState();
}

class _StripeSuccessWidgetState extends State<StripeSuccessWidget> {
  List<StripeAccountsRow>? getStripe;

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 32.0),
                  child: Container(
                    width: 120.0,
                    height: 120.0,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 60.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Stripe Connected Successfully!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 32.0),
                  child: Text(
                    'Your Stripe account has been connected successfully. You can now start receiving payments from your sales!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
                AppGradientButton(
                  text: 'Continue',
                  onPressed: () async {
                    getStripe = await StripeAccountsTable().queryRows(
                      queryFn: (q) => q.eqOrNull(
                        'user_id',
                        currentUserUid,
                      ),
                    );
                    setState(() {});

                    context.goNamed(
                      HomePageWidget.routeName,
                      extra: <String, dynamic>{
                        kTransitionInfoKey: TransitionInfo(
                          hasTransition: true,
                          transitionType: PageTransitionType.fade,
                          duration: Duration(milliseconds: 0),
                        ),
                      },
                    );

                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

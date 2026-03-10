import '/core/theme/app_colors.dart';
import '/core/router/app_router.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/home/presentation/pages/home_page/home_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class StripeRefreshWidget extends StatefulWidget {
  const StripeRefreshWidget({super.key});

  static String routeName = 'stripeRefresh';
  static String routePath = 'stripeRefresh';

  @override
  State<StripeRefreshWidget> createState() => _StripeRefreshWidgetState();
}

class _StripeRefreshWidgetState extends State<StripeRefreshWidget> {
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
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
                      color: Color(0xFFFFE6E6),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: 60.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    'Stripe Connection Failed',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 32.0),
                  child: Text(
                    'We\'re sorry, but we couldn\'t connect your Stripe account at this time.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
                AppGradientButton(
                  text: 'Go Back',
                  onPressed: () async {
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

import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '/core/constants/app_constants.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/auth/presentation/pages/sign_in/sign_in_widget.dart';
import '/features/auth/presentation/pages/sign_up/sign_up_widget.dart';
class WelcomeWidget extends StatefulWidget {
  const WelcomeWidget({super.key});

  static String routeName = 'welcome';
  static String routePath = 'welcome';

  @override
  State<WelcomeWidget> createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget> {
  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.initPasswordResetDeepLink(
        context,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Spacer(),
                Text(
                  AppConstants.appName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 48.0,
                    height: 1.0,
                  ),
                ),
                Text(
                  'Snap.Catalog. Organize',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.normal,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                    fontSize: 18.0,
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: AppGradientButton(
                    text: 'Create Account',
                    onPressed: () async {
                      context.pushNamed(SignUpWidget.routeName);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: InkWell(
                    onTap: () async {
                      context.pushNamed(SignInWidget.routeName);
                    },
                    child: RichText(
                      textScaler: MediaQuery.of(context).textScaler,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Already have an account?',
                            style: Theme.of(context).textTheme.labelMedium!,
                          ),
                          TextSpan(
                            text: ' Sign In',
                            style: GoogleFonts.inter(
                              color: AppColors.brandPurpleLight,
                            ),
                          ),
                        ],
                        style: Theme.of(context).textTheme.bodyMedium!,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

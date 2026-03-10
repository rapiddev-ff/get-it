import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/constants/app_constants.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/dismiss_keyboard.dart';
import 'forgot_password_step2_model.dart';
export 'forgot_password_step2_model.dart';

class ForgotPasswordStep2Widget extends StatefulWidget {
  const ForgotPasswordStep2Widget({
    super.key,
    required this.email,
  });

  final String? email;

  static String routeName = 'forgotPasswordStep2';
  static String routePath = 'forgotPasswordStep2';

  @override
  State<ForgotPasswordStep2Widget> createState() =>
      _ForgotPasswordStep2WidgetState();
}

class _ForgotPasswordStep2WidgetState extends State<ForgotPasswordStep2Widget>
    with KeyboardVisibilityMixin {
  late ForgotPasswordStep2Model _model;

  @override
  void initState() {
    super.initState();
    _model = ForgotPasswordStep2Model();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundPrimary,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () {
              context.pop();
            },
          ),
          title: Text(
            AppConstants.appName,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Check Your Inbox',
                  style: GoogleFonts.inter(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Container(
                          width: 140.0,
                          height: 140.0,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundSecondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(
                          'Almost there! We\'ve sent a password reset link to ${widget.email}. Click the link in the email to create your new password. Don\'t see it? Check your spam folder or wait a few minutes for delivery.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: AppColors.textPrimary,
                            fontSize: 16.0,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ].addToStart(SizedBox(height: 24.0)),
                  ),
                ),
              ),
              if (!isKeyboardShowing(context))
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Didn\u2019t get anything?',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Color(0xFFAFAFB4),
                          fontSize: 16.0,
                          height: 1.5,
                        ),
                      ),
                      AppGradientButton(
                        text: 'Back to Sign In',
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ]
                        .divide(SizedBox(height: 24.0))
                        .addToStart(SizedBox(height: 24.0))
                        .addToEnd(SizedBox(height: 32.0)),
                  ).animate().move(
                        begin: Offset(0, 100),
                        end: Offset.zero,
                        duration: 600.ms,
                      ),
                ),
            ].addToStart(SizedBox(height: 32.0)),
          ),
        ),
      ),
    );
  }
}

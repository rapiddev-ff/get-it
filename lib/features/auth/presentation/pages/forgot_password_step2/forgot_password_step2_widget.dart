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
import '/custom_code/actions/index.dart' as actions;

class ForgotPasswordStep2Widget extends StatefulWidget {
  const ForgotPasswordStep2Widget({
    super.key,
    required this.email,
  });

  final String? email;

  static const String routeName = 'forgotPasswordStep2';
  static const String routePath = 'forgotPasswordStep2';

  @override
  State<ForgotPasswordStep2Widget> createState() =>
      _ForgotPasswordStep2WidgetState();
}

class _ForgotPasswordStep2WidgetState extends State<ForgotPasswordStep2Widget>
    with KeyboardVisibilityMixin {
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Check Your Inbox',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          width: 140.0,
                          height: 140.0,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundSecondary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.mail_outline_rounded,
                            color: AppColors.primary,
                            size: 64.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(
                          'Almost there! We\'ve sent a password reset link to ${widget.email}. Click the link in the email to create your new password.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(height: 1.5),
                        ),
                      ),
                      Text(
                        'Don\'t see it? Check your spam folder or wait a few minutes for delivery.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                              color: AppColors.textSecondary,
                              height: 1.5,
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
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge!
                            .copyWith(height: 1.5),
                      ),
                      AppGradientButton(
                        text: 'Resend Email',
                        isLoading: _isResending,
                        onPressed: _isResending
                            ? null
                            : () async {
                                setState(() => _isResending = true);
                                try {
                                  final result =
                                      await actions.requestPasswordReset(
                                    widget.email ?? '',
                                  );
                                  if (!mounted) return;
                                  if (result['success'] == true) {
                                    await actions.toastificationshow(
                                      context,
                                      'Email Sent',
                                      'We\'ve resent the password reset link to ${widget.email}.',
                                      'success',
                                    );
                                  } else {
                                    await actions.toastificationshow(
                                      context,
                                      'Error',
                                      'Could not resend email. Please try again later.',
                                      'error',
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() => _isResending = false);
                                  }
                                }
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

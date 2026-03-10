import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/auth/presentation/pages/additional_info/additional_info_widget.dart';
class PermissionsWidget extends StatefulWidget {
  const PermissionsWidget({super.key});

  static String routeName = 'permissions';
  static String routePath = 'permissions';

  @override
  State<PermissionsWidget> createState() => _PermissionsWidgetState();
}

class _PermissionsWidgetState extends State<PermissionsWidget>
    with KeyboardVisibilityMixin {
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
            icon: const Icon(
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
              letterSpacing: 0.0,
            ),
          ),
          actions: const [],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 48.0,
                          letterSpacing: 0.0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Let\u2019s Get You Set Up.',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'To provide you with the best possible experience, we\u2019d like to send you helpful notifications and know your location.',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            color: AppColors.textPrimary,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            height: 1.5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 48.0),
                        child: Text(
                          'We\u2019ll ask permission for:',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            height: 1.5,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          width: double.infinity,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundSecondary,
                            borderRadius: BorderRadius.circular(4.0),
                            shape: BoxShape.rectangle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: const BoxDecoration(
                                    color: AppColors.surfaceDark,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.notifications,
                                    color: AppColors.textPrimary,
                                    size: 24.0,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      'Notifications',
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.normal,
                                        color: AppColors.textPrimary,
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ].divide(const SizedBox(width: 12.0)),
                            ),
                          ),
                        ),
                      ),
                    ].addToStart(const SizedBox(height: 32.0)),
                  ),
                ),
              ),
              if (!isKeyboardShowing(context))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppGradientButton(
                        text: 'Next',
                        onPressed: () async {
                          await Permission.notification.request();

                          if (context.mounted) {
                            context.pushNamed(AdditionalInfoWidget.routeName);
                          }
                        },
                      ),
                      InkWell(
                        onTap: () {
                          context.pushNamed(AdditionalInfoWidget.routeName);
                        },
                        child: Text(
                          'No thanks, I\'ll do this later.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontSize: 16.0,
                            letterSpacing: 0.0,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ]
                        .divide(const SizedBox(height: 24.0))
                        .addToStart(const SizedBox(height: 24.0))
                        .addToEnd(const SizedBox(height: 32.0)),
                  ).animate().move(
                        begin: const Offset(0, 100),
                        end: Offset.zero,
                        duration: 600.ms,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import '/features/profile/presentation/pages/settings_dialog/settings_dialog_widget.dart';
import '/features/auth/presentation/pages/sign_up/sign_up_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsDeleteAccountWidget extends StatelessWidget {
  const SettingsDeleteAccountWidget({super.key});

  static String routeName = 'settingsDeleteAccount';
  static String routePath = 'settingsDeleteAccount';

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundSecondary,
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
            'Delete Account',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0x42EF4444),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Icon(
                      Icons.remove_circle_outline,
                      color: AppColors.destructive500,
                      size: 20.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'Are you sure you want to delete your account?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 24.0,
                      height: 1.5,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    'If you confirm for your account to be deleted, ALL of your saved information including names, emails and app data will be deleted. This data is not recoverable.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0,
                      height: 1.5,
                    ),
                  ),
                ),
                Spacer(),
                Column(
                  children: [
                    Builder(
                      builder: (context) => SizedBox(
                        width: double.infinity,
                        height: 56.0,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final result =
                                await actions.permanentlyDeleteAccount();
                            if ((result is Map) ? result['success'] : false) {
                              await showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return Dialog(
                                    elevation: 0,
                                    insetPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    alignment: Alignment.center
                                        .resolve(Directionality.of(context)),
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(dialogContext).unfocus();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      child: SettingsDialogWidget(
                                        title: 'Account Deleted',
                                        subtitle:
                                            'Your account deletion has been confirmed.',
                                        action: () async {
                                          Navigator.pop(context);

                                          context.goNamed(
                                            SignUpWidget.routeName,
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              await actions.toastificationshow(
                                context,
                                'Error!',
                                ((result is Map) ? result['error'] : '')
                                    .toString(),
                                'error',
                              );
                            }
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.trash,
                            size: 16.0,
                            color: AppColors.destructive500,
                          ),
                          label: Text(
                            'Delete Account',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 17.0,
                              color: AppColors.destructive500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.destructive500,
                              width: 1.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56.0,
                        child: OutlinedButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: Text(
                            'Back',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 17.0,
                              color: Colors.white,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.neutral800,
                              width: 1.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ].addToEnd(SizedBox(height: 32.0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

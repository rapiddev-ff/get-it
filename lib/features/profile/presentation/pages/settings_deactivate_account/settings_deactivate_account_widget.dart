import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsDeactivateAccountWidget extends StatelessWidget {
  const SettingsDeactivateAccountWidget({super.key});

  static String routeName = 'settingsDeactivateAccount';
  static String routePath = 'settingsDeactivateAccount';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
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
            'Deactivate Account',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
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
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                  child: Text(
                    'Are you sure you want to deactivate your account?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 24.0,
                      height: 1.5,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                  child: Text(
                    'If you choose to deactivate your account, you will need to reactivate your account by signing in the future. ',
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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56.0,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          print('Button pressed ...');
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.powerOff,
                          size: 16.0,
                          color: AppColors.destructive500,
                        ),
                        label: Text(
                          'Deactivate Account',
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
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
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
                              color: Color(0xFF545454),
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

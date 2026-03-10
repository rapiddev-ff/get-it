import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '/core/theme/app_colors.dart';
import '/core/widgets/dismiss_keyboard.dart';

class SettingsPrivacyWidget extends StatelessWidget {
  const SettingsPrivacyWidget({super.key});

  static String routeName = 'settingsPrivacy';
  static String routePath = 'settingsPrivacy';

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(119.0),
          child: AppBar(
            backgroundColor: AppColors.backgroundSecondary,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Padding(
                padding: EdgeInsets.only(bottom: 14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                context.pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Privacy Policy',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 28.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              expandedTitleScale: 1.0,
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, top: 32.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Accepting The Terms',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sit amet ex mattis, lobortis ante vitae, bibendum ex. Vestibulum feugiat mi eu tincidunt congue. Nam viverra. Lorem ipsum dolor ',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: Text(
                    'Using CardSmart App',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam sit amet ex mattis, lobortis ante vitae, bibendum ex. Vestibulum feugiat mi eu tincidunt congue. Nam viverra. Lorem ipsum dolor ',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0,
                      color: AppColors.textSecondary,
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

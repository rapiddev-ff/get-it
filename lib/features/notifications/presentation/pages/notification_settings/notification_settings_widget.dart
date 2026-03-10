import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '/core/theme/app_colors.dart';
import '/core/widgets/dismiss_keyboard.dart';

class NotificationSettingsWidget extends StatefulWidget {
  const NotificationSettingsWidget({super.key});

  static String routeName = 'notificationSettings';
  static String routePath = 'notificationSettings';

  @override
  State<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(119.0),
          child: AppBar(
            backgroundColor: AppColors.backgroundSecondary,
            automaticallyImplyLeading: false,
            actions: const [],
            flexibleSpace: FlexibleSpaceBar(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: IconButton(
                              style: IconButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                fixedSize: const Size(44.0, 44.0),
                              ),
                              icon: const Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              onPressed: () => context.pop(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        'Notification Settings',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
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
            padding: const EdgeInsets.only(left: 16.0, top: 32.0, right: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Notification Type',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Switch.adaptive(
                      value: _switchValue,
                      onChanged: (newValue) {
                        setState(() => _switchValue = newValue);
                      },
                      activeThumbColor: AppColors.primary,
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: AppColors.alternate,
                      inactiveThumbColor: AppColors.backgroundSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

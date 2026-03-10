import '/core/theme/app_colors.dart';
import '/core/widgets/app_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DialogWidget extends StatelessWidget {
  const DialogWidget({
    super.key,
    required this.action,
    String? title,
    String? subtitle,
    Color? bgColor,
    required this.icon,
    String? actionText,
  })  : this.title = title ?? 'N/A',
        this.subtitle = subtitle ?? 'N/A',
        this.bgColor = bgColor ?? const Color(0x548E6CFF),
        this.actionText = actionText ?? 'N/A';

  final Future Function()? action;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Widget? icon;
  final String actionText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(14.0),
                  child: icon!,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 24.0,
                    height: 1.5,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                    height: 1.5,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: AppGradientButton(
                  text: actionText,
                  onPressed: () async {
                    await action?.call();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

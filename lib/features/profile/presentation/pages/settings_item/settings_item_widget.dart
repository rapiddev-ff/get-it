import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsItemWidget extends StatelessWidget {
  const SettingsItemWidget({
    super.key,
    String? tittle,
    String? value,
    required this.action,
    required this.showTrailingIcon,
  })  : this.tittle = tittle ?? 'N/A',
        this.value = value ?? 'N/A';

  final String tittle;
  final String value;
  final Future Function()? action;
  final bool? showTrailingIcon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await action?.call();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tittle,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      value,
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ].divide(SizedBox(height: 8.0)),
                ),
              ),
              if (showTrailingIcon ?? true)
                Icon(
                  Icons.chevron_right_outlined,
                  color: Color(0xFFAFAFB4),
                  size: 24.0,
                ),
            ].divide(SizedBox(width: 12.0)),
          ),
        ),
      ),
    );
  }
}

import '/core/theme/app_colors.dart';
import '/core/utils/value_utils.dart';
import '/core/widgets/app_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.icon,
    String? title,
    String? description,
    bool? hasButton,
    String? buttonText,
    this.buttonAction,
    double? sidePadding,
  })  : this.title = title ?? 'n/a',
        this.description = description ?? 'n/a',
        this.hasButton = hasButton ?? false,
        this.buttonText = buttonText ?? 'n/a',
        this.sidePadding = sidePadding ?? 16.0;

  final Widget? icon;
  final String title;
  final String description;
  final bool hasButton;

  /// t
  final String buttonText;

  final Future Function()? buttonAction;
  final double sidePadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
          valueOrDefault<double>(
            sidePadding,
            0.0,
          ),
          0.0,
          valueOrDefault<double>(
            sidePadding,
            0.0,
          ),
          0.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
                height: 1.5,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
          if (hasButton)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
              child: AppGradientButton(
                text: buttonText,
                height: 40.0,
                onPressed: () async {
                  await buttonAction?.call();
                },
              ),
            ),
        ],
      ),
    );
  }
}

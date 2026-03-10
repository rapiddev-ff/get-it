import '/core/theme/app_colors.dart';
import '/core/widgets/app_gradient_button.dart';
import 'package:flutter/material.dart';

class SettingsDialogWidget extends StatelessWidget {
  const SettingsDialogWidget({
    super.key,
    required this.action,
    String? title,
    String? subtitle,
  })  : this.title = title ?? 'N/A',
        this.subtitle = subtitle ?? 'N/A';

  final Future Function()? action;
  final String title;
  final String subtitle;

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
                  color: AppColors.destructive500.withValues(alpha: 0.26),
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
                padding: EdgeInsets.only(top: 24.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.w500, height: 1.5),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(height: 1.5),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: AppGradientButton(
                  text: 'Return to Login',
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

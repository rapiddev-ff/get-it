import 'package:flutter/material.dart';

import '/core/theme/app_colors.dart';

/// App-wide loading indicator with consistent primary color styling.
///
/// Use [AppLoadingIndicator.centered] for a centered version with padding.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.color = AppColors.primary,
    this.strokeWidth = 4.0,
    this.size,
  });

  /// Centered loading indicator with standard padding, typically used as
  /// full-page or section loading state.
  const AppLoadingIndicator.centered({
    super.key,
    this.color = AppColors.primary,
    this.strokeWidth = 4.0,
    this.size,
  });

  final Color color;
  final double strokeWidth;
  final double? size;

  @override
  Widget build(BuildContext context) {
    Widget indicator = CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(color),
      strokeWidth: strokeWidth,
    );

    if (size != null) {
      indicator = SizedBox(
        width: size,
        height: size,
        child: indicator,
      );
    }

    return indicator;
  }
}

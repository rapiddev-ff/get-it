import '/core/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';

/// Primary action button with the app's standard purple gradient.
///
/// When [enabled] is false, the gradient is replaced with a flat grey.
/// Wraps a [TextButton] inside a gradient [Container] for consistent styling.
class AppGradientButton extends StatelessWidget {
  const AppGradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.enabled = true,
    this.height = 56.0,
    this.borderRadius = 4.0,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool enabled;
  final double height;
  final double borderRadius;
  final bool isLoading;

  static const _activeStart = AppColors.brandPurple;
  static const _activeEnd = AppColors.brandBlue;
  static const _disabledColor = AppColors.surfaceDark;

  @override
  Widget build(BuildContext context) {
    final isActive = enabled && onPressed != null;
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isActive ? _activeStart : _disabledColor,
            isActive ? _activeEnd : _disabledColor,
          ],
          stops: const [0.0, 1.0],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TextButton(
        onPressed: isActive ? onPressed : null,
        style: TextButton.styleFrom(
          minimumSize: Size(double.infinity, height),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child:
                    AppLoadingIndicator(strokeWidth: 2.5, color: Colors.white),
              )
            : Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
      ),
    );
  }
}

/// Secondary cancel/outline button used alongside [AppGradientButton].
class AppOutlineButton extends StatelessWidget {
  const AppOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 56.0,
    this.borderRadius = 4.0,
  });

  final String text;
  final VoidCallback? onPressed;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: Size(double.infinity, height),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          side: const BorderSide(color: AppColors.neutral800),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w500, fontSize: 17.0, color: Colors.white),
        ),
      ),
    );
  }
}

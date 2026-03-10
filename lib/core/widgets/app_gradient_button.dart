import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  static const _activeStart = Color(0xFF7D56FF);
  static const _activeEnd = Color(0xFF6187F1);
  static const _disabledColor = Color(0xFF363636);

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
          begin: const AlignmentDirectional(0.0, -1.0),
          end: const AlignmentDirectional(0, 1.0),
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
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16.0,
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
          side: const BorderSide(color: Color(0xFF545454)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 17.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

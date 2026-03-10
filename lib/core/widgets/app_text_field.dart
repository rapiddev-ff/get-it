import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/value_utils.dart';

/// Shared InputDecoration used across all form fields in the app.
///
/// Provides consistent styling with AppColors borders and rounded corners.
InputDecoration appInputDecoration(
  String hintText, {
  Widget? prefix,
  Widget? suffixIcon,
}) {
  final borderRadius = BorderRadius.circular(
    valueOrDefault<double>(AppConstants.radiusTextField4, 0.0),
  );
  return InputDecoration(
    isDense: false,
    prefix: prefix,
    suffixIcon: suffixIcon,
    hintText: hintText,
    hintStyle: GoogleFonts.inter(fontSize: 16.0, color: AppColors.textSecondary),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.neutral700, width: 1.0),
      borderRadius: borderRadius,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.secondary, width: 1.0),
      borderRadius: borderRadius,
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.error, width: 1.0),
      borderRadius: borderRadius,
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.error, width: 1.0),
      borderRadius: borderRadius,
    ),
  );
}

/// Standard text field style used across the app.
final appTextFieldStyle =
    GoogleFonts.inter(fontSize: 14.0, color: AppColors.textPrimary);

/// A standard text field widget with consistent app styling.
///
/// Wraps [TextFormField] with [appInputDecoration] and common defaults.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText = '',
    this.prefix,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.maxLengthEnforcement,
    this.buildCounter,
    this.autofocus = false,
    this.enabled = true,
    this.readOnly = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final Widget? prefix;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final InputCounterWidgetBuilder? buildCounter;
  final bool autofocus;
  final bool enabled;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      autofocus: autofocus,
      enabled: enabled,
      readOnly: readOnly,
      obscureText: obscureText,
      decoration: appInputDecoration(hintText, prefix: prefix, suffixIcon: suffixIcon),
      style: appTextFieldStyle,
      keyboardType: keyboardType,
      cursorColor: AppColors.textPrimary,
      enableInteractiveSelection: true,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      maxLengthEnforcement: maxLengthEnforcement,
      buildCounter: buildCounter,
    );
  }
}

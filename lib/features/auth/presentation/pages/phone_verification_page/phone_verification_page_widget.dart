import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '/backend/api_requests/api_calls.dart';
import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/auth/data/supabase_auth/auth_util.dart';
import '/features/auth/presentation/pages/phone_verification_page2/phone_verification_page2_widget.dart';
import 'phone_verification_page_model.dart';

export 'phone_verification_page_model.dart';

class PhoneVerificationPageWidget extends StatefulWidget {
  const PhoneVerificationPageWidget({
    super.key,
    required this.isOnboarding,
  });

  final bool? isOnboarding;

  static String routeName = 'phoneVerificationPage';
  static String routePath = 'phoneVerificationPage';

  @override
  State<PhoneVerificationPageWidget> createState() =>
      _PhoneVerificationPageWidgetState();
}

class _PhoneVerificationPageWidgetState
    extends State<PhoneVerificationPageWidget> with KeyboardVisibilityMixin {
  late PhoneVerificationPageModel _model;

  /// Returns null if the phone number is valid, or an error string if invalid.
  static String? _phoneValidationResult(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.trim().isEmpty) {
      return 'Phone number is required';
    }

    final digitsOnly = phoneNumber.trim().replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10) {
      return 'Phone number is too short';
    }

    if (digitsOnly.length > 15) {
      return 'Phone number is too long';
    }

    return null;
  }

  /// Strips all non-digit characters except a leading '+'.
  static String _formatPhoneNumber(String phone) {
    String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');

    if (phone.startsWith('+') && !cleaned.startsWith('+')) {
      cleaned = '+$cleaned';
    }

    return cleaned;
  }

  @override
  void initState() {
    super.initState();
    _model = PhoneVerificationPageModel();

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(() => setState(() {}));
    _model.textFieldMask = MaskTextInputFormatter(mask: '+# (###) ###-##-##');
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  bool get _isPhoneValid {
    final text = _model.textController!.text;
    final result = _phoneValidationResult(text);
    return (result == null || result.isEmpty) && text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () async {
              if (widget.isOnboarding!) {
                await authManager.signOut();
                context.go('/');
              } else {
                context.pop();
              }
            },
          ),
          title: Text(
            AppConstants.appName,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: const [],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Verify Your Account',
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Text(
                            'We\'ll send you a code to confirm it\'s you.',
                            style: Theme.of(context).textTheme.labelLarge!,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                'Phone Number',
                                style: GoogleFonts.inter(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TextFormField(
                                controller: _model.textController,
                                focusNode: _model.textFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.textController',
                                  const Duration(milliseconds: 100),
                                  () => setState(() {}),
                                ),
                                autofocus: false,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: false,
                                  hintText: 'Your phone number',
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.neutral700,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusTextField4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.secondary,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusTextField4),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusTextField4),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusTextField4),
                                  ),
                                ),
                                style: GoogleFonts.inter(),
                                keyboardType: TextInputType.number,
                                cursorColor: AppColors.textPrimary,
                                enableInteractiveSelection: true,
                                validator: (value) => _model
                                    .textControllerValidator
                                    ?.call(context, value),
                                inputFormatters: [_model.textFieldMask],
                              ),
                            ),
                            if (_phoneValidationResult(
                                        _model.textController!.text) !=
                                    null &&
                                _phoneValidationResult(
                                        _model.textController!.text) !=
                                    '' &&
                                _model.textController!.text != '')
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  _phoneValidationResult(
                                          _model.textController!.text) ??
                                      'N/A',
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.error),
                                ).animate().fade(duration: 600.ms),
                              ),
                          ],
                        ),
                      ].addToStart(const SizedBox(height: 24.0)),
                    ),
                  ),
                ),
              ),
              if (!isKeyboardShowing(context))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppGradientButton(
                        text: 'Send',
                        enabled: _isPhoneValid,
                        borderRadius: 8.0,
                        onPressed: !_isPhoneValid
                            ? null
                            : () async {
                                await TwillioGroup.sendVerificationCall.call(
                                  to: _formatPhoneNumber(
                                      _model.textController!.text),
                                );

                                context.pushNamed(
                                  PhoneVerificationPage2Widget.routeName,
                                  queryParameters: {
                                    'phoneNumber': _model.textController!.text,
                                    'isOnborading':
                                        widget.isOnboarding.toString(),
                                  },
                                );
                              },
                      ),
                    ]
                        .divide(const SizedBox(height: 40.0))
                        .addToStart(const SizedBox(height: 24.0))
                        .addToEnd(const SizedBox(height: 32.0)),
                  ).animate().move(
                        begin: const Offset(0, 100),
                        end: Offset.zero,
                        duration: 600.ms,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

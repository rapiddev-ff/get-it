import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '/backend/supabase/supabase.dart';
import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/dismiss_keyboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/custom_code/actions/index.dart' as actions;
import '/features/auth/data/supabase_auth/auth_util.dart';
import '/features/auth/presentation/providers/auth_settings_provider.dart';
import '/features/auth/presentation/pages/phone_verification_page/phone_verification_page_widget.dart';
import '/features/auth/presentation/widgets/password_component/password_component_widget.dart';
import '/features/profile/presentation/pages/settings_privacy/settings_privacy_widget.dart';
import '/features/profile/presentation/pages/settings_terms/settings_terms_widget.dart';
import 'sign_up_model.dart';

export 'sign_up_model.dart';

class SignUpWidget extends ConsumerStatefulWidget {
  const SignUpWidget({super.key});

  static String routeName = 'signUp';
  static String routePath = 'signUp';

  @override
  ConsumerState<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends ConsumerState<SignUpWidget>
    with KeyboardVisibilityMixin {
  late SignUpModel _model;

  static bool _checkEmailFormat(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    _model = SignUpModel();
    _model.initState(context);

    _model.emailTextController ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textFieldFocusNode1!.addListener(() => setState(() {}));
    _model.passwordTextController ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textFieldFocusNode2!.addListener(() => setState(() {}));
    _model.confirmPasswordTextController ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
    _model.textFieldFocusNode3!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
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
            onPressed: () {
              context.pop();
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
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    AppConstants.paddingPage,
                    0.0,
                    AppConstants.paddingPage,
                    0.0,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Create Your Account ',
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Text(
                            'Let\'s get you started.',
                            style: Theme.of(context).textTheme.labelLarge!,
                          ),
                        ),
                        // Email section
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            AppConstants.paddingPage,
                            0.0,
                            AppConstants.paddingPage,
                            16.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Email',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, height: 1.4),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: _model.emailTextController,
                                  focusNode: _model.textFieldFocusNode1,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.emailTextController',
                                    const Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  onFieldSubmitted: (_) async {
                                    _model.textFieldFocusNode2?.requestFocus();
                                  },
                                  autofocus: false,
                                  obscureText: false,
                                  decoration:
                                      appInputDecoration('Your email address'),
                                  style: appTextFieldStyle,
                                  keyboardType: TextInputType.emailAddress,
                                  cursorColor: AppColors.textPrimary,
                                  enableInteractiveSelection: true,
                                ),
                              ),
                              if (_model.errorEmailRequired)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Please enter your email.',
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              if (_model.errorEmailFormat)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Check your email format.',
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              if (_model.emailAlreadyInUse)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Email already in use - try signing in instead.',
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                            ],
                          ),
                        ),
                        // Password section
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            AppConstants.paddingPage,
                            0.0,
                            AppConstants.paddingPage,
                            16.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Password',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, height: 1.4),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: _model.passwordTextController,
                                  focusNode: _model.textFieldFocusNode2,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.passwordTextController',
                                    const Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  onFieldSubmitted: (_) async {
                                    _model.textFieldFocusNode3?.requestFocus();
                                  },
                                  autofocus: false,
                                  obscureText: !_model.passwordVisibility1,
                                  decoration: appInputDecoration(
                                    'Your Password',
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() =>
                                            _model.passwordVisibility1 =
                                                !_model.passwordVisibility1);
                                      },
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        _model.passwordVisibility1
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.white,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                  style: appTextFieldStyle,
                                  keyboardType: TextInputType.emailAddress,
                                  cursorColor: AppColors.textPrimary,
                                  enableInteractiveSelection: true,
                                ),
                              ),
                              if (_model.errorPasswordRequired)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Password is required.',
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                            ],
                          ),
                        ),
                        // Confirm Password section
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            AppConstants.paddingPage,
                            0.0,
                            AppConstants.paddingPage,
                            24.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Confirm Password',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, height: 1.4),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextFormField(
                                  controller:
                                      _model.confirmPasswordTextController,
                                  focusNode: _model.textFieldFocusNode3,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.confirmPasswordTextController',
                                    const Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  obscureText: !_model.passwordVisibility2,
                                  decoration: appInputDecoration(
                                    'Confirm Your Password',
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() =>
                                            _model.passwordVisibility2 =
                                                !_model.passwordVisibility2);
                                      },
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        _model.passwordVisibility2
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.white,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                  style: appTextFieldStyle,
                                  keyboardType: TextInputType.emailAddress,
                                  cursorColor: AppColors.textPrimary,
                                  enableInteractiveSelection: true,
                                ),
                              ),
                              if (_model.errorConfirmPasswordRequired)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Confirm Password is required.',
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              if (_model.errorPaswordsDontMatch)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Passwords don\'t match',
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Column(
                                  children: [
                                    PasswordComponentWidget(
                                      isActive: (_model.passwordTextController
                                                  ?.text.length ??
                                              0) >=
                                          8,
                                      text: 'Minimum 8 characters',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: PasswordComponentWidget(
                                        isActive: _model
                                            .passwordTextController!.text
                                            .contains(RegExp(r'[A-Z]')),
                                        text: 'One uppercase letter (A-Z)',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: PasswordComponentWidget(
                                        isActive: _model
                                            .passwordTextController!.text
                                            .contains(RegExp(r'\d')),
                                        text: 'One number (0-9)',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: PasswordComponentWidget(
                                        isActive: _model
                                            .passwordTextController!.text
                                            .contains(RegExp(
                                                r'[!@#\$%^&*(),.?":{}|<>_\-]')),
                                        text: 'One special character (!@#\$%)',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: PasswordComponentWidget(
                                        isActive: (_model.passwordTextController
                                                    ?.text ==
                                                _model
                                                    .confirmPasswordTextController
                                                    ?.text) &&
                                            (_model.passwordTextController
                                                    ?.text !=
                                                ''),
                                        text: 'Passwords match',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ].addToStart(const SizedBox(height: 24.0)),
                    ),
                  ),
                ),
              ),
              if (!isKeyboardShowing(context))
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (!_model.checkBoxIsActive)
                            InkWell(
                              onTap: () {
                                _model.checkBoxIsActive =
                                    !_model.checkBoxIsActive;
                                setState(() {});
                              },
                              child: Container(
                                width: 22.0,
                                height: 22.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(
                                    color: AppColors.neutral700,
                                  ),
                                ),
                              ),
                            ),
                          if (_model.checkBoxIsActive)
                            InkWell(
                              onTap: () {
                                _model.checkBoxIsActive =
                                    !_model.checkBoxIsActive;
                                setState(() {});
                              },
                              child: Container(
                                width: 22.0,
                                height: 22.0,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: Border.all(
                                    color: AppColors.neutral700,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.check_sharp,
                                    color: Colors.white,
                                    size: 12.0,
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                            child: RichText(
                              textScaler: MediaQuery.of(context).textScaler,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'I accept the ',
                                    style: GoogleFonts.inter(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: GoogleFonts.inter(
                                      color: AppColors.textPrimary,
                                      decoration: TextDecoration.underline,
                                    ),
                                    mouseCursor: SystemMouseCursors.click,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        context.pushNamed(
                                            SettingsTermsWidget.routeName);
                                      },
                                  ),
                                  TextSpan(
                                    text: ' and ',
                                    style: GoogleFonts.inter(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: GoogleFonts.inter(
                                      color: AppColors.textPrimary,
                                      decoration: TextDecoration.underline,
                                    ),
                                    mouseCursor: SystemMouseCursors.click,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        context.pushNamed(
                                            SettingsPrivacyWidget.routeName);
                                      },
                                  ),
                                ],
                                style: GoogleFonts.inter(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ].divide(const SizedBox(width: 8.0)),
                      ),
                      if (!_model.checkBoxIsActive &&
                          (_model.confirmPasswordTextController!.text != ''))
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Terms not accepted',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.error),
                          ).animate().fade(duration: 600.ms),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: AppGradientButton(
                          text: 'Create Account',
                          onPressed: () async {
                            var shouldSetState = false;
                            _model.errorEmailRequired = false;
                            _model.errorEmailFormat = false;
                            _model.errorPasswordRequired = false;
                            _model.errorConfirmPasswordRequired = false;
                            _model.emailAlreadyInUse = false;
                            _model.errorPaswordsDontMatch = false;
                            setState(() {});

                            if (_model.emailTextController!.text != '') {
                              _model.errorEmailRequired = false;
                              setState(() {});
                            } else {
                              _model.errorEmailRequired = true;
                              setState(() {});
                              return;
                            }

                            if (_checkEmailFormat(
                                _model.emailTextController!.text)) {
                              _model.errorEmailFormat = false;
                              setState(() {});
                            } else {
                              _model.errorEmailFormat = true;
                              setState(() {});
                              return;
                            }

                            _model.isUserExist =
                                await actions.checkIsEmailRegistered(
                              _model.emailTextController!.text,
                            );
                            shouldSetState = true;
                            if (!_model.isUserExist!) {
                              _model.emailAlreadyInUse = false;
                              setState(() {});
                            } else {
                              _model.emailAlreadyInUse = true;
                              setState(() {});
                              if (shouldSetState) setState(() {});
                              return;
                            }

                            if (_model.passwordTextController!.text != '') {
                              _model.errorPasswordRequired = false;
                              setState(() {});
                            } else {
                              _model.errorPasswordRequired = true;
                              setState(() {});
                              if (shouldSetState) setState(() {});
                              return;
                            }

                            if (_model.confirmPasswordTextController!.text !=
                                '') {
                              _model.errorConfirmPasswordRequired = false;
                              setState(() {});
                            } else {
                              _model.errorConfirmPasswordRequired = true;
                              setState(() {});
                              if (shouldSetState) setState(() {});
                              return;
                            }

                            if (_model.passwordTextController!.text ==
                                _model.confirmPasswordTextController!.text) {
                              _model.errorPaswordsDontMatch = false;
                              setState(() {});
                            } else {
                              _model.errorPaswordsDontMatch = true;
                              setState(() {});
                              if (shouldSetState) setState(() {});
                              return;
                            }

                            if (!((_model.passwordTextController!.text.length >=
                                    8) &&
                                _model.passwordTextController!.text
                                    .contains(RegExp(r'[A-Z]')) &&
                                _model.passwordTextController!.text
                                    .contains(RegExp(r'\d')) &&
                                _model.passwordTextController!.text.contains(
                                    RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]')))) {
                              if (shouldSetState) setState(() {});
                              return;
                            }
                            if (!_model.checkBoxIsActive) {
                              HapticFeedback.lightImpact();
                              if (shouldSetState) setState(() {});
                              return;
                            }

                            if (_model.passwordTextController!.text !=
                                _model.confirmPasswordTextController!.text) {
                              actions.toastificationshow(context, 'Error',
                                  'Passwords don\'t match!', 'error');
                              return;
                            }

                            // Always keep signed in on registration
                            await ref
                                .read(keepSignedInProvider.notifier)
                                .set(true);

                            final user =
                                await authManager.createAccountWithEmail(
                              context,
                              _model.emailTextController!.text,
                              _model.passwordTextController!.text,
                            );
                            if (user == null) {
                              return;
                            }

                            await UserProfilesTable().insert({
                              'email': _model.emailTextController!.text,
                              'created_at': DateTime.now().toIso8601String(),
                              'user_id': ref.read(currentUserIdProvider),
                            });

                            context.goNamed(
                              PhoneVerificationPageWidget.routeName,
                              queryParameters: {
                                'isOnboarding': true.toString(),
                              },
                            );

                            if (shouldSetState) setState(() {});
                          },
                        ),
                      ),
                    ]
                        .addToStart(const SizedBox(height: 12.0))
                        .addToEnd(const SizedBox(height: 32.0)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

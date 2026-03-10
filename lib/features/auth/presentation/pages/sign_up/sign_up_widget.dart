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

class SignUpWidget extends ConsumerStatefulWidget {
  const SignUpWidget({super.key});

  static String routeName = 'signUp';
  static String routePath = 'signUp';

  @override
  ConsumerState<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends ConsumerState<SignUpWidget>
    with KeyboardVisibilityMixin {
  bool errorEmailRequired = false;
  bool errorEmailFormat = false;
  bool errorPasswordRequired = false;
  bool errorConfirmPasswordRequired = false;
  bool emailAlreadyInUse = false;
  bool checkBoxIsActive = false;
  bool errorPaswordsDontMatch = false;

  late final FocusNode textFieldFocusNode1;
  late final TextEditingController emailTextController;
  late final FocusNode textFieldFocusNode2;
  late final TextEditingController passwordTextController;
  bool passwordVisibility1 = false;
  late final FocusNode textFieldFocusNode3;
  late final TextEditingController confirmPasswordTextController;
  bool passwordVisibility2 = false;

  bool? isUserExist;

  static bool _checkEmailFormat(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  @override
  void initState() {
    super.initState();

    emailTextController = TextEditingController();
    textFieldFocusNode1 = FocusNode();
    passwordTextController = TextEditingController();
    textFieldFocusNode2 = FocusNode();
    confirmPasswordTextController = TextEditingController();
    textFieldFocusNode3 = FocusNode();
  }

  @override
  void dispose() {
    textFieldFocusNode1.dispose();
    emailTextController.dispose();
    textFieldFocusNode2.dispose();
    passwordTextController.dispose();
    textFieldFocusNode3.dispose();
    confirmPasswordTextController.dispose();
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
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingPage,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Create Your Account ',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontWeight: FontWeight.bold),
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
                          padding: EdgeInsets.only(
                            left: AppConstants.paddingPage,
                            right: AppConstants.paddingPage,
                            bottom: 16.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Email',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          height: 1.4),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: emailTextController,
                                  focusNode: textFieldFocusNode1,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'emailTextController',
                                    const Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  onFieldSubmitted: (_) async {
                                    textFieldFocusNode2.requestFocus();
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
                              if (errorEmailRequired)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Please enter your email.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              if (errorEmailFormat)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Check your email format.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              if (emailAlreadyInUse)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Email already in use - try signing in instead.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                            ],
                          ),
                        ),
                        // Password section
                        Padding(
                          padding: EdgeInsets.only(
                            left: AppConstants.paddingPage,
                            right: AppConstants.paddingPage,
                            bottom: 16.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Password',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          height: 1.4),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: passwordTextController,
                                  focusNode: textFieldFocusNode2,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'passwordTextController',
                                    const Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  onFieldSubmitted: (_) async {
                                    textFieldFocusNode3.requestFocus();
                                  },
                                  autofocus: false,
                                  obscureText: !passwordVisibility1,
                                  decoration: appInputDecoration(
                                    'Your Password',
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() => passwordVisibility1 =
                                            !passwordVisibility1);
                                      },
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        passwordVisibility1
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
                              if (errorPasswordRequired)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Password is required.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                            ],
                          ),
                        ),
                        // Confirm Password section
                        Padding(
                          padding: EdgeInsets.only(
                            left: AppConstants.paddingPage,
                            right: AppConstants.paddingPage,
                            bottom: 24.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Confirm Password',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          height: 1.4),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: confirmPasswordTextController,
                                  focusNode: textFieldFocusNode3,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'confirmPasswordTextController',
                                    const Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  obscureText: !passwordVisibility2,
                                  decoration: appInputDecoration(
                                    'Confirm Your Password',
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() => passwordVisibility2 =
                                            !passwordVisibility2);
                                      },
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        passwordVisibility2
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
                              if (errorConfirmPasswordRequired)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Confirm Password is required.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              if (errorPaswordsDontMatch)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Passwords don\'t match',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Column(
                                  children: [
                                    PasswordComponentWidget(
                                      isActive: (passwordTextController
                                              .text.length) >=
                                          8,
                                      text: 'Minimum 8 characters',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: PasswordComponentWidget(
                                        isActive: passwordTextController.text
                                            .contains(RegExp(r'[A-Z]')),
                                        text: 'One uppercase letter (A-Z)',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: PasswordComponentWidget(
                                        isActive: passwordTextController.text
                                            .contains(RegExp(r'\d')),
                                        text: 'One number (0-9)',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: PasswordComponentWidget(
                                        isActive: passwordTextController.text
                                            .contains(RegExp(
                                                r'[!@#\$%^&*(),.?":{}|<>_\-]')),
                                        text: 'One special character (!@#\$%)',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: PasswordComponentWidget(
                                        isActive: (passwordTextController
                                                    .text ==
                                                confirmPasswordTextController
                                                    .text) &&
                                            (passwordTextController.text != ''),
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
                          if (!checkBoxIsActive)
                            InkWell(
                              onTap: () {
                                checkBoxIsActive = !checkBoxIsActive;
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
                          if (checkBoxIsActive)
                            InkWell(
                              onTap: () {
                                checkBoxIsActive = !checkBoxIsActive;
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!,
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!,
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
                                style: Theme.of(context).textTheme.labelMedium!,
                              ),
                            ),
                          ),
                        ].divide(const SizedBox(width: 8.0)),
                      ),
                      if (!checkBoxIsActive &&
                          (confirmPasswordTextController.text != ''))
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Terms not accepted',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: AppColors.error),
                          ).animate().fade(duration: 600.ms),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: AppGradientButton(
                          text: 'Create Account',
                          onPressed: () async {
                            errorEmailRequired = false;
                            errorEmailFormat = false;
                            errorPasswordRequired = false;
                            errorConfirmPasswordRequired = false;
                            emailAlreadyInUse = false;
                            errorPaswordsDontMatch = false;
                            setState(() {});

                            if (emailTextController.text != '') {
                              errorEmailRequired = false;
                              setState(() {});
                            } else {
                              errorEmailRequired = true;
                              setState(() {});
                              return;
                            }

                            if (_checkEmailFormat(emailTextController.text)) {
                              errorEmailFormat = false;
                              setState(() {});
                            } else {
                              errorEmailFormat = true;
                              setState(() {});
                              return;
                            }

                            isUserExist = await actions.checkIsEmailRegistered(
                              emailTextController.text,
                            );
                            if (!isUserExist!) {
                              emailAlreadyInUse = false;
                              if (!mounted) return;
                              setState(() {});
                            } else {
                              emailAlreadyInUse = true;
                              setState(() {});
                              return;
                            }

                            if (passwordTextController.text != '') {
                              errorPasswordRequired = false;
                              setState(() {});
                            } else {
                              errorPasswordRequired = true;
                              setState(() {});
                              return;
                            }

                            if (confirmPasswordTextController.text != '') {
                              errorConfirmPasswordRequired = false;
                              setState(() {});
                            } else {
                              errorConfirmPasswordRequired = true;
                              setState(() {});
                              return;
                            }

                            if (passwordTextController.text ==
                                confirmPasswordTextController.text) {
                              errorPaswordsDontMatch = false;
                              setState(() {});
                            } else {
                              errorPaswordsDontMatch = true;
                              setState(() {});
                              return;
                            }

                            if (!((passwordTextController.text.length >= 8) &&
                                passwordTextController.text
                                    .contains(RegExp(r'[A-Z]')) &&
                                passwordTextController.text
                                    .contains(RegExp(r'\d')) &&
                                passwordTextController.text.contains(
                                    RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]')))) {
                              return;
                            }
                            if (!checkBoxIsActive) {
                              HapticFeedback.lightImpact();
                              return;
                            }

                            if (passwordTextController.text !=
                                confirmPasswordTextController.text) {
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
                              emailTextController.text,
                              passwordTextController.text,
                            );
                            if (user == null) {
                              return;
                            }

                            await UserProfilesTable().insert({
                              'email': emailTextController.text,
                              'created_at': DateTime.now().toIso8601String(),
                              'user_id': ref.read(currentUserIdProvider),
                            });

                            if (!mounted) return;
                            context.goNamed(
                              PhoneVerificationPageWidget.routeName,
                              queryParameters: {
                                'isOnboarding': true.toString(),
                              },
                            );
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

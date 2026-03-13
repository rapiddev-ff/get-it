import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '/features/home/presentation/pages/check_data/check_data_widget.dart';
import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/dismiss_keyboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/custom_code/actions/index.dart' as actions;

import '/features/auth/data/supabase_auth/auth_util.dart';
import '/features/auth/presentation/pages/forgot_password/forgot_password_widget.dart';
import '/features/auth/presentation/providers/auth_settings_provider.dart';

class SignInWidget extends ConsumerStatefulWidget {
  const SignInWidget({super.key});

  static String routeName = 'signIn';
  static String routePath = 'signIn';

  @override
  ConsumerState<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends ConsumerState<SignInWidget>
    with KeyboardVisibilityMixin {
  bool errorEmailRequired = false;
  bool errorEmailFormat = false;
  bool errorPasswordRequired = false;
  bool keepSignedIn = false;
  String? errorSignIn;

  late final FocusNode textFieldFocusNode1;
  late final TextEditingController emailTextController;
  late final FocusNode textFieldFocusNode2;
  late final TextEditingController passwordTextController;
  bool passwordVisibility = false;

  static final _emailRegExp =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.initPasswordResetDeepLink(
        context,
      );
    });

    emailTextController = TextEditingController();
    textFieldFocusNode1 = FocusNode();
    if (!mounted) return;
    passwordTextController = TextEditingController();
    textFieldFocusNode2 = FocusNode();
  }

  @override
  void dispose() {
    textFieldFocusNode1.dispose();
    emailTextController.dispose();
    textFieldFocusNode2.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24.0,
            ),
            iconSize: 24.0,
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            AppConstants.appName,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingPage),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 28.0),
                          child: Text(
                            'Sign In',
                            style: Theme.of(context).textTheme.headlineMedium!,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
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
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: emailTextController,
                                  focusNode: textFieldFocusNode1,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'emailTextController',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  onFieldSubmitted: (_) async {
                                    textFieldFocusNode2.requestFocus();
                                  },
                                  autofocus: false,
                                  enabled: true,
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
                                  padding: EdgeInsets.only(top: 4.0),
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
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Check your email format.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
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
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: passwordTextController,
                                  focusNode: textFieldFocusNode2,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'passwordTextController',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  enabled: true,
                                  obscureText: !passwordVisibility,
                                  decoration: appInputDecoration(
                                    'Your Password',
                                    suffixIcon: InkWell(
                                      onTap: () async {
                                        setState(() => passwordVisibility =
                                            !passwordVisibility);
                                      },
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        passwordVisibility
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: Colors.white,
                                        size: 24.0,
                                      ),
                                    ),
                                  ),
                                  style: appTextFieldStyle,
                                  keyboardType: TextInputType.visiblePassword,
                                  cursorColor: AppColors.textPrimary,
                                  enableInteractiveSelection: true,
                                ),
                              ),
                              if (errorPasswordRequired)
                                Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Password is required.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              if (errorSignIn != null && errorSignIn != '')
                                Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    errorSignIn ?? 'n/A',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              Padding(
                                padding: EdgeInsets.only(top: 24.0),
                                child: Row(
                                  children: [
                                    if (!keepSignedIn)
                                      InkWell(
                                        onTap: () async {
                                          keepSignedIn = !keepSignedIn;
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: 22.0,
                                          height: 22.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            border: Border.all(
                                              color: AppColors.neutral700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    if (keepSignedIn)
                                      InkWell(
                                        onTap: () async {
                                          keepSignedIn = !keepSignedIn;
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: 22.0,
                                          height: 22.0,
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            border: Border.all(
                                              color: AppColors.neutral700,
                                            ),
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.check_sharp,
                                              color: Colors.white,
                                              size: 12.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    Expanded(
                                      child: Text(
                                        'Keep me signed in',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!,
                                      ).animate().fade(duration: 600.ms),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        context.pushNamed(
                                            ForgotPasswordWidget.routeName);
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: AppColors.secondary),
                                      ),
                                    ).animate().fade(duration: 600.ms),
                                  ].divide(SizedBox(width: 8.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ].addToStart(SizedBox(height: 24.0)),
                    ),
                  ),
                ),
              ),
              if (!isKeyboardShowing(context))
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      AppGradientButton(
                        text: 'Sign In',
                        onPressed: () async {
                          errorEmailRequired = false;
                          errorEmailFormat = false;
                          errorPasswordRequired = false;
                          setState(() {});
                          if (emailTextController.text != '') {
                            errorEmailRequired = false;
                            setState(() {});
                          } else {
                            errorEmailRequired = true;
                            setState(() {});
                          }

                          if (_emailRegExp.hasMatch(emailTextController.text)) {
                            errorEmailFormat = false;
                            setState(() {});
                          } else {
                            errorEmailFormat = true;
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

                          setState(() {});

                          // Persist keepSignedIn preference via provider
                          await ref.read(keepSignedInProvider.notifier).set(
                                keepSignedIn,
                              );

                          final user = await authManager.signInWithEmail(
                            context,
                            emailTextController.text,
                            passwordTextController.text,
                          );

                          if (!mounted) return;

                          if (user != null) {
                            context.goNamed(
                              CheckDataWidget.routeName,
                              queryParameters: {
                                'fromSignIn': true.toString(),
                              },
                            );
                          } else {
                            errorSignIn =
                                'Email or password is incorrect. Please try again.';
                            setState(() {});
                          }
                        },
                      ),
                    ]
                        .divide(SizedBox(height: 24.0))
                        .addToEnd(SizedBox(height: 32.0)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '/backend/api_requests/api_calls.dart';
import '/core/constants/app_constants.dart';
import '/features/home/presentation/widgets/dialog/dialog_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/auth/presentation/pages/sign_in/sign_in_widget.dart';
import '/features/auth/presentation/widgets/password_component/password_component_widget.dart';

class ForgotPasswordStep3Widget extends StatefulWidget {
  const ForgotPasswordStep3Widget({
    super.key,
    required this.code,
  });

  final String? code;

  static String routeName = 'forgotPasswordStep3';
  static String routePath = 'forgotPasswordStep3';

  @override
  State<ForgotPasswordStep3Widget> createState() =>
      _ForgotPasswordStep3WidgetState();
}

class _ForgotPasswordStep3WidgetState extends State<ForgotPasswordStep3Widget>
    with KeyboardVisibilityMixin {
  bool errorPasswordRequired = false;
  bool errorConfirmPasswordRequired = false;
  bool errorPaswordsDontMatch = false;

  late final FocusNode textFieldFocusNode1;
  late final TextEditingController textController1;
  bool passwordVisibility1 = false;

  late final FocusNode textFieldFocusNode2;
  late final TextEditingController textController2;
  bool passwordVisibility2 = false;

  @override
  void initState() {
    super.initState();

    textController1 = TextEditingController();
    textFieldFocusNode1 = FocusNode();
    textFieldFocusNode1.addListener(() => setState(() {}));
    textController2 = TextEditingController();
    textFieldFocusNode2 = FocusNode();
    textFieldFocusNode2.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    textFieldFocusNode1.dispose();
    textController1.dispose();
    textFieldFocusNode2.dispose();
    textController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            AppConstants.appName,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingPage),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: AppConstants.paddingPage,
                              right: AppConstants.paddingPage,
                              bottom: 16.0),
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
                                  controller: textController1,
                                  focusNode: textFieldFocusNode1,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'textController1',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  enabled: true,
                                  obscureText: !passwordVisibility1,
                                  decoration: appInputDecoration(
                                    'Your Password',
                                    suffixIcon: InkWell(
                                      onTap: () async {
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
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: AppConstants.paddingPage,
                              right: AppConstants.paddingPage,
                              bottom: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
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
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: textController2,
                                  focusNode: textFieldFocusNode2,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'textController2',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  enabled: true,
                                  obscureText: !passwordVisibility2,
                                  decoration: appInputDecoration(
                                    'Confirm Your Password',
                                    suffixIcon: InkWell(
                                      onTap: () async {
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
                                  keyboardType: TextInputType.visiblePassword,
                                  cursorColor: AppColors.textPrimary,
                                  enableInteractiveSelection: true,
                                ),
                              ),
                              if (errorConfirmPasswordRequired)
                                Padding(
                                  padding: EdgeInsets.only(top: 4.0),
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
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Passwords don\'t match',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Column(
                                  children: [
                                    PasswordComponentWidget(
                                      isActive:
                                          (textController1.text.length) >= 8,
                                      text: 'Minimum 8 characters',
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.0),
                                      child: PasswordComponentWidget(
                                        isActive: (String text) {
                                          return text
                                              .contains(RegExp(r'[A-Z]'));
                                        }(textController1.text),
                                        text: 'One uppercase letter (A-Z)',
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.0),
                                      child: PasswordComponentWidget(
                                        isActive: (String text) {
                                          return text.contains(RegExp(r'\d'));
                                        }(textController1.text),
                                        text: 'One number (0-9)',
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.0),
                                      child: PasswordComponentWidget(
                                        isActive: (String text) {
                                          return text.contains(RegExp(
                                              r'[!@#\$%^&*(),.?":{}|<>_\-]'));
                                        }(textController1.text),
                                        text: 'One special character (!@#\$%)',
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 4.0),
                                      child: PasswordComponentWidget(
                                        isActive: (textController1.text ==
                                                textController2.text) &&
                                            (textController2.text != ''),
                                        text: 'Passwords match',
                                      ),
                                    ),
                                  ],
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
                        text: 'Reset Password',
                        onPressed: () async {
                          errorPasswordRequired = false;
                          errorConfirmPasswordRequired = false;
                          errorPaswordsDontMatch = false;
                          setState(() {});
                          if (textController1.text != '') {
                            errorPasswordRequired = false;
                            setState(() {});
                          } else {
                            errorPasswordRequired = true;
                            setState(() {});
                          }

                          if (textController2.text != '') {
                            errorConfirmPasswordRequired = false;
                            setState(() {});
                          } else {
                            errorConfirmPasswordRequired = true;
                            setState(() {});
                            return;
                          }

                          if (textController1.text == textController2.text) {
                            errorPaswordsDontMatch = false;
                            setState(() {});
                          } else {
                            errorPaswordsDontMatch = true;
                            setState(() {});
                            return;
                          }

                          if (errorPasswordRequired) return;

                          await SupabaseEdgeGroup.resetPasswordCall.call(
                            code: widget.code,
                            newPassword: textController2.text,
                          );

                          await actions.resetPasswordRecoveryState();
                          if (!mounted) return;
                          await showDialog(
                            context: context,
                            builder: (dialogContext) {
                              return Dialog(
                                elevation: 0,
                                insetPadding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                alignment: Alignment.center
                                    .resolve(Directionality.of(context)),
                                child: GestureDetector(
                                  onTap: () {
                                    FocusScope.of(dialogContext).unfocus();
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  child: DialogWidget(
                                    title: 'Password Reset Successful',
                                    subtitle:
                                        'Your password has been successfully updated.You can now log in using your new password.',
                                    bgColor: AppColors.primary
                                        .withValues(alpha: 0.2),
                                    icon: FaIcon(
                                      FontAwesomeIcons.circleCheck,
                                      color: AppColors.primary,
                                      size: 20.0,
                                    ),
                                    actionText: 'Go to Login',
                                    action: () async {
                                      Navigator.pop(context);

                                      context.goNamed(SignInWidget.routeName);
                                    },
                                  ),
                                ),
                              );
                            },
                          );
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

import '/features/auth/presentation/widgets/password_component/password_component_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class SettingsChangePasswordWidget extends StatefulWidget {
  const SettingsChangePasswordWidget({super.key});

  static String routeName = 'settingsChangePassword';
  static String routePath = 'settingsChangePassword';

  @override
  State<SettingsChangePasswordWidget> createState() =>
      _SettingsChangePasswordWidgetState();
}

class _SettingsChangePasswordWidgetState
    extends State<SettingsChangePasswordWidget> with KeyboardVisibilityMixin {
  // Local state fields
  bool errorConfirmPasswordRequired = false;
  bool errorCurrentPasswordRequired = false;
  bool errorPasswordRequired = false;
  bool passwordVisibility1 = false;
  bool passwordVisibility2 = false;
  bool passwordVisibility3 = false;

  // Text controllers and focus nodes
  late final TextEditingController textController1;
  late final FocusNode textFieldFocusNode1;
  late final TextEditingController textController2;
  late final FocusNode textFieldFocusNode2;
  late final TextEditingController textController3;
  late final FocusNode textFieldFocusNode3;

  // Action output result
  String? result;

  @override
  void initState() {
    super.initState();

    textController1 = TextEditingController();
    textFieldFocusNode1 = FocusNode();
    textController2 = TextEditingController();
    textFieldFocusNode2 = FocusNode();
    textController3 = TextEditingController();
    textFieldFocusNode3 = FocusNode();
  }

  @override
  void dispose() {
    textFieldFocusNode1.dispose();
    textController1.dispose();
    textFieldFocusNode2.dispose();
    textController2.dispose();
    textFieldFocusNode3.dispose();
    textController3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.backgroundSecondary,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () {
              context.pop();
            },
          ),
          title: Text(
            'Change Password',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.w500, color: Colors.white, height: 1.5),
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  'Current Password',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(height: 1.4),
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
                                  onFieldSubmitted: (_) async {
                                    textFieldFocusNode2.requestFocus();
                                  },
                                  autofocus: false,
                                  enabled: true,
                                  autofillHints: [AutofillHints.password],
                                  obscureText: !passwordVisibility1,
                                  decoration: appInputDecoration(
                                    'Enter Current Password',
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
                                        color: AppColors.textSecondary,
                                        size: 20.0,
                                      ),
                                    ),
                                  ),
                                  style: appTextFieldStyle,
                                  cursorColor: AppColors.textPrimary,
                                  enableInteractiveSelection: true,
                                ),
                              ),
                              if (errorCurrentPasswordRequired)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, top: 4.0),
                                  child: Text(
                                    'Current Password is required.',
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
                                padding: EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  'New Password',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(height: 1.4),
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
                                  onFieldSubmitted: (_) async {
                                    textFieldFocusNode3.requestFocus();
                                  },
                                  autofocus: false,
                                  enabled: true,
                                  autofillHints: [AutofillHints.password],
                                  obscureText: !passwordVisibility2,
                                  decoration: appInputDecoration(
                                    'Enter New Password',
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
                                        color: AppColors.textSecondary,
                                        size: 20.0,
                                      ),
                                    ),
                                  ),
                                  style: appTextFieldStyle,
                                  cursorColor: AppColors.textPrimary,
                                  enableInteractiveSelection: true,
                                ),
                              ),
                              if (errorPasswordRequired)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, top: 4.0),
                                  child: Text(
                                    'New Password is required.',
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
                          padding: EdgeInsets.only(bottom: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  'Confirm Password',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(height: 1.4),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: textController3,
                                  focusNode: textFieldFocusNode3,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    'textController3',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  enabled: true,
                                  autofillHints: [AutofillHints.password],
                                  obscureText: !passwordVisibility3,
                                  decoration: appInputDecoration(
                                    'Confirm New Password',
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() => passwordVisibility3 =
                                            !passwordVisibility3);
                                      },
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        passwordVisibility3
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: AppColors.textSecondary,
                                        size: 20.0,
                                      ),
                                    ),
                                  ),
                                  style: appTextFieldStyle,
                                  cursorColor: AppColors.textPrimary,
                                  enableInteractiveSelection: true,
                                ),
                              ),
                              if (errorConfirmPasswordRequired)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, top: 4.0),
                                  child: Text(
                                    'Confirm Password is required.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: AppColors.error),
                                  ).animate().fade(duration: 600.ms),
                                ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            PasswordComponentWidget(
                              isActive: (textController2.text.length) >= 8,
                              text: 'Minimum 8 characters',
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: PasswordComponentWidget(
                                isActive: (String text) {
                                  return text.contains(RegExp(r'[A-Z]'));
                                }(textController2.text),
                                text: 'One uppercase letter (A-Z)',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: PasswordComponentWidget(
                                isActive: (String text) {
                                  return text.contains(RegExp(r'\d'));
                                }(textController2.text),
                                text: 'One number (0-9)',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: PasswordComponentWidget(
                                isActive: (String text) {
                                  return text.contains(
                                      RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]'));
                                }(textController2.text),
                                text: 'One special character (!@#\$%)',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: PasswordComponentWidget(
                                isActive: (textController2.text ==
                                        textController3.text) &&
                                    (textController2.text != ''),
                                text: 'Passwords match',
                              ),
                            ),
                          ],
                        ),
                      ].addToStart(SizedBox(height: 24.0)),
                    ),
                  ),
                ),
              ),
              if (!isKeyboardShowing(context))
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppGradientButton(
                        text: 'Change Password',
                        onPressed: () async {
                          errorConfirmPasswordRequired = false;
                          errorCurrentPasswordRequired = false;
                          errorPasswordRequired = false;
                          setState(() {});
                          if (textController1.text != '') {
                            errorCurrentPasswordRequired = false;
                          } else {
                            errorCurrentPasswordRequired = true;
                            setState(() {});
                            return;
                          }

                          if (textController2.text != '') {
                            errorPasswordRequired = false;
                          } else {
                            errorPasswordRequired = true;
                            setState(() {});
                            return;
                          }

                          if (textController3.text != '') {
                            errorConfirmPasswordRequired = false;
                          } else {
                            errorConfirmPasswordRequired = true;
                            setState(() {});
                            return;
                          }

                          // Client-side password strength validation
                          final newPw = textController2.text;
                          final confirmPw = textController3.text;
                          if (newPw.length < 8 ||
                              !newPw.contains(RegExp(r'[A-Z]')) ||
                              !newPw.contains(RegExp(r'\d')) ||
                              !newPw.contains(
                                  RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]')) ||
                              newPw != confirmPw) {
                            await actions.toastificationshow(
                              context,
                              'Error!',
                              'Please meet all password requirements.',
                              'error',
                            );
                            return;
                          }

                          result = await actions.changePassword(
                            textController1.text,
                            textController3.text,
                          );
                          if (result == null || result == '') {
                            if (!mounted) return;
                            context.pop();
                            await actions.toastificationshow(
                              context,
                              'Success!',
                              'Password has been updated!',
                              'success',
                            );
                          } else {
                            await actions.toastificationshow(
                              context,
                              'Error!',
                              result!,
                              'error',
                            );
                          }

                          if (!mounted) return;
                          setState(() {});
                        },
                      ),
                      AppOutlineButton(
                        text: 'Cancel',
                        onPressed: () {
                          context.pop();
                        },
                      ),
                    ]
                        .divide(SizedBox(height: 16.0))
                        .addToStart(SizedBox(height: 24.0))
                        .addToEnd(SizedBox(height: 32.0)),
                  ).animate().move(
                        begin: Offset(0, 100),
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

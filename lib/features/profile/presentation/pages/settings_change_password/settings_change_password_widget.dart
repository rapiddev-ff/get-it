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
import 'settings_change_password_model.dart';

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
  late SettingsChangePasswordModel _model;

  @override
  void initState() {
    super.initState();
    _model = SettingsChangePasswordModel();

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textFieldFocusNode1!.addListener(() => setState(() {}));
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textFieldFocusNode2!.addListener(() => setState(() {}));
    _model.textController3 ??= TextEditingController();
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
                                  controller: _model.textController1,
                                  focusNode: _model.textFieldFocusNode1,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.textController1',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  onFieldSubmitted: (_) async {
                                    _model.textFieldFocusNode2?.requestFocus();
                                  },
                                  autofocus: false,
                                  enabled: true,
                                  autofillHints: [AutofillHints.password],
                                  obscureText: !_model.passwordVisibility1,
                                  decoration: appInputDecoration(
                                    'Enter Current Password',
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
                              if (_model.errorCurrentPasswordRequired)
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
                                  controller: _model.textController2,
                                  focusNode: _model.textFieldFocusNode2,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.textController2',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  onFieldSubmitted: (_) async {
                                    _model.textFieldFocusNode3?.requestFocus();
                                  },
                                  autofocus: false,
                                  enabled: true,
                                  autofillHints: [AutofillHints.password],
                                  obscureText: !_model.passwordVisibility2,
                                  decoration: appInputDecoration(
                                    'Enter New Password',
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
                              if (_model.errorPasswordRequired)
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
                                  controller: _model.textController3,
                                  focusNode: _model.textFieldFocusNode3,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.textController3',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  enabled: true,
                                  autofillHints: [AutofillHints.password],
                                  obscureText: !_model.passwordVisibility3,
                                  decoration: appInputDecoration(
                                    'Confirm New Password',
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() =>
                                            _model.passwordVisibility3 =
                                                !_model.passwordVisibility3);
                                      },
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        _model.passwordVisibility3
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
                              if (_model.errorConfirmPasswordRequired)
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
                              isActive:
                                  (_model.textController2!.text.length) >= 8,
                              text: 'Minimum 8 characters',
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: PasswordComponentWidget(
                                isActive: (String text) {
                                  return text.contains(RegExp(r'[A-Z]'));
                                }(_model.textController2!.text),
                                text: 'One uppercase letter (A-Z)',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: PasswordComponentWidget(
                                isActive: (String text) {
                                  return text.contains(RegExp(r'\d'));
                                }(_model.textController2!.text),
                                text: 'One number (0-9)',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: PasswordComponentWidget(
                                isActive: (String text) {
                                  return text.contains(
                                      RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]'));
                                }(_model.textController2!.text),
                                text: 'One special character (!@#\$%)',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.0),
                              child: PasswordComponentWidget(
                                isActive: (_model.textController2!.text ==
                                        _model.textController3!.text) &&
                                    (_model.textController2!.text != ''),
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
                          _model.errorConfirmPasswordRequired = false;
                          _model.errorCurrentPasswordRequired = false;
                          _model.errorPasswordRequired = false;
                          setState(() {});
                          if (_model.textController1!.text != '') {
                            _model.errorCurrentPasswordRequired = false;
                          } else {
                            _model.errorCurrentPasswordRequired = true;
                            setState(() {});
                            return;
                          }

                          if (_model.textController2!.text != '') {
                            _model.errorPasswordRequired = false;
                          } else {
                            _model.errorPasswordRequired = true;
                            setState(() {});
                            return;
                          }

                          if (_model.textController3!.text != '') {
                            _model.errorConfirmPasswordRequired = false;
                          } else {
                            _model.errorConfirmPasswordRequired = true;
                            setState(() {});
                            return;
                          }

                          // Client-side password strength validation
                          final newPw = _model.textController2!.text;
                          final confirmPw = _model.textController3!.text;
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

                          _model.result = await actions.changePassword(
                            _model.textController1!.text,
                            _model.textController3!.text,
                          );
                          if (_model.result == null || _model.result == '') {
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
                              _model.result!,
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

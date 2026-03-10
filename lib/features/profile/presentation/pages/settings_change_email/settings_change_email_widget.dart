import '/features/auth/data/supabase_auth/auth_util.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'settings_change_email_model.dart';

class SettingsChangeEmailWidget extends StatefulWidget {
  const SettingsChangeEmailWidget({
    super.key,
    required this.isOnboarding,
  });

  final bool? isOnboarding;

  static String routeName = 'settingsChangeEmail';
  static String routePath = 'settingsChangeEmail';

  @override
  State<SettingsChangeEmailWidget> createState() =>
      _SettingsChangeEmailWidgetState();
}

class _SettingsChangeEmailWidgetState extends State<SettingsChangeEmailWidget>
    with KeyboardVisibilityMixin {
  late SettingsChangeEmailModel _model;

  @override
  void initState() {
    super.initState();
    _model = SettingsChangeEmailModel();

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textFieldFocusNode1!.addListener(() => setState(() {}));
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textFieldFocusNode2!.addListener(() => setState(() {}));
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
        backgroundColor: AppColors.backgroundPrimary,
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
            'Edit Email',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
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
                                  style: GoogleFonts.inter(
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
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
                                  autofocus: false,
                                  enabled: true,
                                  autofillHints: [AutofillHints.password],
                                  obscureText: !_model.passwordVisibility,
                                  decoration: appInputDecoration(
                                    'Your password',
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        setState(() =>
                                            _model.passwordVisibility =
                                                !_model.passwordVisibility);
                                      },
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        _model.passwordVisibility
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
                                    'Password is required.',
                                    style: GoogleFonts.inter(
                                      color: AppColors.error,
                                      fontSize: 12.0,
                                    ),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              if (_model.errorPassword)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, top: 4.0),
                                  child: Text(
                                    'Incorrect password. Try again.',
                                    style: GoogleFonts.inter(
                                      color: AppColors.error,
                                      fontSize: 12.0,
                                    ),
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
                                  'New Email',
                                  style: GoogleFonts.inter(
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
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
                              if (_model.errorEmailRequired)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, top: 4.0),
                                  child: Text(
                                    'Please enter your email.',
                                    style: GoogleFonts.inter(
                                      color: AppColors.error,
                                      fontSize: 12.0,
                                    ),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              if (_model.errorEmailFormat)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, top: 4.0),
                                  child: Text(
                                    'Check your email format.',
                                    style: GoogleFonts.inter(
                                      color: AppColors.error,
                                      fontSize: 12.0,
                                    ),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              if (_model.emailAlreadyInUse)
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 16.0, top: 4.0),
                                  child: Text(
                                    'Email already in use.',
                                    style: GoogleFonts.inter(
                                      color: AppColors.error,
                                      fontSize: 12.0,
                                    ),
                                  ).animate().fade(duration: 600.ms),
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
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppGradientButton(
                        text: 'Save Changes',
                        onPressed: () async {
                          var _shouldSetState = false;
                          if (_model.textController1!.text != '') {
                            _model.errorPasswordRequired = false;
                            setState(() {});
                          } else {
                            _model.errorPasswordRequired = true;
                            setState(() {});
                            return;
                          }

                          _model.isCorrect = await actions.supabaseLogin(
                            currentUserEmail,
                            _model.textController1!.text,
                          );
                          _shouldSetState = true;
                          if (((_model.isCorrect is Map)
                              ? _model.isCorrect['success']
                              : false)) {
                            _model.errorPassword = false;
                            setState(() {});
                          } else {
                            _model.errorPassword = true;
                            setState(() {});
                            if (_shouldSetState) setState(() {});
                            return;
                          }

                          _model.errorEmailRequired = false;
                          _model.errorEmailFormat = false;
                          _model.emailAlreadyInUse = false;
                          setState(() {});
                          if (RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(_model.textController2!.text.trim())) {
                            _model.errorEmailFormat = false;
                            setState(() {});
                          } else {
                            _model.errorEmailFormat = true;
                            setState(() {});
                            if (_shouldSetState) setState(() {});
                            return;
                          }

                          _model.isEmailRegistered =
                              await actions.checkIsEmailRegistered(
                            _model.textController2!.text,
                          );
                          _shouldSetState = true;
                          if (!_model.isEmailRegistered!) {
                            _model.emailAlreadyInUse = false;
                            setState(() {});
                          } else {
                            _model.emailAlreadyInUse = true;
                            setState(() {});
                            if (_shouldSetState) setState(() {});
                            return;
                          }

                          _model.result =
                              await actions.changeUserEmailWithPasswordCheck(
                            context,
                            currentUserEmail,
                            _model.textController2!.text,
                            _model.textController1!.text,
                          );
                          _shouldSetState = true;
                          if ((_model.result is Map)
                              ? _model.result['success']
                              : false) {
                            context.pop();
                          } else {
                            await actions.toastificationshow(
                              context,
                              'Error!',
                              ((_model.result is Map)
                                      ? _model.result['error']
                                      : '')
                                  .toString(),
                              'error',
                            );
                          }

                          if (_shouldSetState) setState(() {});
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

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '/backend/api_requests/api_calls.dart';
import '/core/constants/app_constants.dart';
import '/features/home/presentation/widgets/dialog/dialog_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/app_text_field.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/auth/presentation/pages/sign_in/sign_in_widget.dart';
import '/features/auth/presentation/widgets/password_component/password_component_widget.dart';
import 'forgot_password_step3_model.dart';
export 'forgot_password_step3_model.dart';

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
  late ForgotPasswordStep3Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    _model = ForgotPasswordStep3Model();
    _model.initState(context);

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.backgroundPrimary,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundPrimary,
          automaticallyImplyLeading: false,
          title: Text(
            AppConstants.appName,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      AppConstants.paddingPage,
                      0.0,
                      AppConstants.paddingPage,
                      0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              AppConstants.paddingPage,
                              0.0,
                              AppConstants.paddingPage,
                              16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 8.0),
                                child: Text(
                                  'Password',
                                  style: GoogleFonts.inter(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
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
                                  obscureText: !_model.passwordVisibility1,
                                  decoration: appInputDecoration(
                                    'Your Password',
                                    suffixIcon: InkWell(
                                      onTap: () async {
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
                                  keyboardType: TextInputType.visiblePassword,
                                  cursorColor: AppColors.textPrimary,
                                  enableInteractiveSelection: true,
                                ),
                              ),
                              if (_model.errorPasswordRequired)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 0.0),
                                  child: Text(
                                    'Password is required.',
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
                          padding: EdgeInsetsDirectional.fromSTEB(
                              AppConstants.paddingPage,
                              0.0,
                              AppConstants.paddingPage,
                              24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 8.0),
                                child: Text(
                                  'Confirm Password',
                                  style: GoogleFonts.inter(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w500,
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
                                  obscureText: !_model.passwordVisibility2,
                                  decoration: appInputDecoration(
                                    'Confirm Your Password',
                                    suffixIcon: InkWell(
                                      onTap: () async {
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
                                  keyboardType: TextInputType.visiblePassword,
                                  cursorColor: AppColors.textPrimary,
                                  enableInteractiveSelection: true,
                                ),
                              ),
                              if (_model.errorConfirmPasswordRequired)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 0.0),
                                  child: Text(
                                    'Confirm Password is required.',
                                    style: GoogleFonts.inter(
                                      color: AppColors.error,
                                      fontSize: 12.0,
                                    ),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              if (_model.errorPaswordsDontMatch)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 0.0),
                                  child: Text(
                                    'Passwords don\'t match',
                                    style: GoogleFonts.inter(
                                      color: AppColors.error,
                                      fontSize: 12.0,
                                    ),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 20.0, 0.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    PasswordComponentWidget(
                                      isActive: (_model
                                              .textController1!.text.length) >=
                                          8,
                                      text: 'Minimum 8 characters',
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 4.0, 0.0, 0.0),
                                      child: PasswordComponentWidget(
                                        isActive: (String text) {
                                          return text
                                              .contains(RegExp(r'[A-Z]'));
                                        }(_model.textController1!.text),
                                        text: 'One uppercase letter (A-Z)',
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 4.0, 0.0, 0.0),
                                      child: PasswordComponentWidget(
                                        isActive: (String text) {
                                          return text.contains(RegExp(r'\d'));
                                        }(_model.textController1!.text),
                                        text: 'One number (0-9)',
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 4.0, 0.0, 0.0),
                                      child: PasswordComponentWidget(
                                        isActive: (String text) {
                                          return text.contains(RegExp(
                                              r'[!@#\$%^&*(),.?":{}|<>_\-]'));
                                        }(_model.textController1!.text),
                                        text: 'One special character (!@#\$%)',
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 4.0, 0.0, 0.0),
                                      child: PasswordComponentWidget(
                                        isActive: (_model
                                                    .textController1!.text ==
                                                _model.textController2!.text) &&
                                            (_model.textController2!.text !=
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
                      ].addToStart(SizedBox(height: 24.0)),
                    ),
                  ),
                ),
              ),
              if (!isKeyboardShowing(context))
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 32.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AppGradientButton(
                        text: 'Reset Password',
                        onPressed: () async {
                          _model.errorPasswordRequired = false;
                          _model.errorConfirmPasswordRequired = false;
                          _model.errorPaswordsDontMatch = false;
                          setState(() {});
                          if (_model.textController1!.text != '') {
                            _model.errorPasswordRequired = false;
                            setState(() {});
                          } else {
                            _model.errorPasswordRequired = true;
                            setState(() {});
                          }

                          if (_model.textController2!.text != '') {
                            _model.errorConfirmPasswordRequired = false;
                            setState(() {});
                          } else {
                            _model.errorConfirmPasswordRequired = true;
                            setState(() {});
                            return;
                          }

                          if (_model.textController1!.text ==
                              _model.textController2!.text) {
                            _model.errorPaswordsDontMatch = false;
                            setState(() {});
                          } else {
                            _model.errorPaswordsDontMatch = true;
                            setState(() {});
                            return;
                          }

                          if (_model.errorPasswordRequired) return;

                          await SupabaseEdgeGroup.resetPasswordCall.call(
                            code: widget.code,
                            newPassword: _model.textController2!.text,
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
                                alignment: AlignmentDirectional(0.0, 0.0)
                                    .resolve(Directionality.of(context)),
                                child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(dialogContext)
                                          .unfocus();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    child: DialogWidget(
                                      title: 'Password Reset Successful',
                                      subtitle:
                                          'Your password has been successfully updated.You can now log in using your new password.',
                                      bgColor: Color(0x338E6CFF),
                                      icon: FaIcon(
                                        FontAwesomeIcons.circleCheck,
                                        color: Color(0xFF8E6CFF),
                                        size: 20.0,
                                      ),
                                      actionText: 'Go to Login',
                                      action: () async {
                                        Navigator.pop(context);

                                        context.goNamed(
                                            SignInWidget.routeName);
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

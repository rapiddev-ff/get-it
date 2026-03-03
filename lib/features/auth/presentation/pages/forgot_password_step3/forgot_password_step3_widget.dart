import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'dart:async';

import '/backend/api_requests/api_calls.dart';
import '/core/constants/app_constants.dart';
import '/features/home/presentation/widgets/dialog/dialog_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
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

class _ForgotPasswordStep3WidgetState extends State<ForgotPasswordStep3Widget> {
  late ForgotPasswordStep3Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription<bool> _keyboardVisibilitySubscription;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _model = ForgotPasswordStep3Model();
    _model.initState(context);

    if (!kIsWeb) {
      _keyboardVisibilitySubscription =
          KeyboardVisibilityController().onChange.listen((bool visible) {
        setState(() {
          _isKeyboardVisible = visible;
        });
      });
    }

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

    if (!kIsWeb) {
      _keyboardVisibilitySubscription.cancel();
    }
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
                                  decoration: InputDecoration(
                                    isDense: false,
                                    hintText: 'Your Password',
                                    hintStyle: GoogleFonts.inter(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.textSecondary,
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
                                  style: GoogleFonts.inter(
                                    color: AppColors.textPrimary,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
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
                                  decoration: InputDecoration(
                                    isDense: false,
                                    hintText: 'Confirm Your Password',
                                    hintStyle: GoogleFonts.inter(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.textSecondary,
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
                                  style: GoogleFonts.inter(
                                    color: AppColors.textPrimary,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
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
              if (!(kIsWeb
                  ? MediaQuery.viewInsetsOf(context).bottom > 0
                  : _isKeyboardVisible))
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 32.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 56.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF7D56FF), Color(0xFF6187F1)],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(0.0, -1.0),
                            end: AlignmentDirectional(0, 1.0),
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Builder(
                          builder: (context) => TextButton(
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
                              }

                              await SupabaseEdgeGroup.resetPasswordCall.call(
                                code: widget.code,
                                newPassword: _model.textController2!.text,
                              );

                              await actions.resetPasswordRecoveryState();
                              await showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return Dialog(
                                    elevation: 0,
                                    insetPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    alignment: AlignmentDirectional(0.0, 0.0)
                                        .resolve(Directionality.of(context)),
                                    child: WebViewAware(
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
                                    ),
                                  );
                                },
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                            ),
                            child: Text(
                              'Reset Password',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
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

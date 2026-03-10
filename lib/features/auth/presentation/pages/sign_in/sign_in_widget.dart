import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '/features/home/presentation/pages/check_data/check_data_widget.dart';
import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/app_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/custom_code/actions/index.dart' as actions;

import '/features/auth/data/supabase_auth/auth_util.dart';
import '/features/auth/presentation/pages/forgot_password/forgot_password_widget.dart';
import '/features/auth/presentation/providers/auth_settings_provider.dart';
import 'sign_in_model.dart';

export 'sign_in_model.dart';

class SignInWidget extends ConsumerStatefulWidget {
  const SignInWidget({super.key});

  static String routeName = 'signIn';
  static String routePath = 'signIn';

  @override
  ConsumerState<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends ConsumerState<SignInWidget> {
  late SignInModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription<bool> _keyboardVisibilitySubscription;
  bool _isKeyboardVisible = false;

  static final _emailRegExp =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  @override
  void initState() {
    super.initState();
    _model = SignInModel();
    _model.initState(context);

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await actions.initPasswordResetDeepLink(
        context,
      );
    });

    if (!kIsWeb) {
      _keyboardVisibilitySubscription =
          KeyboardVisibilityController().onChange.listen((bool visible) {
        setState(() {
          _isKeyboardVisible = visible;
        });
      });
    }

    _model.emailTextController ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.textFieldFocusNode1!.addListener(() => setState(() {}));
    _model.passwordTextController ??= TextEditingController();
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
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
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
                              0.0, 0.0, 0.0, 28.0),
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 8.0),
                                child: Text(
                                  'Email',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: _model.emailTextController,
                                  focusNode: _model.textFieldFocusNode1,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.emailTextController',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  onFieldSubmitted: (_) async {
                                    _model.textFieldFocusNode2?.requestFocus();
                                  },
                                  autofocus: false,
                                  enabled: true,
                                  obscureText: false,
                                  decoration: appInputDecoration('Your email address'),
                                  style: appTextFieldStyle,
                                  keyboardType: TextInputType.emailAddress,
                                  cursorColor: AppColors.textPrimary,
                                  enableInteractiveSelection: true,
                                ),
                              ),
                              if (_model.errorEmailRequired)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 0.0),
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
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 0.0),
                                  child: Text(
                                    'Check your email format.',
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
                              0.0, 0.0, 0.0, 16.0),
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
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: _model.passwordTextController,
                                  focusNode: _model.textFieldFocusNode2,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.passwordTextController',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  enabled: true,
                                  obscureText: !_model.passwordVisibility,
                                  decoration: appInputDecoration(
                                    'Your Password',
                                    suffixIcon: InkWell(
                                      onTap: () async {
                                        setState(() =>
                                            _model.passwordVisibility =
                                                !_model.passwordVisibility);
                                      },
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        _model.passwordVisibility
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
                              if (_model.errorSignIn != null &&
                                  _model.errorSignIn != '')
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 0.0),
                                  child: Text(
                                    _model.errorSignIn ?? 'n/A',
                                    style: GoogleFonts.inter(
                                      color: AppColors.error,
                                      fontSize: 12.0,
                                    ),
                                  ).animate().fade(duration: 600.ms),
                                ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 24.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    if (!_model.keepSignedIn)
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          _model.keepSignedIn =
                                              !_model.keepSignedIn;
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
                                    if (_model.keepSignedIn)
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          _model.keepSignedIn =
                                              !_model.keepSignedIn;
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
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
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
                                        style: GoogleFonts.inter(
                                          color: AppColors.textPrimary,
                                          fontSize: 14.0,
                                        ),
                                      ).animate().fade(duration: 600.ms),
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        context.pushNamed(
                                            ForgotPasswordWidget.routeName);
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: GoogleFonts.inter(
                                          color: AppColors.secondary,
                                          fontSize: 14.0,
                                        ),
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
              if (!(kIsWeb
                  ? MediaQuery.viewInsetsOf(context).bottom > 0
                  : _isKeyboardVisible))
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 32.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AppGradientButton(
                        text: 'Sign In',
                        onPressed: () async {
                          _model.errorEmailRequired = false;
                          _model.errorEmailFormat = false;
                          _model.errorPasswordRequired = false;
                          setState(() {});
                          if (_model.emailTextController!.text != '') {
                            _model.errorEmailRequired = false;
                            setState(() {});
                          } else {
                            _model.errorEmailRequired = true;
                            setState(() {});
                          }

                          if (_emailRegExp
                              .hasMatch(_model.emailTextController!.text)) {
                            _model.errorEmailFormat = false;
                            setState(() {});
                          } else {
                            _model.errorEmailFormat = true;
                            setState(() {});
                            return;
                          }

                          if (_model.passwordTextController!.text != '') {
                            _model.errorPasswordRequired = false;
                            setState(() {});
                          } else {
                            _model.errorPasswordRequired = true;
                            setState(() {});
                            return;
                          }

                          setState(() {});

                          // Persist keepSignedIn preference via provider
                          await ref.read(keepSignedInProvider.notifier).set(
                            _model.keepSignedIn,
                          );

                          final user = await authManager.signInWithEmail(
                            context,
                            _model.emailTextController!.text,
                            _model.passwordTextController!.text,
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
                            _model.errorSignIn =
                                'Email or password is incorrect. Please try again';
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

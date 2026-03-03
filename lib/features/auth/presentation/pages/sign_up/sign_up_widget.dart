import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '/backend/supabase/supabase.dart';
import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/auth/data/supabase_auth/auth_util.dart';
import '/features/auth/presentation/pages/phone_verification_page/phone_verification_page_widget.dart';
import '/features/auth/presentation/widgets/password_component/password_component_widget.dart';
import '/features/profile/presentation/pages/settings_privacy/settings_privacy_widget.dart';
import '/features/profile/presentation/pages/settings_terms/settings_terms_widget.dart';
import 'sign_up_model.dart';

export 'sign_up_model.dart';

class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  static String routeName = 'signUp';
  static String routePath = 'signUp';

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  late SignUpModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription<bool> _keyboardVisibilitySubscription;
  bool _isKeyboardVisible = false;

  static bool _checkEmailFormat(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    _model = SignUpModel();
    _model.initState(context);

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
    _model.confirmPasswordTextController ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
    _model.textFieldFocusNode3!.addListener(() => setState(() {}));
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
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 8.0),
                          child: Text(
                            'Create Your Account ',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 24.0,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 24.0),
                          child: Text(
                            'Let\'s get you started.',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                              color: AppColors.textSecondary,
                            ),
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
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
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
                                    setState(() {
                                      _model.passwordTextController?.text = '';
                                      _model.textFieldFocusNode2
                                          ?.requestFocus();
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        _model.passwordTextController
                                                ?.selection =
                                            const TextSelection.collapsed(
                                                offset: 0);
                                      });
                                    });
                                  },
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    isDense: false,
                                    hintText: 'Your email address',
                                    hintStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16.0,
                                      color: AppColors.textSecondary,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.neutral700,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radiusTextField4),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.secondary,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radiusTextField4),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radiusTextField4),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radiusTextField4),
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
                              if (_model.errorEmailRequired)
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
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
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 0.0),
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
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 0.0),
                                  child: Text(
                                    'Email already in use - try signing in instead.',
                                    style: GoogleFonts.inter(
                                      color: AppColors.error,
                                      fontSize: 12.0,
                                    ),
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
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
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
                                    setState(() {
                                      _model.confirmPasswordTextController
                                          ?.text = '';
                                      _model.textFieldFocusNode3
                                          ?.requestFocus();
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        _model.confirmPasswordTextController
                                                ?.selection =
                                            const TextSelection.collapsed(
                                                offset: 0);
                                      });
                                    });
                                  },
                                  autofocus: false,
                                  obscureText: !_model.passwordVisibility1,
                                  decoration: InputDecoration(
                                    isDense: false,
                                    hintText: 'Your Password',
                                    hintStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16.0,
                                      color: AppColors.textSecondary,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.neutral700,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radiusTextField4),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.secondary,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radiusTextField4),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radiusTextField4),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radiusTextField4),
                                    ),
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
                                  padding: const EdgeInsetsDirectional.fromSTEB(
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
                        // Confirm Password section
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            AppConstants.paddingPage,
                            0.0,
                            AppConstants.paddingPage,
                            24.0,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 8.0),
                                child: Text(
                                  'Confirm Password',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                    height: 1.4,
                                  ),
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
                                  decoration: InputDecoration(
                                    isDense: false,
                                    hintText: 'Confirm Your Password',
                                    hintStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16.0,
                                      color: AppColors.textSecondary,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.neutral700,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radiusTextField4),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.secondary,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radiusTextField4),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radiusTextField4),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: AppColors.error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          AppConstants.radiusTextField4),
                                    ),
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
                                  padding: const EdgeInsetsDirectional.fromSTEB(
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
                                  padding: const EdgeInsetsDirectional.fromSTEB(
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
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 20.0, 0.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    PasswordComponentWidget(
                                      isActive: (_model.passwordTextController
                                                  ?.text.length ??
                                              0) >=
                                          8,
                                      text: 'Minimum 8 characters',
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 4.0, 0.0, 0.0),
                                      child: PasswordComponentWidget(
                                        isActive: _model
                                            .passwordTextController!.text
                                            .contains(RegExp(r'[A-Z]')),
                                        text: 'One uppercase letter (A-Z)',
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 4.0, 0.0, 0.0),
                                      child: PasswordComponentWidget(
                                        isActive: _model
                                            .passwordTextController!.text
                                            .contains(RegExp(r'\d')),
                                        text: 'One number (0-9)',
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 4.0, 0.0, 0.0),
                                      child: PasswordComponentWidget(
                                        isActive: _model
                                            .passwordTextController!.text
                                            .contains(RegExp(
                                                r'[!@#\$%^&*(),.?":{}|<>_\-]')),
                                        text: 'One special character (!@#\$%)',
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0.0, 4.0, 0.0, 0.0),
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
              if (!(kIsWeb
                  ? MediaQuery.viewInsetsOf(context).bottom > 0
                  : _isKeyboardVisible))
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      32.0, 0.0, 32.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (!_model.checkBoxIsActive)
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
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
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
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
                                child: const Align(
                                  alignment: AlignmentDirectional(0.0, 0.0),
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
                                      color: const Color(0xFFAFAFB4),
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
                                      color: const Color(0xFFAFAFB4),
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
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 4.0, 0.0, 0.0),
                          child: Text(
                            'Terms not accepted',
                            style: GoogleFonts.inter(
                              color: AppColors.error,
                              fontSize: 12.0,
                            ),
                          ).animate().fade(duration: 600.ms),
                        ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 24.0, 0.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          height: 56.0,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7D56FF), Color(0xFF6187F1)],
                              stops: [0.0, 1.0],
                              begin: AlignmentDirectional(0.0, -1.0),
                              end: AlignmentDirectional(0, 1.0),
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: TextButton(
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

                              if (!((_model.passwordTextController!.text
                                          .length >=
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Passwords don\'t match!',
                                    ),
                                  ),
                                );
                                return;
                              }

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
                                'user_id': currentUserUid,
                              });

                              context.goNamed(
                                PhoneVerificationPageWidget.routeName,
                                queryParameters: {
                                  'isOnboarding': true.toString(),
                                },
                              );

                              if (shouldSetState) setState(() {});
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            child: Text(
                              'Create Account',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
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

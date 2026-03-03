import '/features/auth/data/supabase_auth/auth_util.dart';
import '/core/theme/app_colors.dart';
import '/core/constants/app_constants.dart';
import '/core/utils/list_extensions.dart';
import 'dart:async';
import '/custom_code/actions/index.dart' as actions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
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

class _SettingsChangeEmailWidgetState extends State<SettingsChangeEmailWidget> {
  late SettingsChangeEmailModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription<bool> _keyboardVisibilitySubscription;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _model = SettingsChangeEmailModel();

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
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 4.0),
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
                                  decoration: InputDecoration(
                                    isDense: false,
                                    hintText: 'Your password',
                                    hintStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16.0,
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
                                  style: GoogleFonts.inter(),
                                  cursorColor: AppColors.textPrimary,
                                  enableInteractiveSelection: true,
                                ),
                              ),
                              if (_model.errorPasswordRequired)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 4.0, 0.0, 0.0),
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
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 4.0, 0.0, 0.0),
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
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 4.0),
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
                                  decoration: InputDecoration(
                                    isDense: false,
                                    hintText: 'Your email address',
                                    hintStyle: GoogleFonts.inter(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16.0,
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
                                  ),
                                  style: GoogleFonts.inter(),
                                  keyboardType: TextInputType.emailAddress,
                                  cursorColor: AppColors.textPrimary,
                                  enableInteractiveSelection: true,
                                ),
                              ),
                              if (_model.errorEmailRequired)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 4.0, 0.0, 0.0),
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
                                      16.0, 4.0, 0.0, 0.0),
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
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 4.0, 0.0, 0.0),
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
              if (!(kIsWeb
                  ? MediaQuery.viewInsetsOf(context).bottom > 0
                  : _isKeyboardVisible))
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                        child: TextButton(
                          onPressed: () async {
                            var _shouldSetState = false;
                            if (_model.textController1!.text != '') {
                              _model.errorPasswordRequired = false;
                              setState(() {});
                            } else {
                              _model.errorPasswordRequired = true;
                              setState(() {});
                              if (_shouldSetState) setState(() {});
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
                                .hasMatch(
                                    _model.textController2!.text.trim())) {
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
                          style: TextButton.styleFrom(
                            minimumSize: Size(double.infinity, 56.0),
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                          child: Text(
                            'Save Changes',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 56.0,
                        child: OutlinedButton(
                          onPressed: () {
                            context.pop();
                          },
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Color(0xFF545454),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
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

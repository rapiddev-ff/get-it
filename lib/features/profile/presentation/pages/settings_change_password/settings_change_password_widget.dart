import '/features/auth/presentation/widgets/password_component/password_component_widget.dart';
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
    extends State<SettingsChangePasswordWidget> {
  late SettingsChangePasswordModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  late StreamSubscription<bool> _keyboardVisibilitySubscription;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _model = SettingsChangePasswordModel();

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
    _model.textController3 ??= TextEditingController();
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
                                  onFieldSubmitted: (_) async {
                                    setState(() {
                                      _model.textController2?.text = '';
                                      _model.textFieldFocusNode2
                                          ?.requestFocus();
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        _model.textController2?.selection =
                                            const TextSelection.collapsed(
                                                offset: 0);
                                      });
                                    });
                                  },
                                  autofocus: false,
                                  enabled: true,
                                  autofillHints: [AutofillHints.password],
                                  obscureText: !_model.passwordVisibility1,
                                  decoration: InputDecoration(
                                    isDense: false,
                                    hintText: 'Enter Current Password',
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
                                  style: GoogleFonts.inter(),
                                  cursorColor: AppColors.textPrimary,
                                  enableInteractiveSelection: true,
                                ),
                              ),
                              if (_model.errorCurrentPasswordRequired)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 4.0, 0.0, 0.0),
                                  child: Text(
                                    'Current Password is required.',
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
                                  'New Password',
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
                                  onFieldSubmitted: (_) async {
                                    setState(() {
                                      _model.textController3?.text = '';
                                      _model.textFieldFocusNode3
                                          ?.requestFocus();
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        _model.textController3?.selection =
                                            const TextSelection.collapsed(
                                                offset: 0);
                                      });
                                    });
                                  },
                                  autofocus: false,
                                  enabled: true,
                                  autofillHints: [AutofillHints.password],
                                  obscureText: !_model.passwordVisibility2,
                                  decoration: InputDecoration(
                                    isDense: false,
                                    hintText: 'Enter New Password',
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
                                    'New Password is required.',
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
                              0.0, 0.0, 0.0, 24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 4.0),
                                child: Text(
                                  'Confirm Password',
                                  style: GoogleFonts.inter(
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
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
                                  decoration: InputDecoration(
                                    isDense: false,
                                    hintText: 'Confirm New Password',
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
                                  style: GoogleFonts.inter(),
                                  cursorColor: AppColors.textPrimary,
                                  enableInteractiveSelection: true,
                                ),
                              ),
                              if (_model.errorConfirmPasswordRequired)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 4.0, 0.0, 0.0),
                                  child: Text(
                                    'Confirm Password is required.',
                                    style: GoogleFonts.inter(
                                      color: AppColors.error,
                                      fontSize: 12.0,
                                    ),
                                  ).animate().fade(duration: 600.ms),
                                ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            PasswordComponentWidget(
                              isActive:
                                  (_model.textController2!.text.length) >= 8,
                              text: 'Minimum 8 characters',
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 0.0),
                              child: PasswordComponentWidget(
                                isActive: (String text) {
                                  return text.contains(RegExp(r'[A-Z]'));
                                }(_model.textController2!.text),
                                text: 'One uppercase letter (A-Z)',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 0.0),
                              child: PasswordComponentWidget(
                                isActive: (String text) {
                                  return text.contains(RegExp(r'\d'));
                                }(_model.textController2!.text),
                                text: 'One number (0-9)',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 0.0),
                              child: PasswordComponentWidget(
                                isActive: (String text) {
                                  return text.contains(
                                      RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-]'));
                                }(_model.textController2!.text),
                                text: 'One special character (!@#\$%)',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 0.0),
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
                            _model.errorConfirmPasswordRequired = false;
                            _model.errorCurrentPasswordRequired = false;
                            _model.errorPasswordRequired = false;
                            setState(() {});
                            if (_model.textController2!.text != '') {
                              _model.errorPasswordRequired = false;
                              setState(() {});
                            } else {
                              _model.errorPasswordRequired = true;
                              setState(() {});
                            }

                            if (_model.textController1!.text != '') {
                              _model.errorCurrentPasswordRequired = false;
                              setState(() {});
                            } else {
                              _model.errorCurrentPasswordRequired = true;
                              setState(() {});
                            }

                            if (_model.textController3!.text != '') {
                              _model.errorConfirmPasswordRequired = false;
                              setState(() {});
                            } else {
                              _model.errorConfirmPasswordRequired = true;
                              setState(() {});
                              if (_shouldSetState) setState(() {});
                              return;
                            }

                            _model.result = await actions.changePassword(
                              _model.textController1!.text,
                              _model.textController3!.text,
                            );
                            _shouldSetState = true;
                            if (_model.result == null || _model.result == '') {
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

                            if (_shouldSetState) setState(() {});
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size(double.infinity, 56.0),
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                          ),
                          child: Text(
                            'Change Password',
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

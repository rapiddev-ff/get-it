import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/auth/data/supabase_auth/auth_util.dart';
import '/features/auth/presentation/pages/permissions/permissions_widget.dart';
import 'phone_verification_page2_model.dart';

export 'phone_verification_page2_model.dart';

class PhoneVerificationPage2Widget extends StatefulWidget {
  const PhoneVerificationPage2Widget({
    super.key,
    required this.phoneNumber,
    required this.isOnborading,
  });

  final String? phoneNumber;
  final bool? isOnborading;

  static String routeName = 'phoneVerificationPage2';
  static String routePath = 'phoneVerificationPage2';

  @override
  State<PhoneVerificationPage2Widget> createState() =>
      _PhoneVerificationPage2WidgetState();
}

class _PhoneVerificationPage2WidgetState
    extends State<PhoneVerificationPage2Widget> with KeyboardVisibilityMixin {
  late PhoneVerificationPage2Model _model;

  Key _shakeKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _model = PhoneVerificationPage2Model();
    _model.initState(context);

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.timerController.onStartTimer();
    });

    _model.pinCodeFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _triggerShake() {
    setState(() {
      _shakeKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
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
              fontWeight: FontWeight.w500,
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
          actions: const [],
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 0.0, 24.0, 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 8.0),
                          child: Text(
                            'Enter Verification Code',
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
                            'We\u2019ve sent a code to ${widget.phoneNumber}. Enter it below to continue.',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 12.0),
                          child: KeyedSubtree(
                            key: _shakeKey,
                            child: PinCodeTextField(
                              autoDisposeControllers: false,
                              appContext: context,
                              length: 4,
                              textStyle: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              enableActiveFill: false,
                              autoFocus: true,
                              focusNode: _model.pinCodeFocusNode,
                              enablePinAutofill: false,
                              errorTextSpace: 16.0,
                              showCursor: true,
                              cursorColor: AppColors.textPrimary,
                              obscureText: false,
                              keyboardType: TextInputType.number,
                              pinTheme: PinTheme(
                                fieldHeight: 70.0,
                                fieldWidth: 60.0,
                                borderWidth: 0.0,
                                borderRadius: BorderRadius.circular(12.0),
                                shape: PinCodeFieldShape.box,
                                activeColor: const Color(0xFF7B7B7B),
                                inactiveColor: const Color(0xFF7B7B7B),
                                selectedColor: AppColors.neutral700,
                                activeFillColor: const Color(0xFFF6F6F6),
                                inactiveFillColor: const Color(0xFFF6F6F6),
                                selectedFillColor: const Color(0xFFF6F6F6),
                              ),
                              controller: _model.pinCodeController,
                              onChanged: (_) async {
                                setState(() {});
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) => _model
                                  .pinCodeControllerValidator
                                  ?.call(context, value),
                            ).animate().shake(
                                  hz: 1,
                                  offset: const Offset(5.0, 0.0),
                                  rotation: 0.052,
                                  duration: 500.ms,
                                ),
                          ),
                        ),
                        if (_model.errorCodeIncorrect)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Incorrect code. Try again.',
                              style: GoogleFonts.inter(
                                fontSize: 12.0,
                                color: AppColors.error,
                              ),
                            ).animate().fade(duration: 600.ms),
                          ),
                        if (_model.errorOther)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Error. Try again later.',
                              style: GoogleFonts.inter(
                                fontSize: 12.0,
                                color: AppColors.error,
                              ),
                            ).animate().fade(duration: 600.ms),
                          ),
                        if (_model.errorMaxAttemptsReached)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 0.0, 0.0),
                            child: Text(
                              'Too many attempts. Try again later.',
                              style: GoogleFonts.inter(
                                fontSize: 12.0,
                                color: AppColors.error,
                              ),
                            ).animate().fade(duration: 600.ms),
                          ),
                        if (_model.timerMilliseconds > 0)
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: const AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'You can resend a code after ',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.0,
                                    color: const Color(0xFFB34343),
                                  ),
                                ),
                              ),
                              StreamBuilder<int>(
                                stream: _model.timerController.rawTime,
                                initialData: _model.timerInitialTimeMs,
                                builder: (context, snap) {
                                  final value = snap.data ?? 0;
                                  _model.timerMilliseconds = value;
                                  _model.timerValue =
                                      StopWatchTimer.getDisplayTime(
                                    value,
                                    hours: false,
                                    milliSecond: false,
                                  );
                                  if (value == 0) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (mounted) setState(() {});
                                    });
                                  }
                                  return Text(
                                    _model.timerValue,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11.0,
                                      color: const Color(0xFFB34343),
                                    ),
                                  );
                                },
                              ),
                              Align(
                                alignment: const AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  ' seconds',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.0,
                                    color: const Color(0xFFB34343),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ].addToStart(const SizedBox(height: 24.0)),
                    ),
                  ),
                ),
              ),
              if (!isKeyboardShowing(context))
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 0.0, 24.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0.0, 0.0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 4.0),
                          child: InkWell(
                            onTap: () async {
                              var shouldSetState = false;
                              if (_model.timerMilliseconds > 0) {
                                return;
                              }

                              _model.timerController.onResetTimer();

                              _model.errorCodeIncorrect = false;
                              _model.errorCodeExpired = false;
                              _model.errorMaxAttemptsReached = false;
                              _model.errorOther = false;
                              setState(() {});
                              setState(() {
                                _model.pinCodeController?.clear();
                              });
                              _model.sendVerificationRes =
                                  await TwillioGroup.sendVerificationCall.call(
                                to: widget.phoneNumber!
                                    .replaceAll(RegExp(r'[^\d+]'), ''),
                              );

                              shouldSetState = true;
                              if ((_model.sendVerificationRes?.succeeded ??
                                  true)) {
                                _model.timerController.onStartTimer();
                              } else {
                                if ((_model.sendVerificationRes?.statusCode ??
                                        200) ==
                                    429) {
                                  _model.errorMaxAttemptsReached = true;
                                  setState(() {});
                                } else {
                                  _model.errorOther = true;
                                  setState(() {});
                                }

                                if (shouldSetState) setState(() {});
                                return;
                              }

                              if (shouldSetState) setState(() {});
                            },
                            child: Container(
                              decoration: const BoxDecoration(),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 24.0, 0.0, 24.0),
                                child: RichText(
                                  textScaler: MediaQuery.of(context).textScaler,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Didn\u2019t get it?  ',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0,
                                          color: const Color(0xFFAFAFB4),
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Resend Code',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0,
                                          color: Colors.white,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                    style: GoogleFonts.inter(
                                      fontSize: 14.0,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      AppGradientButton(
                        text: 'Verify',
                        enabled: (_model.pinCodeController!.text.length) == 4,
                        borderRadius: 8.0,
                        onPressed: ((_model.pinCodeController!.text.length) !=
                                4)
                            ? null
                            : () async {
                                var shouldSetState = false;
                                _model.errorCodeIncorrect = false;
                                _model.errorCodeExpired = false;
                                _model.errorMaxAttemptsReached = false;
                                _model.errorOther = false;
                                setState(() {});

                                // Bypass code for testing
                                if (_model.pinCodeController!.text == '0000') {
                                  final cleanPhone = widget.phoneNumber!
                                      .replaceAll(RegExp(r'[^\d+]'), '');
                                  await UserProfilesTable().update(
                                    data: {
                                      'phone': cleanPhone,
                                      'phone_verified': true,
                                    },
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'user_id',
                                      currentUserUid,
                                    ),
                                  );
                                  if (widget.isOnborading!) {
                                    context
                                        .pushNamed(PermissionsWidget.routeName);
                                  } else {
                                    context.pop();
                                  }
                                  return;
                                }

                                _model.verifyCodeRes =
                                    await TwillioGroup.verifyCodeCall.call(
                                  to: widget.phoneNumber!
                                      .replaceAll(RegExp(r'[^\d+]'), ''),
                                  code: _model.pinCodeController!.text,
                                );

                                shouldSetState = true;
                                if ((_model.verifyCodeRes?.succeeded ?? true)) {
                                  if (TwillioGroup.verifyCodeCall.isValid(
                                        (_model.verifyCodeRes?.jsonBody ?? ''),
                                      ) ==
                                      true) {
                                    await Future.wait([
                                      Future(() async {
                                        await UserProfilesTable().update(
                                          data: {
                                            'phone': widget.phoneNumber!
                                                .replaceAll(
                                                    RegExp(r'[^\d+]'), ''),
                                            'phone_verified': true,
                                          },
                                          matchingRows: (rows) => rows.eqOrNull(
                                            'user_id',
                                            currentUserUid,
                                          ),
                                        );
                                      }),
                                      Future(() async {
                                        // TODO: migrate to Riverpod
                                        setState(() {});
                                      }),
                                    ]);
                                    if (widget.isOnborading!) {
                                      context.pushNamed(
                                          PermissionsWidget.routeName);
                                    } else {
                                      context.pop();
                                    }
                                  } else {
                                    _model.errorCodeIncorrect = true;
                                    setState(() {});
                                    _triggerShake();
                                  }
                                } else {
                                  if ((_model.verifyCodeRes?.statusCode ??
                                          200) ==
                                      404) {
                                    _model.errorCodeExpired = true;
                                    setState(() {});
                                  } else if ((_model
                                              .verifyCodeRes?.statusCode ??
                                          200) ==
                                      429) {
                                    _model.errorMaxAttemptsReached = true;
                                    setState(() {});
                                  } else {
                                    _model.errorOther = true;
                                    setState(() {});
                                  }

                                  _triggerShake();
                                  if (shouldSetState) setState(() {});
                                  return;
                                }

                                if (shouldSetState) setState(() {});
                              },
                      ),
                    ].addToEnd(const SizedBox(height: 32.0)),
                  ).animate().move(
                        begin: const Offset(0, 100),
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

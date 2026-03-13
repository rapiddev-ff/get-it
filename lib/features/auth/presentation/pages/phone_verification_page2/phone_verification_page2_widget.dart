import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import '/features/auth/presentation/pages/permissions/permissions_widget.dart';

class PhoneVerificationPage2Widget extends ConsumerStatefulWidget {
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
  ConsumerState<PhoneVerificationPage2Widget> createState() =>
      _PhoneVerificationPage2WidgetState();
}

class _PhoneVerificationPage2WidgetState
    extends ConsumerState<PhoneVerificationPage2Widget>
    with KeyboardVisibilityMixin {
  bool isPinSet = false;
  bool errorCodeIncorrect = false;
  bool errorCodeExpired = false;
  bool errorMaxAttemptsReached = false;
  bool errorOther = false;

  late final TextEditingController pinCodeController;
  FocusNode? pinCodeFocusNode;

  final timerInitialTimeMs = 59000;
  int timerMilliseconds = 59000;
  String timerValue = StopWatchTimer.getDisplayTime(
    59000,
    hours: false,
    milliSecond: false,
  );
  late final StopWatchTimer timerController;

  ApiCallResponse? sendVerificationRes;
  ApiCallResponse? verifyCodeRes;

  Key _shakeKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    pinCodeController = TextEditingController();
    timerController = StopWatchTimer(mode: StopWatchMode.countDown);

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      timerController.onStartTimer();
    });

    pinCodeFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    pinCodeFocusNode?.dispose();
    pinCodeController.dispose();
    timerController.dispose();
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
        appBar: AppBar(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Enter Verification Code',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Text(
                            'We\u2019ve sent a code to ${widget.phoneNumber}. Enter it below to continue.',
                            style: Theme.of(context).textTheme.bodyLarge!,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: KeyedSubtree(
                            key: _shakeKey,
                            child: PinCodeTextField(
                              autoDisposeControllers: false,
                              appContext: context,
                              length: 4,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.white),
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              enableActiveFill: false,
                              autoFocus: true,
                              focusNode: pinCodeFocusNode,
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
                                activeColor: AppColors.neutral700,
                                inactiveColor: AppColors.neutral700,
                                selectedColor: AppColors.neutral700,
                                activeFillColor: AppColors.surfaceLight,
                                inactiveFillColor: AppColors.surfaceLight,
                                selectedFillColor: AppColors.surfaceLight,
                              ),
                              controller: pinCodeController,
                              onChanged: (_) async {
                                setState(() {});
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ).animate().shake(
                                  hz: 1,
                                  offset: const Offset(5.0, 0.0),
                                  rotation: 0.052,
                                  duration: 500.ms,
                                ),
                          ),
                        ),
                        if (errorCodeIncorrect)
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'The code you entered is incorrect. Please check and try again.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: AppColors.error),
                            ).animate().fade(duration: 600.ms),
                          ),
                        if (errorOther)
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'Something went wrong. Please try again later.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: AppColors.error),
                            ).animate().fade(duration: 600.ms),
                          ),
                        if (errorMaxAttemptsReached)
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              'Too many attempts. Try again later.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: AppColors.error),
                            ).animate().fade(duration: 600.ms),
                          ),
                        if (timerMilliseconds > 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  'You can resend a code after ',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.0,
                                    color: AppColors.errorDark,
                                  ),
                                ),
                              ),
                              StreamBuilder<int>(
                                stream: timerController.rawTime,
                                initialData: timerInitialTimeMs,
                                builder: (context, snap) {
                                  final value = snap.data ?? 0;
                                  timerMilliseconds = value;
                                  timerValue = StopWatchTimer.getDisplayTime(
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
                                    timerValue,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11.0,
                                      color: AppColors.errorDark,
                                    ),
                                  );
                                },
                              ),
                              Center(
                                child: Text(
                                  ' seconds',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.0,
                                    color: AppColors.errorDark,
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
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: InkWell(
                            onTap: () async {
                              if (timerMilliseconds > 0) {
                                return;
                              }

                              timerController.onResetTimer();

                              errorCodeIncorrect = false;
                              errorCodeExpired = false;
                              errorMaxAttemptsReached = false;
                              errorOther = false;
                              setState(() {});
                              setState(() {
                                pinCodeController.clear();
                              });
                              sendVerificationRes =
                                  await TwillioGroup.sendVerificationCall.call(
                                to: widget.phoneNumber!
                                    .replaceAll(RegExp(r'[^\d+]'), ''),
                              );
                              if ((sendVerificationRes?.succeeded ?? false)) {
                                timerController.onStartTimer();
                              } else {
                                if ((sendVerificationRes?.statusCode ?? 0) ==
                                    429) {
                                  errorMaxAttemptsReached = true;
                                  setState(() {});
                                } else {
                                  errorOther = true;
                                  setState(() {});
                                }

                                setState(() {});
                                return;
                              }

                              setState(() {});
                            },
                            child: Container(
                              decoration: const BoxDecoration(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24.0),
                                child: RichText(
                                  textScaler: MediaQuery.of(context).textScaler,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Didn\u2019t get it?  ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                      TextSpan(
                                        text: 'Resend Code',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                decoration:
                                                    TextDecoration.underline),
                                      ),
                                    ],
                                    style:
                                        Theme.of(context).textTheme.bodyMedium!,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      AppGradientButton(
                        text: 'Verify',
                        enabled: (pinCodeController.text.length) == 4,
                        borderRadius: 8.0,
                        onPressed: ((pinCodeController.text.length) != 4)
                            ? null
                            : () async {
                                errorCodeIncorrect = false;
                                errorCodeExpired = false;
                                errorMaxAttemptsReached = false;
                                errorOther = false;
                                setState(() {});

                                // Bypass code for testing
                                if (pinCodeController.text == '0000') {
                                  final cleanPhone = widget.phoneNumber!
                                      .replaceAll(RegExp(r'[^\d+]'), '');
                                  await UserProfilesTable().update(
                                    data: {
                                      'phone': cleanPhone,
                                      'phone_verified': true,
                                    },
                                    matchingRows: (rows) => rows.eqOrNull(
                                      'user_id',
                                      ref.read(currentUserIdProvider),
                                    ),
                                  );
                                  if (widget.isOnborading!) {
                                    context
                                        .pushNamed(PermissionsWidget.routeName);
                                  } else {
                                    if (!mounted) return;
                                    context.pop();
                                  }
                                  return;
                                }

                                verifyCodeRes =
                                    await TwillioGroup.verifyCodeCall.call(
                                  to: widget.phoneNumber!
                                      .replaceAll(RegExp(r'[^\d+]'), ''),
                                  code: pinCodeController.text,
                                );
                                if ((verifyCodeRes?.succeeded ?? false)) {
                                  final isValid =
                                      TwillioGroup.verifyCodeCall.isValid(
                                            verifyCodeRes?.jsonBody,
                                          ) ==
                                          true;
                                  final status =
                                      TwillioGroup.verifyCodeCall.status(
                                    verifyCodeRes?.jsonBody,
                                  );
                                  if (isValid ||
                                      status == 'approved') {
                                    final cleanPhone = widget.phoneNumber!
                                        .replaceAll(RegExp(r'[^\d+]'), '');
                                    await UserProfilesTable().update(
                                      data: {
                                        'phone': cleanPhone,
                                        'phone_verified': true,
                                      },
                                      matchingRows: (rows) => rows.eqOrNull(
                                        'user_id',
                                        ref.read(currentUserIdProvider),
                                      ),
                                    );
                                    if (!mounted) return;
                                    setState(() {});
                                    if (widget.isOnborading!) {
                                      context.pushNamed(
                                          PermissionsWidget.routeName);
                                    } else {
                                      context.pop();
                                    }
                                  } else {
                                    errorCodeIncorrect = true;
                                    setState(() {});
                                    _triggerShake();
                                  }
                                } else {
                                  if ((verifyCodeRes?.statusCode ?? 0) ==
                                      404) {
                                    errorCodeExpired = true;
                                    setState(() {});
                                  } else if ((verifyCodeRes?.statusCode ??
                                          0) ==
                                      429) {
                                    errorMaxAttemptsReached = true;
                                    setState(() {});
                                  } else {
                                    errorOther = true;
                                    setState(() {});
                                  }

                                  _triggerShake();
                                  setState(() {});
                                  return;
                                }

                                setState(() {});
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

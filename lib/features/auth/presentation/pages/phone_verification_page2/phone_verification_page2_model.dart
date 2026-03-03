import '/backend/api_requests/api_calls.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';

class PhoneVerificationPage2Model {
  bool isPinSet = false;
  bool errorCodeIncorrect = false;
  bool errorCodeExpired = false;
  bool errorMaxAttemptsReached = false;
  bool errorOther = false;

  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;

  final timerInitialTimeMs = 59000;
  int timerMilliseconds = 59000;
  String timerValue = StopWatchTimer.getDisplayTime(
    59000,
    hours: false,
    milliSecond: false,
  );
  late StopWatchTimer timerController;

  ApiCallResponse? sendVerificationRes;
  ApiCallResponse? verifyCodeRes;

  void initState(BuildContext context) {
    pinCodeController = TextEditingController();
    timerController = StopWatchTimer(mode: StopWatchMode.countDown);
  }

  void dispose() {
    pinCodeFocusNode?.dispose();
    pinCodeController?.dispose();
    timerController.dispose();
  }
}

import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'phone_verification_page2_widget.dart' show PhoneVerificationPage2Widget;
import 'package:flutter/material.dart';

class PhoneVerificationPage2Model
    extends FlutterFlowModel<PhoneVerificationPage2Widget> {
  ///  Local state fields for this page.

  bool isPinSet = false;

  bool errorCodeIncorrect = false;

  bool errorCodeExpired = false;

  bool errorMaxAttemptsReached = false;

  bool errorOther = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  // State field(s) for Timer widget.
  final timerInitialTimeMs = 59000;
  int timerMilliseconds = 59000;
  String timerValue = StopWatchTimer.getDisplayTime(
    59000,
    hours: false,
    milliSecond: false,
  );
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  // Stores action output result for [Backend Call - API (SendVerification)] action in ResendCodeBtn widget.
  ApiCallResponse? sendVerificationRes;
  // Stores action output result for [Backend Call - API (VerifyCode)] action in Button widget.
  ApiCallResponse? verifyCodeRes;

  @override
  void initState(BuildContext context) {
    pinCodeController = TextEditingController();
  }

  @override
  void dispose() {
    pinCodeFocusNode?.dispose();
    pinCodeController?.dispose();

    timerController.dispose();
  }
}

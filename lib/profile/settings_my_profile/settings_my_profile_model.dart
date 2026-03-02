import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'settings_my_profile_widget.dart' show SettingsMyProfileWidget;
import 'package:flutter/material.dart';

class SettingsMyProfileModel extends FlutterFlowModel<SettingsMyProfileWidget> {
  ///  Local state fields for this page.

  String? state = 'As Buyer';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (getuserprofilewithreviews)] action in settingsMyProfile widget.
  ApiCallResponse? getReviews;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

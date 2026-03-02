import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'chat_buyer_profile_widget.dart' show ChatBuyerProfileWidget;
import 'package:flutter/material.dart';

class ChatBuyerProfileModel extends FlutterFlowModel<ChatBuyerProfileWidget> {
  ///  Local state fields for this page.

  String? state = 'As Buyer';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (getuserprofilewithreviews)] action in chatBuyerProfile widget.
  ApiCallResponse? getReviews;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

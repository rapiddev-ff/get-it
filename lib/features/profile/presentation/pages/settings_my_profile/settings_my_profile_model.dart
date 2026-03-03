import '/backend/api_requests/api_calls.dart';

class SettingsMyProfileModel {
  ///  Local state fields for this page.

  String? state = 'As Buyer';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (getuserprofilewithreviews)] action in settingsMyProfile widget.
  ApiCallResponse? getReviews;

  void dispose() {}
}

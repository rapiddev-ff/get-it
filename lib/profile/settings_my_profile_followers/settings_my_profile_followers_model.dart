import '/components/follower_item_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/profile/settings_blocked_user_item/settings_blocked_user_item_widget.dart';
import 'settings_my_profile_followers_widget.dart'
    show SettingsMyProfileFollowersWidget;
import 'package:flutter/material.dart';

class SettingsMyProfileFollowersModel
    extends FlutterFlowModel<SettingsMyProfileFollowersWidget> {
  ///  Local state fields for this page.

  String? state = 'As Buyer';

  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // Model for followerItem component.
  late FollowerItemModel followerItemModel;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // Model for settingsBlockedUserItem component.
  late SettingsBlockedUserItemModel settingsBlockedUserItemModel;

  @override
  void initState(BuildContext context) {
    followerItemModel = createModel(context, () => FollowerItemModel());
    settingsBlockedUserItemModel =
        createModel(context, () => SettingsBlockedUserItemModel());
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    followerItemModel.dispose();
    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    settingsBlockedUserItemModel.dispose();
  }
}

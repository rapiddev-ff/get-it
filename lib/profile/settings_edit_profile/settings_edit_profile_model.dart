import '/flutter_flow/flutter_flow_util.dart';
import 'settings_edit_profile_widget.dart' show SettingsEditProfileWidget;
import 'package:flutter/material.dart';

class SettingsEditProfileModel
    extends FlutterFlowModel<SettingsEditProfileWidget> {
  ///  Local state fields for this page.

  FFUploadedFile? image;

  String? username;

  bool usernameAvailable = true;

  bool isUsernameEdited = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - convertUrlToUploadedFile] action in settingsEditProfile widget.
  FFUploadedFile? convertToUploadedFile;
  bool isDataUploading_uploadData7l8 = false;
  FFUploadedFile uploadedLocalFile_uploadData7l8 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Custom Action - uploadImageToStorage] action in ConditionalBuilder widget.
  String? uploadToBucket;
  // State field(s) for Username widget.
  FocusNode? usernameFocusNode;
  TextEditingController? usernameTextController;
  String? Function(BuildContext, String?)? usernameTextControllerValidator;
  // Stores action output result for [Custom Action - checkIsUsernameAvailable] action in Username widget.
  bool? checkIsUsernameAvailable;
  // State field(s) for bio widget.
  FocusNode? bioFocusNode;
  TextEditingController? bioTextController;
  String? Function(BuildContext, String?)? bioTextControllerValidator;
  // State field(s) for firstname widget.
  FocusNode? firstnameFocusNode;
  TextEditingController? firstnameTextController;
  String? Function(BuildContext, String?)? firstnameTextControllerValidator;
  // State field(s) for lastname widget.
  FocusNode? lastnameFocusNode;
  TextEditingController? lastnameTextController;
  String? Function(BuildContext, String?)? lastnameTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    usernameFocusNode?.dispose();
    usernameTextController?.dispose();

    bioFocusNode?.dispose();
    bioTextController?.dispose();

    firstnameFocusNode?.dispose();
    firstnameTextController?.dispose();

    lastnameFocusNode?.dispose();
    lastnameTextController?.dispose();
  }
}

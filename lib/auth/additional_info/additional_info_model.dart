import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'additional_info_widget.dart' show AdditionalInfoWidget;
import 'package:flutter/material.dart';

class AdditionalInfoModel extends FlutterFlowModel<AdditionalInfoWidget> {
  ///  Local state fields for this page.

  FFUploadedFile? image;

  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadImage = false;
  FFUploadedFile uploadedLocalFile_uploadImage =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // Stores action output result for [Custom Action - uploadImageToStorage] action in ConditionalBuilder widget.
  String? uploadToBucket;
  // State field(s) for firstname widget.
  FocusNode? firstnameFocusNode;
  TextEditingController? firstnameTextController;
  String? Function(BuildContext, String?)? firstnameTextControllerValidator;
  // State field(s) for lastname widget.
  FocusNode? lastnameFocusNode;
  TextEditingController? lastnameTextController;
  String? Function(BuildContext, String?)? lastnameTextControllerValidator;
  // State field(s) for Username widget.
  FocusNode? usernameFocusNode;
  TextEditingController? usernameTextController;
  String? Function(BuildContext, String?)? usernameTextControllerValidator;
  // Stores action output result for [Custom Action - checkIsUsernameAvailable] action in Username widget.
  bool? checkIsUsernameAvailable;
  // Stores action output result for [Custom Action - createStripeCustomer] action in Button widget.
  dynamic createStripeCustomer;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    firstnameFocusNode?.dispose();
    firstnameTextController?.dispose();

    lastnameFocusNode?.dispose();
    lastnameTextController?.dispose();

    usernameFocusNode?.dispose();
    usernameTextController?.dispose();
  }
}

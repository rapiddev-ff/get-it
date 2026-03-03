import 'dart:typed_data';
import 'package:flutter/material.dart';

class AdditionalInfoModel {
  Uint8List? image;

  bool isDataUploading_uploadImage = false;
  Uint8List? uploadedLocalFile_uploadImage;

  String? uploadToBucket;

  FocusNode? firstnameFocusNode;
  TextEditingController? firstnameTextController;
  String? Function(BuildContext, String?)? firstnameTextControllerValidator;

  FocusNode? lastnameFocusNode;
  TextEditingController? lastnameTextController;
  String? Function(BuildContext, String?)? lastnameTextControllerValidator;

  FocusNode? usernameFocusNode;
  TextEditingController? usernameTextController;
  String? Function(BuildContext, String?)? usernameTextControllerValidator;

  bool? checkIsUsernameAvailable;
  dynamic createStripeCustomer;

  void dispose() {
    firstnameFocusNode?.dispose();
    firstnameTextController?.dispose();
    lastnameFocusNode?.dispose();
    lastnameTextController?.dispose();
    usernameFocusNode?.dispose();
    usernameTextController?.dispose();
  }
}

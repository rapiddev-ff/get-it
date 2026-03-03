import 'dart:typed_data';
import 'package:flutter/material.dart';

class SettingsEditProfileModel {
  ///  Local state fields for this page.

  Uint8List? image;

  String? username;

  bool usernameAvailable = true;

  bool isUsernameEdited = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - uploadImageToStorage] action in ConditionalBuilder widget.
  String? uploadToBucket;
  // State field(s) for Username widget.
  FocusNode? usernameFocusNode;
  TextEditingController? usernameTextController;
  // Stores action output result for [Custom Action - checkIsUsernameAvailable] action in Username widget.
  bool? checkIsUsernameAvailable;
  // State field(s) for bio widget.
  FocusNode? bioFocusNode;
  TextEditingController? bioTextController;
  // State field(s) for firstname widget.
  FocusNode? firstnameFocusNode;
  TextEditingController? firstnameTextController;
  // State field(s) for lastname widget.
  FocusNode? lastnameFocusNode;
  TextEditingController? lastnameTextController;

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

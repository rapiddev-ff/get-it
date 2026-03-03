import 'package:flutter/material.dart';

class BrowseModel {
  String state = 'All';

  FocusNode? textFieldFocusNode;
  TextEditingController? textController;

  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

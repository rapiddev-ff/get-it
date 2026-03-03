import '/backend/supabase/supabase.dart';
import 'package:flutter/material.dart';

class SettingsBlockListModel {
  ///  State fields for stateful widgets in this page.

  Stream<List<BlockedUsersRow>>? settingsBlockListSupabaseStream;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;

  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

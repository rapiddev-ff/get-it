import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'settings_block_list_widget.dart' show SettingsBlockListWidget;
import 'package:flutter/material.dart';

class SettingsBlockListModel extends FlutterFlowModel<SettingsBlockListWidget> {
  ///  State fields for stateful widgets in this page.

  Stream<List<BlockedUsersRow>>? settingsBlockListSupabaseStream;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

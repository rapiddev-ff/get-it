import '/backend/schema/structs/index.dart';
import '/core/nav_bar/nav_bar_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'messages_widget.dart' show MessagesWidget;
import 'package:flutter/material.dart';

class MessagesModel extends FlutterFlowModel<MessagesWidget> {
  ///  Local state fields for this page.

  String state = 'All';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - loadConversations] action in messages widget.
  List<ConversationStruct>? loadConversations;
  // Model for navBar component.
  late NavBarModel navBarModel;

  @override
  void initState(BuildContext context) {
    navBarModel = createModel(context, () => NavBarModel());
  }

  @override
  void dispose() {
    navBarModel.dispose();
  }
}

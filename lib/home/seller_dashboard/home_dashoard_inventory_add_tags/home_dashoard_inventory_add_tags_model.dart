import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_dashoard_inventory_add_tags_widget.dart'
    show HomeDashoardInventoryAddTagsWidget;
import 'package:flutter/material.dart';

class HomeDashoardInventoryAddTagsModel
    extends FlutterFlowModel<HomeDashoardInventoryAddTagsWidget> {
  ///  Local state fields for this page.

  List<TagStruct> tags = [];
  void addToTags(TagStruct item) => tags.add(item);
  void removeFromTags(TagStruct item) => tags.remove(item);
  void removeAtIndexFromTags(int index) => tags.removeAt(index);
  void insertAtIndexInTags(int index, TagStruct item) =>
      tags.insert(index, item);
  void updateTagsAtIndex(int index, Function(TagStruct) updateFn) =>
      tags[index] = updateFn(tags[index]);

  ///  State fields for stateful widgets in this page.

  Stream<List<TagsRow>>? homeDashoardInventoryAddTagsSupabaseStream;
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

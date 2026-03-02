import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_dashoard_inventory_add_sub_category_widget.dart'
    show HomeDashoardInventoryAddSubCategoryWidget;
import 'package:flutter/material.dart';

class HomeDashoardInventoryAddSubCategoryModel
    extends FlutterFlowModel<HomeDashoardInventoryAddSubCategoryWidget> {
  ///  Local state fields for this component.

  SubcategoriesRow? choosenSubCategory;

  ///  State fields for stateful widgets in this component.

  Stream<List<SubcategoriesRow>>? listViewSupabaseStream;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

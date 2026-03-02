import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_dashoard_inventory_add_category_widget.dart'
    show HomeDashoardInventoryAddCategoryWidget;
import 'package:flutter/material.dart';

class HomeDashoardInventoryAddCategoryModel
    extends FlutterFlowModel<HomeDashoardInventoryAddCategoryWidget> {
  ///  Local state fields for this component.

  CategoriesRow? choosenCategory;

  ///  State fields for stateful widgets in this component.

  Stream<List<CategoriesRow>>? listViewSupabaseStream;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

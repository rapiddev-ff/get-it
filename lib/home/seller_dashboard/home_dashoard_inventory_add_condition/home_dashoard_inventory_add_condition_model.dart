import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_dashoard_inventory_add_condition_widget.dart'
    show HomeDashoardInventoryAddConditionWidget;
import 'package:flutter/material.dart';

class HomeDashoardInventoryAddConditionModel
    extends FlutterFlowModel<HomeDashoardInventoryAddConditionWidget> {
  ///  Local state fields for this component.

  List<ConditionsRow> conditionsList = [];
  void addToConditionsList(ConditionsRow item) => conditionsList.add(item);
  void removeFromConditionsList(ConditionsRow item) =>
      conditionsList.remove(item);
  void removeAtIndexFromConditionsList(int index) =>
      conditionsList.removeAt(index);
  void insertAtIndexInConditionsList(int index, ConditionsRow item) =>
      conditionsList.insert(index, item);
  void updateConditionsListAtIndex(
          int index, Function(ConditionsRow) updateFn) =>
      conditionsList[index] = updateFn(conditionsList[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

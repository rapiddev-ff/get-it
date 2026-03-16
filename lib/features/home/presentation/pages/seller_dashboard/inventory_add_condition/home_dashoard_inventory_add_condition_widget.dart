import '/core/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';

class HomeDashoardInventoryAddConditionWidget extends StatefulWidget {
  const HomeDashoardInventoryAddConditionWidget({
    super.key,
    this.conditionsList,
    this.categoryId,
  });

  final List<ConditionsRow>? conditionsList;
  final String? categoryId;

  @override
  State<HomeDashoardInventoryAddConditionWidget> createState() =>
      _HomeDashoardInventoryAddConditionWidgetState();
}

class _HomeDashoardInventoryAddConditionWidgetState
    extends State<HomeDashoardInventoryAddConditionWidget> {
  // Inlined model state
  List<ConditionsRow> conditionsList = [];

  void addToConditionsList(ConditionsRow item) {
    conditionsList.add(item);
  }

  void removeFromConditionsList(ConditionsRow item) {
    conditionsList.removeWhere((c) => c.id == item.id);
  }

  bool _checkConditionsContains(
      List<ConditionsRow> list, ConditionsRow condition) {
    return list.any((c) => c.id == condition.id);
  }

  @override
  void initState() {
    super.initState();

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      conditionsList = widget.conditionsList!.toList().cast<ConditionsRow>();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceDarker,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Padding(
        padding:
            EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0, bottom: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Condition',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: FutureBuilder<List<ConditionsRow>>(
                future: ConditionsTable().queryRows(
                  queryFn: (q) {
                    if (widget.categoryId != null &&
                        widget.categoryId!.isNotEmpty) {
                      return q.eqOrNull('category_id', widget.categoryId);
                    }
                    return q;
                  },
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: AppLoadingIndicator(),
                      ),
                    );
                  }
                  List<ConditionsRow> listViewConditionsRowList =
                      snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    itemCount: listViewConditionsRowList.length,
                    itemBuilder: (context, listViewIndex) {
                      final listViewConditionsRow =
                          listViewConditionsRowList[listViewIndex];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              if (_checkConditionsContains(
                                  conditionsList.toList(),
                                  listViewConditionsRow)) {
                                removeFromConditionsList(listViewConditionsRow);
                                setState(() {});
                              } else {
                                addToConditionsList(listViewConditionsRow);
                                setState(() {});
                              }
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.0),
                                    child: Text(
                                      listViewConditionsRow.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 15.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 24.0,
                                  height: 24.0,
                                  decoration: BoxDecoration(
                                    color: _checkConditionsContains(
                                            conditionsList.toList(),
                                            listViewConditionsRow)
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(6.0),
                                    border: Border.all(
                                      color: _checkConditionsContains(
                                              conditionsList.toList(),
                                              listViewConditionsRow)
                                          ? AppColors.primary
                                          : AppColors.neutral700,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: _checkConditionsContains(
                                          conditionsList.toList(),
                                          listViewConditionsRow)
                                      ? Center(
                                          child: Icon(
                                            Icons.check_rounded,
                                            color: Colors.white,
                                            size: 16.0,
                                          ),
                                        )
                                      : null,
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                          ),
                          Divider(
                            height: 1.0,
                            thickness: 1.0,
                            color: AppColors.surfaceDarkAlt,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: AppOutlineButton(
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.pop(
                          context, widget.conditionsList ?? <ConditionsRow>[]);
                    },
                  ),
                ),
                Expanded(
                  child: AppGradientButton(
                    text: 'Save',
                    onPressed: () async {
                      Navigator.pop(context, conditionsList);
                    },
                  ),
                ),
              ].divide(SizedBox(width: 16.0)),
            ),
          ],
        ),
      ),
    );
  }
}

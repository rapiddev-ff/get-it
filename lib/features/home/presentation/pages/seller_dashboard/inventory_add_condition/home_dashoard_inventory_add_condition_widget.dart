import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';

class HomeDashoardInventoryAddConditionWidget extends StatefulWidget {
  const HomeDashoardInventoryAddConditionWidget({
    super.key,
    this.conditionsList,
  });

  final List<ConditionsRow>? conditionsList;

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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF202021),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Condition',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
                color: AppColors.textPrimary,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 24.0),
              child: FutureBuilder<List<ConditionsRow>>(
                future: ConditionsTable().queryRows(
                  queryFn: (q) => q,
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                    );
                  }
                  List<ConditionsRow> listViewConditionsRowList =
                      snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: listViewConditionsRowList.length,
                    itemBuilder: (context, listViewIndex) {
                      final listViewConditionsRow =
                          listViewConditionsRowList[listViewIndex];
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
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
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 14.0, 0.0, 14.0),
                                    child: Text(
                                      listViewConditionsRow.name,
                                      style: GoogleFonts.inter(
                                        fontSize: 15.0,
                                        color: AppColors.textPrimary,
                                      ),
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
                            color: Color(0xFF29292A),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      Navigator.pop(context, widget.conditionsList ?? <ConditionsRow>[]);
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 56.0),
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      side: BorderSide(color: Color(0xFF545454)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 17.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 56.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7D56FF), Color(0xFF6187F1)],
                        stops: [0.0, 1.0],
                        begin: AlignmentDirectional(0.0, -1.0),
                        end: AlignmentDirectional(0, 1.0),
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pop(context, conditionsList);
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size(double.infinity, 40.0),
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        backgroundColor: Color(0x008E6CFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
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

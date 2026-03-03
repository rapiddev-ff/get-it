import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';

class HomeDashoardInventoryAddSubCategoryWidget extends StatefulWidget {
  const HomeDashoardInventoryAddSubCategoryWidget({
    super.key,
    required this.categoryRow,
    this.subcategories,
  });

  final CategoriesRow? categoryRow;
  final SubcategoriesRow? subcategories;

  @override
  State<HomeDashoardInventoryAddSubCategoryWidget> createState() =>
      _HomeDashoardInventoryAddSubCategoryWidgetState();
}

class _HomeDashoardInventoryAddSubCategoryWidgetState
    extends State<HomeDashoardInventoryAddSubCategoryWidget> {
  // Inlined model state
  SubcategoriesRow? choosenSubCategory;
  Stream<List<SubcategoriesRow>>? listViewSupabaseStream;

  @override
  void initState() {
    super.initState();

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      choosenSubCategory = widget.subcategories;
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
              'Select Subcategory',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
                color: AppColors.textPrimary,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 24.0),
              child: StreamBuilder<List<SubcategoriesRow>>(
                stream: listViewSupabaseStream ??= SupaFlow.client
                    .from("subcategories")
                    .stream(primaryKey: ['id'])
                    .eqOrNull(
                      'category_id',
                      widget.categoryRow?.id,
                    )
                    .map((list) =>
                        list.map((item) => SubcategoriesRow(item)).toList()),
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
                  List<SubcategoriesRow> listViewSubcategoriesRowList =
                      snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: listViewSubcategoriesRowList.length,
                    itemBuilder: (context, listViewIndex) {
                      final listViewSubcategoriesRow =
                          listViewSubcategoriesRowList[listViewIndex];
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              choosenSubCategory = listViewSubcategoriesRow;
                              setState(() {});
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 14.0, 0.0, 14.0),
                                    child: Text(
                                      listViewSubcategoriesRow.name,
                                      style: GoogleFonts.inter(
                                        fontSize: 15.0,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                                if (listViewSubcategoriesRow.id !=
                                    choosenSubCategory?.id)
                                  Icon(
                                    Icons.circle_outlined,
                                    color: AppColors.textSecondary,
                                    size: 20.0,
                                  ),
                                if (listViewSubcategoriesRow.id ==
                                    choosenSubCategory?.id)
                                  Icon(
                                    Icons.radio_button_checked_rounded,
                                    color: AppColors.primary,
                                    size: 20.0,
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
                      Navigator.pop(context, choosenSubCategory);
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
                        Navigator.pop(context, choosenSubCategory);
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

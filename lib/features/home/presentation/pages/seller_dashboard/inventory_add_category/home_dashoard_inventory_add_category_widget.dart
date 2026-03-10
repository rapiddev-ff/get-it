import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';

class HomeDashoardInventoryAddCategoryWidget extends StatefulWidget {
  const HomeDashoardInventoryAddCategoryWidget({
    super.key,
    this.category,
  });

  final CategoriesRow? category;

  @override
  State<HomeDashoardInventoryAddCategoryWidget> createState() =>
      _HomeDashoardInventoryAddCategoryWidgetState();
}

class _HomeDashoardInventoryAddCategoryWidgetState
    extends State<HomeDashoardInventoryAddCategoryWidget> {
  // Inlined model state
  CategoriesRow? choosenCategory;
  Stream<List<CategoriesRow>>? listViewSupabaseStream;

  @override
  void initState() {
    super.initState();

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      choosenCategory = widget.category;
      setState(() {});
    });
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
              'Select Category',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
                color: AppColors.textPrimary,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 24.0),
              child: StreamBuilder<List<CategoriesRow>>(
                stream: listViewSupabaseStream ??= SupaFlow.client
                    .from("categories")
                    .stream(primaryKey: ['id']).map((list) =>
                        list.map((item) => CategoriesRow(item)).toList()),
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
                  List<CategoriesRow> listViewCategoriesRowList =
                      snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: listViewCategoriesRowList.length,
                    itemBuilder: (context, listViewIndex) {
                      final listViewCategoriesRow =
                          listViewCategoriesRowList[listViewIndex];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              choosenCategory = listViewCategoriesRow;
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 14.0, 0.0, 14.0),
                                    child: Text(
                                      listViewCategoriesRow.name,
                                      style: GoogleFonts.inter(
                                        fontSize: 15.0,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                                if (listViewCategoriesRow.id !=
                                    choosenCategory?.id)
                                  Icon(
                                    Icons.circle_outlined,
                                    color: AppColors.textSecondary,
                                    size: 20.0,
                                  ),
                                if (listViewCategoriesRow.id ==
                                    choosenCategory?.id)
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
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      Navigator.pop(context, widget.category);
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
                  child: AppGradientButton(
                    text: 'Save',
                    onPressed: () async {
                      Navigator.pop(context, choosenCategory);
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

import '/core/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';

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
              'Select Subcategory',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
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
                        child: AppLoadingIndicator(),
                      ),
                    );
                  }
                  List<SubcategoriesRow> listViewSubcategoriesRowList =
                      snapshot.data!;

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    itemCount: listViewSubcategoriesRowList.length,
                    itemBuilder: (context, listViewIndex) {
                      final listViewSubcategoriesRow =
                          listViewSubcategoriesRowList[listViewIndex];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              choosenSubCategory = listViewSubcategoriesRow;
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.0),
                                    child: Text(
                                      listViewSubcategoriesRow.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 15.0),
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
                  child: OutlinedButton(
                    onPressed: () async {
                      Navigator.pop(context, widget.subcategories);
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 56.0),
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      side: BorderSide(color: AppColors.neutral800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 17.0,
                          color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: AppGradientButton(
                    text: 'Save',
                    onPressed: () async {
                      Navigator.pop(context, choosenSubCategory);
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

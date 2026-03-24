import '/core/widgets/app_loading_indicator.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import '/core/constants/app_constants.dart';
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
  SubcategoriesRow? chosenSubCategory;
  Stream<List<SubcategoriesRow>>? listViewSupabaseStream;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      chosenSubCategory = widget.subcategories;
      setState(() {});
    });
  }

  @override
  void dispose() {
    EasyDebounce.cancelAll();
    _searchController.dispose();
    super.dispose();
  }

  List<SubcategoriesRow> _filter(List<SubcategoriesRow> list) {
    if (_searchQuery.isEmpty) return list;
    final query = _searchQuery.toLowerCase();
    return list.where((c) => c.name.toLowerCase().contains(query)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: AppColors.surfaceDarker,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: Padding(
        padding:
            EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0, bottom: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Subcategory',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: TextFormField(
                controller: _searchController,
                onChanged: (_) => EasyDebounce.debounce(
                  '_subcategorySearch',
                  Duration(milliseconds: 100),
                  () => setState(() {
                    _searchQuery = _searchController.text;
                  }),
                ),
                decoration: InputDecoration(
                  isDense: false,
                  hintText: 'Search subcategories',
                  hintStyle: Theme.of(context).textTheme.labelLarge!,
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.neutral700, width: 1.0),
                    borderRadius: BorderRadius.circular(
                        AppConstants.radiusTextField4),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.secondary, width: 1.0),
                    borderRadius: BorderRadius.circular(
                        AppConstants.radiusTextField4),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.textPrimary,
                    size: 24.0,
                  ),
                ),
                style: Theme.of(context).textTheme.bodyMedium!,
                cursorColor: AppColors.textPrimary,
              ),
            ),
            Expanded(
              child: StreamBuilder<List<SubcategoriesRow>>(
                stream: listViewSupabaseStream ??= SupaFlow.client
                    .from("subcategories")
                    .stream(primaryKey: ['id'])
                    .eqOrNull('category_id', widget.categoryRow?.id)
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
                  final filtered = _filter(snapshot.data!);

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        'No subcategories found',
                        style: Theme.of(context).textTheme.bodyMedium!,
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final row = filtered[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              chosenSubCategory = row;
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.0),
                                    child: Text(
                                      row.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(fontSize: 15.0),
                                    ),
                                  ),
                                ),
                                Icon(
                                  row.id == chosenSubCategory?.id
                                      ? Icons.radio_button_checked_rounded
                                      : Icons.circle_outlined,
                                  color: row.id == chosenSubCategory?.id
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
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
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: AppOutlineButton(
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.pop(context, widget.subcategories);
                    },
                  ),
                ),
                Expanded(
                  child: AppGradientButton(
                    text: 'Save',
                    onPressed: () async {
                      Navigator.pop(context, chosenSubCategory);
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

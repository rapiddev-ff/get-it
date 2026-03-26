import '/core/widgets/app_loading_indicator.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import '/core/constants/app_constants.dart';
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
  CategoriesRow? chosenCategory;
  Stream<List<CategoriesRow>>? listViewSupabaseStream;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      chosenCategory = widget.category;
      setState(() {});
    });
  }

  @override
  void dispose() {
    EasyDebounce.cancelAll();
    _searchController.dispose();
    super.dispose();
  }

  List<CategoriesRow> _filterCategories(List<CategoriesRow> categories) {
    if (_searchQuery.isEmpty) return categories;
    final query = _searchQuery.toLowerCase();
    return categories
        .where((c) => c.name.toLowerCase().contains(query))
        .toList();
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
        padding: EdgeInsets.only(
          left: 16.0,
          top: 24.0,
          right: 16.0,
          bottom: 32.0 + MediaQuery.of(context).viewPadding.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Category',
              style: Theme.of(context).textTheme.titleLarge!,
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: TextFormField(
                controller: _searchController,
                onChanged: (_) => EasyDebounce.debounce(
                  '_categorySearch',
                  Duration(milliseconds: 100),
                  () => setState(() {
                    _searchQuery = _searchController.text;
                  }),
                ),
                decoration: InputDecoration(
                  isDense: false,
                  hintText: 'Search categories',
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
                        child: AppLoadingIndicator(),
                      ),
                    );
                  }
                  final filtered = _filterCategories(snapshot.data!);

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        'No categories found',
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
                              chosenCategory = row;
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
                                  row.id == chosenCategory?.id
                                      ? Icons.radio_button_checked_rounded
                                      : Icons.circle_outlined,
                                  color: row.id == chosenCategory?.id
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
                      Navigator.pop(context, widget.category);
                    },
                  ),
                ),
                Expanded(
                  child: AppGradientButton(
                    text: 'Save',
                    onPressed: () async {
                      Navigator.pop(context, chosenCategory);
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

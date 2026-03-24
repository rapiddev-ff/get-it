import '/features/browse/domain/models/browse_product_model.dart';
import '/features/browse/presentation/widgets/browse_products_item/browse_products_item_widget.dart';
import '/features/home/presentation/widgets/empty_state/empty_state_widget.dart';
import '/features/home/presentation/widgets/nav_bar/nav_bar_widget.dart';
import '/features/home/presentation/pages/home_product/home_product_widget.dart';
import '/features/notifications/presentation/pages/notification/notification_widget.dart';
import '/features/profile/presentation/pages/settings/settings_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/constants/app_constants.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/features/browse/presentation/widgets/browse_filter/browse_filter_sheet.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class BrowseWidget extends ConsumerStatefulWidget {
  const BrowseWidget({super.key});

  static const String routeName = 'browse';
  static const String routePath = 'browse';

  @override
  ConsumerState<BrowseWidget> createState() => _BrowseWidgetState();
}

class _BrowseWidgetState extends ConsumerState<BrowseWidget> {
  final _textController = TextEditingController();
  final _textFieldFocusNode = FocusNode();
  var _filterState = const BrowseFilterState();

  @override
  void initState() {
    super.initState();
    _textFieldFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _textFieldFocusNode.removeListener(_onFocusChange);
    _textFieldFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  iconSize: 24.0,
                  icon: const Icon(
                    Icons.menu,
                    color: AppColors.info,
                  ),
                  onPressed: () {
                    context.pushNamed(SettingsWidget.routeName);
                  },
                ),
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  iconSize: 20.0,
                  icon: const FaIcon(
                    FontAwesomeIcons.solidBell,
                    color: AppColors.info,
                  ),
                  onPressed: () {
                    context.pushNamed(NotificationWidget.routeName);
                  },
                ),
              ],
            ),
            actions: const [],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _textController,
                            focusNode: _textFieldFocusNode,
                            onChanged: (_) => setState(() {}),
                            autofocus: false,
                            decoration: InputDecoration(
                              hintText: 'Search products, tags, years...',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(fontSize: 15.0),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.neutral700,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusTextField4),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.secondary,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusTextField4),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusTextField4),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: AppColors.error,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(
                                    AppConstants.radiusTextField4),
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 24.0,
                              ),
                            ),
                            style: Theme.of(context).textTheme.bodyMedium!,
                            cursorColor: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        _buildFilterButton(),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: custom_widgets.BrowseProductsGrid(
                            width: double.infinity,
                            height: double.infinity,
                            userId: ref.read(currentUserIdProvider),
                            searchQuery: _textController.text,
                            categoryId: null,
                            subcategoryId: null,
                            // If subcategories are selected, filter by subcategories only
                            // (subcategory already implies category). Otherwise filter by categories.
                            categoryIds: _filterState.allSubcategoryIds.isEmpty &&
                                    _filterState.selectedCategoryIds.isNotEmpty
                                ? _filterState.selectedCategoryIds.toList()
                                : null,
                            subcategoryIds: _filterState.allSubcategoryIds.isNotEmpty
                                ? _filterState.allSubcategoryIds
                                : null,
                            conditionIds: _filterState.selectedConditionIds.isNotEmpty
                                ? _filterState.selectedConditionIds.toList()
                                : null,
                            tagIds: _filterState.selectedTagIds.isNotEmpty
                                ? _filterState.selectedTagIds.toList()
                                : null,
                            priceMin: _filterState.priceMin,
                            priceMax: _filterState.priceMax,
                            year: _filterState.year,
                            crossAxisCount: 2,
                            childAspectRatio: 0.67,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            paddingLeft: 0.0,
                            paddingRight: 0.0,
                            paddingTop: 0.0,
                            paddingBottom: 0.0,
                            pageSize: 20,
                            onProductTap: (productId) async {
                              HapticFeedback.lightImpact();

                              context.pushNamed(
                                HomeProductWidget.routeName,
                                queryParameters: {
                                  'productId': productId.toString(),
                                },
                              );
                            },
                            onTotalChanged: (total) async {},
                            itemBuilder: (BrowseProduct product) =>
                                BrowseProductsItemWidget(
                              browseDataType: product,
                            ),
                            emptyStateWidget: () {
                              final hasSearch =
                                  _textController.text.trim().isNotEmpty;
                              final hasFilters = !_filterState.isEmpty;
                              final hasAny = hasSearch || hasFilters;
                              return EmptyStateWidget(
                                icon: Icon(
                                  hasAny
                                      ? Icons.search_off
                                      : Icons.inventory_2_outlined,
                                  color: AppColors.neutral800,
                                  size: 140.0,
                                ),
                                title: hasSearch
                                    ? 'No results for "${_textController.text}"'
                                    : hasFilters
                                        ? 'No products match filters'
                                        : 'No products available',
                                description: hasAny
                                    ? 'Try adjusting your search or filters.'
                                    : 'Check back later for new listings.',
                                hasButton: hasAny,
                                sidePadding: 0.0,
                                buttonText: hasSearch ? 'Clear Search' : 'Clear Filters',
                                buttonAction: () async {
                                  setState(() {
                                    _textController.clear();
                                    _filterState = const BrowseFilterState();
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ]
                      .addToStart(const SizedBox(height: 24.0))
                      .addToEnd(const SizedBox(height: 24.0)),
                ),
              ),
            ),
            NavBarWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    final count = _filterState.activeFilterCount;
    return InkWell(
      onTap: () async {
        final result = await showBrowseFilterSheet(context, _filterState);
        if (result != null) {
          setState(() => _filterState = result);
        }
      },
      borderRadius: BorderRadius.circular(AppConstants.radiusTextField4),
      child: Container(
        width: 48.0,
        height: 48.0,
        decoration: BoxDecoration(
          color: count > 0 ? AppColors.secondary : AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(AppConstants.radiusTextField4),
          border: Border.all(
            color: count > 0 ? AppColors.secondary : AppColors.neutral700,
            width: 1.0,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.tune,
              color: count > 0 ? Colors.white : AppColors.textPrimary,
              size: 22.0,
            ),
            if (count > 0)
              Positioned(
                top: 6.0,
                right: 6.0,
                child: Container(
                  width: 16.0,
                  height: 16.0,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

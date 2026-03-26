import '/backend/supabase/supabase.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '/features/home/domain/models/seller_product_model.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/constants/app_constants.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/home/presentation/pages/seller_dashboard/inventory_item/inventory_item_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/inventory_add/home_dashoard_inventory_add_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/shortlist/home_dashoard_shortlist_widget.dart';

class HomeDashoardInventoryWidget extends ConsumerStatefulWidget {
  const HomeDashoardInventoryWidget({super.key});

  static const String routeName = 'homeDashoardInventory';
  static const String routePath = 'homeDashoardInventory';

  @override
  ConsumerState<HomeDashoardInventoryWidget> createState() =>
      _HomeDashoardInventoryWidgetState();
}

class _HomeDashoardInventoryWidgetState
    extends ConsumerState<HomeDashoardInventoryWidget>
    with KeyboardVisibilityMixin {
  // Inlined model state
  ({String id, String name})? chosenCategory;
  List<({String id, String name})> _categories = [];
  int? itemsCount = 0;
  int _gridKey = 0;
  String? _statusFilter;
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;

  @override
  void initState() {
    super.initState();

    textController ??= TextEditingController();
    textFieldFocusNode ??= FocusNode();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final rows = await SupaFlow.client
          .from('products')
          .select('category_id, categories!inner(id, name)')
          .eq('seller_id', ref.read(currentUserIdProvider))
          .isFilter('deleted_at', null);

      final seen = <String>{};
      final cats = <({String id, String name})>[];
      for (final row in rows) {
        final cat = row['categories'];
        if (cat == null) continue;
        final id = cat['id']?.toString() ?? '';
        if (id.isNotEmpty && seen.add(id)) {
          cats.add((id: id, name: cat['name']?.toString() ?? ''));
        }
      }
      if (mounted) setState(() => _categories = cats);
    } catch (_) {}
  }

  @override
  void dispose() {
    EasyDebounce.cancelAll();
    textController?.dispose();
    textFieldFocusNode?.dispose();
    super.dispose();
  }

  void _showStatusFilter() {
    final statuses = ['active', 'draft', 'sold', 'archived'];
    final labels = {'active': 'Active', 'draft': 'Draft', 'sold': 'Sold', 'archived': 'Deactivated'};
    // Start with current selection; null means all are shown (none checked)
    final selected = Set<String>.from(
      _statusFilter != null ? [_statusFilter!] : [],
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Product Status',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16.0),
                ...statuses.map((status) {
                  final isChecked = selected.contains(status);
                  return InkWell(
                    onTap: () {
                      setSheetState(() {
                        if (isChecked) {
                          selected.remove(status);
                        } else {
                          selected.clear();
                          selected.add(status);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              labels[status] ?? status,
                              style: Theme.of(context).textTheme.bodyLarge!,
                            ),
                          ),
                          Container(
                            width: 22.0,
                            height: 22.0,
                            decoration: BoxDecoration(
                              color: isChecked
                                  ? AppColors.secondary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                color: isChecked
                                    ? AppColors.secondary
                                    : AppColors.textSecondary,
                                width: 1.5,
                              ),
                            ),
                            child: isChecked
                                ? const Icon(Icons.check,
                                    size: 16.0, color: Colors.white)
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.neutral700),
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(
                          'Cancel',
                          style: Theme.of(context).textTheme.bodyLarge!,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _statusFilter =
                                selected.isNotEmpty ? selected.first : null;
                            _gridKey++;
                          });
                        },
                        child: Text(
                          'Apply',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppColors.brandPurple, AppColors.brandBlue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          color: isSelected ? null : AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool hasSearch) {
    if (hasSearch) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'No matches',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                'We couldn\'t find anyone matching "${textController!.text}".',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                ),
                onPressed: () {
                  textController!.clear();
                  setState(() {});
                },
                child: Text(
                  'Clear Search',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'Your inventory is empty',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first item to start selling and\ntracking views.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.neutral700),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  ),
                  onPressed: () {
                    // TODO: scan item
                  },
                  child: Text(
                    'Scan Item',
                    style: Theme.of(context).textTheme.bodyMedium!,
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  ),
                  onPressed: () {
                    context
                        .pushNamed(HomeDashoardInventoryAddWidget.routeName);
                  },
                  child: Text(
                    'Add a Product',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.info,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.pop();
                  },
                ),
                Text(
                  'Inventory',
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                Opacity(
                  opacity: 0.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.notifications_none,
                      color: AppColors.info,
                      size: 20.0,
                    ),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: textController,
                              focusNode: textFieldFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                '_model.textController',
                                Duration(milliseconds: 100),
                                () => setState(() {}),
                              ),
                              autofocus: false,
                              enabled: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: false,
                                hintText: 'Search inventory...',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(fontSize: 15.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.neutral700,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.secondary,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColors.error,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                              ),
                              style: Theme.of(context).textTheme.bodyMedium!,
                              cursorColor: AppColors.textPrimary,
                              enableInteractiveSelection: true,
                            ),
                          ),
                        InkWell(
                          onTap: _showStatusFilter,
                          borderRadius: BorderRadius.circular(4.0),
                          child: Container(
                            width: 56.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                color: AppColors.neutral700,
                                width: 1.0,
                              ),
                            ),
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.filter,
                                color: AppColors.info,
                                size: 16.0,
                              ),
                            ),
                          ),
                        ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _categoryChip(
                            label: 'All',
                            isSelected: chosenCategory == null,
                            onTap: () {
                              chosenCategory = null;
                              setState(() {});
                            },
                          ),
                          ...List.generate(_categories.length, (i) {
                            final cat = _categories[i];
                            return _categoryChip(
                              label: cat.name,
                              isSelected: chosenCategory?.id == cat.id,
                              onTap: () {
                                chosenCategory = cat;
                                setState(() {});
                              },
                            );
                          }),
                        ]
                            .divide(SizedBox(width: 8.0))
                            .addToStart(SizedBox(width: 16.0))
                            .addToEnd(SizedBox(width: 16.0)),
                      ),
                    ),
                  ),
                  Divider(
                    height: 48.0,
                    thickness: 1.0,
                    color: AppColors.surfaceDark,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '${itemsCount?.toString()} Items',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: custom_widgets.InfiniteProductGrid(
                        key: ValueKey('inventory_grid_$_gridKey'),
                        width: double.infinity,
                        height: double.infinity,
                        sellerId: ref.read(currentUserIdProvider),
                        userId: ref.read(currentUserIdProvider),
                        status: _statusFilter,
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 16.0,
                        padding: 16.0,
                        pageSize: 20,
                        searchText: textController!.text,
                        categoryId: chosenCategory?.id,
                        onProductTap: (productId) async {
                          await context.pushNamed(
                            HomeDashoardInventoryAddWidget.routeName,
                            queryParameters: {
                              'productId': productId.toString(),
                            },
                          );
                          if (!mounted) return;
                          setState(() => _gridKey++);
                          _loadCategories();
                        },
                        emptyBuilder: (hasSearch) => _buildEmptyState(hasSearch),
                        onTotalChanged: (total) async {
                          itemsCount = total;
                          setState(() {});
                        },
                        itemBuilder: (SellerProduct? sellerProduct) =>
                            InventoryItemWidget(
                          sellerProduct: sellerProduct,
                        ),
                      ),
                    ),
                  ),
                ]
                    .addToStart(SizedBox(height: 24.0))
                    .addToEnd(SizedBox(height: 24.0)),
              ),
            ),
            if (!isKeyboardShowing(context))
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16.0,
                    top: 12.0,
                    right: 16.0,
                    bottom: 12.0 + MediaQuery.of(context).viewPadding.bottom,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(
                              color: AppColors.neutral800,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 12.0, bottom: 14.0),
                            child: Column(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.camera,
                                  color: AppColors.textPrimary,
                                  size: 16.0,
                                ),
                                Text(
                                  'Scan Item',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium!,
                                ),
                              ].divide(SizedBox(height: 4.0)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            context.pushNamed(
                                HomeDashoardInventoryAddWidget.routeName);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                color: AppColors.neutral800,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 12.0, bottom: 14.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: AppColors.textPrimary,
                                    size: 16.0,
                                  ),
                                  Text(
                                    'Add Manual',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium!,
                                  ),
                                ].divide(SizedBox(height: 4.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            context.pushNamed(
                                HomeDashoardShortlistWidget.routeName);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                color: AppColors.neutral800,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 12.0, bottom: 14.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.playlist_add_sharp,
                                    color: AppColors.textPrimary,
                                    size: 16.0,
                                  ),
                                  Text(
                                    'Shortlists',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium!,
                                  ),
                                ].divide(SizedBox(height: 4.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 12.0)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

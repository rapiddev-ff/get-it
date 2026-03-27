import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/constants/app_constants.dart';
import '/core/providers/current_user_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/app_loading_indicator.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/core/widgets/product_price_row.dart';
import '/features/browse/presentation/widgets/browse_filter/browse_filter_sheet.dart';
import '/features/home/data/repositories/shortlist_repository.dart';
import '/features/home/domain/models/shortlist_product_model.dart';

class ShortlistAddResult {
  const ShortlistAddResult({required this.quantities, required this.products});
  final Map<String, int> quantities;
  final List<ShortlistProduct> products;
}

class HomeDashoardShortlistAddWidget extends ConsumerStatefulWidget {
  const HomeDashoardShortlistAddWidget({
    super.key,
    this.shortlistId,
  });

  /// If editing an existing shortlist, pass its ID to exclude already-added products.
  final String? shortlistId;

  static const String routeName = 'homeDashoardShortlistAdd';
  static const String routePath = 'homeDashoardShortlistAdd';

  @override
  ConsumerState<HomeDashoardShortlistAddWidget> createState() =>
      _HomeDashoardShortlistAddWidgetState();
}

class _HomeDashoardShortlistAddWidgetState
    extends ConsumerState<HomeDashoardShortlistAddWidget> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  List<ShortlistProduct> _products = [];
  bool _isLoading = true;

  /// product_id → selected quantity for this shortlist addition
  Map<String, int> _selectedQuantities = {};

  /// Category/subcategory filter state
  BrowseFilterState _filterState = const BrowseFilterState();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    EasyDebounce.cancelAll();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final repo = ref.read(shortlistRepositoryProvider);
    final results = await repo.getSellerProductsForShortlist(
      sellerId: ref.read(currentUserIdProvider) ?? '',
      searchQuery: _searchController.text.trim(),
      categoryIds: _filterState.selectedCategoryIds.isNotEmpty
          ? _filterState.selectedCategoryIds.toList()
          : null,
      subcategoryIds: _filterState.allSubcategoryIds.isNotEmpty
          ? _filterState.allSubcategoryIds
          : null,
      existingShortlistId: widget.shortlistId,
    );
    if (!mounted) return;
    setState(() {
      _products = results;
      _isLoading = false;
    });
  }

  int get _selectedProductCount =>
      _selectedQuantities.values.where((q) => q > 0).length;

  bool get _allSelected =>
      _products.isNotEmpty &&
      _products.every(
          (p) => (_selectedQuantities[p.id] ?? 0) >= p.availableQuantity);

  void _toggleSelectAll() {
    setState(() {
      if (_allSelected) {
        _selectedQuantities.clear();
      } else {
        for (final p in _products) {
          _selectedQuantities[p.id] = p.availableQuantity;
        }
      }
    });
  }

  void _setQuantity(ShortlistProduct product, int qty) {
    setState(() {
      final clamped = qty.clamp(0, product.availableQuantity);
      if (clamped == 0) {
        _selectedQuantities.remove(product.id);
      } else {
        _selectedQuantities[product.id] = clamped;
      }
    });
  }

  void _showQuantityInput(ShortlistProduct product) {
    final controller = TextEditingController(
      text: (_selectedQuantities[product.id] ?? 0).toString(),
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text('Enter Quantity',
            style: Theme.of(context).textTheme.titleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${product.title}\nAvailable: ${product.availableQuantity}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autofocus: true,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: '0',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child:
                Text('Cancel', style: TextStyle(color: AppColors.textPrimary)),
          ),
          TextButton(
            onPressed: () {
              final val = int.tryParse(controller.text) ?? 0;
              _setQuantity(product, val);
              Navigator.pop(ctx);
            },
            child: Text('OK', style: TextStyle(color: AppColors.secondary)),
          ),
        ],
      ),
    );
    controller.dispose;
  }

  Future<void> _openFilter() async {
    final result = await showBrowseFilterSheet(context, _filterState);
    if (result != null) {
      _filterState = result;
      _loadProducts();
    }
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
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: Icon(Icons.arrow_back,
                      color: AppColors.info, size: 24.0),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'Add to Shortlist (${_products.length})',
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                Opacity(
                  opacity: 0.0,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    icon: Icon(Icons.more_vert,
                        color: AppColors.info, size: 20.0),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.0),
                      // Search + Filter row
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                'shortlistAddSearch',
                                Duration(milliseconds: 300),
                                () => _loadProducts(),
                              ),
                              decoration: InputDecoration(
                                isDense: false,
                                hintText: 'Search products...',
                                hintStyle: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(fontSize: 15.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.neutral700, width: 1.0),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.secondary, width: 1.0),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.error, width: 1.0),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.error, width: 1.0),
                                  borderRadius: BorderRadius.circular(
                                      AppConstants.radiusTextField4),
                                ),
                                prefixIcon: Icon(Icons.search,
                                    color: Colors.white, size: 24.0),
                              ),
                              style: Theme.of(context).textTheme.bodyMedium!,
                              cursorColor: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(width: 8.0),
                          // Filter button
                          GestureDetector(
                            onTap: _openFilter,
                            child: Container(
                              width: 48.0,
                              height: 48.0,
                              decoration: BoxDecoration(
                                color: _filterState.isEmpty
                                    ? AppColors.backgroundSecondary
                                    : AppColors.secondary,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Icon(Icons.tune,
                                        color: Colors.white, size: 24.0),
                                  ),
                                  if (!_filterState.isEmpty)
                                    Positioned(
                                      top: 4.0,
                                      right: 4.0,
                                      child: Container(
                                        width: 18.0,
                                        height: 18.0,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${_filterState.activeFilterCount}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Select All + selected count
                      Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: _toggleSelectAll,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundSecondary,
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 7.0,
                                      top: 7.0,
                                      right: 16.0,
                                      bottom: 7.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 22.0,
                                        height: 22.0,
                                        decoration: BoxDecoration(
                                          color: _allSelected
                                              ? AppColors.secondary
                                              : Colors.transparent,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: _allSelected
                                                ? AppColors.secondary
                                                : AppColors.neutral700,
                                          ),
                                        ),
                                        child: _allSelected
                                            ? Icon(Icons.check,
                                                color: Colors.white,
                                                size: 14.0)
                                            : null,
                                      ),
                                      Text(
                                        'Select All',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15.0),
                                      ),
                                    ].divide(SizedBox(width: 8.0)),
                                  ),
                                ),
                              ),
                            ),
                            if (_selectedProductCount > 0)
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.secondary,
                                      AppColors.brandBlue
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    '$_selectedProductCount selected',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15.0),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.0),
                      // Product list
                      Expanded(
                        child: _isLoading
                            ? Center(child: AppLoadingIndicator())
                            : _products.isEmpty
                                ? _buildEmptyState()
                                : ListView.separated(
                                    padding: EdgeInsets.only(bottom: 24.0),
                                    itemCount: _products.length,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(height: 8.0),
                                    itemBuilder: (context, index) =>
                                        _buildProductItem(_products[index]),
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom CTA
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: AppGradientButton(
                  text: _selectedProductCount > 0
                      ? 'Add Products ($_selectedProductCount)'
                      : 'Add Products',
                  enabled: _selectedProductCount > 0,
                  onPressed: () {
                    final quantities = Map<String, int>.from(_selectedQuantities)
                      ..removeWhere((_, qty) => qty <= 0);
                    final selectedProducts = _products
                        .where((p) => quantities.containsKey(p.id))
                        .toList();
                    Navigator.pop(context, ShortlistAddResult(
                      quantities: quantities,
                      products: selectedProducts,
                    ));
                  },
                ),
              ),
            ].addToEnd(SizedBox(height: 32.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final hasSearch = _searchController.text.trim().isNotEmpty;
    final hasFilter = !_filterState.isEmpty;
    if (hasSearch || hasFilter) {
      return Center(
        child: Text(
          'No products found',
          style: Theme.of(context).textTheme.labelLarge!,
        ),
      );
    }
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inventory_2_outlined,
                color: AppColors.textSecondary, size: 64.0),
            SizedBox(height: 16.0),
            Text(
              'No products yet',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.0),
            Text(
              'Add products to your inventory first, then you can add them to your shortlist.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge!,
            ),
            SizedBox(height: 24.0),
            AppGradientButton(
              text: 'Add a Product',
              onPressed: () {
                Navigator.pop(context);
                // Navigate to inventory add — caller handles navigation
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(ShortlistProduct product) {
    final qty = _selectedQuantities[product.id] ?? 0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: SizedBox(
                width: 56.0,
                height: 56.0,
                child: product.mainImageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: product.mainImageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => Container(
                          color: AppColors.surfaceDarkAlt,
                          child: Icon(Icons.image,
                              color: AppColors.textSecondary, size: 24.0),
                        ),
                      )
                    : Container(
                        color: AppColors.surfaceDarkAlt,
                        child: Icon(Icons.image,
                            color: AppColors.textSecondary, size: 24.0),
                      ),
              ),
            ),
            SizedBox(width: 12.0),
            // Title + Price + Available
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4.0),
                  ProductPriceRow(
                    price: product.price,
                    originalPrice: product.originalPrice,
                    flashSaleEnabled: product.flashSaleEnabled,
                    flashSalePrice: product.flashSalePrice,
                    flashSaleEndsAt: product.flashSaleEndsAt,
                    discountType: product.discountType,
                    discountAmount: product.discountAmount,
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    'Qty ${product.availableQuantity}',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.0),
            // Quantity counter: - [N] +
            Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundPrimary,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: qty > 0 ? AppColors.secondary : AppColors.neutral700,
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _counterButton(
                    icon: Icons.remove,
                    enabled: qty > 0,
                    onTap: () => _setQuantity(product, qty - 1),
                  ),
                  GestureDetector(
                    onTap: () => _showQuantityInput(product),
                    child: Container(
                      constraints: BoxConstraints(minWidth: 36.0),
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        '$qty',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: qty > 0
                                  ? AppColors.secondary
                                  : AppColors.textPrimary,
                            ),
                      ),
                    ),
                  ),
                  _counterButton(
                    icon: Icons.add,
                    enabled: qty < product.availableQuantity,
                    onTap: () => _setQuantity(product, qty + 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _counterButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32.0,
        height: 32.0,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18.0,
          color: enabled ? AppColors.textPrimary : AppColors.neutral700,
        ),
      ),
    );
  }
}

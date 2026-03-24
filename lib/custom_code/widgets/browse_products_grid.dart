import '/core/widgets/app_loading_indicator.dart';
import '/features/browse/domain/models/browse_product_model.dart';
import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:shimmer/shimmer.dart';

class BrowseProductsGrid extends StatefulWidget {
  const BrowseProductsGrid({
    super.key,
    this.width,
    this.height,
    this.userId,
    this.searchQuery,
    this.categoryId,
    this.subcategoryId,
    this.categoryIds,
    this.subcategoryIds,
    this.conditionIds,
    this.tagIds,
    this.priceMin,
    this.priceMax,
    this.year,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.65,
    this.crossAxisSpacing = 12.0,
    this.mainAxisSpacing = 12.0,
    this.paddingLeft = 16.0,
    this.paddingRight = 16.0,
    this.paddingTop = 0.0,
    this.paddingBottom = 16.0,
    this.pageSize = 20,
    this.onProductTap,
    this.onTotalChanged,
    this.itemBuilder,
    this.emptyStateWidget,
  });

  final double? width;
  final double? height;
  final String? userId;
  final String? searchQuery;
  final String? categoryId;
  final String? subcategoryId;
  final List<String>? categoryIds;
  final List<String>? subcategoryIds;
  final List<String>? conditionIds;
  final List<String>? tagIds;
  final double? priceMin;
  final double? priceMax;
  final int? year;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;
  final int pageSize;
  final Future Function(String productId)? onProductTap;
  final Future Function(int total)? onTotalChanged;
  final Widget Function(BrowseProduct product)? itemBuilder;

  /// Custom empty state widget builder. Falls back to default if null.
  final Widget Function()? emptyStateWidget;

  @override
  State<BrowseProductsGrid> createState() => _BrowseProductsGridState();
}

class _BrowseProductsGridState extends State<BrowseProductsGrid> {
  List<BrowseProduct> _products = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  // _totalCount removed (unused)
  String? _error;
  int _currentOffset = 0;
  Timer? _debounceTimer;

  // Track previous filter values for change detection
  String? _prevSearchQuery;
  String? _prevCategoryId;
  String? _prevSubcategoryId;
  String? _prevUserId;
  List<String>? _prevCategoryIds;
  List<String>? _prevSubcategoryIds;
  List<String>? _prevConditionIds;
  List<String>? _prevTagIds;
  double? _prevPriceMin;
  double? _prevPriceMax;
  int? _prevYear;

  @override
  void initState() {
    super.initState();
    _syncPrev();
    _loadProducts(reset: true);
  }

  void _syncPrev() {
    _prevSearchQuery = widget.searchQuery;
    _prevCategoryId = widget.categoryId;
    _prevSubcategoryId = widget.subcategoryId;
    _prevUserId = widget.userId;
    _prevCategoryIds = widget.categoryIds;
    _prevSubcategoryIds = widget.subcategoryIds;
    _prevConditionIds = widget.conditionIds;
    _prevTagIds = widget.tagIds;
    _prevPriceMin = widget.priceMin;
    _prevPriceMax = widget.priceMax;
    _prevYear = widget.year;
  }

  static bool _listEquals(List<String>? a, List<String>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  void didUpdateWidget(BrowseProductsGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    final filtersChanged = widget.searchQuery != _prevSearchQuery ||
        widget.categoryId != _prevCategoryId ||
        widget.subcategoryId != _prevSubcategoryId ||
        widget.userId != _prevUserId ||
        !_listEquals(widget.categoryIds, _prevCategoryIds) ||
        !_listEquals(widget.subcategoryIds, _prevSubcategoryIds) ||
        !_listEquals(widget.conditionIds, _prevConditionIds) ||
        !_listEquals(widget.tagIds, _prevTagIds) ||
        widget.priceMin != _prevPriceMin ||
        widget.priceMax != _prevPriceMax ||
        widget.year != _prevYear;

    if (filtersChanged) {
      _syncPrev();

      _debounceTimer?.cancel();
      _debounceTimer = Timer(
        Duration(
            milliseconds:
                widget.searchQuery != oldWidget.searchQuery ? 300 : 0),
        () => _loadProducts(reset: true),
      );
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadProducts({bool reset = false}) async {
    if (reset) {
      setState(() {
        _error = null;
        _currentOffset = 0;
        _hasMore = true;
        _isLoading = true;
        _products = [];
      });
    } else {
      if (_isLoadingMore || !_hasMore) return;
      setState(() => _isLoadingMore = true);
    }

    try {
      final rpcParams = {
        'p_user_id': widget.userId,
        'p_search_query': widget.searchQuery?.isNotEmpty == true
            ? widget.searchQuery
            : null,
        'p_category_id': widget.categoryId,
        'p_subcategory_id': widget.subcategoryId,
        'p_category_ids': widget.categoryIds?.isNotEmpty == true
            ? widget.categoryIds
            : null,
        'p_subcategory_ids': widget.subcategoryIds?.isNotEmpty == true
            ? widget.subcategoryIds
            : null,
        'p_condition_ids': widget.conditionIds?.isNotEmpty == true
            ? widget.conditionIds
            : null,
        'p_tag_ids': widget.tagIds?.isNotEmpty == true
            ? widget.tagIds
            : null,
        'p_price_min': widget.priceMin,
        'p_price_max': widget.priceMax,
        'p_year': widget.year,
        'p_limit': widget.pageSize,
        'p_offset': _currentOffset,
      };
      debugPrint('[BrowseGrid] RPC params: $rpcParams');
      final response = await SupaFlow.client.rpc(
        'get_browse_products',
        params: rpcParams,
      );
      debugPrint('[BrowseGrid] RPC response total_count: ${(response as Map)['total_count']}, products: ${((response)['products'] as List).length}');

      final data = response as Map<String, dynamic>;
      final productsJson = data['products'] as List<dynamic>;
      var newProducts = productsJson
          .map((json) => BrowseProduct.fromJson(json as Map<String, dynamic>))
          .toList();

      // Enrich with flash sale data from products table
      final productIds = newProducts.map((p) => p.id).toList();
      if (productIds.isNotEmpty) {
        try {
          final flashRows = await SupaFlow.client
              .from('products')
              .select('id, flash_sale_enabled, flash_sale_price')
              .inFilter('id', productIds);
          final flashMap = <String, Map<String, dynamic>>{};
          for (final row in (flashRows as List)) {
            flashMap[row['id'].toString()] = row;
          }
          for (var i = 0; i < newProducts.length; i++) {
            final fd = flashMap[newProducts[i].id];
            if (fd != null) {
              newProducts[i] = newProducts[i].copyWith(
                flashSaleEnabled: fd['flash_sale_enabled'] == true,
                flashSalePrice:
                    (fd['flash_sale_price'] as num?)?.toDouble(),
              );
            }
          }
        } catch (_) {}
      }

      final totalCount = data['total_count'] as int;
      final hasMore = data['has_more'] == true;

      if (!mounted) return;

      setState(() {
        if (reset) {
          _products = newProducts;
        } else {
          // Deduplicate by product ID
          final existingIds = _products.map((p) => p.id).toSet();
          final uniqueNew = newProducts.where((p) => !existingIds.contains(p.id)).toList();
          _products = [..._products, ...uniqueNew];
        }
        _hasMore = hasMore;
        _currentOffset += newProducts.length;
        _isLoading = false;
        _isLoadingMore = false;
      });

      widget.onTotalChanged?.call(totalCount);
    } catch (e, st) {
      debugPrint('[BrowseGrid] RPC ERROR: $e');
      debugPrint('[BrowseGrid] Stack: $st');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _handleProductTap(BrowseProduct product) async {
    if (widget.onProductTap == null) {
      debugPrint('[BrowseProductsGrid] onProductTap is null');
      return;
    }
    try {
      await widget.onProductTap!(product.id);
    } catch (e) {
      debugPrint('[BrowseProductsGrid] onProductTap error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildShimmerGrid();
    }

    if (_error != null) {
      return _buildErrorWidget();
    }

    if (_products.isEmpty) {
      return widget.emptyStateWidget?.call() ?? _buildDefaultEmpty();
    }

    return GridView.builder(
      padding: EdgeInsets.only(
        left: widget.paddingLeft,
        right: widget.paddingRight,
        top: widget.paddingTop,
        bottom: widget.paddingBottom,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        childAspectRatio: widget.childAspectRatio,
        crossAxisSpacing: widget.crossAxisSpacing,
        mainAxisSpacing: widget.mainAxisSpacing,
      ),
      itemCount: _products.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _products.length) {
          return _buildLoadMoreTrigger();
        }

        final product = _products[index];

        if (widget.itemBuilder == null) {
          debugPrint(
              '[BrowseProductsGrid] itemBuilder is null -- no card to render');
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () => _handleProductTap(product),
          child: widget.itemBuilder!(product),
        );
      },
    );
  }

  // -- Empty State --

  Widget _buildDefaultEmpty() {
    final hasFilters = (widget.searchQuery?.isNotEmpty == true) ||
        widget.categoryId != null ||
        widget.subcategoryId != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasFilters ? Icons.search_off : Icons.inventory_2_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              hasFilters ? 'No products found' : 'No products available',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? 'Try adjusting your search or filters'
                  : 'Check back later for new listings',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
          ],
        ),
      ),
    );
  }

  // -- Load More --

  Widget _buildLoadMoreTrigger() {
    return VisibilityDetector(
      key: const Key('browse-load-more-trigger'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0 && !_isLoadingMore && _hasMore) {
          _loadProducts();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: SizedBox(
          width: 24,
          height: 24,
          child: AppLoadingIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  // -- Shimmer --

  Widget _buildShimmerGrid() {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundSecondary,
      highlightColor: AppColors.backgroundPrimary.withValues(alpha: 0.5),
      child: GridView.builder(
        padding: EdgeInsets.only(
          left: widget.paddingLeft,
          right: widget.paddingRight,
          top: widget.paddingTop,
          bottom: widget.paddingBottom,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          childAspectRatio: widget.childAspectRatio,
          crossAxisSpacing: widget.crossAxisSpacing,
          mainAxisSpacing: widget.mainAxisSpacing,
        ),
        itemCount: widget.pageSize.clamp(4, 8),
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => _buildShimmerCard(),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        height: 16,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -- Error --

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load products',
              style: Theme.of(context).textTheme.bodyMedium!,
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall!,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadProducts(reset: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.info,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

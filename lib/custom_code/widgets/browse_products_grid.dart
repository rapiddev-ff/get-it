import '/backend/schema/enums/enums.dart';
import '/features/browse/domain/models/browse_product_model.dart';
import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import 'index.dart';
import '/custom_code/actions/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  int _totalCount = 0;
  String? _error;
  int _currentOffset = 0;
  Timer? _debounceTimer;

  String? _prevSearchQuery;
  String? _prevCategoryId;
  String? _prevSubcategoryId;
  String? _prevUserId;

  @override
  void initState() {
    super.initState();
    _prevSearchQuery = widget.searchQuery;
    _prevCategoryId = widget.categoryId;
    _prevSubcategoryId = widget.subcategoryId;
    _prevUserId = widget.userId;
    _loadProducts(reset: true);
  }

  @override
  void didUpdateWidget(BrowseProductsGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    final filtersChanged = widget.searchQuery != _prevSearchQuery ||
        widget.categoryId != _prevCategoryId ||
        widget.subcategoryId != _prevSubcategoryId ||
        widget.userId != _prevUserId;

    if (filtersChanged) {
      _prevSearchQuery = widget.searchQuery;
      _prevCategoryId = widget.categoryId;
      _prevSubcategoryId = widget.subcategoryId;
      _prevUserId = widget.userId;

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
      final hadProducts = _products.isNotEmpty;
      setState(() {
        _error = null;
        _currentOffset = 0;
        _hasMore = true;
        if (!hadProducts) {
          _isLoading = true;
          _products = [];
        }
      });
    } else {
      if (_isLoadingMore || !_hasMore) return;
      setState(() => _isLoadingMore = true);
    }

    try {
      final response = await SupaFlow.client.rpc(
        'get_browse_products',
        params: {
          'p_user_id': widget.userId,
          'p_search_query': widget.searchQuery?.isNotEmpty == true
              ? widget.searchQuery
              : null,
          'p_category_id': widget.categoryId,
          'p_subcategory_id': widget.subcategoryId,
          'p_limit': widget.pageSize,
          'p_offset': _currentOffset,
        },
      );

      final data = response as Map<String, dynamic>;
      final productsJson = data['products'] as List<dynamic>;
      final newProducts = productsJson
          .map((json) =>
              BrowseProduct.fromJson(json as Map<String, dynamic>))
          .toList();

      final totalCount = data['total_count'] as int;
      final hasMore = data['has_more'] as bool;

      if (!mounted) return;

      setState(() {
        if (reset) {
          _products = newProducts;
        } else {
          _products.addAll(newProducts);
        }
        _totalCount = totalCount;
        _hasMore = hasMore;
        _currentOffset += newProducts.length;
        _isLoading = false;
        _isLoadingMore = false;
      });

      widget.onTotalChanged?.call(totalCount);
    } catch (e) {
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
      debugPrint(
          '[BrowseProductsGrid] onProductTap is null -- not wired in FlutterFlow');
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
              style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? 'Try adjusting your search or filters'
                  : 'Check back later for new listings',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 14, color: AppColors.textPrimary),
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
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  // -- Shimmer --

  Widget _buildShimmerGrid() {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundSecondary,
      highlightColor: AppColors.backgroundPrimary.withOpacity(0.5),
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
                color: Colors.white.withOpacity(0.1),
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
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
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
                          color: Colors.white.withOpacity(0.1),
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
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
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
            Icon(Icons.error_outline,
                size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text(
              'Failed to load products',
              style: GoogleFonts.inter(
                  fontSize: 14, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              _error ?? 'Unknown error',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.textSecondary),
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

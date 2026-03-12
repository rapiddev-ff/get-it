import '/core/widgets/app_loading_indicator.dart';
import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '/features/home/domain/models/seller_product_model.dart';

import 'package:visibility_detector/visibility_detector.dart';
import 'package:shimmer/shimmer.dart';

class SellerProductsGrid extends StatefulWidget {
  const SellerProductsGrid({
    super.key,
    this.width,
    this.height,
    required this.sellerId,
    this.userId,
    this.status,
    this.searchQuery,
    this.categoryId,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.7,
    this.mainAxisSpacing = 12.0,
    this.crossAxisSpacing = 12.0,
    this.padding = 16.0,
    this.pageSize = 20,
    this.onProductTap,
    this.itemBuilder,
    this.onCategoriesLoaded,
  });

  final double? width;
  final double? height;
  final String sellerId;
  final String? userId;
  final String? status;
  final String? searchQuery;
  final String? categoryId;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double padding;
  final int pageSize;
  final Future Function(String productId)? onProductTap;
  final Widget Function(SellerProduct? sellerProduct)? itemBuilder;
  final void Function(List<({String id, String name})> categories, int total)?
      onCategoriesLoaded;

  @override
  State<SellerProductsGrid> createState() => _SellerProductsGridState();
}

class _SellerProductsGridState extends State<SellerProductsGrid> {
  final List<SellerProduct> _products = [];

  bool _isLoading = false;
  bool _hasMore = true;
  bool _isInitialLoad = true;
  String? _error;
  int _offset = 0;
  // _total removed (unused)

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void didUpdateWidget(SellerProductsGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status ||
        oldWidget.sellerId != widget.sellerId) {
      _reset();
      _loadProducts();
    }
  }

  void _reset() {
    setState(() {
      _products.clear();
      _offset = 0;
      _hasMore = true;
      _isInitialLoad = true;
      _error = null;
    });
  }

  Future<void> _loadProducts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await SupaFlow.client.rpc(
        'get_seller_products',
        params: {
          'p_seller_id': widget.sellerId,
          'p_user_id': widget.userId,
          'p_status': widget.status,
          'p_limit': widget.pageSize,
          'p_offset': _offset,
        },
      );

      final data = response as Map<String, dynamic>;
      final productsJson = data['products'] as List<dynamic>? ?? [];
      final hasMore = data['has_more'] == true;
      // total not currently used
      // final total = data['total'] as int? ?? 0;

      final newProducts = productsJson.map((json) {
        return SellerProduct(
          id: json['id']?.toString() ?? '',
          title: json['title']?.toString() ?? '',
          price: (json['price'] as num?)?.toDouble() ?? 0.0,
          originalPrice: (json['original_price'] as num?)?.toDouble() ?? 0.0,
          flashSaleEnabled: json['flash_sale_enabled'] == true,
          flashSalePrice: (json['flash_sale_price'] as num?)?.toDouble(),
          status: json['status']?.toString() ?? '',
          viewsCount: (json['views_count'] as num?)?.toInt() ?? 0,
          conditionName: json['condition_name']?.toString() ?? '',
          mainImageUrl: json['main_image_url']?.toString() ?? '',
          isInWishlist: json['is_in_wishlist'] == true,
          categoryId: json['category_id']?.toString() ?? '',
          categoryName: json['category_name']?.toString() ?? '',
          createdAt: json['created_at'] != null
              ? DateTime.tryParse(json['created_at'].toString())
              : null,
        );
      }).toList();

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
        } catch (_) {
          // Non-critical — continue without flash sale data
        }
      }

      // Extract categories on first load
      if (_offset == 0 && widget.onCategoriesLoaded != null) {
        final total = (data['total'] as num?)?.toInt() ?? newProducts.length;
        final categoriesJson = data['categories'] as List<dynamic>?;
        if (categoriesJson != null) {
          final cats = categoriesJson
              .map((c) => (
                    id: c['id']?.toString() ?? '',
                    name: c['name']?.toString() ?? '',
                  ))
              .where((c) => c.id.isNotEmpty && c.name.isNotEmpty)
              .toList();
          widget.onCategoriesLoaded!(cats, total);
        } else {
          // Fallback: extract from products
          final seen = <String>{};
          final cats = <({String id, String name})>[];
          for (final p in newProducts) {
            if (p.categoryId.isNotEmpty &&
                p.categoryName.isNotEmpty &&
                seen.add(p.categoryId)) {
              cats.add((id: p.categoryId, name: p.categoryName));
            }
          }
          widget.onCategoriesLoaded!(cats, total);
        }
      }

      setState(() {
        _products.addAll(newProducts);
        _hasMore = hasMore;
        _offset += widget.pageSize;
        _isInitialLoad = false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
        _isInitialLoad = false;
      });
    }
  }

  void _onTriggerVisible() {
    if (!_isLoading && _hasMore) {
      _loadProducts();
    }
  }

  void _handleProductTap(String productId) {
    if (widget.onProductTap != null) {
      widget.onProductTap!(productId);
    }
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
          // Image placeholder
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
          // Text content placeholder
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title line 1
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Title line 2 (shorter)
                  Container(
                    height: 14,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Price
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundSecondary,
      highlightColor: AppColors.backgroundPrimary.withValues(alpha: 0.5),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(widget.padding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          childAspectRatio: widget.childAspectRatio,
          mainAxisSpacing: widget.mainAxisSpacing,
          crossAxisSpacing: widget.crossAxisSpacing,
        ),
        itemCount: 6, // Show 6 shimmer cards
        itemBuilder: (context, index) => _buildShimmerCard(),
      ),
    );
  }

  List<SellerProduct> get _filteredProducts {
    var list = _products;
    final search = widget.searchQuery?.toLowerCase() ?? '';
    if (search.isNotEmpty) {
      list = list
          .where((p) => p.title.toLowerCase().contains(search))
          .toList();
    }
    final catId = widget.categoryId;
    if (catId != null && catId.isNotEmpty) {
      list = list.where((p) => p.categoryId == catId).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    // Shimmer on initial load
    if (_isInitialLoad && _isLoading) {
      return _buildShimmerGrid();
    }

    if (_error != null && _products.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text('Error loading products',
              style: Theme.of(context).textTheme.bodyMedium!),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              _error ?? '',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              _reset();
              _loadProducts();
            },
            child: Text('Retry', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      );
    }

    final filtered = _filteredProducts;

    if (filtered.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text('No products found',
              style: Theme.of(context).textTheme.bodyLarge!),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(widget.padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.crossAxisCount,
            childAspectRatio: widget.childAspectRatio,
            mainAxisSpacing: widget.mainAxisSpacing,
            crossAxisSpacing: widget.crossAxisSpacing,
          ),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final product = filtered[index];

            if (widget.itemBuilder != null) {
              return GestureDetector(
                onTap: () => _handleProductTap(product.id),
                child: widget.itemBuilder!(product),
              );
            }

            return GestureDetector(
              onTap: () => _handleProductTap(product.id),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text(product.title)),
              ),
            );
          },
        ),
        if (_hasMore)
          VisibilityDetector(
            key: Key('load-more-trigger-${widget.sellerId}'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction > 0) {
                _onTriggerVisible();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isLoading
                  ? AppLoadingIndicator()
                  : const SizedBox(height: 1),
            ),
          )
      ],
    );
  }
}

import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/features/home/domain/models/seller_product_model.dart';
import 'package:shimmer/shimmer.dart';

class InfiniteProductGrid extends StatefulWidget {
  const InfiniteProductGrid({
    super.key,
    this.width,
    this.height,
    required this.sellerId,
    this.userId,
    this.status,
    this.searchText,
    this.categoryId,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.7,
    this.mainAxisSpacing = 12.0,
    this.crossAxisSpacing = 12.0,
    this.padding = 16.0,
    this.pageSize = 20,
    this.onProductTap,
    this.itemBuilder,
    this.onTotalChanged,
  });

  final double? width;
  final double? height;
  final String sellerId;
  final String? userId;
  final String? status;
  final String? searchText;
  final String? categoryId;
  final int crossAxisCount;
  final double childAspectRatio;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double padding;
  final int pageSize;
  final Future Function(String productId)? onProductTap;
  final Widget Function(SellerProduct? sellerProduct)? itemBuilder;
  final Future Function(int total)? onTotalChanged;

  @override
  State<InfiniteProductGrid> createState() => _InfiniteProductGridState();
}

class _InfiniteProductGridState extends State<InfiniteProductGrid> {
  final ScrollController _scrollController = ScrollController();
  final List<SellerProduct> _products = [];

  bool _isLoading = false;
  bool _hasMore = true;
  bool _isInitialLoad = true;
  bool _isSearching = false;
  String? _error;
  int _offset = 0;
  // _total removed (unused)

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadProducts();
  }

  @override
  void didUpdateWidget(InfiniteProductGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status ||
        oldWidget.sellerId != widget.sellerId ||
        oldWidget.searchText != widget.searchText ||
        oldWidget.categoryId != widget.categoryId) {
      final isSearchChange = oldWidget.searchText != widget.searchText;
      _reset(isSearching: isSearchChange);
      _loadProducts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _reset({bool isSearching = false}) {
    setState(() {
      _products.clear();
      _offset = 0;
      _hasMore = true;
      _isInitialLoad = !isSearching;
      _isSearching = isSearching;
      _error = null;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadProducts();
    }
  }

  SellerProduct _mapToStruct(Map<String, dynamic> data) {
    return SellerProduct(
      id: data['id']?.toString() ?? '',
      title: data['title']?.toString() ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (data['original_price'] as num?)?.toDouble() ?? 0.0,
      status: data['status']?.toString() ?? '',
      viewsCount: (data['views_count'] as num?)?.toInt() ?? 0,
      conditionName: data['condition_name']?.toString() ?? '',
      mainImageUrl: data['main_image_url']?.toString() ?? '',
      isInWishlist: data['is_in_wishlist'] as bool? ?? false,
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'].toString())
          : null,
      quantity: (data['quantity'] as num?)?.toInt() ?? 0,
      categoryId: data['category_id']?.toString() ?? '',
    );
  }

  Future<void> _loadProducts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await Supabase.instance.client.rpc(
        'get_seller_products_paginated',
        params: {
          'p_seller_id': widget.sellerId,
          'p_user_id': widget.userId,
          'p_status': widget.status,
          'p_search_text':
              widget.searchText?.isNotEmpty == true ? widget.searchText : null,
          'p_category_id':
              widget.categoryId?.isNotEmpty == true ? widget.categoryId : null,
          'p_limit': widget.pageSize,
          'p_offset': _offset,
        },
      );

      final data = response as Map<String, dynamic>;
      final rawProducts = data['products'] as List<dynamic>;
      final hasMore = data['has_more'] as bool;
      final total = data['total'] as int;

      final newProducts = rawProducts
          .map((e) => _mapToStruct(e as Map<String, dynamic>))
          .toList();

      final isFirstPage = _offset == 0;

      setState(() {
        _products.addAll(newProducts);
        _hasMore = hasMore;
        _offset += widget.pageSize;
        _isInitialLoad = false;
        _isSearching = false;
        _isLoading = false;
      });

      if (isFirstPage && widget.onTotalChanged != null) {
        widget.onTotalChanged!(total);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
        _isInitialLoad = false;
        _isSearching = false;
      });
    }
  }

  Future<void> _refresh() async {
    _reset();
    await _loadProducts();
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF2A2A2A),
      highlightColor: const Color(0xFF3D3D3D),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(4),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  height: 14,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 18,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 24,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      height: 14,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(widget.padding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          childAspectRatio: widget.childAspectRatio,
          mainAxisSpacing: widget.mainAxisSpacing,
          crossAxisSpacing: widget.crossAxisSpacing,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => _buildShimmerCard(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Shimmer on initial load or search
    if ((_isInitialLoad && _isLoading) || _isSearching) {
      return _buildShimmerGrid();
    }

    if (_error != null && _products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _refresh,
              child: Text('Retry', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      );
    }

    if (_products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined,
                size: 64, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              widget.searchText?.isNotEmpty == true
                  ? 'No products found for "${widget.searchText}"'
                  : 'No products found',
              style:
                  GoogleFonts.inter(fontSize: 16, color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(widget.padding),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                childAspectRatio: widget.childAspectRatio,
                mainAxisSpacing: widget.mainAxisSpacing,
                crossAxisSpacing: widget.crossAxisSpacing,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildProductCard(context, _products[index]);
                },
                childCount: _products.length,
              ),
            ),
          ),
          if (_isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, SellerProduct product) {
    return GestureDetector(
      onTap: () {
        if (widget.onProductTap != null && (product.id.isNotEmpty == true)) {
          widget.onProductTap!(product.id);
        }
      },
      child: widget.itemBuilder!(product),
    );
  }
}

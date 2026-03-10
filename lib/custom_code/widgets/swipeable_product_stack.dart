import '/features/home/domain/models/feed_product_model.dart';
import '/core/theme/app_colors.dart';
import '/features/auth/presentation/providers/auth_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SwipeableProductStack extends ConsumerStatefulWidget {
  const SwipeableProductStack({
    super.key,
    this.width,
    this.height,
    required this.products,
    // Callbacks - return productId and index
    this.onBuy,
    this.onHide,
    this.onSkip,
    this.onLike,
    this.onTapDetails,
    this.onEmpty,
    // Styling
    this.colorBuy,
    this.colorHide,
    this.colorSkip,
    this.cardBgColor,
    this.priceTextColor,
    this.emptyMessage,
  });

  final double? width;
  final double? height;
  final List<FeedProduct> products;

  // Callbacks
  final Future<dynamic> Function(FeedProduct product)? onBuy;
  final Future<dynamic> Function(String productId, int index)? onHide;
  final Future<dynamic> Function(String productId, int index)? onSkip;
  final Future<dynamic> Function(String productId, int index)? onLike;
  final Future<dynamic> Function(String productId, int index)? onTapDetails;
  final Future<dynamic> Function()? onEmpty;

  // Styling
  final Color? colorBuy;
  final Color? colorHide;
  final Color? colorSkip;
  final Color? cardBgColor;
  final Color? priceTextColor;
  final String? emptyMessage;

  @override
  ConsumerState<SwipeableProductStack> createState() =>
      _SwipeableProductStackState();
}

class _SwipeableProductStackState extends ConsumerState<SwipeableProductStack>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _showOnboarding = false;

  // Swipe animation
  late AnimationController _swipeController;
  late Animation<Offset> _swipeAnimation;
  late AnimationController _likeController;
  late Animation<double> _likeScaleAnimation;

  Offset _offset = Offset.zero;
  double _rotation = 0.0;

  static const double _maxRotation = 0.15;
  static const double _swipeThreshold = 100.0;
  static const double _upSwipeThreshold = 100.0;
  static const Duration _animationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _initAnimations();
    // Show onboarding only after we confirm the user hasn't viewed home before
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final isViewed = await ref.read(isHomeViewedProvider.future);
    if (mounted && !isViewed) {
      setState(() {
        _showOnboarding = true;
      });
    }
  }

  void _initAnimations() {
    _swipeController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(_updatePositionFromAnimation);

    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_swipeController);

    _likeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _likeScaleAnimation = CurvedAnimation(
      parent: _likeController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _swipeController.dispose();
    _likeController.dispose();
    super.dispose();
  }

  void _updatePositionFromAnimation() {
    setState(() {
      _offset = _swipeAnimation.value;
    });
  }

  void _resetCard() {
    _swipeController.reset();
    setState(() {
      _offset = Offset.zero;
      _rotation = 0.0;
    });
  }

  @override
  void didUpdateWidget(covariant SwipeableProductStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If products list changed (e.g. realtime re-fetch), clamp index
    if (widget.products.length != oldWidget.products.length) {
      if (_currentIndex >= widget.products.length &&
          widget.products.isNotEmpty) {
        _currentIndex = widget.products.length - 1;
      }
    }
  }

  void _nextCard() {
    _resetCard();
    setState(() {
      _currentIndex++;
    });

    if (_currentIndex >= widget.products.length) {
      widget.onEmpty?.call();
    }
  }

  void _triggerLikeAnimation() {
    _likeController.forward(from: 0.0).then((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _likeController.reverse();
        }
      });
    });
  }

  void _handlePanUpdate(DragUpdateDetails details, double screenWidth) {
    if (_swipeController.isAnimating) return;

    setState(() {
      _offset += details.delta;
      _rotation = (_offset.dx / (screenWidth / 2)) * _maxRotation;
      _rotation = _rotation.clamp(-_maxRotation, _maxRotation);
    });
  }

  void _handlePanEnd(DragEndDetails details, double screenWidth) {
    final double dx = _offset.dx.abs();
    final double dy = _offset.dy.abs();
    final currentProduct = widget.products[_currentIndex];
    final productId = currentProduct.id;
    final currentIndex = _currentIndex;

    if (dy > _upSwipeThreshold && dy > dx && _offset.dy < 0) {
      // SWIPE UP -> SKIP (product removed from list by callback)
      _animateOffScreen(Offset(0.0, -screenWidth * 2), () async {
        await widget.onSkip?.call(productId, currentIndex);
        _resetCard();
        // Check if we've run out of products
        if (_currentIndex >= widget.products.length) {
          widget.onEmpty?.call();
        }
        setState(() {});
      });
    } else if (dx > _swipeThreshold) {
      if (_offset.dx < 0) {
        // SWIPE LEFT -> HIDE (product removed from list by callback)
        _animateOffScreen(Offset(-screenWidth * 2, _offset.dy), () async {
          await widget.onHide?.call(productId, currentIndex);
          _resetCard();
          if (_currentIndex >= widget.products.length) {
            widget.onEmpty?.call();
          }
          setState(() {});
        });
      } else {
        // SWIPE RIGHT -> BUY (product stays in list, just move index)
        _animateOffScreen(Offset(screenWidth * 2, _offset.dy), () async {
          await widget.onBuy?.call(currentProduct);
          _nextCard();
        });
      }
    } else {
      _animateSnapBack();
    }
  }

  void _animateOffScreen(Offset endOffset, Future<void> Function() onComplete) {
    final startOffset = _offset;
    _swipeAnimation = Tween<Offset>(
      begin: startOffset,
      end: endOffset,
    ).animate(_swipeController);

    _swipeController.forward(from: 0.0).then((_) async {
      await onComplete();
    });
  }

  void _animateSnapBack() {
    final startOffset = _offset;
    _swipeAnimation =
        Tween<Offset>(begin: startOffset, end: Offset.zero).animate(
      CurvedAnimation(parent: _swipeController, curve: Curves.elasticOut),
    );

    setState(() {
      _rotation = 0.0;
    });

    _swipeController.forward(from: 0.0).then((_) {
      _resetCard();
    });
  }

  String _formatPrice(FeedProduct product) {
    if (product.flashSaleEnabled &&
        product.flashSalePrice != null &&
        product.flashSalePrice! > 0) {
      return '\$${product.flashSalePrice!.toStringAsFixed(2)}';
    }
    return '\$${product.price.toStringAsFixed(2)}';
  }

  bool _isFlashSaleActive(FeedProduct product) {
    if (!product.flashSaleEnabled || product.flashSaleEndsAt == null) {
      return false;
    }
    return DateTime.now().isBefore(product.flashSaleEndsAt!);
  }

  String _formatDiscount(FeedProduct product) {
    final original = product.originalPrice ?? product.price;
    final sale = product.flashSalePrice ?? product.price;
    if (original <= 0) return '';
    final percent = ((original - sale) / original * 100).round();
    return '-$percent%';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty || _currentIndex >= widget.products.length) {
      return _buildEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = widget.width ?? constraints.maxWidth;
        final cardHeight = widget.height ?? constraints.maxHeight;
        final screenWidth = MediaQuery.of(context).size.width;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Active card (front)
            _buildActiveCard(
              widget.products[_currentIndex],
              cardWidth,
              cardHeight,
              screenWidth,
            ),

            // Swipe Up Indicator (below card)
            if (_offset.dy < 0 && _offset.dy.abs() > _offset.dx.abs())
              Positioned(
                bottom: 20,
                child: Transform.scale(
                  scale: 0.5 +
                      ((_offset.dy.abs() / _upSwipeThreshold).clamp(0.0, 1.0) *
                          0.7),
                  child: Opacity(
                    opacity: (_offset.dy.abs() / _upSwipeThreshold).clamp(
                      0.0,
                      1.0,
                    ),
                    child: _buildVerticalSwipeIndicator(
                      widget.colorSkip ?? const Color(0xFFF59E0B),
                    ),
                  ),
                ),
              ),

            // Onboarding Overlay
            if (_showOnboarding) _buildOnboardingOverlay(cardWidth, cardHeight),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
            widget.emptyMessage ?? 'No more products to show',
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new items',
            style: GoogleFonts.inter(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveCard(
    FeedProduct product,
    double cardWidth,
    double cardHeight,
    double screenWidth,
  ) {
    final bgColor = widget.cardBgColor ?? AppColors.backgroundSecondary;
    final cBuy = widget.colorBuy ?? const Color(0xFF4B39EF);
    final cHide = widget.colorHide ?? AppColors.error;

    final double distanceX = _offset.dx.abs();
    final double distanceY = _offset.dy.abs();
    final bool isVerticalSwipe = distanceY > distanceX;

    final double swipeXOpacity = (distanceX / _swipeThreshold).clamp(0.0, 1.0);
    final double swipeYOpacity = (distanceY / _upSwipeThreshold).clamp(
      0.0,
      1.0,
    );

    final double scaleX = 0.5 + (swipeXOpacity * 0.7);

    final bool isFlashSale = _isFlashSaleActive(product);

    return Transform.translate(
      offset: _offset,
      child: Transform.rotate(
        angle: _rotation,
        child: GestureDetector(
          onTap: () async {
            await widget.onTapDetails?.call(product.id, _currentIndex);
          },
          onDoubleTap: () async {
            _triggerLikeAnimation();
            await widget.onLike?.call(product.id, _currentIndex);
          },
          onPanUpdate: (details) => _handlePanUpdate(details, screenWidth),
          onPanEnd: (details) => _handlePanEnd(details, screenWidth),
          child: Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: const Color(0xFF383838), width: 1.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section with 16px padding
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Product Image
                        product.mainImageUrl.isNotEmpty
                            ? Image.network(
                                product.mainImageUrl,
                                width: cardWidth,
                                height: cardHeight * 0.62,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: cardWidth,
                                  height: cardHeight * 0.62,
                                  color: AppColors.textSecondary
                                      .withValues(alpha: 0.2),
                                  child: Icon(
                                    Icons.broken_image,
                                    color: AppColors.textSecondary,
                                    size: 48,
                                  ),
                                ),
                              )
                            : Container(
                                width: cardWidth,
                                height: cardHeight * 0.62,
                                color: AppColors.textSecondary
                                    .withValues(alpha: 0.2),
                                child: Icon(
                                  Icons.image,
                                  color: AppColors.textSecondary,
                                  size: 48,
                                ),
                              ),

                        // Swipe Action Icons
                        Positioned.fill(
                          child: Center(
                            child: Stack(
                              children: [
                                // SWIPE LEFT -> HIDE
                                if (_offset.dx < 0 && !isVerticalSwipe)
                                  Center(
                                    child: Transform.scale(
                                      scale: scaleX,
                                      child: Opacity(
                                        opacity: swipeXOpacity,
                                        child: _buildActionIcon(
                                          Icons.thumb_down,
                                          cHide,
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),

                                // SWIPE RIGHT -> BUY
                                if (_offset.dx > 0 && !isVerticalSwipe)
                                  Center(
                                    child: Transform.scale(
                                      scale: scaleX,
                                      child: Opacity(
                                        opacity: swipeXOpacity,
                                        child: _buildActionIcon(
                                          Icons.shopping_cart_rounded,
                                          cBuy,
                                          Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        // Like Animation (center heart)
                        Center(
                          child: ScaleTransition(
                            scale: _likeScaleAnimation,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.favorite_rounded,
                                size: 100,
                                color: product.isInWishlist
                                    ? Colors.red
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),

                        // "Tap to view details" button (bottom left)
                        if (swipeXOpacity < 0.1 && swipeYOpacity < 0.1)
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: GestureDetector(
                              onTap: () async {
                                await widget.onTapDetails?.call(
                                  product.id,
                                  _currentIndex,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Text(
                                  'Tap to view details',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 18 / 12,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Like Button (top right)
                        Positioned(
                          top: 16,
                          right: 16,
                          child: GestureDetector(
                            onTap: () async {
                              _triggerLikeAnimation();
                              await widget.onLike?.call(
                                product.id,
                                _currentIndex,
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.4),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                product.isInWishlist
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: product.isInWishlist
                                    ? Colors.red
                                    : Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),

                        // Seller Info Row
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                                image: product.sellerAvatarUrl != null &&
                                        product.sellerAvatarUrl!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(
                                          product.sellerAvatarUrl!,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: product.sellerAvatarUrl == null ||
                                      product.sellerAvatarUrl!.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      size: 12,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                '@${product.sellerUsername}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  height: 16 / 12,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        // Title
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 30 / 20,
                          ),
                        ),

                        // Condition
                        if (product.conditionName.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            product.conditionName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 20 / 14,
                            ),
                          ),
                        ],

                        const SizedBox(height: 8),

                        // Price Row with Flash Sale
                        Row(
                          children: [
                            Text(
                              _formatPrice(product),
                              style: GoogleFonts.inter(
                                color: AppColors.textPrimary,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                height: 36 / 24,
                              ),
                            ),
                            if (isFlashSale &&
                                product.originalPrice != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                '\$${product.originalPrice!.toStringAsFixed(2)}',
                                style: GoogleFonts.inter(
                                  color: AppColors.textSecondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.lineThrough,
                                  height: 16 / 16,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.bolt,
                                color: const Color(0xFFFF2D55),
                                size: 16,
                              ),
                              Text(
                                _formatDiscount(product),
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFFF2D55),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  height: 16 / 16,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, size: 48, color: iconColor),
    );
  }

  Widget _buildVerticalSwipeIndicator(Color color) {
    // Design colors for each bar
    const Color leftBarColor = Color(0xFF7B59FE);
    const Color middleBarColor = Color(0xFF716BF9);
    const Color rightBarColor = Color(0xFF697AF5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSwipeBar(61, leftBarColor),
          const SizedBox(width: 8),
          _buildSwipeBar(40, middleBarColor),
          const SizedBox(width: 8),
          _buildSwipeBar(61, rightBarColor),
        ],
      ),
    );
  }

  Widget _buildSwipeBar(double height, Color color) {
    return Container(
      width: 6,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  /// Builds the onboarding overlay with swipe instructions
  Widget _buildOnboardingOverlay(
    double cardWidth,
    double cardHeight,
  ) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Stack(
          children: [
            // Skip instruction (top center)
            Positioned(
              top: cardHeight * 0.12,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Icon(Icons.arrow_upward, color: Colors.white, size: 24),
                  const SizedBox(height: 4),
                  Text(
                    'Skip',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),

            // Double-tap hint (center)
            Positioned(
              top: cardHeight * 0.28,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Double-tap to wishlist \u2022 Tap to view details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            // Hide (left) and Buy (right) instructions
            Positioned(
              top: cardHeight * 0.42,
              left: 17,
              right: 17,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Hide instruction
                  Row(
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'Hide',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                  // Buy instruction
                  Row(
                    children: [
                      Text(
                        'Buy',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  ),
                ],
              ),
            ),

            // Got It! button (bottom) - matches exact design specs
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: _dismissOnboarding,
                child: Container(
                  height: 149,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.brandPurple, AppColors.brandBlue],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(13),
                      bottomRight: Radius.circular(13),
                    ),
                    border: Border(
                      top: BorderSide(color: const Color(0xFF989898), width: 1),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Got It!',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                      ),
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

  /// Dismisses the onboarding overlay and marks home as viewed
  void _dismissOnboarding() {
    setState(() {
      _showOnboarding = false;
    });
    ref.read(isHomeViewedProvider.notifier).set(true);
  }
}

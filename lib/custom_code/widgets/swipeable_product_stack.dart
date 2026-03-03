// Automatic FlutterFlow imports
import '/backend/schema/enums/enums.dart';
import '/features/home/domain/models/feed_product_model.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/widgets/index.dart';
import '/flutter_flow/custom_functions.dart';

class SwipeableProductStack extends StatefulWidget {
  const SwipeableProductStack({
    super.key,
    this.width,
    this.height,
    required this.products,
    // Callbacks - возвращают productId и index
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
  State<SwipeableProductStack> createState() => _SwipeableProductStackState();
}

class _SwipeableProductStackState extends State<SwipeableProductStack>
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
    // Show onboarding only if the user hasn't viewed home before
    _showOnboarding = !(FFAppState().isHomeViewed);
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
    setState(() {
      _offset = Offset.zero;
      _rotation = 0.0;
    });
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
      // SWIPE UP -> SKIP
      _animateOffScreen(Offset(0.0, -screenWidth * 2), () async {
        await widget.onSkip?.call(productId, currentIndex);
        _nextCard();
      });
    } else if (dx > _swipeThreshold) {
      if (_offset.dx < 0) {
        // SWIPE LEFT -> HIDE
        _animateOffScreen(Offset(-screenWidth * 2, _offset.dy), () async {
          await widget.onHide?.call(productId, currentIndex);
          _nextCard();
        });
      } else {
        // SWIPE RIGHT -> BUY
        _animateOffScreen(Offset(screenWidth * 2, _offset.dy), () async {
          await widget.onBuy?.call(currentProduct);
          _nextCard();
        });
      }
    } else {
      _animateSnapBack();
    }
  }

  void _animateOffScreen(Offset endOffset, VoidCallback onComplete) {
    final startOffset = _offset;
    _swipeAnimation = Tween<Offset>(
      begin: startOffset,
      end: endOffset,
    ).animate(_swipeController);

    _swipeController.forward(from: 0.0).then((_) {
      onComplete();
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

  // Форматирование цены с учётом flash sale
  String _formatPrice(FeedProduct product) {
    if (product.flashSaleEnabled &&
        product.flashSalePrice != null &&
        product.flashSalePrice! > 0) {
      return '\$${product.flashSalePrice!.toStringAsFixed(2)}';
    }
    return '\$${product.price.toStringAsFixed(2)}';
  }

  // Проверка активности flash sale
  bool _isFlashSaleActive(FeedProduct product) {
    if (!product.flashSaleEnabled || product.flashSaleEndsAt == null) {
      return false;
    }
    return DateTime.now().isBefore(product.flashSaleEndsAt!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    if (widget.products.isEmpty || _currentIndex >= widget.products.length) {
      return _buildEmptyState(theme);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = widget.width ?? constraints.maxWidth;
        final cardHeight = widget.height ?? constraints.maxHeight;
        final screenWidth = MediaQuery.of(context).size.width;

        return Stack(
          alignment: Alignment.center,
          children: [
            // Активная карточка (передняя)
            _buildActiveCard(
              widget.products[_currentIndex],
              cardWidth,
              cardHeight,
              screenWidth,
              theme,
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
            if (_showOnboarding)
              _buildOnboardingOverlay(theme, cardWidth, cardHeight),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(FlutterFlowTheme theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: theme.secondaryText,
          ),
          const SizedBox(height: 16),
          Text(
            widget.emptyMessage ?? 'No more products to show',
            style: theme.titleMedium.override(
              fontFamily: theme.titleMediumFamily,
              color: theme.secondaryText,
              useGoogleFonts: true,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new items',
            style: theme.bodyMedium.override(
              fontFamily: theme.bodyMediumFamily,
              color: theme.secondaryText.withOpacity(0.7),
              useGoogleFonts: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundCard(
    FeedProduct product,
    double width,
    double height,
    FlutterFlowTheme theme, {
    required double scale,
    required double opacity,
    double offsetY = 0,
  }) {
    final bgColor = widget.cardBgColor ?? const Color(0xFF252525);

    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF383838)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product.mainImageUrl.isNotEmpty
                  ? Image.network(
                      product.mainImageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _buildImagePlaceholder(theme),
                    )
                  : _buildImagePlaceholder(theme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveCard(
    FeedProduct product,
    double cardWidth,
    double cardHeight,
    double screenWidth,
    FlutterFlowTheme theme,
  ) {
    final bgColor = widget.cardBgColor ?? const Color(0xFF252525);
    final priceColor = widget.priceTextColor ?? Colors.white;
    final cBuy = widget.colorBuy ?? const Color(0xFF4B39EF);
    final cHide = widget.colorHide ?? theme.error;
    final cSkip = widget.colorSkip ?? const Color(0xFFF59E0B);

    final double distanceX = _offset.dx.abs();
    final double distanceY = _offset.dy.abs();
    final bool isVerticalSwipe = distanceY > distanceX;

    final double swipeXOpacity = (distanceX / _swipeThreshold).clamp(0.0, 1.0);
    final double swipeYOpacity = (distanceY / _upSwipeThreshold).clamp(
      0.0,
      1.0,
    );

    final double scaleX = 0.5 + (swipeXOpacity * 0.7);
    final double scaleY = 0.5 + (swipeYOpacity * 0.7);

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
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
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
                                height: cardHeight * 0.65,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: cardWidth,
                                  height: cardHeight * 0.65,
                                  color: theme.secondaryText.withOpacity(0.2),
                                  child: Icon(
                                    Icons.broken_image,
                                    color: theme.secondaryText,
                                    size: 48,
                                  ),
                                ),
                              )
                            : Container(
                                width: cardWidth,
                                height: cardHeight * 0.65,
                                color: theme.secondaryText.withOpacity(0.2),
                                child: Icon(
                                  Icons.image,
                                  color: theme.secondaryText,
                                  size: 48,
                                ),
                              ),

                        // Flash Sale Badge
                        if (isFlashSale)
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.flash_on,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'FLASH SALE',
                                    style: theme.bodySmall.override(
                                      fontFamily: theme.bodySmallFamily,
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts: true,
                                    ),
                                  ),
                                ],
                              ),
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
                            bottom: 12,
                            left: 12,
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
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Text(
                                  'Tap to view details',
                                  style: theme.bodyMedium.override(
                                    fontFamily: theme.bodyMediumFamily,
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    useGoogleFonts: true,
                                  ),
                                ),
                              ),
                            ),
                          ),

                        // Like Button (top right)
                        Positioned(
                          top: 12,
                          right: 12,
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
                                color: Colors.black.withOpacity(0.4),
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
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.headlineMedium.override(
                            fontFamily: theme.headlineMediumFamily,
                            color: theme.primaryText,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            useGoogleFonts: true,
                          ),
                        ),

                        const SizedBox(height: 4),

                        // Subtitle (condition)
                        if (product.conditionName.isNotEmpty)
                          Text(
                            product.conditionName,
                            style: theme.bodyMedium.override(
                              fontFamily: theme.bodyMediumFamily,
                              color: theme.secondaryText,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              useGoogleFonts: true,
                            ),
                          ),

                        const Spacer(),

                        // Price & Seller Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Price
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Original price (if flash sale)
                                if (isFlashSale &&
                                    product.originalPrice != null)
                                  Text(
                                    '\$${product.originalPrice!.toStringAsFixed(2)}',
                                    style: theme.bodySmall.override(
                                      fontFamily: theme.bodySmallFamily,
                                      color: theme.secondaryText,
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                      useGoogleFonts: true,
                                    ),
                                  ),
                                Text(
                                  _formatPrice(product),
                                  style: theme.titleLarge.override(
                                    fontFamily: theme.titleLargeFamily,
                                    color:
                                        isFlashSale ? Colors.red : priceColor,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    useGoogleFonts: true,
                                  ),
                                ),
                              ],
                            ),

                            // Seller Info
                            Row(
                              children: [
                                // Seller Avatar
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
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
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 8),

                                // Seller Username & Rating
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '@${product.sellerUsername}',
                                      style: theme.bodySmall.override(
                                        fontFamily: theme.bodySmallFamily,
                                        color: theme.secondaryText,
                                        fontSize: 12,
                                        useGoogleFonts: true,
                                      ),
                                    ),
                                    if (product.sellerRating > 0)
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star_rounded,
                                            size: 12,
                                            color: Colors.amber,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            '${product.sellerRating.toStringAsFixed(1)} (${product.sellerTotalReviews})',
                                            style: theme.bodySmall.override(
                                              fontFamily: theme.bodySmallFamily,
                                              color: theme.secondaryText,
                                              fontSize: 10,
                                              useGoogleFonts: true,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
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

  Widget _buildImagePlaceholder(FlutterFlowTheme theme) {
    return Container(
      color: theme.secondaryText.withOpacity(0.2),
      child: Center(
        child: Icon(Icons.image, color: theme.secondaryText, size: 48),
      ),
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
    FlutterFlowTheme theme,
    double cardWidth,
    double cardHeight,
  ) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
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
                  'Double-tap to wishlist • Tap to view details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white.withOpacity(0.9),
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
                      colors: [Color(0xFF7D56FF), Color(0xFF6187F1)],
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
    // Mark home as viewed in AppState
    FFAppState().isHomeViewed = true;
  }
}

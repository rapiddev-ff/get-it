import 'dart:math';
import 'dart:ui' as ui;

import '/features/auth/data/supabase_auth/auth_util.dart';
import '/features/home/domain/models/product_details_model.dart';
import '/features/messages/domain/models/conversation_model.dart';
import '/features/home/domain/models/feed_product_model.dart';
import '/features/messages/presentation/providers/messages_provider.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/core/widgets/custom_icons.dart' show AppIcons;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class HomeProductWidget extends ConsumerStatefulWidget {
  const HomeProductWidget({
    super.key,
    required this.productId,
  });

  final String? productId;

  static String routeName = 'homeProduct';
  static String routePath = 'homeProduct';

  @override
  ConsumerState<HomeProductWidget> createState() => _HomeProductWidgetState();
}

class _HomeProductWidgetState extends ConsumerState<HomeProductWidget> {
  // Inlined from HomeProductModel
  ProductDetails? _getProduct;
  PageController? _pageViewController;
  Conversation? _getOrCreateConversation;
  bool _isInWishlist = false;
  bool _isTogglingWishlist = false;

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final productId = widget.productId;
      if (!mounted || productId == null || productId.isEmpty) return;
      try {
        _getProduct = await actions.getProductDetails(
          productId,
          currentUserUid,
        );
        _isInWishlist = _getProduct?.isInWishlist ?? false;
      } catch (_) {
        // Network or API error — leave _getProduct null (shimmer stays).
      }
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageViewController?.dispose();
    super.dispose();
  }

  String _formatCurrency(num? value, {String prefix = ''}) {
    if (value == null) return '0';
    return '$prefix${NumberFormat('#,##0.##', 'en_US').format(value)}';
  }

  bool _hasValue(String? value) =>
      value != null && value.isNotEmpty && value != 'null';

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundSecondary,
      highlightColor: Color(0xFF3A3A3A),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 416.0,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 250.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    width: 120.0,
                    height: 28.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Container(
                    width: double.infinity,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Container(
                    width: 100.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    width: double.infinity,
                    height: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Container(
                    width: 160.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  SizedBox(height: 12.0),
                  ...List.generate(
                    3,
                    (_) => Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 100.0,
                            height: 16.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                          Container(
                            width: 60.0,
                            height: 16.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.normal,
              color: Color(0xFFAFAFB4),
              fontSize: 16.0,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.normal,
              color: AppColors.textPrimary,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = _getProduct;

    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: AppBar(
            backgroundColor: AppColors.backgroundPrimary,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    minimumSize: Size(40.0, 40.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: Icon(
                    AppIcons.karrowBack,
                    color: AppColors.info,
                    size: 24.0,
                  ),
                  onPressed: () {
                    context.pop();
                  },
                ),
                Text(
                  'Product Details',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    minimumSize: Size(40.0, 40.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: Icon(
                    AppIcons.khelp,
                    color: AppColors.info,
                    size: 20.0,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            actions: [],
            centerTitle: true,
            elevation: 0.0,
          ),
        ),
        body: product == null
            ? _buildShimmer()
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 416.0,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundSecondary,
                            ),
                            child: Builder(
                              builder: (context) {
                                final images = product.images.toList();
                                if (images.isEmpty) {
                                  return Center(
                                    child: Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Color(0xFFAFAFB4),
                                      size: 48.0,
                                    ),
                                  );
                                }

                                return Container(
                                  width: double.infinity,
                                  child: Stack(
                                    children: [
                                      PageView.builder(
                                        controller: _pageViewController ??=
                                            PageController(
                                                initialPage: max(0,
                                                    min(0, images.length - 1))),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: images.length,
                                        itemBuilder: (context, imagesIndex) {
                                          final imagesItem =
                                              images[imagesIndex];
                                          return Align(
                                            alignment:
                                                AlignmentDirectional(0.0, -1.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 32.0, 0.0, 0.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: CachedNetworkImage(
                                                  imageUrl: imagesItem.imageUrl,
                                                  width: 310.0,
                                                  height: 320.0,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Shimmer.fromColors(
                                                    baseColor: AppColors
                                                        .backgroundSecondary,
                                                    highlightColor:
                                                        Color(0xFF3A3A3A),
                                                    child: Container(
                                                      width: 310.0,
                                                      height: 320.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(
                                                    Icons.broken_image,
                                                    color: Color(0xFFAFAFB4),
                                                    size: 48.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      if (images.length > 1)
                                        Align(
                                          alignment:
                                              AlignmentDirectional(0.0, 1.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 30.0),
                                            child: smooth_page_indicator
                                                .SmoothPageIndicator(
                                              controller: _pageViewController ??=
                                                  PageController(
                                                      initialPage: max(
                                                          0,
                                                          min(
                                                              0,
                                                              images.length -
                                                                  1))),
                                              count: images.length,
                                              axisDirection: Axis.horizontal,
                                              onDotClicked: (i) async {
                                                await _pageViewController!
                                                    .animateToPage(
                                                  i,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.ease,
                                                );
                                                setState(() {});
                                              },
                                              effect: smooth_page_indicator
                                                  .SlideEffect(
                                                spacing: 8.0,
                                                radius: 8.0,
                                                dotWidth: 8.0,
                                                dotHeight: 8.0,
                                                dotColor: Color(0x80FFFFFF),
                                                activeDotColor: Colors.white,
                                                paintStyle: PaintingStyle.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          if (!product.isOwnProduct)
                            Positioned(
                              top: 12.0,
                              right: 12.0,
                              child: GestureDetector(
                                onTap: () async {
                                  if (_isTogglingWishlist) return;
                                  setState(() {
                                    _isTogglingWishlist = true;
                                    _isInWishlist = !_isInWishlist;
                                  });
                                  final result = await actions.toggleWishlist(
                                    currentUserUid,
                                    product.id,
                                  );
                                  if (mounted) {
                                    setState(() {
                                      _isInWishlist = result;
                                      _isTogglingWishlist = false;
                                    });
                                  }
                                },
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isInWishlist
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _isInWishlist
                                        ? Colors.red
                                        : Colors.white,
                                    size: 22.0,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_hasValue(product.title))
                            Text(
                              product.title,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                              ),
                            ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 4.0, 0.0, 0.0),
                            child: _buildPriceRow(product),
                          ),
                          if (product.tags.isNotEmpty)
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: _buildTagsSection(product),
                            ),
                          if (product.seller != null)
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: InkWell(
                                onTap: () async {
                                  context.pushNamed(
                                    HomeSellerProfileWidget.routeName,
                                    queryParameters: {
                                      'sellerId': product.seller?.id ?? '',
                                    },
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundSecondary,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 48.0,
                                          height: 48.0,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: CachedNetworkImage(
                                            fadeInDuration:
                                                Duration(milliseconds: 500),
                                            fadeOutDuration:
                                                Duration(milliseconds: 500),
                                            imageUrl: valueOrDefault<String>(
                                              product.seller?.avatarUrl,
                                              'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (_hasValue(
                                                  product.seller?.username))
                                                Text(
                                                  product.seller!.username,
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        0.0, 8.0, 0.0, 0.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Icon(
                                                      Icons.star_sharp,
                                                      color: Color(0xFFFFD900),
                                                      size: 18.0,
                                                    ),
                                                    Text(
                                                      '${product.seller?.ratingAsSeller ?? 0} (${product.seller?.totalReviewsAsSeller ?? 0} reviews)',
                                                      style: GoogleFonts.inter(
                                                        color:
                                                            Color(0xFFAFAFB4),
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(width: 8.0)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          color: Color(0xFFAFAFB4),
                                          size: 24.0,
                                        ),
                                      ].divide(SizedBox(width: 12.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (_hasValue(product.description)) ...[
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
                              child: Text(
                                'Description',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 4.0, 0.0, 0.0),
                              child: Text(
                                product.description,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ],
                          if (_hasConditionOrDetails(product)) ...[
                            Divider(
                              height: 48.0,
                              thickness: 2.0,
                              color: Color(0xFF363636),
                            ),
                            Text(
                              'Condition & Details',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                            if (product.conditions.isNotEmpty)
                              _buildDetailRow(
                                'Condition',
                                product.conditions
                                    .map((c) => c.name)
                                    .join(', '),
                              ),
                            if (product.year != null)
                              _buildDetailRow('Year', product.year.toString()),
                            if (product.issueNumber != null)
                              _buildDetailRow(
                                  'Issue Number', '#${product.issueNumber}'),
                          ],
                          if (_hasShippingInfo(product)) ...[
                            Divider(
                              height: 48.0,
                              thickness: 2.0,
                              color: Color(0xFF363636),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.backgroundSecondary,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.local_shipping,
                                          color: AppColors.primary,
                                          size: 18.0,
                                        ),
                                        Text(
                                          'Shipping Information',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 12.0)),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      product.freeShipping
                                          ? 'Free shipping'
                                          : 'Shipping cost: ${_formatCurrency(_getShippingCost(product), prefix: '\$')}',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 4.0),
                                    Text(
                                      'Carefully packaged with tracking included.',
                                      style: GoogleFonts.inter(
                                        fontSize: 14.0,
                                        color: Color(0xFFAFAFB4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          if (currentUserUid != product.seller?.id) ...[
                            Divider(
                              height: 48.0,
                              thickness: 2.0,
                              color: Color(0xFF363636),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 56.0,
                                    child: TextButton(
                                      onPressed: () async {
                                        _getOrCreateConversation = await actions
                                            .getOrCreateConversation(
                                          product.seller?.id ?? '',
                                          widget.productId,
                                        );
                                        ref
                                            .read(messagesProvider.notifier)
                                            .setCurrentConversation(
                                                _getOrCreateConversation!);
                                        if (!mounted) return;
                                        context.pushNamed(
                                          ChatPageWidget.routeName,
                                          queryParameters: {
                                            'conversation':
                                                _getOrCreateConversation!
                                                    .serialize(),
                                          },
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                            AppColors.backgroundSecondary,
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                      child: Text(
                                        'Ask Question',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 17.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    height: 56.0,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF7D56FF),
                                          Color(0xFF6187F1)
                                        ],
                                        stops: [0.0, 1.0],
                                        begin: AlignmentDirectional(0.0, -1.0),
                                        end: AlignmentDirectional(0, 1.0),
                                      ),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: TextButton(
                                      onPressed: () async {
                                        context.pushNamed(
                                          CheckoutWidget.routeName,
                                          queryParameters: {
                                            'feedProductItem': FeedProduct(
                                              id: product.id,
                                              title: product.title,
                                              description: product.description,
                                              price: product.price,
                                              originalPrice:
                                                  product.originalPrice,
                                              flashSaleEnabled:
                                                  product.flashSaleEnabled,
                                              flashSalePrice:
                                                  product.flashSalePrice,
                                              flashSaleEndsAt:
                                                  product.flashSaleEndsAt,
                                              conditionName: product.conditions
                                                      .firstOrNull?.name ??
                                                  '',
                                              mainImageUrl: product.images
                                                      .firstOrNull?.imageUrl ??
                                                  '',
                                              sellerId:
                                                  product.seller?.id ?? '',
                                              sellerUsername:
                                                  product.seller?.username ??
                                                      '',
                                              sellerAvatarUrl:
                                                  product.seller?.avatarUrl,
                                              sellerRating: product
                                                      .seller?.ratingAsSeller ??
                                                  0.0,
                                              sellerTotalReviews: product.seller
                                                      ?.totalReviewsAsSeller ??
                                                  0,
                                              isInWishlist:
                                                  product.isInWishlist,
                                              createdAt: product.createdAt,
                                              shippingPrice:
                                                  product.shippingPrice,
                                              freeShipping:
                                                  product.freeShipping,
                                              useSellerShipping:
                                                  product.useSellerShipping,
                                              customFlatRate:
                                                  product.customFlatRate,
                                              customAdditionalItemFee: product
                                                  .customAdditionalItemFee,
                                            ).serialize(),
                                            'initialQuantity': 1.toString(),
                                          },
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color(0x008E6CFF),
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 0.0, 16.0, 0.0),
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            AppIcons.kadd,
                                            color: Colors.white,
                                            size: 28.0,
                                          ),
                                          SizedBox(width: 8.0),
                                          Text(
                                            'Buy Now',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                              fontSize: 17.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ].divide(SizedBox(width: 20.0)),
                            ),
                          ],
                        ].addToEnd(SizedBox(height: 32.0)),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildPriceRow(ProductDetails product) {
    final hasFlashSale =
        product.flashSaleEnabled && product.flashSalePrice != null;
    final hasDiscount = product.discountType != null &&
        product.discountAmount != null &&
        product.discountAmount! > 0;

    if (!hasFlashSale && !hasDiscount) {
      return Text(
        _formatCurrency(product.price, prefix: '\$'),
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
        ),
      );
    }

    // Determine display prices and discount text
    double currentPrice = product.price;
    double? originalPrice;
    String discountLabel = '';

    if (hasFlashSale) {
      currentPrice = product.flashSalePrice!;
      originalPrice = product.price;
    } else if (hasDiscount) {
      originalPrice = product.originalPrice ?? product.price;
    }

    if (product.discountType == 'percentage') {
      discountLabel = '-${product.discountAmount!.toStringAsFixed(0)}%';
    } else if (product.discountType == 'dollar') {
      discountLabel = '\$${_formatCurrency(product.discountAmount!)}';
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          _formatCurrency(currentPrice, prefix: '\$'),
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        if (originalPrice != null) ...[
          SizedBox(width: 8.0),
          Text(
            _formatCurrency(originalPrice, prefix: '\$'),
            style: GoogleFonts.inter(
              fontWeight: FontWeight.normal,
              fontSize: 14.0,
              color: Color(0xFFAFAFB4),
              decoration: TextDecoration.lineThrough,
              decorationColor: Color(0xFFAFAFB4),
            ),
          ),
        ],
        if (discountLabel.isNotEmpty) ...[
          SizedBox(width: 6.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bolt,
                color: Color(0xFFFF6B6B),
                size: 16.0,
              ),
              Text(
                discountLabel,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: Color(0xFFFF6B6B),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(
          color: Color(0xFF363636),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(12.0, 5.0, 12.0, 5.0),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.normal,
            fontSize: 14.0,
          ),
        ),
      ),
    );
  }

  Widget _buildTagsSection(ProductDetails product) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tags = product.tags;
        const spacing = 12.0;
        const runSpacing = 12.0;

        // Measure tag widths to determine which fit in 2 rows
        final visibleTags = <int>[];
        double currentRowWidth = 0.0;
        int rowCount = 1;
        const maxRows = 2;

        for (int i = 0; i < tags.length; i++) {
          final tagWidth = _estimateTagWidth(tags[i].name);
          final widthNeeded = currentRowWidth == 0
              ? tagWidth
              : currentRowWidth + spacing + tagWidth;

          if (widthNeeded <= constraints.maxWidth) {
            currentRowWidth = widthNeeded;
            visibleTags.add(i);
          } else if (rowCount < maxRows) {
            rowCount++;
            currentRowWidth = tagWidth;
            visibleTags.add(i);
          } else {
            break;
          }
        }

        final remainingCount = tags.length - visibleTags.length;

        // Check if "+N" chip fits, if not remove last visible tag
        if (remainingCount > 0) {
          final moreChipWidth = _estimateTagWidth('+$remainingCount');

          // Try to fit "+N" on the current row
          final spaceNeeded = currentRowWidth + spacing + moreChipWidth;
          if (spaceNeeded > constraints.maxWidth) {
            // Remove last tag to make room
            visibleTags.removeLast();
          }
        }

        final actualRemaining = tags.length - visibleTags.length;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: [
            ...visibleTags.map((i) => _buildTagChip(tags[i].name)),
            if (actualRemaining > 0)
              GestureDetector(
                onTap: () => _showAllTagsBottomSheet(context, tags),
                child: _buildTagChip('+$actualRemaining'),
              ),
          ],
        );
      },
    );
  }

  double _estimateTagWidth(String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.normal,
          fontSize: 14.0,
        ),
      ),
      maxLines: 1,
      textDirection: ui.TextDirection.ltr,
    )..layout();
    // 12 padding left + 12 padding right + 2 border
    return textPainter.width + 26.0;
  }

  void _showAllTagsBottomSheet(BuildContext context, List tags) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tags',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
                SizedBox(height: 24.0),
                Flexible(
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 12.0,
                      runSpacing: 12.0,
                      children: tags
                          .map((tag) => _buildTagChip(tag.name as String))
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  height: 52.0,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.backgroundSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _getShippingCost(ProductDetails product) {
    if (product.freeShipping) return 0.0;
    if (product.customFlatRate != null && product.customFlatRate! > 0) {
      return product.customFlatRate!;
    }
    return product.shippingPrice;
  }

  bool _hasConditionOrDetails(ProductDetails product) {
    return product.conditions.isNotEmpty ||
        product.year != null ||
        product.issueNumber != null;
  }

  bool _hasShippingInfo(ProductDetails product) {
    return product.freeShipping ||
        (product.customFlatRate != null && product.customFlatRate! > 0) ||
        (product.customAdditionalItemFee != null &&
            product.customAdditionalItemFee! > 0) ||
        product.shippingPrice > 0;
  }
}

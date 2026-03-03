import 'dart:math';

import '/features/auth/data/supabase_auth/auth_util.dart';
import '/app_state.dart';
import '/features/home/domain/models/product_details_model.dart';
import '/features/messages/domain/models/conversation_model.dart';
import '/features/home/domain/models/feed_product_model.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import '/flutter_flow/custom_icons.dart' show FFIcons;
import 'package:smooth_page_indicator/smooth_page_indicator.dart'
    as smooth_page_indicator;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeProductWidget extends StatefulWidget {
  const HomeProductWidget({
    super.key,
    required this.productId,
  });

  final String? productId;

  static String routeName = 'homeProduct';
  static String routePath = 'homeProduct';

  @override
  State<HomeProductWidget> createState() => _HomeProductWidgetState();
}

class _HomeProductWidgetState extends State<HomeProductWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Inlined from HomeProductModel
  ProductDetails? _getProduct;
  PageController? _pageViewController;
  Conversation? _getOrCreateConversation;


  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _getProduct = await actions.getProductDetails(
        widget.productId!,
        currentUserUid,
      );

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
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
                    FFIcons.karrowBack,
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
                    FFIcons.khelp,
                    color: AppColors.info,
                    size: 20.0,
                  ),
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                ),
              ],
            ),
            actions: [],
            centerTitle: true,
            elevation: 0.0,
          ),
        ),
        body: SingleChildScrollView(
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
                          final images =
                              _getProduct?.images.toList() ?? [];

                          return Container(
                            width: double.infinity,
                            child: Stack(
                              children: [
                                PageView.builder(
                                  controller: _pageViewController ??=
                                      PageController(
                                          initialPage: max(
                                              0, min(0, images.length - 1))),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: images.length,
                                  itemBuilder: (context, imagesIndex) {
                                    final imagesItem = images[imagesIndex];
                                    return Align(
                                      alignment:
                                          AlignmentDirectional(0.0, -1.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 32.0, 0.0, 0.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            imagesItem.imageUrl,
                                            width: 310.0,
                                            height: 320.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0.0, 1.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 30.0),
                                    child: smooth_page_indicator
                                        .SmoothPageIndicator(
                                      controller: _pageViewController ??=
                                          PageController(
                                              initialPage: max(0,
                                                  min(0, images.length - 1))),
                                      count: images.length,
                                      axisDirection: Axis.horizontal,
                                      onDotClicked: (i) async {
                                        await _pageViewController!
                                            .animateToPage(
                                          i,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease,
                                        );
                                        setState(() {});
                                      },
                                      effect: smooth_page_indicator.SlideEffect(
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      valueOrDefault<String>(
                        _getProduct?.title,
                        'n/a',
                      ),
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                      child: Text(
                        _formatCurrency(_getProduct?.price, prefix: '\$'),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: Builder(
                        builder: (context) {
                          final tags = _getProduct?.tags.toList() ?? [];

                          return Wrap(
                            spacing: 12.0,
                            runSpacing: 12.0,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            direction: Axis.horizontal,
                            runAlignment: WrapAlignment.start,
                            verticalDirection: VerticalDirection.down,
                            clipBehavior: Clip.none,
                            children: List.generate(tags.length, (tagsIndex) {
                              final tagsItem = tags[tagsIndex];
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundSecondary,
                                  borderRadius: BorderRadius.circular(100.0),
                                  border: Border.all(
                                    color: Color(0xFF363636),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 5.0, 12.0, 5.0),
                                  child: Text(
                                    tagsItem.name,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(
                            HomeSellerProfileWidget.routeName,
                            queryParameters: {
                              'sellerId':
                                  _getProduct?.seller?.id ?? '',
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
                                    fadeInDuration: Duration(milliseconds: 500),
                                    fadeOutDuration:
                                        Duration(milliseconds: 500),
                                    imageUrl: valueOrDefault<String>(
                                      _getProduct?.seller?.avatarUrl,
                                      'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        valueOrDefault<String>(
                                          _getProduct?.seller?.username,
                                          'N/A',
                                        ),
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              Icons.star_sharp,
                                              color: Color(0xFFFFD900),
                                              size: 18.0,
                                            ),
                                            Text(
                                              '${_getProduct?.seller?.ratingAsSeller.toString()} (${_getProduct?.seller?.totalReviewsAsSeller.toString()} reviews)',
                                              style: GoogleFonts.inter(
                                                color: Color(0xFFAFAFB4),
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ].divide(SizedBox(width: 8.0)),
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
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                      child: Text(
                        'Description',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                      child: Text(
                        valueOrDefault<String>(
                          _getProduct?.description,
                          'N/A',
                        ),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.normal,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
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
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Condition',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.normal,
                              color: Color(0xFFAFAFB4),
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            valueOrDefault<String>(
                              _getProduct?.conditions.firstOrNull?.name,
                              'N/A',
                            ),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.normal,
                              color: AppColors.textPrimary,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Year',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.normal,
                              color: Color(0xFFAFAFB4),
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            valueOrDefault<String>(
                              _getProduct?.year.toString(),
                              'N/A',
                            ),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.normal,
                              color: AppColors.textPrimary,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Issue Number',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.normal,
                              color: Color(0xFFAFAFB4),
                              fontSize: 16.0,
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(1.0, 0.0),
                            child: Text(
                              '#${_getProduct?.issueNumber.toString()}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.normal,
                                color: AppColors.textPrimary,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Flat Shipping',
                                  style: GoogleFonts.inter(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  _formatCurrency(
                                      _getProduct?.customFlatRate),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Additional Fee',
                                  style: GoogleFonts.inter(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  _formatCurrency(
                                      _getProduct?.customAdditionalItemFee),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ].divide(SizedBox(height: 16.0)),
                        ),
                      ),
                    ),
                    Divider(
                      height: 48.0,
                      thickness: 2.0,
                      color: Color(0xFF363636),
                    ),
                    if (currentUserUid != _getProduct?.seller?.id)
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              height: 56.0,
                              child: TextButton(
                                onPressed: () async {
                                  _getOrCreateConversation =
                                      await actions.getOrCreateConversation(
                                    _getProduct!.seller?.id ?? '',
                                    widget.productId,
                                  );
                                  FFAppState().currentConversation =
                                      _getOrCreateConversation!;
                                  setState(() {});

                                  context.pushNamed(
                                    ChatPageWidget.routeName,
                                    queryParameters: {
                                      'conversation': FFAppState()
                                          .currentConversation
                                          .serialize(),
                                    },
                                  );

                                  setState(() {});
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.backgroundSecondary,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16.0, 0.0, 16.0, 0.0),
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
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
                                        id: _getProduct?.id ?? '',
                                        title: _getProduct?.title ?? '',
                                        description:
                                            _getProduct?.description ?? '',
                                        price: _getProduct?.price ?? 0.0,
                                        originalPrice:
                                            _getProduct?.originalPrice,
                                        flashSaleEnabled:
                                            _getProduct?.flashSaleEnabled ?? false,
                                        flashSalePrice:
                                            _getProduct?.flashSalePrice,
                                        flashSaleEndsAt:
                                            _getProduct?.flashSaleEndsAt,
                                        conditionName: _getProduct
                                            ?.conditions.firstOrNull?.name ?? '',
                                        mainImageUrl: _getProduct
                                            ?.images.firstOrNull?.imageUrl ?? '',
                                        sellerId:
                                            _getProduct?.seller?.id ?? '',
                                        sellerUsername:
                                            _getProduct?.seller?.username ?? '',
                                        sellerAvatarUrl:
                                            _getProduct?.seller?.avatarUrl,
                                        sellerRating: _getProduct
                                            ?.seller?.ratingAsSeller ?? 0.0,
                                        sellerTotalReviews: _getProduct
                                            ?.seller?.totalReviewsAsSeller ?? 0,
                                        isInWishlist:
                                            _getProduct?.isInWishlist ?? false,
                                        createdAt:
                                            _getProduct?.createdAt,
                                        shippingPrice:
                                            _getProduct?.shippingPrice ?? 0.0,
                                        freeShipping:
                                            _getProduct?.freeShipping ?? false,
                                        useSellerShipping:
                                            _getProduct?.useSellerShipping ?? false,
                                        customFlatRate:
                                            _getProduct?.customFlatRate,
                                        customAdditionalItemFee:
                                            _getProduct
                                                ?.customAdditionalItemFee,
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
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FFIcons.kadd,
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
                  ].addToEnd(SizedBox(height: 32.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

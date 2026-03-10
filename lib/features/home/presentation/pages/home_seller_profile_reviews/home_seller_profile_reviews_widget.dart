import '/backend/api_requests/api_calls.dart';
import '/features/home/domain/models/seller_model.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/date_utils.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:go_router/go_router.dart';
import '/features/home/presentation/pages/home_seller_profile_more/home_seller_profile_more_widget.dart';
import '/index.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:webviewx_plus/webviewx_plus.dart';
import 'home_seller_profile_reviews_model.dart';
export 'home_seller_profile_reviews_model.dart';

class HomeSellerProfileReviewsWidget extends StatefulWidget {
  const HomeSellerProfileReviewsWidget({
    super.key,
    required this.sellerDataType,
  });

  final Seller? sellerDataType;

  static String routeName = 'homeSellerProfileReviews';
  static String routePath = 'homeSellerProfileReviews';

  @override
  State<HomeSellerProfileReviewsWidget> createState() =>
      _HomeSellerProfileReviewsWidgetState();
}

class _HomeSellerProfileReviewsWidgetState
    extends State<HomeSellerProfileReviewsWidget> {
  late HomeSellerProfileReviewsModel _model;

  // Mutable header data for refresh
  double? _ratingAsBuyer;
  double? _ratingAsSeller;
  int? _totalReviewsAsBuyer;
  int? _totalReviewsAsSeller;

  double get _currentRatingAsBuyer =>
      _ratingAsBuyer ?? widget.sellerDataType?.ratingAsBuyer ?? 0.0;
  double get _currentRatingAsSeller =>
      _ratingAsSeller ?? widget.sellerDataType?.ratingAsSeller ?? 0.0;
  int get _currentTotalReviewsAsBuyer =>
      _totalReviewsAsBuyer ?? widget.sellerDataType?.totalReviewsAsBuyer ?? 0;
  int get _currentTotalReviewsAsSeller =>
      _totalReviewsAsSeller ?? widget.sellerDataType?.totalReviewsAsSeller ?? 0;

  @override
  void initState() {
    super.initState();
    _model = HomeSellerProfileReviewsModel();
  }

  Future<void> _refreshAfterReview() async {
    // Re-fetch seller info to get updated ratings
    final updatedSeller = await actions.getSellerInfo(
      widget.sellerDataType!.id,
      null,
    );
    if (!mounted) return;
    setState(() {
      if (updatedSeller != null) {
        _ratingAsBuyer = updatedSeller.ratingAsBuyer;
        _ratingAsSeller = updatedSeller.ratingAsSeller;
        _totalReviewsAsBuyer = updatedSeller.totalReviewsAsBuyer;
        _totalReviewsAsSeller = updatedSeller.totalReviewsAsSeller;
      }
    });
    // Refresh paging controllers
    _model.listViewPagingController1?.refresh();
    _model.listViewPagingController2?.refresh();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundSecondary,
          automaticallyImplyLeading: false,
          title: Row(
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
                  Icons.arrow_back,
                  color: AppColors.info,
                  size: 24.0,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              Text(
                'Reviews',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                  color: AppColors.textPrimary,
                ),
              ),
              Builder(
                builder: (context) => IconButton(
                  style: IconButton.styleFrom(
                    minimumSize: Size(40.0, 40.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.info,
                    size: 20.0,
                  ),
                  onPressed: () async {
                    await showAlignedDialog(
                      context: context,
                      isGlobal: false,
                      avoidOverflow: true,
                      targetAnchor: AlignmentDirectional(-4.0, 5.5)
                          .resolve(Directionality.of(context)),
                      followerAnchor:
                          Alignment.center.resolve(Directionality.of(context)),
                      builder: (dialogContext) {
                        return Material(
                          color: Colors.transparent,
                          child: WebViewAware(
                            child: GestureDetector(
                              onTap: () {
                                FocusScope.of(dialogContext).unfocus();
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              child: HomeSellerProfileMoreWidget(
                                userId: widget.sellerDataType?.id ?? '',
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 80.0,
                            height: 80.0,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: widget.sellerDataType!.avatarUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    fadeInDuration: Duration(milliseconds: 100),
                                    fadeOutDuration:
                                        Duration(milliseconds: 100),
                                    imageUrl: widget.sellerDataType!.avatarUrl,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 40.0,
                                    color: AppColors.textSecondary,
                                  ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    widget.sellerDataType?.username,
                                    'N/A',
                                  ),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      RatingBarIndicator(
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star_rounded,
                                          color: Color(0xFFFACC15),
                                        ),
                                        direction: Axis.horizontal,
                                        rating: _model.state == 'As Buyer'
                                            ? _currentRatingAsBuyer
                                            : _currentRatingAsSeller,
                                        unratedColor: Color(0xFF7B7B7B),
                                        itemCount: 5,
                                        itemSize: 18.0,
                                      ),
                                      Text(
                                        (_model.state == 'As Buyer'
                                                ? _currentRatingAsBuyer
                                                : _currentRatingAsSeller)
                                            .toString(),
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        '(${_model.state == 'As Buyer' ? _currentTotalReviewsAsBuyer : _currentTotalReviewsAsSeller}) reviews',
                                        style: GoogleFonts.inter(
                                          fontSize: 14.0,
                                          color: Color(0xFFAFAFB4),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 8.0)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            valueOrDefault<String>(
                                              widget
                                                  .sellerDataType?.totalProducts
                                                  .toString(),
                                              '0',
                                            ),
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            'Items',
                                            style: GoogleFonts.inter(
                                              fontSize: 12.0,
                                              color: Color(0xFFAFAFB4),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            valueOrDefault<String>(
                                              widget.sellerDataType?.totalSales
                                                  .toString(),
                                              '0',
                                            ),
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            'Sold',
                                            style: GoogleFonts.inter(
                                              fontSize: 12.0,
                                              color: Color(0xFFAFAFB4),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            valueOrDefault<String>(
                                              widget.sellerDataType
                                                  ?.followersCount
                                                  .toString(),
                                              '0',
                                            ),
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            'Followers',
                                            style: GoogleFonts.inter(
                                              fontSize: 12.0,
                                              color: Color(0xFFAFAFB4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ].divide(SizedBox(width: 24.0)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24.0),
                        child: Container(
                          width: double.infinity,
                          height: 53.0,
                          decoration: BoxDecoration(),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    _model.state = 'As Buyer';
                                    setState(() {});
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          'As Buyer',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.normal,
                                            color: _model.state == 'As Buyer'
                                                ? AppColors.textPrimary
                                                : Color(0xFFAFAFB4),
                                            height: 2.0,
                                          ),
                                        ),
                                      ),
                                      Opacity(
                                        opacity:
                                            (_model.state == 'As Buyer' ? 1 : 0)
                                                .toDouble(),
                                        child: Container(
                                          width: double.infinity,
                                          height: 2.0,
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    _model.state = 'As Seller';
                                    setState(() {});
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 10.0),
                                        child: Text(
                                          'As Seller',
                                          style: GoogleFonts.inter(
                                            color: _model.state == 'As Seller'
                                                ? AppColors.textPrimary
                                                : Color(0xFFAFAFB4),
                                            height: 2.0,
                                          ),
                                        ),
                                      ),
                                      Opacity(
                                        opacity: (_model.state == 'As Seller'
                                                ? 1
                                                : 0)
                                            .toDouble(),
                                        child: Container(
                                          width: double.infinity,
                                          height: 2.0,
                                          decoration: BoxDecoration(
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Container(
                          width: double.infinity,
                          height: 56.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF7D56FF), Color(0xFF6187F1)],
                              stops: [0.0, 1.0],
                              begin: Alignment.topCenter,
                              end: AlignmentDirectional(0, 1.0),
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: TextButton.icon(
                            onPressed: () async {
                              final reviewRole = _model.state == 'As Buyer'
                                  ? 'as_buyer'
                                  : 'as_seller';
                              final result = await context.pushNamed<bool>(
                                HomeSellerProfileReviewsStep1Widget.routeName,
                                queryParameters: {
                                  'sellerDataType':
                                      widget.sellerDataType?.serialize(),
                                  'reviewRole': reviewRole,
                                },
                              );
                              if (result == true && mounted) {
                                await _refreshAfterReview();
                              }
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 24.0,
                              color: Colors.white,
                            ),
                            label: Text(
                              'Write a Review',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          if (_model.state == 'As Buyer') {
                            return PagedListView<ApiPagingParams,
                                dynamic>.separated(
                              pagingController: _model.setListViewController1(
                                (nextPageMarker) =>
                                    SupabaseRPCGroup.getuserreviewsCall.call(
                                  userId: widget.sellerDataType?.id,
                                  role: 'as_buyer',
                                  limit: 20,
                                  offset: nextPageMarker.numItems,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              primary: false,
                              shrinkWrap: true,
                              reverse: false,
                              scrollDirection: Axis.vertical,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 16.0),
                              builderDelegate:
                                  PagedChildBuilderDelegate<dynamic>(
                                firstPageProgressIndicatorBuilder: (_) =>
                                    Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                newPageProgressIndicatorBuilder: (_) => Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                itemBuilder:
                                    (context, reviewItem, asBuyerIndex) {
                                  final item = reviewItem is Map
                                      ? reviewItem
                                      : <String, dynamic>{};
                                  return _buildReviewCard(item);
                                },
                              ),
                            );
                          } else {
                            return PagedListView<ApiPagingParams,
                                dynamic>.separated(
                              pagingController: _model.setListViewController2(
                                (nextPageMarker) =>
                                    SupabaseRPCGroup.getuserreviewsCall.call(
                                  userId: widget.sellerDataType?.id,
                                  role: 'as_seller',
                                  limit: 20,
                                  offset: nextPageMarker.numItems,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              primary: false,
                              shrinkWrap: true,
                              reverse: false,
                              scrollDirection: Axis.vertical,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 16.0),
                              builderDelegate:
                                  PagedChildBuilderDelegate<dynamic>(
                                firstPageProgressIndicatorBuilder: (_) =>
                                    Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                newPageProgressIndicatorBuilder: (_) => Center(
                                  child: SizedBox(
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                itemBuilder:
                                    (context, reviewItem, asSellerIndex) {
                                  final item = reviewItem is Map
                                      ? reviewItem
                                      : <String, dynamic>{};
                                  return _buildReviewCard(item);
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ].addToEnd(SizedBox(height: 32.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(Map item) {
    final reviewerUsername = item['reviewer_username']?.toString() ?? '';
    final reviewerAvatarUrl = item['reviewer_avatar_url']?.toString() ?? '';
    final rating =
        (item['rating'] is num) ? (item['rating'] as num).toDouble() : 0.0;
    final productTitle = item['product_title']?.toString() ?? '';
    final productPrice = (item['product_price'] is num)
        ? (item['product_price'] as num).toDouble()
        : 0.0;
    final productImageUrl = item['product_main_image_url']?.toString() ?? '';
    final content = item['content']?.toString() ?? '';
    final createdAtStr = item['created_at']?.toString();
    final createdAt =
        createdAtStr != null ? DateTime.tryParse(createdAtStr) : null;
    final orderDateStr = item['order_date']?.toString();
    final orderDate =
        orderDateStr != null ? DateTime.tryParse(orderDateStr) : null;
    final reviewRole = item['review_role']?.toString() ?? '';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 32.0,
                  height: 32.0,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: reviewerAvatarUrl.isNotEmpty
                      ? CachedNetworkImage(
                          fadeInDuration: Duration(milliseconds: 500),
                          fadeOutDuration: Duration(milliseconds: 500),
                          imageUrl: reviewerAvatarUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Icon(
                            Icons.person,
                            size: 20.0,
                            color: AppColors.textSecondary,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 20.0,
                          color: AppColors.textSecondary,
                        ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reviewerUsername.isNotEmpty
                            ? '@$reviewerUsername'
                            : 'Anonymous',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                      RatingBarIndicator(
                        itemBuilder: (context, index) => Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFACC15),
                        ),
                        direction: Axis.horizontal,
                        rating: rating,
                        unratedColor: Color(0xFF7B7B7B),
                        itemCount: 5,
                        itemSize: 12.0,
                      ),
                    ].divide(SizedBox(height: 4.0)),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      createdAt != null
                          ? dateTimeFormat('relative', createdAt)
                          : '',
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        color: Color(0xFFAFAFB4),
                      ),
                    ),
                    Container(
                      width: 26.0,
                      height: 26.0,
                      decoration: BoxDecoration(
                        color: Color(0xFF111111),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.flag,
                          color: AppColors.textPrimary,
                          size: 12.0,
                        ),
                      ),
                    ),
                  ].divide(SizedBox(width: 8.0)),
                ),
              ].divide(SizedBox(width: 12.0)),
            ),
            if (productTitle.isNotEmpty || productImageUrl.isNotEmpty)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF111111),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (productImageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 500),
                            fadeOutDuration: Duration(milliseconds: 500),
                            imageUrl: productImageUrl,
                            width: 32.0,
                            height: 32.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (productTitle.isNotEmpty)
                              Text(
                                productTitle,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 14.0,
                                  color: AppColors.textPrimary,
                                  height: 1.5,
                                ),
                              ),
                            if (productPrice > 0)
                              Text(
                                '\$${NumberFormat('#,##0.00', 'en_US').format(productPrice)}',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.0,
                                  color: AppColors.textPrimary,
                                  height: 1.5,
                                ),
                              ),
                          ].divide(SizedBox(height: 4.0)),
                        ),
                      ),
                    ].divide(SizedBox(width: 12.0)),
                  ),
                ),
              ),
            if (content.isNotEmpty)
              Text(
                content,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            if (orderDate != null)
              Text(
                reviewRole == 'as_seller'
                    ? 'Sold on ${DateFormat('MMM dd, yyyy').format(orderDate)}'
                    : 'Purchased on ${DateFormat('MMM dd, yyyy').format(orderDate)}',
                style: GoogleFonts.inter(
                  fontSize: 12.0,
                  color: Color(0xFFAFAFB4),
                ),
              ),
          ].divide(SizedBox(height: 16.0)),
        ),
      ),
    );
  }
}

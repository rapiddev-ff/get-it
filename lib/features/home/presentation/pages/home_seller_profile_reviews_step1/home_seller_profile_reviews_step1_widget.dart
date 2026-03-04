import '/features/home/domain/models/seller_model.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeSellerProfileReviewsStep1Widget extends StatefulWidget {
  const HomeSellerProfileReviewsStep1Widget({
    super.key,
    required this.sellerDataType,
    this.reviewRole = 'as_buyer',
  });

  final Seller? sellerDataType;
  final String reviewRole;

  static String routeName = 'homeSellerProfileReviewsStep1';
  static String routePath = 'homeSellerProfileReviewsStep1';

  @override
  State<HomeSellerProfileReviewsStep1Widget> createState() =>
      _HomeSellerProfileReviewsStep1WidgetState();
}

class _HomeSellerProfileReviewsStep1WidgetState
    extends State<HomeSellerProfileReviewsStep1Widget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Inlined from model
  String? state = 'As Buyer';
  dynamic getUserProfileWithReviews;

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      getUserProfileWithReviews = await actions.callRpc(
        context,
        'get_user_profile_with_reviews',
        <String, String>{
          'p_user_id': widget.sellerDataType!.id,
        },
      );
      setState(() {});
    });
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
        appBar: AppBar(
          backgroundColor: AppColors.backgroundSecondary,
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
                  Icons.arrow_back,
                  color: AppColors.info,
                  size: 24.0,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              Text(
                'Choose Product to Review',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                  color: AppColors.textPrimary,
                ),
              ),
              Opacity(
                opacity: 0.0,
                child: IconButton(
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
                  onPressed: null,
                ),
              ),
            ],
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 80.0,
                        height: 80.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CachedNetworkImage(
                          fadeInDuration: Duration(milliseconds: 100),
                          fadeOutDuration: Duration(milliseconds: 100),
                          imageUrl: valueOrDefault<String>(
                            widget.sellerDataType?.avatarUrl,
                            'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',
                          ),
                          fit: BoxFit.cover,
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
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 8.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  RatingBarIndicator(
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star_rounded,
                                      color: Color(0xFFFACC15),
                                    ),
                                    direction: Axis.horizontal,
                                    rating: valueOrDefault<double>(
                                      valueOrDefault<int>(
                                        _getJsonInt(getUserProfileWithReviews,
                                            'overall', 'avgRating'),
                                        0,
                                      ).toDouble(),
                                      0.0,
                                    ),
                                    unratedColor: Color(0xFF7B7B7B),
                                    itemCount: 5,
                                    itemSize: 15.0,
                                  ),
                                  Text(
                                    valueOrDefault<String>(
                                      _getJsonValue(getUserProfileWithReviews,
                                              'overall', 'avgRating')
                                          ?.toString(),
                                      '0',
                                    ),
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${valueOrDefault<String>(
                                      _getJsonValue(getUserProfileWithReviews,
                                              'overall', 'total')
                                          ?.toString(),
                                      '0',
                                    )} reviews',
                                    style: GoogleFonts.inter(
                                      fontSize: 14.0,
                                      color: Color(0xFFAFAFB4),
                                    ),
                                  ),
                                ].divide(SizedBox(width: 8.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ].divide(SizedBox(width: 12.0)),
                  ),
                ),
                Divider(
                  height: 56.0,
                  thickness: 1.0,
                  color: Color(0xFFE5E7EB),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: Color(0xFF363636),
                        width: 2.0,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 12.0, 16.0, 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.textPrimary,
                            size: 28.0,
                          ),
                          Expanded(
                            child: Text(
                              'Select the product you want to review from your recent purchases below.',
                              style: GoogleFonts.inter(
                                color: AppColors.textPrimary,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ].divide(SizedBox(width: 10.0)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Your purchases from this seller',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Builder(
                    builder: (context) {
                      final purchasedProducts =
                          widget.sellerDataType?.purchasedProducts.toList() ??
                              [];

                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: purchasedProducts.length,
                        separatorBuilder: (_, __) => SizedBox(height: 16.0),
                        itemBuilder: (context, purchasedProductsIndex) {
                          final purchasedProductsItem =
                              purchasedProducts[purchasedProductsIndex];
                          return InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              final result = await context.pushNamed<bool>(
                                HomeSellerProfileReviewsStep2Widget.routeName,
                                queryParameters: {
                                  'sellerDataType':
                                      widget.sellerDataType?.serialize(),
                                  'product': purchasedProductsItem.serialize(),
                                  'reviewRole': widget.reviewRole,
                                },
                              );
                              if (result == true && mounted) {
                                Navigator.of(context).pop(true);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.backgroundSecondary,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10.0, 16.0, 16.0, 16.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4.0),
                                      child: Image.network(
                                        purchasedProductsItem.mainImageUrl,
                                        width: 64.0,
                                        height: 84.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            valueOrDefault<String>(
                                              purchasedProductsItem.title,
                                              'n/a',
                                            ),
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textPrimary,
                                              height: 1.5,
                                            ),
                                          ),
                                          if (purchasedProductsItem.conditionName.isNotEmpty)
                                            Text(
                                              purchasedProductsItem.conditionName,
                                              maxLines: 1,
                                              style: GoogleFonts.inter(
                                                color: AppColors.textSecondary,
                                                fontSize: 12.0,
                                                height: 1.5,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 8.0, 0.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    NumberFormat(
                                                            '#,##0.##', 'en_US')
                                                        .format(
                                                            purchasedProductsItem
                                                                .price),
                                                    style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppColors.textPrimary,
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  purchasedProductsItem.createdAt != null
                                                      ? 'Purchased ${DateFormat('MMM dd, yyyy').format(purchasedProductsItem.createdAt!)}'
                                                      : '',
                                                  maxLines: 1,
                                                  style: GoogleFonts.inter(
                                                    color:
                                                        AppColors.textSecondary,
                                                    fontSize: 12.0,
                                                    height: 1.5,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 2.0)),
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right_sharp,
                                      color: AppColors.textSecondary,
                                      size: 20.0,
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ].addToEnd(SizedBox(height: 32.0)),
            ),
          ),
        ),
      ),
    );
  }

  // Helper for nested JSON access: json['key1']['key2']
  dynamic _getJsonValue(dynamic json, String key1, String key2) {
    if (json is Map && json[key1] is Map) {
      return json[key1][key2];
    }
    return null;
  }

  int? _getJsonInt(dynamic json, String key1, String key2) {
    final val = _getJsonValue(json, key1, key2);
    if (val is int) return val;
    if (val is double) return val.toInt();
    return null;
  }
}

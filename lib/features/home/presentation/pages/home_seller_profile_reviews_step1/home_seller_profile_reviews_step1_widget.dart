import '/core/widgets/app_loading_indicator.dart';
import '/features/home/domain/models/seller_model.dart';
import '/features/home/domain/models/seller_product_model.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/home/presentation/pages/home_seller_profile_reviews_step2/home_seller_profile_reviews_step2_widget.dart';
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
  // Inlined from model
  String? state = 'As Buyer';
  dynamic getUserProfileWithReviews;
  List<Map<String, dynamic>> _reviewableProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final results = await Future.wait([
        actions.callRpc(
          context,
          'get_user_profile_with_reviews',
          <String, String>{
            'p_user_id': widget.sellerDataType!.id,
          },
        ),
        actions.callRpc(
          context,
          'get_products_to_review',
          <String, String>{
            'p_reviewed_user_id': widget.sellerDataType!.id,
            'p_review_role': widget.reviewRole,
          },
        ),
      ]);
      if (!mounted) return;
      getUserProfileWithReviews = results[0];
      final productsRaw = results[1];
      if (productsRaw is List) {
        _reviewableProducts = productsRaw
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
      _isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
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
                'Choose Product to Review',
                style: Theme.of(context).textTheme.titleMedium!,
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
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
                  child: Row(
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  RatingBarIndicator(
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star_rounded,
                                      color: AppColors.statusYellow,
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
                                    unratedColor: AppColors.neutral700,
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '${valueOrDefault<String>(
                                      _getJsonValue(getUserProfileWithReviews,
                                              'overall', 'total')
                                          ?.toString(),
                                      '0',
                                    )} reviews',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!,
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
                  color: AppColors.alternate,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      border: Border.all(
                        color: AppColors.surfaceDark,
                        width: 2.0,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      child: Row(
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
                    widget.reviewRole == 'as_seller'
                        ? 'Your purchases from this seller'
                        : 'Products you sold to this buyer',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w500, height: 1.5),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: _isLoading
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: AppLoadingIndicator(),
                          ),
                        )
                      : _reviewableProducts.isEmpty
                          ? Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Center(
                                child: Text(
                                  'No products available for review.',
                                  style:
                                      Theme.of(context).textTheme.labelMedium!,
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              itemCount: _reviewableProducts.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 16.0),
                              itemBuilder: (context, index) {
                                final item = _reviewableProducts[index];
                                final alreadyReviewed =
                                    item['already_reviewed'] == true;
                                final productTitle =
                                    item['product_title']?.toString() ?? 'n/a';
                                final productPrice =
                                    (item['product_price'] as num?)
                                            ?.toDouble() ??
                                        0.0;
                                final productImage =
                                    item['product_image']?.toString() ?? '';
                                final conditionName =
                                    item['product_condition']?.toString() ?? '';
                                final orderId =
                                    item['order_id']?.toString() ?? '';
                                final productId =
                                    item['product_id']?.toString() ?? '';
                                final paidAtStr =
                                    item['order_paid_at']?.toString();
                                final paidAt = paidAtStr != null
                                    ? DateTime.tryParse(paidAtStr)
                                    : null;

                                final dateLabel =
                                    widget.reviewRole == 'as_seller'
                                        ? 'Purchased'
                                        : 'Sold';

                                return Opacity(
                                  opacity: alreadyReviewed ? 0.5 : 1.0,
                                  child: InkWell(
                                    onTap: alreadyReviewed
                                        ? null
                                        : () async {
                                            final result =
                                                await context.pushNamed<bool>(
                                              HomeSellerProfileReviewsStep2Widget
                                                  .routeName,
                                              queryParameters: {
                                                'sellerDataType': widget
                                                    .sellerDataType
                                                    ?.serialize(),
                                                'product': SellerProduct(
                                                  id: productId,
                                                  orderId: orderId,
                                                  title: productTitle,
                                                  price: productPrice,
                                                  conditionName: conditionName,
                                                  mainImageUrl: productImage,
                                                  createdAt: paidAt,
                                                ).serialize(),
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
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0,
                                            top: 16.0,
                                            right: 16.0,
                                            bottom: 16.0),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              child: CachedNetworkImage(
                                                imageUrl: productImage,
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
                                                    productTitle,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            height: 1.5),
                                                  ),
                                                  if (conditionName.isNotEmpty)
                                                    Text(
                                                      conditionName,
                                                      maxLines: 1,
                                                      style: Theme.of(context).textTheme.labelSmall!.copyWith(height: 1.5),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 8.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            '\$${NumberFormat('#,##0.##', 'en_US').format(productPrice)}',
                                                            style: GoogleFonts
                                                                .inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: AppColors
                                                                  .textPrimary,
                                                              height: 1.5,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          paidAt != null
                                                              ? '$dateLabel ${DateFormat('MMM dd, yyyy').format(paidAt)}'
                                                              : '',
                                                          maxLines: 1,
                                                          style: Theme.of(context).textTheme.labelSmall!.copyWith(height: 1.5),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (alreadyReviewed)
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 4.0),
                                                      child: Text(
                                                        'Already reviewed',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall!
                                                            .copyWith(
                                                                color: AppColors
                                                                    .primary),
                                                      ),
                                                    ),
                                                ].divide(SizedBox(height: 2.0)),
                                              ),
                                            ),
                                            if (!alreadyReviewed)
                                              Icon(
                                                Icons
                                                    .keyboard_arrow_right_sharp,
                                                color: AppColors.textSecondary,
                                                size: 20.0,
                                              ),
                                          ].divide(SizedBox(width: 12.0)),
                                        ),
                                      ),
                                    ),
                                  ),
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

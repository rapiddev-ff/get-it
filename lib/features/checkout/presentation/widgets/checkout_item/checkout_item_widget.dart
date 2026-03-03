import '/features/home/domain/models/feed_product_model.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CheckoutItemWidget extends StatelessWidget {
  const CheckoutItemWidget({
    super.key,
    required this.feedProduct,
    required this.quantity,
    required this.addQuantityAction,
    required this.minusQuantityAction,
  });

  final FeedProduct? feedProduct;
  final int? quantity;
  final Future Function()? addQuantityAction;
  final Future Function()? minusQuantityAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: CachedNetworkImage(
              fadeInDuration: Duration(milliseconds: 500),
              fadeOutDuration: Duration(milliseconds: 500),
              imageUrl: valueOrDefault<String>(
                feedProduct?.mainImageUrl,
                'https://picsum.photos/seed/357/600',
              ),
              width: 80.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(
                        valueOrDefault<String>(
                          feedProduct?.title,
                          'N/A',
                        ),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.close_outlined,
                      color: Color(0xFF9B85FF),
                      size: 24.0,
                    ),
                  ].divide(SizedBox(width: 12.0)),
                ),
                Text(
                  'PSA 9 Mint',
                  maxLines: 1,
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 12.0,
                    height: 1.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                RichText(
                  textScaler: MediaQuery.of(context).textScaler,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Seller: ',
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: '@',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 12.0,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: valueOrDefault<String>(
                          feedProduct?.sellerUsername,
                          'N/A',
                        ),
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.0,
                        ),
                      )
                    ],
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      height: 1.5,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          NumberFormat('#,##0.##', 'en_US')
                              .format(feedProduct!.price * (quantity!)),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          await minusQuantityAction?.call();
                        },
                        child: FaIcon(
                          FontAwesomeIcons.squareMinus,
                          color: AppColors.textPrimary,
                          size: 24.0,
                        ),
                      ),
                      Text(
                        valueOrDefault<String>(
                          quantity?.toString(),
                          '1',
                        ),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          await addQuantityAction?.call();
                        },
                        child: FaIcon(
                          FontAwesomeIcons.squarePlus,
                          color: AppColors.textPrimary,
                          size: 24.0,
                        ),
                      ),
                    ].divide(SizedBox(width: 12.0)),
                  ),
                ),
              ].divide(SizedBox(height: 4.0)),
            ),
          ),
        ].divide(SizedBox(width: 12.0)),
      ),
    );
  }
}

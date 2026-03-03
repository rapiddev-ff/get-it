import '/features/browse/domain/models/browse_product_model.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/value_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BrowseProductsItemWidget extends StatelessWidget {
  const BrowseProductsItemWidget({
    super.key,
    required this.browseDataType,
  });

  final BrowseProduct? browseDataType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: const Color(0xFF363636),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 168.5,
            height: 128.0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4.0),
                topRight: Radius.circular(4.0),
              ),
              child: CachedNetworkImage(
                fadeInDuration: const Duration(milliseconds: 500),
                fadeOutDuration: const Duration(milliseconds: 500),
                imageUrl: valueOrDefault<String>(
                  browseDataType?.mainImageUrl,
                  'https://picsum.photos/seed/487/600',
                ),
                width: 172.5,
                height: 128.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF363636),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4.0),
                  bottomRight: Radius.circular(4.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      valueOrDefault<String>(
                        browseDataType?.title,
                        'n/a',
                      ),
                      maxLines: 2,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '- \u2022 ${browseDataType?.categoryName}',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.0,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          _formatPrice(browseDataType?.price),
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: AppColors.secondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatPrice(double? price) {
    if (price == null) return '0';
    return NumberFormat('#,##0.##', 'en_US').format(price);
  }
}

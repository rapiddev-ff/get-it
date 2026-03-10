import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '/features/home/domain/models/seller_product_model.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';

class InventoryItemWidget extends StatelessWidget {
  const InventoryItemWidget({
    super.key,
    required this.sellerProduct,
  });

  final SellerProduct? sellerProduct;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 168.5,
          height: 128.0,
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0.0),
                  bottomRight: Radius.circular(0.0),
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
                child: CachedNetworkImage(
                  fadeInDuration: Duration(milliseconds: 500),
                  fadeOutDuration: Duration(milliseconds: 500),
                  imageUrl: valueOrDefault<String>(
                    sellerProduct?.mainImageUrl,
                    'https://picsum.photos/seed/487/600',
                  ),
                  width: 168.5,
                  height: 128.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFF363636),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4.0),
              bottomRight: Radius.circular(4.0),
              topLeft: Radius.circular(0.0),
              topRight: Radius.circular(0.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valueOrDefault<String>(
                    sellerProduct?.title,
                    'N/A',
                  ),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.0,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
                Text(
                  NumberFormat('#,##0.##', 'en_US')
                      .format(sellerProduct!.price),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF22C55D),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Text(
                            valueOrDefault<String>(
                              sellerProduct?.status,
                              'N/A',
                            ),
                            style: Theme.of(context).textTheme.bodyMedium!,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Text(
                          '${valueOrDefault<String>(
                            sellerProduct?.viewsCount.toString(),
                            '0',
                          )} Views',
                          style: Theme.of(context).textTheme.bodyMedium!,
                        ),
                      ),
                    ],
                  ),
                ),
              ].divide(SizedBox(height: 4.0)),
            ),
          ),
        ),
      ],
    );
  }
}

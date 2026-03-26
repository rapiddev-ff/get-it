import '/features/browse/domain/models/browse_product_model.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/value_utils.dart';
import '/core/widgets/product_price_row.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(8.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: valueOrDefault<String>(
                  browseDataType?.mainImageUrl,
                  'https://picsum.photos/seed/487/600',
                ),
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 100),
                fadeOutDuration: Duration(milliseconds: 100),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  browseDataType?.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (browseDataType?.categoryName.isNotEmpty == true) ...[
                  SizedBox(height: 4.0),
                  Text(
                    browseDataType!.categoryName,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
                SizedBox(height: 6.0),
                ProductPriceRow(
                  price: browseDataType?.price ?? 0.0,
                  originalPrice: browseDataType?.originalPrice ?? 0.0,
                  flashSaleEnabled: browseDataType?.flashSaleEnabled ?? false,
                  flashSalePrice: browseDataType?.flashSalePrice,
                  flashSaleEndsAt: browseDataType?.flashSaleEndsAt,
                  discountType: browseDataType?.discountType,
                  discountAmount: browseDataType?.discountAmount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

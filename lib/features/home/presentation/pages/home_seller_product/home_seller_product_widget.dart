import '/features/home/domain/models/seller_product_model.dart';
import '/core/utils/value_utils.dart';
import '/core/widgets/product_price_row.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';

class HomeSellerProductWidget extends StatelessWidget {
  const HomeSellerProductWidget({
    super.key,
    required this.productDataType,
  });

  final SellerProduct? productDataType;

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
                  productDataType?.mainImageUrl,
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
                  productDataType?.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 4.0),
                ProductPriceRow(
                  price: productDataType?.price ?? 0.0,
                  originalPrice: productDataType?.originalPrice ?? 0.0,
                  flashSaleEnabled: productDataType?.flashSaleEnabled ?? false,
                  flashSalePrice: productDataType?.flashSalePrice,
                  discountType: productDataType?.discountType,
                  discountAmount: productDataType?.discountAmount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

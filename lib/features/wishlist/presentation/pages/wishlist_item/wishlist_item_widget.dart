import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:octo_image/octo_image.dart';

import '/features/home/domain/models/product_details_model.dart';
import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/widgets/product_price_row.dart';

class WishlistItemWidget extends StatelessWidget {
  const WishlistItemWidget({
    super.key,
    required this.productDataType,
    required this.actionWishlish,
    this.onBuyNow,
  });

  final ProductDetails? productDataType;
  final Future Function()? actionWishlish;
  final VoidCallback? onBuyNow;

  bool get _isSold =>
      productDataType?.quantity == 0 ||
      productDataType?.status.toLowerCase() == 'sold';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(8.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              children: [
                OctoImage(
                  placeholderBuilder: (_) => SizedBox.expand(
                    child: Image(
                      image: BlurHashImage(AppConstants.blurHash),
                      fit: BoxFit.cover,
                    ),
                  ),
                  image: NetworkImage(
                    productDataType?.images.firstOrNull?.imageUrl ??
                        'https://picsum.photos/seed/487/600',
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 10.0),
                    child: GestureDetector(
                      onTap: () async {
                        await actionWishlish?.call();
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.solidHeart,
                        color: AppColors.destructive500,
                        size: 24.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productDataType?.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Expanded(
                      child: ProductPriceRow(
                        price: productDataType?.price ?? 0.0,
                        originalPrice:
                            productDataType?.originalPrice ?? 0.0,
                        flashSaleEnabled:
                            productDataType?.flashSaleEnabled ?? false,
                        flashSalePrice: productDataType?.flashSalePrice,
                        discountType: productDataType?.discountType,
                        discountAmount: productDataType?.discountAmount,
                      ),
                    ),
                    GestureDetector(
                      onTap: _isSold ? null : onBuyNow,
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isSold
                              ? const Color(0xFF4A4A4A)
                              : AppColors.secondary,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Text(
                            _isSold ? 'Sold' : 'Buy Now',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: _isSold
                                          ? AppColors.textSecondary
                                          : AppColors.textPrimary,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

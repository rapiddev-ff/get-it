import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';

import '/features/home/domain/models/product_details_model.dart';
import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';

class WishlistItemWidget extends StatelessWidget {
  const WishlistItemWidget({
    super.key,
    required this.productDataType,
    required this.actionWishlish,
  });

  final ProductDetails? productDataType;
  final Future Function()? actionWishlish;

  bool get _isSold =>
      productDataType?.quantity == 0 ||
      productDataType?.status.toLowerCase() == 'sold';

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
          AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                  child: OctoImage(
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
                        color: Color(0xFFEF4444),
                        size: 24.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productDataType?.title ?? 'N/A',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, height: 1.5),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '\$${NumberFormat('#,##0.##', 'en_US').format(productDataType?.price ?? 0)}',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                      Container(
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
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                              color: _isSold
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

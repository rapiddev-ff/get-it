import '/features/home/domain/models/seller_product_model.dart';
import '/core/utils/value_utils.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
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
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: AppColors.surfaceDark,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                  child: Image.network(
                    valueOrDefault<String>(
                      productDataType?.mainImageUrl,
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
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      valueOrDefault<String>(
                        productDataType?.title,
                        'N/A',
                      ),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                    ),
                    Text(
                      valueOrDefault<String>(
                        productDataType?.price != null
                            ? NumberFormat('#,##0.##', 'en_US')
                                .format(productDataType!.price)
                            : null,
                        '0',
                      ),
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                          height: 1.5),
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
}

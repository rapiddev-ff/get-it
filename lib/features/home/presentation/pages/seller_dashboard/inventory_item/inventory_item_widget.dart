import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
            color: AppColors.surfaceDark,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(4.0),
              bottomRight: Radius.circular(4.0),
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
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w500, height: 1.5),
                ),
                Text(
                  '\$${NumberFormat('#,##0.##', 'en_US').format(sellerProduct!.price)}',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _StatusBadge(status: sellerProduct?.status ?? ''),
                      Text(
                        '${valueOrDefault<String>(
                          sellerProduct?.viewsCount.toString(),
                          '0',
                        )} Views',
                        style: Theme.of(context).textTheme.bodyMedium!,
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

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final isFilled = normalized == 'active' || normalized == 'sold';
    final label = _label(normalized);

    return Container(
      decoration: BoxDecoration(
        color: isFilled ? _backgroundColor(normalized) : Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
        border: isFilled
            ? null
            : Border.all(color: AppColors.textSecondary, width: 1.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w500,
                color: isFilled ? Colors.white : AppColors.textSecondary,
              ),
        ),
      ),
    );
  }

  String _label(String s) {
    switch (s) {
      case 'active':
        return 'Active';
      case 'sold':
        return 'Sold';
      case 'draft':
        return 'Draft';
      case 'archived':
      case 'removed':
        return 'Deactivated';
      default:
        return s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : 'N/A';
    }
  }

  Color _backgroundColor(String s) {
    switch (s) {
      case 'active':
        return const Color(0xFF22C55D);
      case 'sold':
        return const Color(0xFFEF4444);
      default:
        return AppColors.surfaceDark;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/core/theme/app_colors.dart';

/// Shared price row widget used across product cards.
///
/// Shows: `$4,500  $7000  ⚡-10%`  (discountType == 'percent')
///   or:  `$4,500  $4600  ⚡-$100` (discountType == 'dollar')
///   or:  `$4,500`                  (no discount)
class ProductPriceRow extends StatelessWidget {
  const ProductPriceRow({
    super.key,
    required this.price,
    this.originalPrice = 0.0,
    this.flashSaleEnabled = false,
    this.flashSalePrice,
    this.flashSaleEndsAt,
    this.discountType,
    this.discountAmount,
  });

  final double price;
  final double originalPrice;
  final bool flashSaleEnabled;
  final double? flashSalePrice;
  final DateTime? flashSaleEndsAt;

  /// 'percent' or 'dollar' — from the product's discount_type DB field.
  final String? discountType;
  final double? discountAmount;

  bool get _isFlashSaleActive {
    if (!flashSaleEnabled || flashSaleEndsAt == null) return false;
    return DateTime.now().isBefore(flashSaleEndsAt!);
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat('#,##0.##', 'en_US');

    double effectivePrice = price;
    if (_isFlashSaleActive && flashSalePrice != null) {
      effectivePrice = flashSalePrice!;
    }

    // Compare against originalPrice first, then base price
    final comparePrice =
        originalPrice > effectivePrice ? originalPrice : price;
    final hasDiscount = effectivePrice < comparePrice && comparePrice > 0;

    if (!hasDiscount) {
      return Text(
        '\$${fmt.format(price)}',
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
      );
    }

    final savings = comparePrice - effectivePrice;
    final percentOff = ((savings / comparePrice) * 100).round();

    // Use discountType from DB to decide format
    String discountText;
    if (discountType == 'dollar') {
      final amount = discountAmount ?? savings;
      discountText = '-\$${fmt.format(amount)}';
    } else {
      // 'percent' or default
      final pct = discountAmount?.round() ?? percentOff;
      discountText = '-$pct%';
    }

    final discountStyle = Theme.of(context).textTheme.labelSmall!.copyWith(
          color: Colors.red,
          fontWeight: FontWeight.w600,
        );

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 4.0,
      children: [
        Text(
          '\$${fmt.format(effectivePrice)}',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
        ),
        Text(
          '\$${fmt.format(comparePrice)}',
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
                decoration: TextDecoration.lineThrough,
                color: AppColors.textSecondary,
              ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bolt,
              color: Colors.red,
              size: 14.0,
            ),
            Text(discountText, style: discountStyle),
          ],
        ),
      ],
    );
  }
}

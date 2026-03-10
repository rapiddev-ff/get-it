import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/features/home/presentation/pages/seller_dashboard/shipping_detailed/home_dashoard_shipping_detailed_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SellerDashboardShipItemWidget extends StatelessWidget {
  const SellerDashboardShipItemWidget({
    super.key,
    required this.order,
    this.onShipped,
  });

  final Map<String, dynamic> order;
  final VoidCallback? onShipped;

  String _formatPrice(dynamic price) {
    final value = (price is num) ? price.toDouble() : 0.0;
    return NumberFormat('#,##0.00', 'en_US').format(value);
  }

  String _getProductTitle() {
    final items = order['order_items'];
    if (items is List && items.isNotEmpty) {
      return items[0]['product_title']?.toString() ?? 'Unknown Product';
    }
    return 'Unknown Product';
  }

  String _getBuyerUsername() {
    final buyer = order['buyer'];
    if (buyer is Map) {
      return buyer['username']?.toString() ?? 'unknown';
    }
    return 'unknown';
  }

  String _getProductImageUrl() {
    final items = order['order_items'];
    if (items is List && items.isNotEmpty) {
      final product = items[0]['products'];
      if (product is Map) {
        return product['main_image_url']?.toString() ?? '';
      }
    }
    return '';
  }

  String get _status => order['status']?.toString() ?? '';
  bool get _isSalePending => _status == 'sale_pending';

  @override
  Widget build(BuildContext context) {
    final orderId = order['id']?.toString() ?? '';
    final imageUrl = _getProductImageUrl();

    return InkWell(
      onTap: () async {
        final result = await context.pushNamed<bool>(
          HomeDashoardShippingDetailedWidget.routeName,
          queryParameters: {'orderId': orderId},
        );
        if (result == true) {
          onShipped?.call();
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: 66.0,
                        height: 66.0,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 66.0,
                          height: 66.0,
                          color: AppColors.backgroundPrimary,
                          child:
                              Icon(Icons.image, color: AppColors.textSecondary),
                        ),
                      )
                    : Container(
                        width: 66.0,
                        height: 66.0,
                        color: AppColors.backgroundPrimary,
                        child:
                            Icon(Icons.image, color: AppColors.textSecondary),
                      ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getProductTitle(),
                      maxLines: 1,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Sold to @${_getBuyerUsername()}',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelSmall!,
                      overflow: TextOverflow.ellipsis,
                    ),
                    RichText(
                      textScaler: MediaQuery.of(context).textScaler,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Order #${order['order_number'] ?? ''}',
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                            ),
                          ),
                          TextSpan(
                            text: ' • ',
                            style: TextStyle(),
                          ),
                          TextSpan(
                            text: '\$${_formatPrice(order['total_amount'])}',
                            style: GoogleFonts.inter(
                              color: Color(0xFF689FFF),
                              fontSize: 12.0,
                            ),
                          )
                        ],
                        style: GoogleFonts.inter(),
                      ),
                    ),
                  ].divide(SizedBox(height: 2.0)),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color:
                      _isSalePending ? Color(0xFFD97706) : AppColors.secondary,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Text(
                    _isSalePending ? 'Pending' : 'Ship',
                    style: GoogleFonts.inter(),
                  ),
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
        ),
      ),
    );
  }
}

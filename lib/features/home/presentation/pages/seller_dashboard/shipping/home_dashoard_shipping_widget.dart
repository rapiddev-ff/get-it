import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/providers/current_user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/home/presentation/pages/seller_dashboard/shipping_detailed/home_dashoard_shipping_detailed_widget.dart';

class HomeDashoardShippingWidget extends ConsumerStatefulWidget {
  const HomeDashoardShippingWidget({super.key});

  static String routeName = 'homeDashoardShipping';
  static String routePath = 'homeDashoardShipping';

  @override
  ConsumerState<HomeDashoardShippingWidget> createState() =>
      _HomeDashoardShippingWidgetState();
}

class _HomeDashoardShippingWidgetState
    extends ConsumerState<HomeDashoardShippingWidget> {
  bool _isLoading = true;
  Map<String, int> _counts = {'to_ship': 0, 'shipped': 0};
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        actions.getSellerOrderCounts(sellerId: ref.read(currentUserIdProvider)),
        actions.getSellerOrders(sellerId: ref.read(currentUserIdProvider)),
      ]);
      if (!mounted) return;
      setState(() {
        _counts = results[0] as Map<String, int>;
        _orders = results[1] as List<Map<String, dynamic>>;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (_) {
      return '';
    }
  }

  String _formatPrice(dynamic price) {
    final value = (price is num) ? price.toDouble() : 0.0;
    return NumberFormat('#,##0.00', 'en_US').format(value);
  }

  String _getProductTitle(Map<String, dynamic> order) {
    final items = order['order_items'];
    if (items is List && items.isNotEmpty) {
      return items[0]['product_title']?.toString() ?? 'Unknown Product';
    }
    return 'Unknown Product';
  }

  int _getQuantity(Map<String, dynamic> order) {
    final items = order['order_items'];
    if (items is List && items.isNotEmpty) {
      return (items[0]['quantity'] as num?)?.toInt() ?? 1;
    }
    return 1;
  }

  String _getBuyerUsername(Map<String, dynamic> order) {
    final buyer = order['buyer'];
    if (buyer is Map) {
      return buyer['username']?.toString() ?? 'unknown';
    }
    return 'unknown';
  }

  String _getProductImageUrl(Map<String, dynamic> order) {
    final items = order['order_items'];
    if (items is List && items.isNotEmpty) {
      final product = items[0]['products'];
      if (product is Map) {
        return product['main_image_url']?.toString() ?? '';
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: AppBar(
            backgroundColor: AppColors.backgroundSecondary,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.info,
                    size: 24.0,
                  ),
                  iconSize: 40.0,
                  onPressed: () => context.pop(),
                ),
                Text(
                  'Shipping Management',
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                Opacity(
                  opacity: 0.0,
                  child: IconButton(
                    icon: Icon(Icons.notifications_none,
                        color: AppColors.info, size: 20.0),
                    iconSize: 40.0,
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppColors.secondary,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadOrders,
                  color: AppColors.secondary,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // Counters row
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundSecondary,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 16.0,
                                        top: 12.0,
                                        right: 16.0,
                                        bottom: 16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${_counts['to_ship'] ?? 0}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'To Ship',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!,
                                        ),
                                      ].divide(SizedBox(height: 4.0)),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundSecondary,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 16.0,
                                        top: 12.0,
                                        right: 16.0,
                                        bottom: 16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${_counts['shipped'] ?? 0}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Shipped',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!,
                                        ),
                                      ].divide(SizedBox(height: 4.0)),
                                    ),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(width: 16.0)),
                          ),
                          // Orders list
                          if (_orders.isEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 48.0),
                              child: Center(
                                child: Text(
                                  'No orders yet',
                                  style:
                                      Theme.of(context).textTheme.labelLarge!,
                                ),
                              ),
                            )
                          else
                            Padding(
                              padding: EdgeInsets.only(top: 24.0),
                              child: ListView.separated(
                                padding: EdgeInsets.only(bottom: 24.0),
                                primary: false,
                                shrinkWrap: true,
                                itemCount: _orders.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(height: 16.0),
                                itemBuilder: (context, index) {
                                  final order = _orders[index];
                                  return _buildOrderCard(order);
                                },
                              ),
                            ),
                        ]
                            .addToStart(SizedBox(height: 24.0))
                            .addToEnd(SizedBox(height: 32.0)),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = order['status']?.toString() ?? '';
    final isSalePending = status == 'sale_pending';
    final isPaid = status == 'paid';
    final isShipped = status == 'shipped';
    final isDelivered = status == 'delivered';
    final orderId = order['id']?.toString() ?? '';
    final imageUrl = _getProductImageUrl(order);

    return InkWell(
      onTap: () async {
        final result = await context.pushNamed<bool>(
          HomeDashoardShippingDetailedWidget.routeName,
          queryParameters: {'orderId': orderId},
        );
        if (result == true) {
          _loadOrders();
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(left: 10.0, top: 16.0, right: 16.0, bottom: 16.0),
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
                      'Sold: ${_formatDate(order['created_at']?.toString())}',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelSmall!,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _getProductTitle(order),
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Qty: ${_getQuantity(order)}',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelSmall!,
                    ),
                    Text(
                      'Sold to @${_getBuyerUsername(order)}',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelSmall!,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Order #${order['order_number'] ?? ''}',
                                  style:
                                      Theme.of(context).textTheme.labelSmall!,
                                ),
                                TextSpan(
                                  text: ' • ',
                                  style:
                                      Theme.of(context).textTheme.labelMedium!,
                                ),
                                TextSpan(
                                  text:
                                      '\$${_formatPrice(order['total_amount'])}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.brandBlueMedium),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isSalePending)
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.statusWarning,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              child: Text(
                                'Pending',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        if (isPaid)
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              child: Text(
                                'Ship',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        if (isShipped)
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.brandBlueDark,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              child: Text(
                                'Shipped',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        if (isDelivered)
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.statusSuccess,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              child: Text(
                                'Delivered',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ].divide(SizedBox(height: 4.0)),
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
        ),
      ),
    );
  }
}

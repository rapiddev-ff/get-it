import '/core/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/core/providers/current_user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/home/presentation/pages/buyer_dashboard/order_detail/buyer_order_detail_widget.dart';

class BuyerPurchasesWidget extends ConsumerStatefulWidget {
  const BuyerPurchasesWidget({super.key});

  static const String routeName = 'buyerPurchases';
  static const String routePath = 'buyerPurchases';

  @override
  ConsumerState<BuyerPurchasesWidget> createState() =>
      _BuyerPurchasesWidgetState();
}

class _BuyerPurchasesWidgetState extends ConsumerState<BuyerPurchasesWidget> {
  bool _isLoading = true;
  String _activeFilter = 'All';
  Map<String, int> _counts = {'active': 0, 'delivered': 0, 'cancelled': 0};
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    try {
      final userId = ref.read(currentUserIdProvider);
      String? statusFilter;
      if (_activeFilter == 'Active') statusFilter = 'active';
      if (_activeFilter == 'Delivered') statusFilter = 'delivered';
      if (_activeFilter == 'Cancelled') statusFilter = 'cancelled';

      final results = await Future.wait([
        actions.getBuyerOrderCounts(buyerId: userId),
        actions.getBuyerOrders(buyerId: userId, statusFilter: statusFilter),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'sale_pending':
        return AppColors.statusWarning;
      case 'paid':
        return AppColors.secondary;
      case 'shipped':
        return AppColors.brandBlueDark;
      case 'delivered':
        return AppColors.statusSuccess;
      case 'cancelled':
        return AppColors.error;
      case 'refunded':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'sale_pending':
        return 'Pending';
      case 'paid':
        return 'Purchased';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      case 'refunded':
        return 'Refunded';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalCount =
        (_counts['active'] ?? 0) + (_counts['delivered'] ?? 0) + (_counts['cancelled'] ?? 0);

    return DismissKeyboard(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.info, size: 24.0),
                  iconSize: 40.0,
                  onPressed: () => context.pop(),
                ),
                Text(
                  'My Purchases',
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
              ? Center(child: AppLoadingIndicator())
              : RefreshIndicator(
                  onRefresh: _loadOrders,
                  color: AppColors.secondary,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // Filter chips
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildFilterChip('All', totalCount),
                                _buildFilterChip('Active', _counts['active'] ?? 0),
                                _buildFilterChip('Delivered', _counts['delivered'] ?? 0),
                                _buildFilterChip('Cancelled', _counts['cancelled'] ?? 0),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                          ),
                          // Orders list
                          if (_orders.isEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 48.0),
                              child: Center(
                                child: Text(
                                  'No purchases yet',
                                  style: Theme.of(context).textTheme.labelLarge!,
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

  Widget _buildFilterChip(String label, int count) {
    final isActive = _activeFilter == label;
    return InkWell(
      onTap: () {
        if (_activeFilter == label) return;
        _activeFilter = label;
        _loadOrders();
      },
      borderRadius: BorderRadius.circular(100.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: [AppColors.secondary, AppColors.brandBlue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          color: isActive ? null : AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            '$label ($count)',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = order['status']?.toString() ?? '';
    final orderId = order['id']?.toString() ?? '';
    final imageUrl = _getProductImageUrl(order);

    return InkWell(
      onTap: () async {
        await context.pushNamed(
          BuyerOrderDetailWidget.routeName,
          queryParameters: {'orderId': orderId},
        );
        _loadOrders();
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
                        errorBuilder: (_, __, ___) => _imagePlaceholder(),
                      )
                    : _imagePlaceholder(),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Purchased: ${_formatDate(order['created_at']?.toString())}',
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
                    Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      'Order #${order['order_number'] ?? ''}',
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
                        Container(
                          decoration: BoxDecoration(
                            color: _getStatusColor(status)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Text(
                              _getStatusLabel(status),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.0,
                                    color: _getStatusColor(status),
                                  ),
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

  Widget _imagePlaceholder() {
    return Container(
      width: 66.0,
      height: 66.0,
      color: AppColors.backgroundPrimary,
      child: Icon(Icons.image, color: AppColors.textSecondary),
    );
  }
}

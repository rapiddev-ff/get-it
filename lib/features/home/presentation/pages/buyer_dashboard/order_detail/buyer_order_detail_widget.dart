import '/core/widgets/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '/core/providers/current_user_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;

class BuyerOrderDetailWidget extends ConsumerStatefulWidget {
  const BuyerOrderDetailWidget({
    super.key,
    this.orderId,
  });

  final String? orderId;

  static const String routeName = 'buyerOrderDetail';
  static const String routePath = 'buyerOrderDetail';

  @override
  ConsumerState<BuyerOrderDetailWidget> createState() =>
      _BuyerOrderDetailWidgetState();
}

class _BuyerOrderDetailWidgetState
    extends ConsumerState<BuyerOrderDetailWidget> {
  bool _isLoading = true;
  Map<String, dynamic>? _order;
  String? _orderId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_orderId == null) {
      _orderId = widget.orderId ??
          GoRouterState.of(context).uri.queryParameters['orderId'];
      _loadOrder();
    }
  }

  Future<void> _loadOrder() async {
    if (_orderId == null) return;
    setState(() => _isLoading = true);
    try {
      final result = await actions.getBuyerOrderDetail(
        orderId: _orderId!,
        buyerId: ref.read(currentUserIdProvider),
      );
      if (!mounted) return;
      setState(() {
        _order = result;
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

  String _getProductTitle() {
    final items = _order?['order_items'];
    if (items is List && items.isNotEmpty) {
      return items[0]['product_title']?.toString() ?? 'Unknown Product';
    }
    return 'Unknown Product';
  }

  int _getQuantity() {
    final items = _order?['order_items'];
    if (items is List && items.isNotEmpty) {
      return (items[0]['quantity'] as num?)?.toInt() ?? 1;
    }
    return 1;
  }

  String _getProductImageUrl() {
    final items = _order?['order_items'];
    if (items is List && items.isNotEmpty) {
      final product = items[0]['products'];
      if (product is Map) {
        return product['main_image_url']?.toString() ?? '';
      }
    }
    return '';
  }

  Map<String, dynamic>? _getShippingAddress() {
    final snapshot = _order?['shipping_address_snapshot'];
    if (snapshot is Map<String, dynamic>) return snapshot;
    return null;
  }

  String _getPaymentLast4() {
    final snapshot = _order?['payment_method_snapshot'];
    if (snapshot is Map) {
      return snapshot['last4']?.toString() ?? '';
    }
    // Fallback: check stripe_payment_intent_id presence
    return '';
  }

  String _getPaymentBrand() {
    final snapshot = _order?['payment_method_snapshot'];
    if (snapshot is Map) {
      final brand = snapshot['brand']?.toString() ?? '';
      if (brand.isNotEmpty) {
        return '${brand[0].toUpperCase()}${brand.substring(1)}';
      }
    }
    return 'Card';
  }

  String get _status => _order?['status']?.toString() ?? '';

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
    final imageUrl = _getProductImageUrl();
    final address = _getShippingAddress();

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
                  icon:
                      Icon(Icons.arrow_back, color: AppColors.info, size: 24.0),
                  iconSize: 40.0,
                  onPressed: () => context.pop(),
                ),
                Text(
                  'Order Details',
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
        body: _isLoading
            ? Center(child: AppLoadingIndicator())
            : _order == null
                ? Center(
                    child: Text('Order not found',
                        style: Theme.of(context).textTheme.labelMedium!))
                : SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Item Description
                          _buildSectionHeader('Item Description'),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16.0, top: 16.0, right: 16.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.backgroundSecondary,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 10.0,
                                    top: 16.0,
                                    right: 16.0,
                                    bottom: 16.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(4.0),
                                      child: imageUrl.isNotEmpty
                                          ? Image.network(
                                              imageUrl,
                                              width: 66.0,
                                              height: 66.0,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (_, __, ___) =>
                                                      _imagePlaceholder(),
                                            )
                                          : _imagePlaceholder(),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _getProductTitle(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          Text(
                                            'Qty: ${_getQuantity()}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!,
                                          ),
                                          Text(
                                            'Order #${_order!['order_number'] ?? ''}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!,
                                          ),
                                        ].divide(SizedBox(height: 4.0)),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 32.0,
                            thickness: 1.0,
                            color: AppColors.surfaceDark,
                          ),
                          // Purchase Information
                          _buildSectionHeader('Purchase Information'),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16.0, top: 16.0, right: 16.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.backgroundSecondary,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildInfoRow(
                                      'Date',
                                      _formatDate(
                                          _order!['created_at']?.toString()),
                                    ),
                                    _buildInfoRow(
                                      'Subtotal',
                                      '\$${_formatPrice(_order!['subtotal'])}',
                                    ),
                                    if ((_order!['shipping_cost'] as num?)
                                            ?.toDouble() !=
                                        null)
                                      _buildInfoRow(
                                        'Shipping',
                                        '\$${_formatPrice(_order!['shipping_cost'])}',
                                      ),
                                    if ((_order!['tax_amount'] as num?)
                                            ?.toDouble() !=
                                        null)
                                      _buildInfoRow(
                                        'Tax',
                                        '\$${_formatPrice(_order!['tax_amount'])}',
                                      ),
                                    Divider(
                                      height: 16.0,
                                      thickness: 1.0,
                                      color: AppColors.surfaceDark,
                                    ),
                                    _buildInfoRow(
                                      'Total',
                                      '\$${_formatPrice(_order!['total_amount'])}',
                                      isBold: true,
                                    ),
                                    SizedBox(height: 8.0),
                                    _buildInfoRow(
                                      'Payment',
                                      _getPaymentLast4().isNotEmpty
                                          ? '${_getPaymentBrand()} •••• ${_getPaymentLast4()}'
                                          : 'Card on file',
                                    ),
                                    _buildInfoRow(
                                      'Status',
                                      null,
                                      statusWidget: Container(
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(_status)
                                              .withValues(alpha: 0.2),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0,
                                              vertical: 4.0),
                                          child: Text(
                                            _getStatusLabel(_status),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11.0,
                                                  color: _getStatusColor(
                                                      _status),
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 32.0,
                            thickness: 1.0,
                            color: AppColors.surfaceDark,
                          ),
                          // Shipping Information
                          _buildSectionHeader('Shipping Information'),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16.0, top: 16.0, right: 16.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.backgroundSecondary,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    if (address != null) ...[
                                      Text(
                                        address['full_name']?.toString() ??
                                            '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        [
                                          address['address_line_1'],
                                          address['address_line_2'],
                                        ]
                                            .where((e) =>
                                                e != null &&
                                                e.toString().isNotEmpty)
                                            .join(', '),
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${address['city'] ?? ''}, ${address['state'] ?? ''} ${address['zip_code'] ?? ''}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!,
                                      ),
                                      Text(
                                        address['country']?.toString() ?? '',
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ] else
                                      Text(
                                        'No shipping address available',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!,
                                      ),
                                  ].divide(SizedBox(height: 4.0)),
                                ),
                              ),
                            ),
                          ),
                          // Tracking Number (read-only)
                          if (_order!['tracking_number'] != null &&
                              _order!['tracking_number']
                                  .toString()
                                  .isNotEmpty) ...[
                            Divider(
                              height: 32.0,
                              thickness: 1.0,
                              color: AppColors.surfaceDark,
                            ),
                            _buildSectionHeader('Tracking'),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 16.0, top: 16.0, right: 16.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundSecondary,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (_order!['shipping_carrier'] !=
                                              null &&
                                          _order!['shipping_carrier']
                                              .toString()
                                              .isNotEmpty)
                                        Text(
                                          _order!['shipping_carrier']
                                              .toString()
                                              .toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!,
                                        ),
                                      Text(
                                        _order!['tracking_number']
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w500),
                                      ),
                                    ].divide(SizedBox(height: 4.0)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          // Status progress
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16.0, top: 24.0, right: 16.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildStatusBadge(
                                      'Pending',
                                      _status == 'sale_pending' ||
                                          _status == 'paid' ||
                                          _status == 'shipped' ||
                                          _status == 'delivered'),
                                  SizedBox(width: 8.0),
                                  _buildStatusBadge(
                                      'Purchased',
                                      _status == 'paid' ||
                                          _status == 'shipped' ||
                                          _status == 'delivered'),
                                  SizedBox(width: 8.0),
                                  _buildStatusBadge(
                                      'Shipped',
                                      _status == 'shipped' ||
                                          _status == 'delivered'),
                                  SizedBox(width: 8.0),
                                  _buildStatusBadge(
                                      'Delivered', _status == 'delivered'),
                                ],
                              ),
                            ),
                          ),
                        ].addToEnd(SizedBox(height: 32.0)),
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value,
      {bool isBold = false, Widget? statusWidget}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall!,
          ),
          if (statusWidget != null)
            statusWidget
          else
            Text(
              value ?? '',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String label, bool isActive) {
    return Container(
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
          label,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 13.0,
                color:
                    isActive ? AppColors.textPrimary : AppColors.textSecondary,
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

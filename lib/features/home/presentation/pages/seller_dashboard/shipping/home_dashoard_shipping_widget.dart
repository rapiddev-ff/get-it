import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/home/presentation/pages/seller_dashboard/shipping_detailed/home_dashoard_shipping_detailed_widget.dart';

class HomeDashoardShippingWidget extends StatefulWidget {
  const HomeDashoardShippingWidget({super.key});

  static String routeName = 'homeDashoardShipping';
  static String routePath = 'homeDashoardShipping';

  @override
  State<HomeDashoardShippingWidget> createState() =>
      _HomeDashoardShippingWidgetState();
}

class _HomeDashoardShippingWidgetState
    extends State<HomeDashoardShippingWidget> {
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
        actions.getSellerOrderCounts(),
        actions.getSellerOrders(),
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
        backgroundColor: AppColors.backgroundPrimary,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: AppBar(
            backgroundColor: AppColors.backgroundSecondary,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.max,
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
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: AppColors.textPrimary,
                  ),
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
            actions: [],
            centerTitle: true,
            elevation: 0.0,
          ),
        ),
        body: SafeArea(
          top: true,
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
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Counters row
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.backgroundSecondary,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 12.0, 16.0, 16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${_counts['to_ship'] ?? 0}',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24.0,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          'To Ship',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14.0,
                                            color: AppColors.textSecondary,
                                          ),
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 12.0, 16.0, 16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${_counts['shipped'] ?? 0}',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24.0,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          'Shipped',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14.0,
                                            color: AppColors.textSecondary,
                                          ),
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
                                  style: GoogleFonts.inter(
                                    color: AppColors.textSecondary,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            )
                          else
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 0.0),
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
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 16.0, 16.0, 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
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
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _getProductTitle(order),
                      maxLines: 1,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Qty: ${_getQuantity(order)}',
                      maxLines: 1,
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      'Sold to @${_getBuyerUsername(order)}',
                      maxLines: 1,
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Order #${order['order_number'] ?? ''}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.0,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                TextSpan(
                                  text: ' • ',
                                  style: GoogleFonts.inter(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '\$${_formatPrice(order['total_amount'])}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.0,
                                    color: Color(0xFF689FFF),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (isSalePending)
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFD97706),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 6.0, 12.0, 6.0),
                              child: Text(
                                'Pending',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0,
                                  color: AppColors.textPrimary,
                                ),
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
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 6.0, 12.0, 6.0),
                              child: Text(
                                'Ship',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        if (isShipped)
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF2D5AA0),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 6.0, 12.0, 6.0),
                              child: Text(
                                'Shipped',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        if (isDelivered)
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF22C55E),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 6.0, 12.0, 6.0),
                              child: Text(
                                'Delivered',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0,
                                  color: AppColors.textPrimary,
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
}

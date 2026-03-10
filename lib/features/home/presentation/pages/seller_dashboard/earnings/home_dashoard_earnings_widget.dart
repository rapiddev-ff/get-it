import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;

class HomeDashoardEarningsWidget extends StatefulWidget {
  const HomeDashoardEarningsWidget({super.key});

  static String routeName = 'homeDashoardEarnings';
  static String routePath = 'homeDashoardEarnings';

  @override
  State<HomeDashoardEarningsWidget> createState() =>
      _HomeDashoardEarningsWidgetState();
}

class _HomeDashoardEarningsWidgetState
    extends State<HomeDashoardEarningsWidget> {
  String _activeTab = 'Sales';
  String _activeFilter = 'All Time';

  bool _isLoading = true;
  Map<String, dynamic> _earnings = {};
  List<Map<String, dynamic>> _allOrders = [];
  List<Map<String, dynamic>> _orders = [];

  static const _filters = ['All Time', 'This Week', 'This Month', '90 Days'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  DateTime? _getStartDate() {
    final now = DateTime.now();
    switch (_activeFilter) {
      case 'This Week':
        return now.subtract(Duration(days: now.weekday - 1));
      case 'This Month':
        return DateTime(now.year, now.month, 1);
      case '90 Days':
        return now.subtract(Duration(days: 90));
      default:
        return null;
    }
  }

  void _applyFilter() {
    final startDate = _getStartDate();
    _orders = _allOrders.where((o) {
      final status = o['status']?.toString() ?? '';
      if (status == 'cancelled' || status == 'refunded') return false;
      if (startDate != null) {
        final createdAt = DateTime.tryParse(o['created_at']?.toString() ?? '');
        if (createdAt != null && createdAt.isBefore(startDate)) return false;
      }
      return true;
    }).toList();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        actions.getSellerEarnings(null, null),
        actions.getSellerOrders(),
      ]);

      if (!mounted) return;

      final earningsData = results[0] as Map<String, dynamic>;
      _allOrders = results[1] as List<Map<String, dynamic>>;

      _applyFilter();

      setState(() {
        _earnings = earningsData;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  String _formatPrice(dynamic price) {
    final value = (price is num) ? price.toDouble() : 0.0;
    return NumberFormat('#,##0.00', 'en_US').format(value);
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

  String _getStatusLabel(String status) {
    switch (status) {
      case 'sale_pending':
        return 'Sale Pending';
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'sale_pending':
        return Color(0xFFD97706);
      case 'paid':
        return AppColors.secondary;
      case 'shipped':
        return Color(0xFF2D5AA0);
      case 'delivered':
        return Color(0xFF22C55E);
      case 'cancelled':
        return AppColors.error;
      case 'refunded':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  double get _availableAmount =>
      (_earnings['available_amount'] as num?)?.toDouble() ?? 0.0;
  double get _pendingAmount =>
      (_earnings['pending_amount'] as num?)?.toDouble() ?? 0.0;
  int get _totalSales => _orders.length;
  double get _filteredRevenue => _orders.fold(
      0.0, (sum, o) => sum + ((o['total_amount'] as num?)?.toDouble() ?? 0.0));
  double get _avgSale => _totalSales > 0 ? _filteredRevenue / _totalSales : 0.0;

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon:
                      Icon(Icons.arrow_back, color: AppColors.info, size: 24.0),
                  iconSize: 40.0,
                  onPressed: () => context.pop(),
                ),
                Text(
                  'Earnings',
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
          ),
        ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: AppColors.secondary))
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Time filter chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _filters
                              .map((f) => Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: _buildFilterChip(f),
                                  ))
                              .toList(),
                        ),
                      ),
                      // Earnings Breakdown
                      Padding(
                        padding: EdgeInsets.only(top: 24.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundSecondary,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Earnings Breakdown',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 16.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildEarningCard(
                                        'Available',
                                        '\$${_formatPrice(_availableAmount)}',
                                        Color(0xFF22C55E),
                                      ),
                                    ),
                                    SizedBox(width: 12.0),
                                    Expanded(
                                      child: _buildEarningCard(
                                        'Pending',
                                        '\$${_formatPrice(_pendingAmount)}',
                                        Color(0xFFD97706),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildStatColumn(
                                        '$_totalSales', 'Total Sales'),
                                    _buildStatColumn(
                                        '\$${_formatPrice(_avgSale)}',
                                        'Avg Sale'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Tabs: Sales | Referrals
                      Padding(
                        padding: EdgeInsets.only(top: 24.0),
                        child: Container(
                          width: double.infinity,
                          height: 53.0,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundPrimary,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                _buildTab('Sales'),
                                _buildTab('Referrals'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Content
                      Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: _activeTab == 'Sales'
                            ? _buildSalesContent()
                            : _buildReferralsContent(),
                      ),
                    ]
                        .addToStart(SizedBox(height: 28.0))
                        .addToEnd(SizedBox(height: 32.0)),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isActive = _activeFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeFilter = label;
          _applyFilter();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: [AppColors.secondary, Color(0xFF6187F1)],
                  stops: [0.0, 1.0],
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
            style: GoogleFonts.inter(
              fontSize: 14.0,
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEarningCard(String label, String amount, Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8.0,
                  height: 8.0,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.0),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.0),
            Text(
              amount,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.0,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String label) {
    final isActive = _activeTab == label;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _activeTab = label),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14.0,
                  color: isActive ? AppColors.textPrimary : Color(0xFFB4B4B4),
                  height: 2.0,
                ),
              ),
            ),
            Opacity(
              opacity: isActive ? 1.0 : 0.0,
              child: Container(
                width: double.infinity,
                height: 2.0,
                decoration: BoxDecoration(color: AppColors.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesContent() {
    if (_orders.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 48.0),
        child: Center(
          child: Text(
            'No sales yet',
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 16.0,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.only(bottom: 24.0),
      primary: false,
      shrinkWrap: true,
      itemCount: _orders.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.0),
      itemBuilder: (context, index) => _buildOrderCard(_orders[index]),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = order['status']?.toString() ?? '';
    final quantity = _getQuantity(order);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(order['created_at']?.toString()),
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
                    'Buyer: @${_getBuyerUsername(order)}',
                    maxLines: 1,
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (quantity > 1)
                    Text(
                      'Qty: $quantity',
                      style: GoogleFonts.inter(
                        fontSize: 12.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  Text(
                    'Order #${order['order_number'] ?? ''}',
                    maxLines: 1,
                    style: GoogleFonts.inter(
                      fontSize: 12.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ].divide(SizedBox(height: 4.0)),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${_formatPrice(order['total_amount'])}',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      _getStatusLabel(status),
                      style: GoogleFonts.inter(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(status),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ].divide(SizedBox(width: 12.0)),
        ),
      ),
    );
  }

  Widget _buildReferralsContent() {
    return Padding(
      padding: EdgeInsets.only(top: 48.0),
      child: Center(
        child: Text(
          'Referrals coming soon',
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}

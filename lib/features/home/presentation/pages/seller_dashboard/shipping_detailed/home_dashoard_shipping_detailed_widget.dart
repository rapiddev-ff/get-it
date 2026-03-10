import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '/backend/supabase/supabase.dart';
import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;

class HomeDashoardShippingDetailedWidget extends StatefulWidget {
  const HomeDashoardShippingDetailedWidget({
    super.key,
    this.orderId,
  });

  final String? orderId;

  static String routeName = 'homeDashoardShippingDetailed';
  static String routePath = 'homeDashoardShippingDetailed';

  @override
  State<HomeDashoardShippingDetailedWidget> createState() =>
      _HomeDashoardShippingDetailedWidgetState();
}

class _HomeDashoardShippingDetailedWidgetState
    extends State<HomeDashoardShippingDetailedWidget> {
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;

  bool _isLoading = true;
  bool _isSaving = false;
  Map<String, dynamic>? _order;
  String? _orderId;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textFieldFocusNode = FocusNode();
    textFieldFocusNode!.addListener(() => setState(() {}));
  }

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
      final result = await SupaFlow.client.from('orders').select('''
            *,
            order_items(product_id, product_title, product_price, quantity, products(main_image_url)),
            buyer:users!orders_buyer_id_fkey(id, username, photo_url)
          ''').eq('id', _orderId!).single();

      if (!mounted) return;
      setState(() {
        _order = result;
        _isLoading = false;
        // Pre-fill tracking number if already set
        final existing = _order?['tracking_number']?.toString() ?? '';
        if (existing.isNotEmpty) {
          textController?.text = existing;
        }
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

  String _getBuyerUsername() {
    final buyer = _order?['buyer'];
    if (buyer is Map) {
      return buyer['username']?.toString() ?? 'unknown';
    }
    return 'unknown';
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

  String get _status => _order?['status']?.toString() ?? '';
  bool get _isSalePending => _status == 'sale_pending';
  bool get _isPaid => _status == 'paid';
  bool get _isShipped => _status == 'shipped';
  bool get _isDelivered => _status == 'delivered';
  bool get _canEditTracking => _isPaid || _isShipped;

  Future<void> _markAsShipped() async {
    if (_orderId == null || _isSaving) return;

    setState(() => _isSaving = true);

    final error = await actions.markOrderShipped(
      orderId: _orderId!,
      trackingNumber: textController?.text,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (error != null) {
      actions.toastificationshow(context, 'Error', error, 'error');
      return;
    }

    actions.toastificationshow(
        context, 'Success', 'Order marked as shipped', 'success');
    context.pop(true);
  }

  Future<void> _updateTracking() async {
    if (_orderId == null || _isSaving) return;
    final trackingText = textController?.text.trim() ?? '';
    if (trackingText.isEmpty) return;

    setState(() => _isSaving = true);

    final error = await actions.updateTrackingNumber(
      orderId: _orderId!,
      trackingNumber: trackingText,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (error != null) {
      actions.toastificationshow(context, 'Error', error, 'error');
      return;
    }

    actions.toastificationshow(
        context, 'Success', 'Tracking number updated', 'success');
  }

  Future<void> _cancelOrder() async {
    if (_orderId == null || _isSaving) return;

    // Show seller cancellation dialog with reason selection
    final result = await showDialog<Map<String, String>?>(
      context: context,
      builder: (ctx) => _SellerCancelDialog(),
    );

    if (result == null) return;

    setState(() => _isSaving = true);

    final error = await actions.cancelOrderSeller(
      orderId: _orderId!,
      reason: result['reason']!,
      reasonText: result['reason_text'],
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (error != null) {
      actions.toastificationshow(context, 'Error', error, 'error');
      return;
    }

    actions.toastificationshow(
        context, 'Success', 'Order cancelled', 'success');
    context.pop(true);
  }

  Future<void> _markAsDelivered() async {
    if (_orderId == null || _isSaving) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text('Mark as Delivered',
            style: Theme.of(context).textTheme.bodyMedium!),
        content: Text('Are you sure this order has been delivered?',
            style: Theme.of(context).textTheme.labelMedium!),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('No',
                style: Theme.of(context).textTheme.labelMedium!),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Yes',
                style: GoogleFonts.inter(color: AppColors.secondary)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isSaving = true);

    final error = await actions.markOrderDelivered(orderId: _orderId!);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (error != null) {
      actions.toastificationshow(context, 'Error', error, 'error');
      return;
    }

    actions.toastificationshow(
        context, 'Success', 'Order marked as delivered', 'success');
    context.pop(true);
  }

  @override
  void dispose() {
    textController?.dispose();
    textFieldFocusNode?.dispose();
    super.dispose();
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
                  'Shipping',
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
            ? Center(
                child: CircularProgressIndicator(color: AppColors.secondary))
            : _order == null
                ? Center(
                    child: Text('Order not found',
                        style:
                            Theme.of(context).textTheme.labelMedium!))
                : SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product card
                          Container(
                            decoration: BoxDecoration(color: AppColors.backgroundPrimary),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 24.0),
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
                                                errorBuilder: (_, __, ___) =>
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
                                              'Sold: ${_formatDate(_order!['created_at']?.toString())}',
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              _getProductTitle(),
                                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              'Qty: ${_getQuantity()}',
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!,
                                            ),
                                            Text(
                                              'Sold to @${_getBuyerUsername()}',
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              'Order #${_order!['order_number'] ?? ''}',
                                              maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall!,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 4.0),
                                              child: Text(
                                                '\$${_formatPrice(_order!['total_amount'])}',
                                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          ].divide(SizedBox(height: 4.0)),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 12.0)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 1.0,
                            thickness: 1.0,
                            color: AppColors.surfaceDark,
                          ),
                          // Shipping Address
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16.0, top: 24.0, right: 16.0),
                            child: Text(
                              'Shipping Address',
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (address != null) ...[
                                      Text(
                                        address['full_name']?.toString() ?? '',
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
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
                                      if (address['phone'] != null &&
                                          address['phone']
                                              .toString()
                                              .isNotEmpty)
                                        Text(
                                          address['phone'].toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!,
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
                          Divider(
                            height: 32.0,
                            thickness: 1.0,
                            color: AppColors.surfaceDark,
                          ),
                          // Add Tracking #
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Add Tracking #',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.normal,
                                fontSize: 15.0,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16.0, top: 8.0, right: 16.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: TextFormField(
                                controller: textController,
                                focusNode: textFieldFocusNode,
                                onChanged: (_) => EasyDebounce.debounce(
                                  'textController',
                                  Duration(milliseconds: 100),
                                  () => setState(() {}),
                                ),
                                autofocus: false,
                                enabled: _canEditTracking,
                                obscureText: false,
                                decoration: InputDecoration(
                                  isDense: false,
                                  hintText: 'Tracking number',
                                  hintStyle:
                                      Theme.of(context).textTheme.labelLarge!,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.neutral700,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusTextField4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.secondary,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusTextField4),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.neutral700
                                          .withValues(alpha: 0.5),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusTextField4),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusTextField4),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.error,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        AppConstants.radiusTextField4),
                                  ),
                                ),
                                style: GoogleFonts.inter(
                                  fontSize: 14.0,
                                  color: _canEditTracking
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                ),
                                cursorColor: AppColors.textPrimary,
                                enableInteractiveSelection: true,
                              ),
                            ),
                          ),
                          // Save tracking button (for shipped orders only)
                          if (_isShipped) ...[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 16.0, top: 12.0, right: 16.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: _isSaving ? null : _updateTracking,
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppColors.secondary,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Update Tracking',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 15.0),
                                  ),
                                ),
                              ),
                            ),
                            // Mark as Delivered button (for shipped orders)
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 16.0, top: 8.0, right: 16.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF16A34A),
                                        AppColors.statusSuccess,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: TextButton(
                                    onPressed:
                                        _isSaving ? null : _markAsDelivered,
                                    style: TextButton.styleFrom(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 12.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    child: Text(
                                      'Mark as Delivered',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 15.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          Divider(
                            height: 48.0,
                            thickness: 1.0,
                            color: AppColors.surfaceDark,
                          ),
                          // Status indicators
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildStatusBadge(
                                      'Sale Pending',
                                      _isSalePending ||
                                          _isPaid ||
                                          _isShipped ||
                                          _isDelivered),
                                  SizedBox(width: 8.0),
                                  _buildStatusBadge('Purchased',
                                      _isPaid || _isShipped || _isDelivered),
                                  SizedBox(width: 8.0),
                                  _buildStatusBadge(
                                      'Shipped', _isShipped || _isDelivered),
                                  SizedBox(width: 8.0),
                                  _buildStatusBadge('Delivered', _isDelivered),
                                ],
                              ),
                            ),
                          ),
                          // Sale Pending info
                          if (_isSalePending)
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 16.0, top: 16.0, right: 16.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color:
                                      Color(0xFF78350F).withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(color: AppColors.statusWarning),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text(
                                    'This order is pending confirmation. The buyer has 5 minutes to cancel. You cannot ship until it\'s confirmed.',
                                    style: GoogleFonts.inter(
                                      fontSize: 13.0,
                                      color: Color(0xFFFBBF24),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          // Action buttons
                          if (_isPaid) ...[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 16.0, top: 32.0, right: 16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed:
                                          _isSaving ? null : _cancelOrder,
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                            color: AppColors.neutral700),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 14.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: Text(
                                        'Cancel',
                                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 15.0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.secondary,
                                            AppColors.brandBlue
                                          ],
                                          stops: [0.0, 1.0],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: TextButton(
                                        onPressed:
                                            _isSaving ? null : _markAsShipped,
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 14.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        child: _isSaving
                                            ? SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: AppColors.textPrimary,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : Text(
                                                'Mark as Shipped',
                                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 15.0),
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ].addToEnd(SizedBox(height: 32.0)),
                      ),
                    ),
                  ),
      ),
    );
  }

  Widget _buildStatusBadge(String label, bool isActive) {
    return Container(
      decoration: BoxDecoration(
        gradient: isActive
            ? LinearGradient(
                colors: [AppColors.secondary, AppColors.brandBlue],
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
            fontWeight: FontWeight.w500,
            fontSize: 13.0,
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
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

/// Dialog for seller-initiated order cancellation with reason selection.
class _SellerCancelDialog extends StatefulWidget {
  @override
  State<_SellerCancelDialog> createState() => _SellerCancelDialogState();
}

class _SellerCancelDialogState extends State<_SellerCancelDialog> {
  String? _selectedReason;
  final _otherController = TextEditingController();

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.backgroundSecondary,
      title: Text('Cancel Order',
          style: GoogleFonts.inter(
              color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Please select a reason:',
              style: Theme.of(context).textTheme.labelMedium!),
          SizedBox(height: 12.0),
          _buildReasonTile('item_sold_out', 'Item sold out'),
          _buildReasonTile(
              'double_sold', 'Item double-sold on another platform'),
          _buildReasonTile('other', 'Other'),
          if (_selectedReason == 'other') ...[
            SizedBox(height: 8.0),
            TextField(
              controller: _otherController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Describe the reason...',
                hintStyle: Theme.of(context).textTheme.labelMedium!,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: AppColors.neutral700),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: AppColors.neutral700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: AppColors.secondary),
                ),
              ),
              style: GoogleFonts.inter(
                  color: AppColors.textPrimary, fontSize: 14.0),
              cursorColor: AppColors.textPrimary,
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Back',
              style: Theme.of(context).textTheme.labelMedium!),
        ),
        TextButton(
          onPressed: _selectedReason == null
              ? null
              : () {
                  Navigator.pop(context, {
                    'reason': _selectedReason!,
                    'reason_text': _otherController.text.trim(),
                  });
                },
          child: Text('Cancel Order',
              style: GoogleFonts.inter(
                  color: _selectedReason != null
                      ? AppColors.error
                      : AppColors.textSecondary)),
        ),
      ],
    );
  }

  Widget _buildReasonTile(String value, String label) {
    return InkWell(
      onTap: () => setState(() => _selectedReason = value),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          children: [
            Icon(
              _selectedReason == value
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: _selectedReason == value
                  ? AppColors.secondary
                  : AppColors.textSecondary,
              size: 20.0,
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.inter(
                      color: AppColors.textPrimary, fontSize: 14.0)),
            ),
          ],
        ),
      ),
    );
  }
}

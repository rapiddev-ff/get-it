import '/features/home/domain/models/feed_product_model.dart';
import '/features/checkout/domain/models/checkout_totals_model.dart';
import '/features/checkout/domain/models/checkout_order_result_model.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/checkout/presentation/pages/checkout_edit_shipping_address/checkout_edit_shipping_address_widget.dart';
import '/features/checkout/presentation/widgets/checkout_item/checkout_item_widget.dart';
import '/features/profile/presentation/pages/settings_payment_method_add/settings_payment_method_add_widget.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/checkout/presentation/providers/checkout_provider.dart';
import '/features/checkout/presentation/widgets/fast_checkout/fast_checkout_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CheckoutWidget extends ConsumerStatefulWidget {
  const CheckoutWidget({
    super.key,
    required this.feedProductItem,
    int? initialQuantity,
    this.shortlistId,
  }) : this.initialQuantity = initialQuantity ?? 1;

  final FeedProduct? feedProductItem;
  final int initialQuantity;
  final String? shortlistId;

  static String routeName = 'checkout';
  static String routePath = 'checkout';

  @override
  ConsumerState<CheckoutWidget> createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends ConsumerState<CheckoutWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _currencyFormat = NumberFormat('\$#,##0.00', 'en_US');

  CheckoutTotals? checkoutTotals;
  int quantity = 1;
  bool isProcessing = false;
  bool isLoading = true;
  double tax = 0.0;
  CheckoutOrderResult? orderResult;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      quantity = widget.initialQuantity;
      _autoSelectDefaultPaymentMethod();
      await _loadTotalsAndTax();
    });
  }

  void _autoSelectDefaultPaymentMethod() {
    final user = ref.read(authProvider);
    final defaultId = user.defaultPaymentMethodId;
    final methods = user.paymentMethod;

    if (methods.isEmpty) return;

    // Try to find default payment method
    final defaultMethod = methods.where((m) => m.id == defaultId).firstOrNull;
    if (defaultMethod != null) {
      ref.read(checkoutProvider.notifier).setPaymentMethod(defaultMethod);
    } else {
      // Fall back to first method
      ref.read(checkoutProvider.notifier).setPaymentMethod(methods.first);
    }
  }

  Future<void> _loadTotalsAndTax() async {
    setState(() => isLoading = true);

    try {
      final totals = await actions.calculateCheckoutTotals(
        widget.feedProductItem!.id,
        quantity,
      );
      if (totals != null) {
        checkoutTotals = totals;
      }

      await _recalculateTax();
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _recalculateTax() async {
    final address = ref.read(authProvider).shippingAddress;
    if (address == null || (address.addressLine1).isEmpty) {
      tax = 0.0;
      return;
    }

    final subtotal = widget.feedProductItem!.price * quantity;
    final shipping = _shippingCost;

    tax = await actions.calculateOrderTax(
      subtotal,
      shipping,
      address.addressLine1,
      address.city,
      address.state,
      address.zipCode,
    );
    if (mounted) setState(() {});
  }

  double get _subtotal => widget.feedProductItem!.price * quantity;

  double get _shippingCost {
    if (checkoutTotals != null) return checkoutTotals!.shippingCost;
    final flat = widget.feedProductItem!.customFlatRate ?? 0.0;
    final additional = widget.feedProductItem!.customAdditionalItemFee ?? 0.0;
    if (quantity <= 1) return flat;
    return flat + additional * (quantity - 1);
  }

  double get _platformFee => _subtotal * 0.1;

  double get _total => _subtotal + _shippingCost + tax + _platformFee;

  bool get _hasShippingAddress {
    final addr = ref.read(authProvider).shippingAddress;
    return addr != null && addr.addressLine1.isNotEmpty;
  }

  bool get _hasPaymentMethod {
    return ref.read(checkoutProvider).id.isNotEmpty;
  }

  Future<void> _onCompletePurchase() async {
    if (isProcessing) return;

    if (!_hasShippingAddress) {
      actions.toastificationshow(
          context, 'Missing Address', 'Please add a shipping address', 'error');
      return;
    }

    if (!_hasPaymentMethod) {
      actions.toastificationshow(context, 'Missing Payment',
          'Please select a payment method', 'error');
      return;
    }

    setState(() => isProcessing = true);

    try {
      final shippingAddressId =
          ref.read(authProvider).shippingAddress?.id ?? '';
      final paymentMethodId = ref.read(checkoutProvider).id;

      orderResult = await actions.createCheckoutOrder(
        widget.feedProductItem!.id,
        quantity,
        shippingAddressId,
        paymentMethodId,
        '',
        widget.shortlistId,
      );

      if (orderResult == null || !orderResult!.success) {
        actions.toastificationshow(
            context, 'Error', 'Failed to create order', 'error');
        return;
      }

      final payResult = await actions.payWithSavedCard(
        orderResult!.orderId,
        paymentMethodId,
        7,
      );

      if (payResult is Map && payResult['success'] == true) {
        if (mounted) {
          Navigator.pop(context);
          _showConfirmationPopup();
        }
      } else {
        final errorMsg = payResult is Map
            ? (payResult['error'] ?? 'Payment failed').toString()
            : 'Payment failed';
        if (mounted) {
          actions.toastificationshow(
              context, 'Payment Error', errorMsg, 'error');
        }
      }
    } catch (e) {
      if (mounted) {
        actions.toastificationshow(
            context, 'Error', 'Something went wrong', 'error');
      }
    } finally {
      if (mounted) setState(() => isProcessing = false);
    }
  }

  void _showConfirmationPopup() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (_) => FastCheckoutWidget(
        feedProduct: widget.feedProductItem,
        orderId: orderResult?.orderId,
        subtotal: _subtotal,
        quantity: quantity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final selectedPayment = ref.watch(checkoutProvider);

    return DismissKeyboard(
      child: Scaffold(
        key: scaffoldKey,
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
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  iconSize: 40.0,
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.info,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'Checkout',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: AppColors.textPrimary,
                  ),
                ),
                Opacity(
                  opacity: 0.0,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    iconSize: 40.0,
                    icon: Icon(
                      Icons.notifications_none,
                      color: AppColors.info,
                      size: 20.0,
                    ),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product item
                CheckoutItemWidget(
                  quantity: quantity,
                  feedProduct: widget.feedProductItem!,
                  addQuantityAction: () async {
                    quantity = quantity + 1;
                    setState(() {});
                    await _recalculateTax();
                  },
                  minusQuantityAction: () async {
                    if (quantity <= 1) return;
                    quantity = quantity - 1;
                    setState(() {});
                    await _recalculateTax();
                  },
                ),
                Divider(
                  height: 48.0,
                  thickness: 1.0,
                  color: Color(0xFF363636),
                ),

                // Shipping Address section
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      await context.pushNamed(
                          CheckoutEditShippingAddressWidget.routeName);
                      // Recalculate tax after address change
                      await _recalculateTax();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            'Shipping Address',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        FaIcon(
                          FontAwesomeIcons.solidPenToSquare,
                          color: AppColors.secondary,
                          size: 14.0,
                        ),
                        Text(
                          _hasShippingAddress ? 'Edit' : 'Add Address',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondary,
                            fontSize: 14.0,
                          ),
                        ),
                      ].divide(SizedBox(width: 4.0)),
                    ),
                  ),
                ),
                if (_hasShippingAddress)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        16.0, 16.0, 16.0, 0.0),
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
                            Text(
                              user.shippingAddress?.fullName ?? '',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              [
                                user.shippingAddress?.addressLine1 ?? '',
                                if ((user.shippingAddress?.addressLine2 ?? '')
                                    .isNotEmpty)
                                  user.shippingAddress!.addressLine2,
                              ].join(', '),
                              maxLines: 1,
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 12.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '${user.shippingAddress?.city ?? ''}, ${user.shippingAddress?.state ?? ''}, ${user.shippingAddress?.zipCode ?? ''}',
                              maxLines: 1,
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 12.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              user.shippingAddress?.country ?? '',
                              maxLines: 1,
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 12.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ].divide(SizedBox(height: 4.0)),
                        ),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        16.0, 16.0, 16.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'No shipping address added',
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  ),

                Divider(
                  height: 48.0,
                  thickness: 1.0,
                  color: Color(0xFF363636),
                ),

                // Payment Method section
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                  child: Text(
                    'Payment Method',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                if (user.paymentMethod.isEmpty)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        16.0, 16.0, 16.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'No payment methods saved',
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        16.0, 16.0, 16.0, 0.0),
                    child: Builder(
                      builder: (context) {
                        final paymentMethods = user.paymentMethod.toList();

                        return ListView.separated(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: paymentMethods.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(height: 16.0),
                          itemBuilder: (context, paymentMethodsIndex) {
                            final paymentMethodsItem =
                                paymentMethods[paymentMethodsIndex];
                            final isSelected =
                                selectedPayment.id == paymentMethodsItem.id;
                            return InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                ref
                                    .read(checkoutProvider.notifier)
                                    .setPaymentMethod(paymentMethodsItem);
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundSecondary,
                                  borderRadius: BorderRadius.circular(4.0),
                                  border: isSelected
                                      ? Border.all(
                                          color: AppColors.secondary,
                                          width: 1.0)
                                      : null,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        isSelected
                                            ? Icons.radio_button_checked
                                            : Icons.radio_button_off,
                                        color: isSelected
                                            ? AppColors.secondary
                                            : AppColors.textSecondary,
                                        size: 20.0,
                                      ),
                                      FaIcon(
                                        _cardBrandIcon(
                                            paymentMethodsItem.card?.brand),
                                        color: AppColors.textPrimary,
                                        size: 32.0,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '**** **** **** ${paymentMethodsItem.card?.last4 ?? ''}',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            'Expires ${paymentMethodsItem.card?.expMonth.toString() ?? ''}/${paymentMethodsItem.card?.expYear.toString() ?? ''}',
                                            maxLines: 1,
                                            style: GoogleFonts.inter(
                                              color: AppColors.textSecondary,
                                              fontSize: 12.0,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ].divide(SizedBox(height: 4.0)),
                                      ),
                                    ].divide(SizedBox(width: 12.0)),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      await context.pushNamed(
                          SettingsPaymentMethodAddWidget.routeName);
                      // Auto-select newly added method
                      if (mounted) {
                        _autoSelectDefaultPaymentMethod();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                          color: AppColors.neutral700,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              Icons.add_circle_outline,
                              color: AppColors.textPrimary,
                              size: 20.0,
                            ),
                            Text(
                              'Add New Payment Method',
                              style: GoogleFonts.inter(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ].divide(SizedBox(width: 8.0)),
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 48.0,
                  thickness: 1.0,
                  color: Color(0xFF363636),
                ),

                // Order Summary section
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                  child: Text(
                    'Order Summary',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          16.0, 16.0, 16.0, 24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _summaryRow('Subtotal', _currencyFormat.format(_subtotal)),
                          _summaryRow('Shipping',
                              widget.feedProductItem!.freeShipping
                                  ? 'Free'
                                  : _currencyFormat.format(_shippingCost)),
                          _summaryRow(
                              'Tax',
                              _hasShippingAddress
                                  ? _currencyFormat.format(tax)
                                  : '-'),
                          _summaryRow(
                              'Platform Fee', _currencyFormat.format(_platformFee)),
                          Divider(
                            height: 1.0,
                            thickness: 1.0,
                            color: Color(0xFF545454),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                  'Total',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                    color: AppColors.textPrimary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              Text(
                                _currencyFormat.format(_total),
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0,
                                  color: AppColors.textPrimary,
                                  height: 1.5,
                                ),
                              ),
                            ].divide(SizedBox(width: 8.0)),
                          ),
                        ].divide(SizedBox(height: 12.0)),
                      ),
                    ),
                  ),
                ),
                Divider(
                  height: 48.0,
                  thickness: 1.0,
                  color: Color(0xFF363636),
                ),

                // Buyer Protection
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.shieldHalved,
                            color: AppColors.primary,
                            size: 18.0,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Buyer Protection',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 8.0, 0.0, 0.0),
                                  child: Text(
                                    'Your purchase is protected by our guarantee. Get a full refund if the item doesn\'t match the description.',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.0,
                                      color: AppColors.textPrimary,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                    ),
                  ),
                ),

                // Complete Purchase button
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 36.0, 16.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    height: 56.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF7D56FF), Color(0xFF6187F1)],
                        stops: [0.0, 1.0],
                        begin: AlignmentDirectional(0.0, -1.0),
                        end: AlignmentDirectional(0, 1.0),
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: TextButton(
                      onPressed: isProcessing ? null : _onCompletePurchase,
                      style: TextButton.styleFrom(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: isProcessing
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Complete Purchase - ${_currencyFormat.format(_total)}',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),

                // Terms
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                  child: Text(
                    'By continuing, you agree to our Terms of Service and Privacy Policy',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      fontSize: 14.0,
                      height: 1.5,
                    ),
                  ),
                ),
              ]
                  .addToStart(SizedBox(height: 20.0))
                  .addToEnd(SizedBox(height: 32.0)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.normal,
              fontSize: 14.0,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
            color: AppColors.textPrimary,
            height: 1.5,
          ),
        ),
      ].divide(SizedBox(width: 8.0)),
    );
  }

  IconData _cardBrandIcon(String? brand) {
    switch (brand?.toLowerCase()) {
      case 'visa':
        return FontAwesomeIcons.ccVisa;
      case 'mastercard':
        return FontAwesomeIcons.ccMastercard;
      case 'amex':
        return FontAwesomeIcons.ccAmex;
      case 'discover':
        return FontAwesomeIcons.ccDiscover;
      default:
        return FontAwesomeIcons.creditCard;
    }
  }
}

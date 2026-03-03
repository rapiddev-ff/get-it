import '/features/home/domain/models/feed_product_model.dart';
import '/features/checkout/domain/models/checkout_totals_model.dart';
import '/features/checkout/domain/models/checkout_order_result_model.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/features/checkout/presentation/pages/checkout_edit_shipping_address/checkout_edit_shipping_address_widget.dart';
import '/features/checkout/presentation/widgets/checkout_item/checkout_item_widget.dart';
import '/features/profile/presentation/pages/settings_payment_method_add/settings_payment_method_add_widget.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/checkout/presentation/providers/checkout_provider.dart';
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

  // Inlined model state
  CheckoutTotals? checkoutTotals;
  int quantity = 1;
  String? selectedAddress;
  bool isProcessing = false;
  bool isLoading = true;
  double? tax;
  String? cancelResult;
  double? getTaxFromStripeAdd;
  double? getTaxFromStripeMinus;
  CheckoutOrderResult? orderResult;

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      isLoading = true;
      quantity = widget.initialQuantity;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
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
                CheckoutItemWidget(
                  quantity: quantity,
                  feedProduct: widget.feedProductItem!,
                  addQuantityAction: () async {
                    quantity = quantity + 1;
                    setState(() {});
                    getTaxFromStripeAdd = await actions.calculateOrderTax(
                      widget.feedProductItem!.price * quantity,
                      (widget.feedProductItem!.customFlatRate ?? 0.0) +
                          (widget.feedProductItem!.customAdditionalItemFee ??
                              0.0),
                      ref.read(authProvider).shippingAddress?.addressLine1 ??
                          '',
                      ref.read(authProvider).shippingAddress?.city ?? '',
                      ref.read(authProvider).shippingAddress?.state ?? '',
                      ref.read(authProvider).shippingAddress?.zipCode ?? '',
                    );
                    tax = getTaxFromStripeAdd;
                    setState(() {});

                    setState(() {});
                  },
                  minusQuantityAction: () async {
                    quantity = quantity + -1;
                    setState(() {});
                    getTaxFromStripeMinus = await actions.calculateOrderTax(
                      widget.feedProductItem!.price * quantity,
                      (widget.feedProductItem!.customFlatRate ?? 0.0) +
                          (widget.feedProductItem!.customAdditionalItemFee ??
                              0.0),
                      ref.read(authProvider).shippingAddress?.addressLine1 ??
                          '',
                      ref.read(authProvider).shippingAddress?.city ?? '',
                      ref.read(authProvider).shippingAddress?.state ?? '',
                      ref.read(authProvider).shippingAddress?.zipCode ?? '',
                    );
                    tax = getTaxFromStripeMinus;
                    setState(() {});

                    setState(() {});
                  },
                ),
                Divider(
                  height: 48.0,
                  thickness: 1.0,
                  color: Color(0xFF363636),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      context.pushNamed(
                          CheckoutEditShippingAddressWidget.routeName);
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
                          (ref
                                          .read(authProvider)
                                          .shippingAddress
                                          ?.addressLine1 ??
                                      '') !=
                                  ''
                              ? 'Edit'
                              : 'Add Address',
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
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
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
                            ref.read(authProvider).shippingAddress?.fullName ??
                                '',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${ref.read(authProvider).shippingAddress?.addressLine1 ?? ''}, ${ref.read(authProvider).shippingAddress?.addressLine2 ?? ''}',
                            maxLines: 1,
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondary,
                              fontSize: 12.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${ref.read(authProvider).shippingAddress?.city ?? ''}, ${ref.read(authProvider).shippingAddress?.state ?? ''}, ${ref.read(authProvider).shippingAddress?.zipCode ?? ''}',
                            maxLines: 1,
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondary,
                              fontSize: 12.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            ref.read(authProvider).shippingAddress?.country ??
                                '',
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
                ),
                Divider(
                  height: 48.0,
                  thickness: 1.0,
                  color: Color(0xFF363636),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                  child: Text(
                    'Payment Method',
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
                  child: Builder(
                    builder: (context) {
                      final paymentMethods =
                          ref.read(authProvider).paymentMethod.toList();

                      return ListView.separated(
                        padding: EdgeInsets.zero,
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: paymentMethods.length,
                        separatorBuilder: (_, __) => SizedBox(height: 16.0),
                        itemBuilder: (context, paymentMethodsIndex) {
                          final paymentMethodsItem =
                              paymentMethods[paymentMethodsIndex];
                          return InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              ref
                                  .read(checkoutProvider.notifier)
                                  .setPaymentMethod(paymentMethodsItem);
                              setState(() {});
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.backgroundSecondary,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Opacity(
                                      opacity: ref.read(checkoutProvider).id ==
                                              paymentMethodsItem.id
                                          ? 1.0
                                          : 0.0,
                                      child: Icon(
                                        Icons.circle_rounded,
                                        color: AppColors.secondary,
                                        size: 10.0,
                                      ),
                                    ),
                                    FaIcon(
                                      FontAwesomeIcons.ccVisa,
                                      color: AppColors.textPrimary,
                                      size: 32.0,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '**** **** ****${paymentMethodsItem.card?.last4 ?? ''}',
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
                      context
                          .pushNamed(SettingsPaymentMethodAddWidget.routeName);
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
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
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                  'Subtotal',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.0,
                                    color: AppColors.textPrimary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              Text(
                                NumberFormat('#,##0.##', 'en_US').format(
                                  widget.feedProductItem!.price * quantity,
                                ),
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  color: AppColors.textPrimary,
                                  height: 1.5,
                                ),
                              ),
                            ].divide(SizedBox(width: 8.0)),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                  'Shipping',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.0,
                                    color: AppColors.textPrimary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              Text(
                                NumberFormat('#,##0.##', 'en_US').format(
                                  (widget.feedProductItem!.customFlatRate ??
                                          0.0) +
                                      (widget.feedProductItem!
                                              .customAdditionalItemFee ??
                                          0.0),
                                ),
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  color: AppColors.textPrimary,
                                  height: 1.5,
                                ),
                              ),
                            ].divide(SizedBox(width: 8.0)),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                  'Tax',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.0,
                                    color: AppColors.textPrimary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              Text(
                                '-',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  color: AppColors.textPrimary,
                                  height: 1.5,
                                ),
                              ),
                            ].divide(SizedBox(width: 8.0)),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                  'Platform Fee',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.0,
                                    color: AppColors.textPrimary,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              Text(
                                NumberFormat('#,##0.##', 'en_US').format(
                                  (widget.feedProductItem!.price * quantity) *
                                      0.1,
                                ),
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  color: AppColors.textPrimary,
                                  height: 1.5,
                                ),
                              ),
                            ].divide(SizedBox(width: 8.0)),
                          ),
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
                                '\$1,432.11 ',
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
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
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
                      onPressed: () async {
                        orderResult = await actions.createCheckoutOrder(
                          widget.feedProductItem!.id,
                          quantity,
                          'f08c02f4-18c9-4f9e-9ae2-c207682fe5c5',
                          '2ebe07f5-d5b8-45bf-a0f0-daf11fad1aca',
                          '',
                          widget.shortlistId,
                        );
                        await actions.payWithSavedCard(
                          orderResult!.orderId,
                          ref.read(authProvider).defaultPaymentMethodId,
                          7,
                        );
                        Navigator.pop(context);

                        setState(() {});
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Complete Purchase - \$1,432.11',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
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
}

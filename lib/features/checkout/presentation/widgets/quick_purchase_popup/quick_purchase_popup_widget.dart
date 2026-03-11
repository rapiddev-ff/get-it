import '/core/widgets/app_loading_indicator.dart';
import '/features/home/domain/models/feed_product_model.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/auth/domain/models/user_settings_model.dart';
import '/features/checkout/domain/models/checkout_order_result_model.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/value_utils.dart';
import '/backend/supabase/supabase.dart';
import '/features/checkout/presentation/widgets/fast_checkout/fast_checkout_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Quick Purchase confirmation popup shown after swipe-right when Daily Budget is active.
/// Displays product info, quantity controls, order summary, and Confirm/Cancel buttons.
class QuickPurchasePopupWidget extends ConsumerStatefulWidget {
  const QuickPurchasePopupWidget({
    super.key,
    required this.feedProduct,
  });

  final FeedProduct feedProduct;

  @override
  ConsumerState<QuickPurchasePopupWidget> createState() =>
      _QuickPurchasePopupWidgetState();
}

class _QuickPurchasePopupWidgetState
    extends ConsumerState<QuickPurchasePopupWidget> {
  final _currencyFormat = NumberFormat('\$#,##0.00', 'en_US');

  int _quantity = 1;
  double _tax = 0.0;
  bool _isProcessing = false;
  bool _isLoadingTax = false;

  @override
  void initState() {
    super.initState();
    _calculateTax();
  }

  double get _subtotal => widget.feedProduct.price * _quantity;

  double get _shippingCost {
    final flat = widget.feedProduct.customFlatRate ?? 0.0;
    final additional = widget.feedProduct.customAdditionalItemFee ?? 0.0;
    if (_quantity <= 1) return flat;
    return flat + additional * (_quantity - 1);
  }

  double get _platformFee => _subtotal * 0.1;

  double get _total => _subtotal + _shippingCost + _tax + _platformFee;

  Future<void> _calculateTax() async {
    final address = ref.read(authProvider).shippingAddress;
    if (address == null || address.addressLine1.isEmpty) {
      _tax = 0.0;
      return;
    }

    setState(() => _isLoadingTax = true);
    _tax = await actions.calculateOrderTax(
      _subtotal,
      _shippingCost,
      address.addressLine1,
      address.city,
      address.state,
      address.zipCode,
    );
    if (mounted) setState(() => _isLoadingTax = false);
  }

  Future<void> _onConfirm() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    try {
      final user = ref.read(authProvider);
      final shippingAddressId = user.shippingAddress?.id ?? '';
      final defaultCard =
          user.paymentMethod.where((e) => e.isDefault).firstOrNull;

      if (defaultCard == null) {
        if (mounted) {
          actions.toastificationshow(
              context, 'Error', 'No default payment method found', 'error');
        }
        return;
      }

      // Validate daily budget
      final settings = user.userSettings;
      final dailyBudget = settings?.dailyBudget ?? 0.0;
      if (dailyBudget > 0) {
        final dailyBudgetUsed = settings?.dailyBudgetUsed ?? 0.0;
        final remaining = dailyBudget - dailyBudgetUsed;
        if (_total > remaining) {
          if (mounted) {
            actions.toastificationshow(context, 'Budget Exceeded',
                'This purchase exceeds your remaining daily budget', 'error');
          }
          return;
        }
      }

      // Create order
      final orderResult = await actions.createCheckoutOrder(
        widget.feedProduct.id,
        _quantity,
        shippingAddressId,
        defaultCard.id,
        '',
        null,
      );

      if (orderResult == null || !orderResult.success) {
        if (mounted) {
          actions.toastificationshow(
              context, 'Error', 'Failed to create order', 'error');
        }
        return;
      }

      // Process payment
      final payResult = await actions.payWithSavedCard(
        orderResult.orderId,
        defaultCard.id,
        7,
      );

      if (payResult['success'] == true) {
        // Update daily budget used
        await _updateDailyBudgetUsed(_total);

        if (mounted) {
          // Close this popup
          Navigator.pop(context);

          // Show success confirmation (FastCheckout)
          _showSuccessConfirmation(orderResult);
        }
      } else {
        final errorMsg = (payResult['error'] ?? 'Payment failed').toString();
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
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _updateDailyBudgetUsed(double amount) async {
    final currentUsed =
        ref.read(authProvider).userSettings?.dailyBudgetUsed ?? 0.0;
    final newUsed = currentUsed + amount;

    ref.read(authProvider.notifier).updateUser(
          (e) => e.copyWith(
            userSettings: (e.userSettings ?? const UserSettings()).copyWith(
              dailyBudgetUsed: newUsed,
            ),
          ),
        );

    await UserSettingsTable().update(
      data: {'daily_budget_used': newUsed},
      matchingRows: (rows) =>
          rows.eqOrNull('user_id', ref.read(currentUserIdProvider)),
    );
  }

  void _showSuccessConfirmation(CheckoutOrderResult orderResult) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (_) {
        // Import is handled via the checkout module
        return _SuccessConfirmation(
          feedProduct: widget.feedProduct,
          orderId: orderResult.orderId,
          orderNumber: orderResult.orderNumber,
          subtotal: _subtotal,
          quantity: _quantity,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Confirm Purchase',
              style: Theme.of(context).textTheme.titleMedium!,
            ),
          ),
          Divider(height: 1.0, thickness: 1.0, color: AppColors.surfaceDark),

          // Product info
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: CachedNetworkImage(
                    imageUrl: valueOrDefault<String>(
                      widget.feedProduct.mainImageUrl,
                      'https://picsum.photos/seed/357/600',
                    ),
                    width: 60.0,
                    height: 80.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.feedProduct.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w500, height: 1.5),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        _currencyFormat.format(widget.feedProduct.price),
                        style: Theme.of(context).textTheme.titleSmall!,
                      ),
                      SizedBox(height: 8.0),
                      // Quantity controls
                      Row(
                        children: [
                          Text(
                            'Qty:',
                            style: Theme.of(context).textTheme.labelMedium!,
                          ),
                          SizedBox(width: 12.0),
                          InkWell(
                            onTap: () {
                              if (_quantity > 1) {
                                setState(() => _quantity--);
                                _calculateTax();
                              }
                            },
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.neutral700),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Icon(Icons.remove,
                                  size: 16.0, color: AppColors.textPrimary),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              '$_quantity',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() => _quantity++);
                              _calculateTax();
                            },
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.neutral700),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Icon(Icons.add,
                                  size: 16.0, color: AppColors.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1.0, thickness: 1.0, color: AppColors.surfaceDark),

          // Order Summary
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _summaryRow('Subtotal', _currencyFormat.format(_subtotal)),
                SizedBox(height: 8.0),
                _summaryRow(
                  'Shipping',
                  widget.feedProduct.freeShipping
                      ? 'Free'
                      : _currencyFormat.format(_shippingCost),
                ),
                SizedBox(height: 8.0),
                _summaryRow(
                  'Tax',
                  _isLoadingTax ? '...' : _currencyFormat.format(_tax),
                ),
                SizedBox(height: 8.0),
                _summaryRow(
                    'Platform Fee', _currencyFormat.format(_platformFee)),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(
                      height: 1.0, thickness: 1.0, color: AppColors.neutral800),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Total',
                        style: Theme.of(context).textTheme.titleSmall!,
                      ),
                    ),
                    Text(
                      _currencyFormat.format(_total),
                      style: Theme.of(context).textTheme.titleSmall!,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Buttons
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Column(
              children: [
                // Confirm button
                Container(
                  width: double.infinity,
                  height: 48.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.brandPurple, AppColors.brandBlue],
                      stops: [0.0, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: TextButton(
                    onPressed: _isProcessing ? null : _onConfirm,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    child: _isProcessing
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: AppLoadingIndicator(
                                strokeWidth: 2.0, color: Colors.white),
                          )
                        : Text(
                            'Confirm - ${_currencyFormat.format(_total)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                          ),
                  ),
                ),
                SizedBox(height: 8.0),
                // Cancel button
                SizedBox(
                  width: double.infinity,
                  height: 48.0,
                  child: OutlinedButton(
                    onPressed:
                        _isProcessing ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.neutral800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.0,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 13.0,
            color: AppColors.textPrimary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

/// Success confirmation shown after quick purchase completes.
/// Reuses the same layout as FastCheckoutWidget but inline.
class _SuccessConfirmation extends ConsumerWidget {
  const _SuccessConfirmation({
    required this.feedProduct,
    required this.orderId,
    this.orderNumber,
    required this.subtotal,
    required this.quantity,
  });

  final FeedProduct feedProduct;
  final String orderId;
  final String? orderNumber;
  final double subtotal;
  final int quantity;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FastCheckoutWidget(
      feedProduct: feedProduct,
      orderId: orderId,
      orderNumber: orderNumber,
      subtotal: subtotal,
      quantity: quantity,
    );
  }
}

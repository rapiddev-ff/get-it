import '/core/widgets/app_loading_indicator.dart';
import '/features/home/domain/models/feed_product_model.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FastCheckoutWidget extends ConsumerStatefulWidget {
  const FastCheckoutWidget({
    super.key,
    required this.feedProduct,
    required this.orderId,
    this.orderNumber,
    this.subtotal,
    this.quantity = 1,
  });

  final FeedProduct? feedProduct;
  final String? orderId;
  final String? orderNumber;
  final double? subtotal;
  final int quantity;

  @override
  ConsumerState<FastCheckoutWidget> createState() => _FastCheckoutWidgetState();
}

class _FastCheckoutWidgetState extends ConsumerState<FastCheckoutWidget> {
  bool _isCancelling = false;
  final _currencyFormat = NumberFormat('\$#,##0.00', 'en_US');

  @override
  void initState() {
    super.initState();

    // Auto-close after 10 seconds
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 10000));
      if (mounted) Navigator.pop(context);
    });
  }

  Future<void> _onCancelOrder() async {
    if (_isCancelling || widget.orderId == null) return;
    setState(() => _isCancelling = true);

    try {
      final error = await actions.cancelOrder(widget.orderId!);
      if (!mounted) return;

      if (error == null) {
        actions.toastificationshow(context, 'Order Cancelled',
            'Your order has been cancelled and refunded', 'success');
      } else {
        actions.toastificationshow(context, 'Cancel Failed', error, 'error');
      }
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        actions.toastificationshow(
            context, 'Error', 'Failed to cancel order', 'error');
        setState(() => _isCancelling = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userSettings = ref.watch(authProvider).userSettings;
    final dailyBudget = userSettings?.dailyBudget ?? 0.0;
    final dailyBudgetUsed = userSettings?.dailyBudgetUsed ?? 0.0;
    final remainingBudget = dailyBudget - dailyBudgetUsed;

    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 95.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Budget
            if (dailyBudget > 0)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Text(
                  'Remaining Daily Budget ${_currencyFormat.format(remainingBudget)} / ${_currencyFormat.format(dailyBudget)}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold, height: 1.5),
                ),
              ),
            if (dailyBudget > 0)
              Divider(
                height: 1.0,
                thickness: 1.0,
                color: AppColors.surfaceDark,
              ),

            // Product info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: CachedNetworkImage(
                      imageUrl: valueOrDefault<String>(
                        widget.feedProduct?.mainImageUrl,
                        'https://picsum.photos/seed/357/600',
                      ),
                      width: 60.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status badge
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(100.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.shopping_cart_outlined,
                                  color: Colors.black,
                                  size: 12.0,
                                ),
                                Text(
                                  'Purchased',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                          color: Colors.black, height: 1.5),
                                ),
                              ].divide(SizedBox(width: 4.0)),
                            ),
                          ),
                        ),
                        // Order number
                        if (widget.orderNumber != null &&
                            widget.orderNumber!.isNotEmpty)
                          Text(
                            'Order #${widget.orderNumber}',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.5),
                          ),
                        // Product name
                        Text(
                          valueOrDefault<String>(
                            widget.feedProduct?.title,
                            'N/A',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(height: 1.5),
                        ),
                        // Subtotal
                        Text(
                          _currencyFormat.format(widget.subtotal ??
                              (widget.feedProduct?.price ?? 0) *
                                  widget.quantity),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.w600, height: 1.5),
                        ),
                      ].divide(SizedBox(height: 4.0)),
                    ),
                  ),
                  // Cancel Order button
                  InkWell(
                    onTap: _isCancelling ? null : _onCancelOrder,
                    child: _isCancelling
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: AppLoadingIndicator(strokeWidth: 2.0),
                          )
                        : Text(
                            'Cancel',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                    height: 1.5,
                                    decoration: TextDecoration.underline),
                          ),
                  ),
                ].divide(SizedBox(width: 12.0)),
              ),
            ),

            // Close button
            Container(
              width: double.infinity,
              height: 56.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.brandPurple, AppColors.brandBlue],
                  stops: [0.0, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  topLeft: Radius.circular(0.0),
                  topRight: Radius.circular(0.0),
                ),
              ),
              child: TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(0.0),
                    ),
                  ),
                ),
                child: Text(
                  'Close',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

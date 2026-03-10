import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '/core/theme/app_colors.dart';
import '/core/widgets/app_gradient_button.dart';
import '/features/home/presentation/pages/home_product/home_product_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/inventory/home_dashoard_inventory_widget.dart';

class DialogProductCreatedWidget extends StatelessWidget {
  const DialogProductCreatedWidget({
    super.key,
    required this.action,
    required this.productId,
  });

  final Future Function()? action;
  final String? productId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0x348E6CFF),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(14.0),
                  child: FaIcon(
                    FontAwesomeIcons.circleCheck,
                    color: AppColors.primary,
                    size: 24.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Text(
                  'Product published',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.w500, height: 1.5),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Your product is live.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(height: 1.5),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: AppGradientButton(
                  text: 'Add another product',
                  onPressed: () async {
                    await action?.call();
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: TextButton(
                  onPressed: () async {
                    if (Navigator.of(context).canPop()) {
                      context.pop();
                    }
                    context.pushNamed(
                      HomeProductWidget.routeName,
                      queryParameters: {
                        'productId': productId ?? '',
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 56.0),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                        color: AppColors.neutral900,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Text(
                    'View Product',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    if (Navigator.of(context).canPop()) {
                      context.pop();
                    }
                    context.pushNamed(HomeDashoardInventoryWidget.routeName);
                  },
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, 56.0),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Go to Inventory',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

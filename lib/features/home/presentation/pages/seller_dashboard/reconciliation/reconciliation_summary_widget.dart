import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/core/theme/app_colors.dart';
import '/features/home/presentation/pages/seller_dashboard/shortlist/home_dashoard_shortlist_widget.dart';

class ReconciliationSummaryWidget extends StatelessWidget {
  const ReconciliationSummaryWidget({
    super.key,
    this.shortlistName = '',
    this.soldCount = 0,
    this.damagedCount = 0,
    this.returnedCount = 0,
  });

  static const String routeName = 'reconciliationSummary';
  static const String routePath = 'reconciliationSummary';

  final String shortlistName;
  final int soldCount;
  final int damagedCount;
  final int returnedCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: 0.0,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: 24.0),
                  onPressed: null,
                ),
              ),
              Text(
                'Shortlist Closed',
                style: Theme.of(context).textTheme.titleMedium!,
              ),
              Opacity(
                opacity: 0.0,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, size: 24.0),
                  onPressed: null,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Success icon
                      Container(
                        width: 72.0,
                        height: 72.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.brandPurple,
                              AppColors.brandBlue,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Icon(Icons.check,
                            color: Colors.white, size: 36.0),
                      ),
                      SizedBox(height: 24.0),
                      Text(
                        'Reconciliation Complete',
                        style: Theme.of(context).textTheme.titleLarge!,
                      ),
                      if (shortlistName.isNotEmpty) ...[
                        SizedBox(height: 8.0),
                        Text(
                          shortlistName,
                          style: Theme.of(context).textTheme.labelMedium!,
                          textAlign: TextAlign.center,
                        ),
                      ],
                      SizedBox(height: 32.0),
                      // Summary card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          children: [
                            _summaryRow(
                              context,
                              icon: Icons.check_circle_outline,
                              iconColor: AppColors.secondary,
                              label: 'Sold',
                              count: soldCount,
                            ),
                            SizedBox(height: 16.0),
                            _summaryRow(
                              context,
                              icon: Icons.warning_amber_rounded,
                              iconColor: AppColors.errorBright,
                              label: 'Damaged',
                              count: damagedCount,
                            ),
                            SizedBox(height: 16.0),
                            _summaryRow(
                              context,
                              icon: Icons.storefront,
                              iconColor: AppColors.brandPurple,
                              label: 'Returned to marketplace',
                              count: returnedCount,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Done button
              Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 48.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.brandPurple,
                          AppColors.brandBlue,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // Pop back to Event Shortlists page
                        context.goNamed(
                            HomeDashoardShortlistWidget.routeName);
                      },
                      child: Text(
                        'Done',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required int count,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 24.0),
        SizedBox(width: 12.0),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium!,
          ),
        ),
        Text(
          '$count',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

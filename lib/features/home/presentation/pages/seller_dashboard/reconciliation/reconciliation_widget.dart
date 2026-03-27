import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/supabase/supabase.dart';
import '/core/providers/current_user_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/widgets/app_loading_indicator.dart';
import '/core/widgets/product_price_row.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/home/data/repositories/shortlist_repository.dart';
import '/features/home/domain/models/shortlist_item_detail_model.dart';
import '/features/home/presentation/pages/seller_dashboard/reconciliation/reconciliation_summary_widget.dart';

class ReconciliationWidget extends ConsumerStatefulWidget {
  const ReconciliationWidget({
    super.key,
    required this.shortlistId,
    this.shortlistName = '',
  });

  static const String routeName = 'reconciliation';
  static const String routePath = 'reconciliation';

  final String shortlistId;
  final String shortlistName;

  @override
  ConsumerState<ReconciliationWidget> createState() =>
      _ReconciliationWidgetState();
}

/// Per-item reconciliation allocation.
class _ItemAllocation {
  _ItemAllocation({required this.totalQty});

  final int totalQty;
  int soldQty = 0;
  int damagedQty = 0;

  int get returnQty => totalQty - soldQty - damagedQty;

  /// Quick action: mark ALL remaining as sold.
  void markAllSold() {
    soldQty = totalQty;
    damagedQty = 0;
  }

  /// Quick action: mark ALL remaining as damaged.
  void markAllDamaged() {
    damagedQty = totalQty;
    soldQty = 0;
  }

  /// Reset to default (all returned).
  void reset() {
    soldQty = 0;
    damagedQty = 0;
  }

  String get label {
    if (soldQty == totalQty) return 'Sold';
    if (damagedQty == totalQty) return 'Damaged';
    if (soldQty == 0 && damagedQty == 0) return 'Active';
    return 'Split';
  }
}

class _ReconciliationWidgetState extends ConsumerState<ReconciliationWidget> {
  List<ShortlistItemDetail> _items = [];
  bool _isLoading = true;
  bool _isSaving = false;

  /// Allocations keyed by shortlist item id.
  final Map<String, _ItemAllocation> _allocations = {};

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final repo = ref.read(shortlistRepositoryProvider);
    final items = await repo.getShortlistItems(widget.shortlistId);
    if (!mounted) return;
    setState(() {
      _items = items;
      _allocations.clear();
      for (final item in items) {
        // Items already sold/damaged get zero-qty allocation (non-actionable).
        if (item.itemStatus == 'sold' || item.itemStatus == 'damaged') {
          _allocations[item.id] = _ItemAllocation(totalQty: 0);
        } else {
          _allocations[item.id] = _ItemAllocation(totalQty: item.quantity);
        }
      }
      _isLoading = false;
    });
  }

  // --- Actions ---

  Future<void> _onComplete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text('Complete Reconciliation'),
        content: Text(
          'Items not marked as Sold or Damaged will be returned to marketplace. '
          'The shortlist will be closed and QR code will stop working.\n\n'
          'Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(false),
            child: Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => ctx.pop(true),
            child: Text('Complete',
                style: TextStyle(color: AppColors.secondary)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isSaving = true);

    try {
      final sellerId = ref.read(currentUserIdProvider);
      final repo = ref.read(shortlistRepositoryProvider);

      int totalSold = 0;
      int totalDamaged = 0;
      int totalReturned = 0;
      final returnProductIds = <String>[];

      for (final item in _items) {
        final alloc = _allocations[item.id];
        if (alloc == null || alloc.totalQty == 0) {
          // Already sold/damaged before reconciliation
          if (item.itemStatus == 'sold') totalSold += item.quantity;
          if (item.itemStatus == 'damaged') totalDamaged += item.quantity;
          continue;
        }

        // Apply sold
        if (alloc.soldQty > 0) {
          if (alloc.soldQty == alloc.totalQty) {
            await repo.updateItemStatus(
              shortlistItemId: item.id,
              newStatus: 'sold',
              sellerId: sellerId,
            );
          } else {
            // Partial sold — update quantity and status directly
            await SupaFlow.client
                .from('shortlist_items')
                .update({
                  'status': 'sold',
                  'quantity': alloc.soldQty,
                })
                .eq('id', item.id);
          }
          totalSold += alloc.soldQty;
        }

        // Apply damaged
        if (alloc.damagedQty > 0) {
          if (alloc.soldQty == 0 && alloc.damagedQty == alloc.totalQty) {
            await repo.updateItemStatus(
              shortlistItemId: item.id,
              newStatus: 'damaged',
              sellerId: sellerId,
            );
          } else if (alloc.soldQty == 0) {
            // Partial damaged only
            await SupaFlow.client
                .from('shortlist_items')
                .update({
                  'status': 'damaged',
                  'quantity': alloc.damagedQty,
                })
                .eq('id', item.id);
          }
          // If both sold and damaged on same item (split) — create separate row for damaged
          if (alloc.soldQty > 0 && alloc.damagedQty > 0) {
            await SupaFlow.client.from('shortlist_items').insert({
              'shortlist_id': widget.shortlistId,
              'product_id': item.productId,
              'quantity': alloc.damagedQty,
              'status': 'damaged',
            });
          }
          totalDamaged += alloc.damagedQty;
        }

        // Return remaining to marketplace
        if (alloc.returnQty > 0) {
          returnProductIds.add(item.productId);
          totalReturned += alloc.returnQty;
        }
      }

      // Release returned items back to marketplace
      if (returnProductIds.isNotEmpty) {
        await repo.releaseItems(
          shortlistId: widget.shortlistId,
          productIds: returnProductIds,
          sellerId: sellerId,
        );
      }

      // Close the shortlist
      await repo.updateShortlistStatus(widget.shortlistId, 'closed');

      if (!mounted) return;
      setState(() => _isSaving = false);

      // Navigate to summary
      context.pushReplacementNamed(
        ReconciliationSummaryWidget.routeName,
        queryParameters: {
          'shortlistName': widget.shortlistName,
          'soldCount': totalSold.toString(),
          'damagedCount': totalDamaged.toString(),
          'returnedCount': totalReturned.toString(),
        },
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      actions.toastificationshow(
          context, 'Error', 'Failed to complete reconciliation: $e', 'error');
    }
  }

  void _onSave() {
    actions.toastificationshow(
        context, 'Saved', 'Reconciliation progress saved', 'success');
  }

  void _showSplitDialog(ShortlistItemDetail item) {
    final alloc = _allocations[item.id];
    if (alloc == null || alloc.totalQty == 0) return;

    int soldInput = alloc.soldQty;
    int damagedInput = alloc.damagedQty;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final remaining = alloc.totalQty - soldInput - damagedInput;
            return AlertDialog(
              backgroundColor: AppColors.backgroundSecondary,
              title: Text('Split Quantity'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.bodyMedium!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Total: ${alloc.totalQty}',
                    style: Theme.of(context).textTheme.labelSmall!,
                  ),
                  SizedBox(height: 16.0),
                  _splitRow(
                    label: 'Sold',
                    value: soldInput,
                    max: alloc.totalQty - damagedInput,
                    onChanged: (v) =>
                        setDialogState(() => soldInput = v),
                  ),
                  SizedBox(height: 12.0),
                  _splitRow(
                    label: 'Damaged',
                    value: damagedInput,
                    max: alloc.totalQty - soldInput,
                    onChanged: (v) =>
                        setDialogState(() => damagedInput = v),
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Return to marketplace',
                          style: Theme.of(context).textTheme.bodyMedium!),
                      Text(
                        '$remaining',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => ctx.pop(),
                  child: Text('Cancel',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      alloc.soldQty = soldInput;
                      alloc.damagedQty = damagedInput;
                    });
                    ctx.pop();
                  },
                  child: Text('Apply',
                      style: TextStyle(color: AppColors.secondary)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _splitRow({
    required String label,
    required int value,
    required int max,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium!),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: value > 0 ? () => onChanged(value - 1) : null,
              child: Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Icon(Icons.remove,
                    size: 18.0, color: AppColors.textPrimary),
              ),
            ),
            SizedBox(
              width: 40.0,
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            GestureDetector(
              onTap: value < max ? () => onChanged(value + 1) : null,
              child: Container(
                width: 32.0,
                height: 32.0,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child:
                    Icon(Icons.add, size: 18.0, color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- UI ---

  Color _statusColor(String status) {
    switch (status) {
      case 'sold':
        return AppColors.secondary;
      case 'damaged':
        return AppColors.errorBright;
      default:
        return AppColors.brandPurple;
    }
  }

  Widget _buildProductCard(ShortlistItemDetail item) {
    final alloc = _allocations[item.id];
    final bool isActionable = alloc != null && alloc.totalQty > 0;
    final String displayStatus =
        isActionable ? alloc.label : item.itemStatus;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              bottomLeft: Radius.circular(12.0),
            ),
            child: SizedBox(
              width: 100.0,
              height: 100.0,
              child: item.mainImageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: item.mainImageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.surfaceDarkAlt,
                        child: Icon(Icons.image,
                            color: AppColors.textSecondary, size: 32),
                      ),
                    )
                  : Container(
                      color: AppColors.surfaceDarkAlt,
                      child: Icon(Icons.image,
                          color: AppColors.textSecondary, size: 32),
                    ),
            ),
          ),
          // Info
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4.0),
                  ProductPriceRow(
                    price: item.price,
                    originalPrice: item.originalPrice,
                    flashSaleEnabled: item.flashSaleEnabled,
                    flashSalePrice: item.flashSalePrice,
                    flashSaleEndsAt: item.flashSaleEndsAt,
                    discountType: item.discountType,
                    discountAmount: item.discountAmount,
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: isActionable
                            ? () => _showSplitDialog(item)
                            : null,
                        child: Text(
                          'Qty: ${item.quantity}',
                          style: GoogleFonts.inter(
                            fontSize: 11.0,
                            color: AppColors.textSecondary,
                            decoration: isActionable
                                ? TextDecoration.underline
                                : null,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: _statusColor(displayStatus.toLowerCase()),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          displayStatus,
                          style: GoogleFonts.inter(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ShortlistItemDetail item) {
    final alloc = _allocations[item.id];
    if (alloc == null || alloc.totalQty == 0) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: _actionButton(
              label: 'Sold (${alloc.totalQty})',
              isSelected: alloc.soldQty == alloc.totalQty,
              onTap: () {
                setState(() {
                  if (alloc.soldQty == alloc.totalQty) {
                    alloc.reset();
                  } else {
                    alloc.markAllSold();
                  }
                });
              },
            ),
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: _actionButton(
              label: 'Damaged (${alloc.totalQty})',
              isSelected: alloc.damagedQty == alloc.totalQty,
              isDanger: true,
              onTap: () {
                setState(() {
                  if (alloc.damagedQty == alloc.totalQty) {
                    alloc.reset();
                  } else {
                    alloc.markAllDamaged();
                  }
                });
              },
            ),
          ),
          SizedBox(width: 8.0),
          GestureDetector(
            onTap: () => _showSplitDialog(item),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Icon(Icons.call_split,
                  size: 18.0, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required VoidCallback onTap,
    bool isSelected = false,
    bool isDanger = false,
  }) {
    final selectedColor = isDanger ? AppColors.errorBright : AppColors.secondary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(4.0),
          border: isSelected
              ? null
              : Border.all(
                  color: AppColors.textSecondary.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

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
              IconButton(
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                icon: Icon(Icons.arrow_back,
                    color: AppColors.info, size: 24.0),
                onPressed: () => context.pop(),
              ),
              Text(
                'Reconciliation',
                style: Theme.of(context).textTheme.titleMedium!,
              ),
              Opacity(
                opacity: 0.0,
                child: IconButton(
                  icon: Icon(Icons.more_vert, size: 20.0),
                  onPressed: null,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: AppLoadingIndicator())
            : Column(
                children: [
                  // Subtitle
                  if (widget.shortlistName.isNotEmpty)
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.shortlistName,
                          style: Theme.of(context).textTheme.labelMedium!,
                        ),
                      ),
                    ),
                  // Items list
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.0),
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildProductCard(item),
                            _buildActionButtons(item),
                          ],
                        );
                      },
                    ),
                  ),
                  // Bottom actions
                  Container(
                    padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundPrimary,
                      border: Border(
                        top: BorderSide(
                          color:
                              AppColors.textSecondary.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Complete reconciliation
                        SizedBox(
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
                              onPressed: _isSaving ? null : _onComplete,
                              child: _isSaving
                                  ? SizedBox(
                                      width: 20.0,
                                      height: 20.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Complete Reconciliation',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: Colors.white),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        // Save + Cancel
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 44.0,
                                child: TextButton(
                                  onPressed: () => context.pop(),
                                  child: Text(
                                    'Cancel',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: AppColors.textSecondary),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: SizedBox(
                                height: 44.0,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: AppColors.surfaceDark,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  onPressed: _onSave,
                                  child: Text(
                                    'Save',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w500),
                                  ),
                                ),
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
    );
  }
}

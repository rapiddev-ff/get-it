import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/home/domain/models/seller_shortlist_model.dart';

class ShortlistItemWidget extends ConsumerStatefulWidget {
  const ShortlistItemWidget._({
    super.key,
    required this.name,
    required this.totalItems,
    required this.status,
    this.createdAt,
    this.endDate,
    this.shortlistId,
    this.shareCode,
    this.totalSales,
    this.itemsSold,
    this.tags = const [],
    this.onChanged,
    this.isOwner = true,
  });

  factory ShortlistItemWidget({
    Key? key,
    required ShortlistsRow shortlist,
    VoidCallback? onChanged,
  }) {
    return ShortlistItemWidget._(
      key: key,
      name: shortlist.name,
      totalItems: shortlist.totalItems ?? 0,
      status: shortlist.status ?? 'active',
      createdAt: shortlist.createdAt,
      endDate: shortlist.endDate,
      shortlistId: shortlist.id,
      shareCode: shortlist.shareCode,
      totalSales: shortlist.totalSales,
      itemsSold: shortlist.itemsSold,
      onChanged: onChanged,
    );
  }

  factory ShortlistItemWidget.fromSeller({
    Key? key,
    required SellerShortlist shortlist,
    bool isOwner = false,
  }) {
    return ShortlistItemWidget._(
      key: key,
      name: shortlist.name,
      totalItems: shortlist.totalItems,
      status: shortlist.status,
      createdAt: shortlist.createdAt,
      endDate: shortlist.endDate,
      shortlistId: shortlist.id.isNotEmpty ? shortlist.id : null,
      shareCode: shortlist.shareCode.isNotEmpty ? shortlist.shareCode : null,
      tags: shortlist.tags,
      isOwner: isOwner,
    );
  }

  final String name;
  final int totalItems;
  final String status;
  final DateTime? createdAt;
  final DateTime? endDate;
  final String? shortlistId;
  final String? shareCode;
  final double? totalSales;
  final int? itemsSold;
  final List<String> tags;
  final VoidCallback? onChanged;
  final bool isOwner;

  @override
  ConsumerState<ShortlistItemWidget> createState() =>
      _ShortlistItemWidgetState();
}

class _ShortlistItemWidgetState extends ConsumerState<ShortlistItemWidget> {
  List<String> _productTags = [];
  bool _tagsLoaded = false;

  @override
  void initState() {
    super.initState();
    if (widget.tags.isNotEmpty) {
      _productTags = widget.tags;
      _tagsLoaded = true;
    } else if (widget.shortlistId != null) {
      _loadProductTags();
    }
  }

  Future<void> _loadProductTags() async {
    final items = await ShortlistItemsTable().queryRows(
      queryFn: (q) => q.eqOrNull('shortlist_id', widget.shortlistId),
    );
    if (!mounted || items.isEmpty) return;
    final productIds = items.map((e) => e.productId).toList();
    final products = await ProductsTable().queryRows(
      queryFn: (q) => q.inFilterOrNull('id', productIds),
    );
    if (!mounted) return;
    setState(() {
      _productTags =
          products.map((p) => p.title).where((t) => t.isNotEmpty).toList();
      _tagsLoaded = true;
    });
  }

  bool get _isExpired {
    if (widget.status == 'expired') return true;
    if (widget.endDate != null && widget.endDate!.isBefore(DateTime.now())) {
      return true;
    }
    return false;
  }

  bool get _isDraft => widget.status == 'draft';

  // --- Actions ---

  void _onView() {
    if (widget.shortlistId == null) return;
    context.pushNamed(
      'homeDashoardShortlistCreateStep2',
      queryParameters: {
        'shortlistId': widget.shortlistId!,
        'name': widget.name,
        'status': widget.status,
      },
    );
  }

  void _onShare() {
    if (widget.shareCode == null || widget.shareCode!.isEmpty) {
      actions.toastificationshow(
          context, 'Error', 'No share code available', 'error');
      return;
    }
    final shareUrl = 'https://getitapp.com/s/${widget.shareCode}';
    Clipboard.setData(ClipboardData(text: shareUrl));
    actions.toastificationshow(
        context, 'Copied', 'Share link copied to clipboard', 'success');
  }

  void _onDownload() {
    actions.toastificationshow(
        context, 'Info', 'QR code download coming soon', 'info');
  }

  void _onEdit() {
    if (widget.shortlistId == null) return;
    context.pushNamed(
      'homeDashoardShortlistCreateStep2',
      queryParameters: {
        'shortlistId': widget.shortlistId!,
        'name': widget.name,
        'status': widget.status,
      },
    );
  }

  Future<void> _onPublish() async {
    if (widget.shortlistId == null) return;
    await ShortlistsTable().update(
      data: {'status': 'active'},
      matchingRows: (q) => q.eqOrNull('id', widget.shortlistId),
    );
    if (!mounted) return;
    actions.toastificationshow(
        context, 'Published', 'Shortlist is now active', 'success');
    widget.onChanged?.call();
  }

  Future<void> _onDuplicate() async {
    if (widget.shortlistId == null) return;
    // Load existing shortlist items
    final items = await ShortlistItemsTable().queryRows(
      queryFn: (q) => q.eqOrNull('shortlist_id', widget.shortlistId),
    );
    // Create new shortlist as draft copy
    final code = List.generate(8, (_) {
      const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
      return chars[(DateTime.now().microsecondsSinceEpoch + _) % chars.length];
    }).join();

    final result = await SupaFlow.client
        .from('shortlists')
        .insert({
          'seller_id': ref.read(currentUserIdProvider),
          'name': '${widget.name} (Copy)',
          'status': 'draft',
          'share_code': code,
          'total_items': widget.totalItems,
        })
        .select()
        .single();

    final newId = result['id'] as String;
    // Copy items
    for (final item in items) {
      await SupaFlow.client.from('shortlist_items').insert({
        'shortlist_id': newId,
        'product_id': item.productId,
        'custom_quantity': item.customQuantity,
      });
    }
    if (!mounted) return;
    actions.toastificationshow(
        context, 'Duplicated', 'Shortlist duplicated as draft', 'success');
    widget.onChanged?.call();
  }

  Future<void> _onArchive() async {
    if (widget.shortlistId == null) return;
    await ShortlistsTable().update(
      data: {'status': 'archived'},
      matchingRows: (q) => q.eqOrNull('id', widget.shortlistId),
    );
    if (!mounted) return;
    actions.toastificationshow(
        context, 'Archived', 'Shortlist has been archived', 'success');
    widget.onChanged?.call();
  }

  // --- UI Builders ---

  Widget _buildTag(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11.0,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildTags() {
    if (!_tagsLoaded || _productTags.isEmpty) return SizedBox.shrink();
    const maxVisible = 3;
    final visible = _productTags.take(maxVisible).toList();
    final remaining = _productTags.length - maxVisible;

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 6.0,
        runSpacing: 6.0,
        children: [
          ...visible.map((t) => _buildTag(t)),
          if (remaining > 0) _buildTag('+$remaining'),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: isPrimary
                ? LinearGradient(
                    colors: [AppColors.brandPurple, AppColors.brandBlue],
                    stops: [0.0, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
            color: isPrimary ? null : AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 11.0),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500, fontSize: 15.0, height: 1.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    final createdStr = widget.createdAt != null
        ? DateFormat.MMMd().format(widget.createdAt!)
        : '';

    if (_isExpired) {
      final expiredStr = widget.endDate != null
          ? DateFormat('MMM yyyy').format(widget.endDate!)
          : '';
      return RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall!.copyWith(height: 1.5),
          children: [
            TextSpan(
              text: '${widget.totalItems} items',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            TextSpan(
              text: ' \u2022 ',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            TextSpan(
              text: 'Expired${expiredStr.isNotEmpty ? ' $expiredStr' : ''}',
              style: TextStyle(color: AppColors.errorBright),
            ),
          ],
        ),
      );
    }

    if (_isDraft) {
      return RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodySmall!.copyWith(height: 1.5),
          children: [
            TextSpan(
              text: '${widget.totalItems} items',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            TextSpan(
              text: ' \u2022 ',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            TextSpan(
              text: 'Drafts',
              style: TextStyle(color: Color(0xFFFF9500)),
            ),
          ],
        ),
      );
    }

    // Active
    return Text(
      '${widget.totalItems} items${createdStr.isNotEmpty ? ' \u2022 Created $createdStr' : ''}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.labelSmall!.copyWith(height: 1.5),
    );
  }

  Widget _buildStatsRow() {
    final sales = widget.totalSales ?? 0.0;
    final sold = widget.itemsSold ?? 0;
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                '\$${NumberFormat('#,##0', 'en_US').format(sales)}',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w700, color: AppColors.secondary),
              ),
              SizedBox(height: 2.0),
              Text(
                'Sales',
                style: Theme.of(context).textTheme.labelSmall!,
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                '$sold of ${widget.totalItems}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 2.0),
              Text(
                'Items sold',
                style: Theme.of(context).textTheme.labelSmall!,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    if (_isExpired) {
      return Row(
        children: [
          _buildButton(label: 'Duplicate', onTap: _onDuplicate),
          SizedBox(width: 12.0),
          _buildButton(label: 'Archive', onTap: _onArchive, isPrimary: true),
        ],
      );
    }

    if (_isDraft) {
      return Row(
        children: [
          _buildButton(label: 'Edit', onTap: _onEdit),
          SizedBox(width: 12.0),
          _buildButton(label: 'Publish', onTap: _onPublish, isPrimary: true),
        ],
      );
    }

    // Active
    return Row(
      children: [
        _buildButton(label: 'View', onTap: _onView, isPrimary: true),
        SizedBox(width: 12.0),
        _buildButton(label: 'Share', onTap: _onShare),
        if (widget.isOwner) ...[
          SizedBox(width: 12.0),
          _buildButton(label: 'Download', onTap: _onDownload),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: name + QR icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(height: 1.5),
                      ),
                      SizedBox(height: 4.0),
                      _buildSubtitle(),
                    ],
                  ),
                ),
                SizedBox(width: 12.0),
                FaIcon(
                  FontAwesomeIcons.qrcode,
                  color: AppColors.primary,
                  size: 24.0,
                ),
              ],
            ),
            // Tags
            SizedBox(height: 12.0),
            _buildTags(),
            // Stats (expired only)
            if (_isExpired) ...[
              SizedBox(height: 16.0),
              _buildStatsRow(),
            ],
            // Buttons
            SizedBox(height: 16.0),
            _buildButtons(),
          ],
        ),
      ),
    );
  }
}

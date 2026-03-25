import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '/backend/supabase/supabase.dart';
import '/core/providers/current_user_provider.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/app_loading_indicator.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/core/widgets/product_price_row.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/browse/presentation/widgets/browse_filter/browse_filter_sheet.dart';
import '/features/home/data/repositories/shortlist_repository.dart';
import '/features/home/domain/models/shortlist_item_detail_model.dart';
import '/features/home/presentation/pages/seller_dashboard/shortlist_add/home_dashoard_shortlist_add_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/shortlist_create/home_dashoard_shortlist_create_widget.dart';

class HomeDashoardShortlistCreateStep2Widget extends ConsumerStatefulWidget {
  const HomeDashoardShortlistCreateStep2Widget({
    super.key,
    this.name = '',
    this.eventName = '',
    this.startDate = '',
    this.endDate = '',
    this.isPublic = true,
    this.shortlistId,
    this.status,
  });

  final String name;
  final String eventName;
  final String startDate;
  final String endDate;
  final bool isPublic;
  final String? shortlistId;

  /// 'draft', 'active' (published), or null (new creation).
  final String? status;

  static const String routeName = 'homeDashoardShortlistCreateStep2';
  static const String routePath = 'homeDashoardShortlistCreateStep2';

  @override
  ConsumerState<HomeDashoardShortlistCreateStep2Widget> createState() =>
      _HomeDashoardShortlistCreateStep2WidgetState();
}

class _HomeDashoardShortlistCreateStep2WidgetState
    extends ConsumerState<HomeDashoardShortlistCreateStep2Widget> {
  List<ShortlistItemDetail> _items = [];
  bool _isLoading = true;
  bool _isSaving = false;
  String? _shareCode;

  TextEditingController? _notesController;
  FocusNode? _notesFocusNode;
  TextEditingController? _searchController;
  FocusNode? _searchFocusNode;

  BrowseFilterState _filterState = const BrowseFilterState();

  /// Cart items (product IDs added to cart) — only for published shortlists.
  Set<String> _cartItems = {};

  bool get _isPublished => widget.status == 'active';
  bool get _isEditing => widget.shortlistId != null;
  bool get _isNew => widget.shortlistId == null;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    _notesFocusNode = FocusNode();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    if (_isEditing) {
      _loadExistingData();
    } else {
      _isLoading = false;
    }
  }

  @override
  void dispose() {
    EasyDebounce.cancelAll();
    _notesController?.dispose();
    _notesFocusNode?.dispose();
    _searchController?.dispose();
    _searchFocusNode?.dispose();
    super.dispose();
  }

  Future<void> _loadExistingData() async {
    // Load shortlist metadata
    final shortlists = await ShortlistsTable().queryRows(
      queryFn: (q) => q.eqOrNull('id', widget.shortlistId),
    );
    if (!mounted) return;
    if (shortlists.isNotEmpty) {
      final sl = shortlists.first;
      _shareCode = sl.shareCode;
      if (sl.description != null && sl.description!.isNotEmpty) {
        _notesController?.text = sl.description!;
      }
    }

    // Load items via repository
    await _loadItems();
  }

  Future<void> _loadItems() async {
    if (widget.shortlistId == null) return;
    final repo = ref.read(shortlistRepositoryProvider);
    final items = await repo.getShortlistItems(widget.shortlistId!);
    if (!mounted) return;
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  List<ShortlistItemDetail> get _filteredItems {
    var items = _items;

    // Search filter
    final query = _searchController?.text.trim().toLowerCase() ?? '';
    if (query.isNotEmpty) {
      items = items
          .where((i) => i.title.toLowerCase().contains(query))
          .toList();
    }

    // Category filter
    if (_filterState.selectedCategoryIds.isNotEmpty) {
      items = items
          .where(
              (i) => _filterState.selectedCategoryIds.contains(i.categoryName))
          .toList();
    }

    return items;
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'active':
        return Color(0xFF34C759);
      case 'sold':
        return AppColors.errorBright;
      case 'damaged':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'active':
        return 'Active';
      case 'sold':
        return 'Sold';
      case 'damaged':
        return 'Damaged';
      default:
        return status;
    }
  }

  Future<void> _openFilter() async {
    final result = await showBrowseFilterSheet(context, _filterState);
    if (result != null) {
      setState(() => _filterState = result);
    }
  }

  Future<void> _addProducts() async {
    final result = await Navigator.push<Map<String, int>>(
      context,
      MaterialPageRoute(
        builder: (_) => HomeDashoardShortlistAddWidget(
          shortlistId: widget.shortlistId,
        ),
      ),
    );
    if (result == null || result.isEmpty) return;

    if (_isEditing) {
      // Reserve immediately for existing shortlists
      setState(() => _isSaving = true);
      final repo = ref.read(shortlistRepositoryProvider);
      final sellerId = ref.read(currentUserIdProvider);
      final reserveResult = await repo.reserveItems(
        shortlistId: widget.shortlistId!,
        items: result,
        sellerId: sellerId,
      );
      if (!mounted) return;

      if (reserveResult['success'] != true) {
        setState(() => _isSaving = false);
        _showConflictDialog(reserveResult['conflicts']);
        return;
      }

      // Reload items
      await _loadItems();
      setState(() => _isSaving = false);
    } else {
      // For new shortlists, just store the selection — reserve on create
      // We can't reserve yet because shortlist doesn't exist in DB
      // Convert to temporary ShortlistItemDetail for display
      // This path is handled by the create flow
      setState(() {});
    }
  }

  void _showConflictDialog(dynamic conflicts) {
    final conflictList = conflicts is List ? conflicts : [];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text('Update your quantities',
            style: Theme.of(context).textTheme.titleMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Some items don't have enough quantity available anymore. Review the updated amounts to continue.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16.0),
            ...conflictList.map((c) => Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          c['title']?.toString() ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'Requested: ${c['requested']} → Available: ${c['available']}',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: AppColors.errorBright),
                      ),
                    ],
                  ),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _addProducts(); // Go back to add products to review
            },
            child: Text('Review items',
                style: TextStyle(color: AppColors.textPrimary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Auto-adjust and retry would need the conflict data;
              // for now, user goes back to review
            },
            child: Text('Add available quantities',
                style: TextStyle(color: AppColors.secondary)),
          ),
        ],
      ),
    );
  }

  void _showItemMenu(ShortlistItemDetail item) {
    final sellerId = ref.read(currentUserIdProvider);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _menuItem(
              icon: Icons.check_circle_outline,
              label: 'Mark as Sold (in person)',
              onTap: () async {
                Navigator.pop(ctx);
                final repo = ref.read(shortlistRepositoryProvider);
                await repo.updateItemStatus(
                  shortlistItemId: item.id,
                  newStatus: 'sold',
                  sellerId: sellerId,
                );
                _loadItems();
              },
            ),
            Divider(
                color: AppColors.textSecondary.withValues(alpha: 0.2),
                height: 1),
            _menuItem(
              icon: Icons.delete_outline,
              label: 'Remove from Inventory (Damaged)',
              onTap: () async {
                Navigator.pop(ctx);
                final repo = ref.read(shortlistRepositoryProvider);
                await repo.updateItemStatus(
                  shortlistItemId: item.id,
                  newStatus: 'damaged',
                  sellerId: sellerId,
                );
                _loadItems();
              },
            ),
            Divider(
                color: AppColors.textSecondary.withValues(alpha: 0.2),
                height: 1),
            _menuItem(
              icon: Icons.playlist_remove,
              label: 'Remove from Shortlist',
              onTap: () async {
                Navigator.pop(ctx);
                final repo = ref.read(shortlistRepositoryProvider);
                await repo.releaseItems(
                  shortlistId: widget.shortlistId!,
                  productIds: [item.productId],
                  sellerId: sellerId,
                );
                _loadItems();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 22.0),
            SizedBox(width: 16.0),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15.0,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveShortlist({required String status}) async {
    setState(() => _isSaving = true);

    if (_isNew) {
      // Create new shortlist with reservation
      final repo = ref.read(shortlistRepositoryProvider);
      final result = await repo.createShortlist(
        name: widget.name,
        eventName: widget.eventName,
        startDate: widget.startDate,
        endDate: widget.endDate,
        isPublic: widget.isPublic,
        notes: _notesController!.text,
        status: status,
      );
      if (!mounted) return;
      setState(() => _isSaving = false);
      actions.toastificationshow(
        context,
        result['title'] ?? '',
        result['message'] ?? '',
        result['success'] == true ? 'success' : 'error',
      );
      if (result['success'] == true) {
        context.pop();
        context.pop();
      }
    } else {
      // Update existing shortlist
      final repo = ref.read(shortlistRepositoryProvider);
      await repo.updateShortlist(widget.shortlistId!, {
        'description': _notesController!.text,
        'status': status,
      });
      if (!mounted) return;
      setState(() => _isSaving = false);
      actions.toastificationshow(
        context,
        status == 'draft' ? 'Draft Saved' : 'Shortlist Updated',
        status == 'draft'
            ? 'Your shortlist has been saved as a draft.'
            : 'Your shortlist has been updated.',
        'success',
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

    return DismissKeyboard(
      child: Scaffold(
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
                  'Shortlist',
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: Icon(Icons.more_vert,
                      color: AppColors.info, size: 20.0),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        body: _isLoading
            ? Center(child: AppLoadingIndicator())
            : Column(
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Info card
                          _buildInfoCard(),
                          // QR code (published only)
                          if (_isPublished && _shareCode != null)
                            _buildQrSection(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Notes
                                Padding(
                                  padding: EdgeInsets.only(top: 16.0),
                                  child: TextFormField(
                                    controller: _notesController,
                                    focusNode: _notesFocusNode,
                                    decoration: appInputDecoration('Notes'),
                                    style: appTextFieldStyle,
                                    maxLines: null,
                                    minLines: 3,
                                    keyboardType: TextInputType.multiline,
                                    cursorColor: AppColors.textPrimary,
                                  ),
                                ),
                                Divider(
                                  height: 48.0,
                                  thickness: 1.0,
                                  color: AppColors.surfaceDark,
                                ),
                                // Search + filter row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Search Shortlist',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize: 15.0, height: 1.5),
                                    ),
                                    Text(
                                      '${_items.length} Items',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(height: 1.5),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _searchController,
                                          focusNode: _searchFocusNode,
                                          onChanged: (_) =>
                                              EasyDebounce.debounce(
                                            'shortlistSearch',
                                            Duration(milliseconds: 300),
                                            () => setState(() {}),
                                          ),
                                          decoration: appInputDecoration(
                                            'Search your shortlist',
                                            prefix: Icon(Icons.search,
                                                color: Colors.white,
                                                size: 24.0),
                                          ),
                                          style: appTextFieldStyle,
                                          cursorColor: AppColors.textPrimary,
                                        ),
                                      ),
                                      SizedBox(width: 8.0),
                                      GestureDetector(
                                        onTap: _openFilter,
                                        child: Container(
                                          width: 48.0,
                                          height: 48.0,
                                          decoration: BoxDecoration(
                                            color: _filterState.isEmpty
                                                ? AppColors.backgroundSecondary
                                                : AppColors.secondary,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: Icon(Icons.tune,
                                                    color: Colors.white,
                                                    size: 24.0),
                                              ),
                                              if (!_filterState.isEmpty)
                                                Positioned(
                                                  top: 4.0,
                                                  right: 4.0,
                                                  child: Container(
                                                    width: 18.0,
                                                    height: 18.0,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '${_filterState.activeFilterCount}',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 44.0,
                                  thickness: 1.0,
                                  color: AppColors.surfaceDark,
                                ),
                                // Product grid
                                if (filtered.isEmpty && _items.isEmpty) ...[
                                  Text(
                                    'Your Shortlist has no products added.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.normal,
                                            height: 1.5),
                                  ),
                                ] else if (filtered.isEmpty) ...[
                                  Text(
                                    'No products match your search.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!,
                                  ),
                                ] else ...[
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 12.0,
                                      mainAxisSpacing: 12.0,
                                      childAspectRatio: 0.55,
                                    ),
                                    itemCount: filtered.length,
                                    itemBuilder: (context, index) =>
                                        _buildProductCard(filtered[index]),
                                  ),
                                ],
                                // Add Products button
                                Padding(
                                  padding: EdgeInsets.only(top: 8.0),
                                  child: InkWell(
                                    onTap: _addProducts,
                                    child: Row(
                                      children: [
                                        Icon(Icons.add_circle_outline,
                                            color: AppColors.brandPurpleLight,
                                            size: 24.0),
                                        Text(
                                          'Add Products',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                  color: AppColors
                                                      .brandPurpleLight,
                                                  height: 1.5),
                                        ),
                                      ].divide(SizedBox(width: 8.0)),
                                    ),
                                  ),
                                ),
                              ].addToEnd(SizedBox(height: 24.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Bottom buttons
                  _buildBottomButtons(),
                ].addToEnd(SizedBox(height: 32.0)),
              ),
      ),
    );
  }

  Widget _buildInfoCard() {
    final createdDate = DateFormat('MMM d, yyyy').format(DateTime.now());
    return Container(
      decoration: BoxDecoration(color: AppColors.backgroundPrimary),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name.isNotEmpty ? widget.name : 'New Shortlist',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(height: 1.5),
                      ),
                      Text(
                        '${_items.length} items',
                        style: Theme.of(context).textTheme.labelSmall!,
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Created $createdDate',
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall!
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ].divide(SizedBox(height: 4.0)),
                  ),
                ),
                // Edit icon → navigate back to Step 1 with data
                if (_isEditing)
                  GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        HomeDashoardShortlistCreateWidget.routeName,
                        queryParameters: {
                          'shortlistId': widget.shortlistId ?? '',
                          'name': widget.name,
                          'eventName': widget.eventName,
                          'startDate': widget.startDate,
                          'endDate': widget.endDate,
                          'isPublic': widget.isPublic.toString(),
                        },
                      );
                    },
                    child: Icon(Icons.edit_outlined,
                        color: AppColors.textPrimary, size: 24.0),
                  ),
              ].divide(SizedBox(width: 12.0)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQrSection() {
    final shareUrl = 'https://getitapp.com/s/$_shareCode';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          SizedBox(height: 16.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: EdgeInsets.all(16.0),
            child: QrImageView(
              data: shareUrl,
              version: QrVersions.auto,
              size: 180.0,
              backgroundColor: Colors.white,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            shareUrl,
            style: Theme.of(context)
                .textTheme
                .labelSmall!
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ShortlistItemDetail item) {
    final isInCart = _cartItems.contains(item.productId);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with menu overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(12.0)),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: item.mainImageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: item.mainImageUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: AppColors.surfaceDarkAlt,
                            child: Icon(Icons.image,
                                color: AppColors.textSecondary, size: 40),
                          ),
                        )
                      : Container(
                          color: AppColors.surfaceDarkAlt,
                          child: Icon(Icons.image,
                              color: AppColors.textSecondary, size: 40),
                        ),
                ),
              ),
              // Menu button
              Positioned(
                top: 8.0,
                right: 8.0,
                child: GestureDetector(
                  onTap: () => _showItemMenu(item),
                  child: Container(
                    width: 28.0,
                    height: 28.0,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.more_horiz,
                        color: Colors.white, size: 18.0),
                  ),
                ),
              ),
            ],
          ),
          // Info
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4.0),
                  // Price with flash sale
                  ProductPriceRow(
                    price: item.price,
                    originalPrice: item.originalPrice,
                    flashSaleEnabled: item.flashSaleEnabled,
                    flashSalePrice: item.flashSalePrice,
                    discountType: item.discountType,
                    discountAmount: item.discountAmount,
                  ),
                  SizedBox(height: 4.0),
                  // Qty + Status row
                  Row(
                    children: [
                      Text(
                        'Qty: ${item.quantity}',
                        style: GoogleFonts.inter(
                          fontSize: 11.0,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: _statusColor(item.itemStatus),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(
                          _statusLabel(item.itemStatus),
                          style: GoogleFonts.inter(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Add to cart (published only)
                  if (_isPublished && item.itemStatus == 'active') ...[
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 28.0,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            if (isInCart) {
                              _cartItems.remove(item.productId);
                            } else {
                              _cartItems.add(item.productId);
                            }
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: isInCart
                              ? AppColors.secondary.withValues(alpha: 0.15)
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            side: BorderSide(
                              color: isInCart
                                  ? AppColors.secondary
                                  : AppColors.neutral700,
                            ),
                          ),
                        ),
                        child: Text(
                          isInCart ? 'Added ✓' : 'Add to cart',
                          style: GoogleFonts.inter(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w500,
                            color: isInCart
                                ? AppColors.secondary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    if (_isPublished) {
      // Published shortlist: Save / Cancel + End Shortlist
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(
                      minimumSize: Size(0, 48.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: AppColors.neutral800),
                      ),
                    ),
                    child: Text('Cancel',
                        style: Theme.of(context).textTheme.bodyMedium!),
                  ),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: AppGradientButton(
                    text: _isSaving ? 'Saving...' : 'Save',
                    enabled: !_isSaving,
                    onPressed: () => _saveShortlist(status: 'active'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.0),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  // GT-104: End shortlist → reconciliation
                  actions.toastificationshow(
                    context,
                    'Coming Soon',
                    'Reconciliation will be available in the next update.',
                    'info',
                  );
                },
                style: TextButton.styleFrom(
                  minimumSize: Size(double.infinity, 48.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    side: BorderSide(color: AppColors.errorBright),
                  ),
                ),
                child: Text(
                  'End Shortlist',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.errorBright),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // New / Draft shortlist: Create + Save as Draft / Move to Drafts
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          AppGradientButton(
            text: _isSaving
                ? 'Creating...'
                : _isNew
                    ? 'Create Shortlist'
                    : 'Publish Shortlist',
            enabled: !_isSaving,
            onPressed: () => _saveShortlist(status: 'active'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: TextButton(
              onPressed:
                  _isSaving ? null : () => _saveShortlist(status: 'draft'),
              style: TextButton.styleFrom(
                minimumSize: Size(double.infinity, 56.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  side: BorderSide(color: AppColors.neutral800),
                ),
              ),
              child: Text(
                _isSaving ? 'Saving...' : 'Move to Drafts',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 17.0,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

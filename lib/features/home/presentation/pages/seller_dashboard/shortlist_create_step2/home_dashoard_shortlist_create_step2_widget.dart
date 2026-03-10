import '/backend/supabase/supabase.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/app_text_field.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/custom_code/actions/index.dart' as actions;
import '/features/home/presentation/pages/seller_dashboard/shortlist_add/home_dashoard_shortlist_add_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class HomeDashoardShortlistCreateStep2Widget extends StatefulWidget {
  const HomeDashoardShortlistCreateStep2Widget({
    super.key,
    this.name = '',
    this.eventName = '',
    this.startDate = '',
    this.endDate = '',
    this.isPublic = true,
    this.shortlistId,
  });

  final String name;
  final String eventName;
  final String startDate;
  final String endDate;
  final bool isPublic;
  final String? shortlistId;

  static String routeName = 'homeDashoardShortlistCreateStep2';
  static String routePath = 'homeDashoardShortlistCreateStep2';

  @override
  State<HomeDashoardShortlistCreateStep2Widget> createState() =>
      _HomeDashoardShortlistCreateStep2WidgetState();
}

class _HomeDashoardShortlistCreateStep2WidgetState
    extends State<HomeDashoardShortlistCreateStep2Widget> {
  String state = 'Shop';
  bool? switchValue;
  List<String> selectedProductIds = [];
  Map<String, ProductsRow> _productDetails = {};
  Map<String, String> _productImages = {};
  bool _isSaving = false;

  TextEditingController? textController1;
  FocusNode? textFieldFocusNode1;
  late MaskTextInputFormatter textFieldMask1;
  TextEditingController? textController2;
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController3;
  FocusNode? textFieldFocusNode3;

  @override
  void initState() {
    super.initState();

    switchValue = false;
    textController1 = TextEditingController();
    textFieldFocusNode1 = FocusNode();
    textFieldFocusNode1!.addListener(() => setState(() {}));
    textFieldMask1 = MaskTextInputFormatter(mask: '##');
    textController2 = TextEditingController();
    textFieldFocusNode2 = FocusNode();
    textFieldFocusNode2!.addListener(() => setState(() {}));
    textController3 = TextEditingController();
    textFieldFocusNode3 = FocusNode();
    textFieldFocusNode3!.addListener(() => setState(() {}));

    if (widget.shortlistId != null) {
      _loadExistingItems();
    }
  }

  Future<void> _loadExistingItems() async {
    // Load shortlist details
    final shortlists = await ShortlistsTable().queryRows(
      queryFn: (q) => q.eqOrNull('id', widget.shortlistId),
    );
    if (!mounted) return;
    if (shortlists.isNotEmpty) {
      final sl = shortlists.first;
      final discount = sl.discountPercentage;
      if (discount != null && discount > 0) {
        switchValue = true;
        textController1?.text = discount.toInt().toString();
      }
      if (sl.description != null && sl.description!.isNotEmpty) {
        textController2?.text = sl.description!;
      }
    }

    // Load shortlist items
    final items = await ShortlistItemsTable().queryRows(
      queryFn: (q) => q.eqOrNull('shortlist_id', widget.shortlistId),
    );
    if (!mounted) return;
    final ids = items.map((e) => e.productId).toList();
    setState(() {
      selectedProductIds = ids;
    });
    _loadProductDetails(ids);
  }

  @override
  void dispose() {
    textController1?.dispose();
    textFieldFocusNode1?.dispose();
    textController2?.dispose();
    textFieldFocusNode2?.dispose();
    textController3?.dispose();
    textFieldFocusNode3?.dispose();
    super.dispose();
  }

  Future<void> _loadProductDetails(List<String> ids) async {
    if (ids.isEmpty) return;
    final newIds = ids.where((id) => !_productDetails.containsKey(id)).toList();
    if (newIds.isEmpty) return;
    final rows = await ProductsTable().queryRows(
      queryFn: (q) => q.inFilterOrNull('id', newIds),
    );
    final images = await ProductImagesTable().queryRows(
      queryFn: (q) =>
          q.inFilterOrNull('product_id', newIds).eqOrNull('is_main', true),
    );
    if (!mounted) return;
    setState(() {
      for (final row in rows) {
        _productDetails[row.id] = row;
      }
      for (final img in images) {
        _productImages[img.productId] = img.imageUrl;
      }
    });
  }

  Color _statusColor(String? status) {
    switch (status) {
      case 'active':
        return Color(0xFF34C759);
      case 'sold':
        return Color(0xFFFF3B30);
      case 'draft':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showProductMenu(BuildContext context, ProductsRow? product, int index) {
    if (product == null) return;
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
                await ProductsTable().update(
                  data: {'status': 'sold'},
                  matchingRows: (q) => q.eqOrNull('id', product.id),
                );
                _loadProductDetails(selectedProductIds);
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
                await ProductsTable().update(
                  data: {'status': 'removed'},
                  matchingRows: (q) => q.eqOrNull('id', product.id),
                );
                setState(() {
                  selectedProductIds.remove(product.id);
                  _productDetails.remove(product.id);
                  _productImages.remove(product.id);
                });
              },
            ),
            Divider(
                color: AppColors.textSecondary.withValues(alpha: 0.2),
                height: 1),
            _menuItem(
              icon: Icons.campaign_outlined,
              label: 'Promote Product',
              onTap: () {
                Navigator.pop(ctx);
                context.pushNamed('homeDashoardPromoteStep1');
              },
            ),
            Divider(
                color: AppColors.textSecondary.withValues(alpha: 0.2),
                height: 1),
            _menuItem(
              icon: Icons.playlist_remove,
              label: 'Remove from Shortlist',
              onTap: () {
                Navigator.pop(ctx);
                setState(() {
                  selectedProductIds.remove(product.id);
                  _productDetails.remove(product.id);
                  _productImages.remove(product.id);
                });
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

  Widget _buildProductCard(ProductsRow? product, String? imageUrl, int index) {
    final price = product != null
        ? '\$${NumberFormat('#,##0', 'en_US').format(product.price)}'
        : '';
    final status = product?.status ?? '';
    final qty = product?.quantity ?? 0;
    final views = product?.viewsCount ?? 0;

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
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Color(0xFF2A2A2A),
                            child: Icon(Icons.image,
                                color: AppColors.textSecondary, size: 40),
                          ),
                        )
                      : Container(
                          color: Color(0xFF2A2A2A),
                          child: Icon(Icons.image,
                              color: AppColors.textSecondary, size: 40),
                        ),
                ),
              ),
              Positioned(
                top: 8.0,
                right: 8.0,
                child: GestureDetector(
                  onTap: () => _showProductMenu(context, product, index),
                  child: Container(
                    width: 28.0,
                    height: 28.0,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                      size: 18.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Info
          Padding(
            padding: EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product?.title ?? 'Loading...',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 6.0),
                Row(
                  children: [
                    Text(
                      price,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Qty: $qty',
                      style: GoogleFonts.inter(
                        fontSize: 13.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: [
                    if (status.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: _statusColor(status),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
                          status[0].toUpperCase() + status.substring(1),
                          style: GoogleFonts.inter(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    Spacer(),
                    Text(
                      '$views Views',
                      style: Theme.of(context).textTheme.labelSmall!,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.info,
                    size: 24.0,
                  ),
                  onPressed: () {
                    context.pop();
                  },
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
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.info,
                    size: 20.0,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.backgroundPrimary,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 24.0),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundSecondary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 20.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.name.isNotEmpty
                                            ? widget.name
                                            : 'New Shortlist',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.0,
                                          color: AppColors.textPrimary,
                                          height: 1.5,
                                        ),
                                      ),
                                      Text(
                                        '${selectedProductIds.length} items',
                                        maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!,
                                      ),
                                    ].divide(SizedBox(height: 4.0)),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_back,
                                  color: AppColors.textPrimary,
                                  size: 24.0,
                                ),
                              ].divide(SizedBox(width: 12.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discount',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0, height: 1.5),
                              ),
                              Switch.adaptive(
                                value: switchValue!,
                                onChanged: (newValue) async {
                                  setState(() => switchValue = newValue);
                                },
                                activeThumbColor: AppColors.primary,
                                activeTrackColor: AppColors.primary,
                                inactiveTrackColor: AppColors.alternate,
                                inactiveThumbColor:
                                    AppColors.backgroundSecondary,
                              ),
                            ],
                          ),
                          if (switchValue == true) ...[
                            Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text(
                                'Discount Percentage',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0, height: 1.5),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: textController1,
                                  focusNode: textFieldFocusNode1,
                                  onChanged: (_) => EasyDebounce.debounce(
                                    '_model.textController1',
                                    Duration(milliseconds: 100),
                                    () => setState(() {}),
                                  ),
                                  autofocus: false,
                                  enabled: true,
                                  obscureText: false,
                                  decoration:
                                      appInputDecoration('0.00').copyWith(
                                    prefixText: '% ',
                                    prefixStyle:
                                        Theme.of(context).textTheme.labelLarge!,
                                  ),
                                  style: appTextFieldStyle,
                                  keyboardType: TextInputType.number,
                                  cursorColor: AppColors.textPrimary,
                                  enableInteractiveSelection: true,
                                  inputFormatters: [textFieldMask1],
                                ),
                              ),
                            ),
                          ],
                          Padding(
                            padding: EdgeInsets.only(top: 24.0),
                            child: Container(
                              width: double.infinity,
                              child: TextFormField(
                                controller: textController2,
                                focusNode: textFieldFocusNode2,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.textController2',
                                  Duration(milliseconds: 100),
                                  () => setState(() {}),
                                ),
                                autofocus: false,
                                enabled: true,
                                obscureText: false,
                                decoration: appInputDecoration('Notes'),
                                style: appTextFieldStyle,
                                maxLines: null,
                                minLines: 4,
                                keyboardType: TextInputType.multiline,
                                cursorColor: AppColors.textPrimary,
                                enableInteractiveSelection: true,
                              ),
                            ),
                          ),
                          Divider(
                            height: 48.0,
                            thickness: 1.0,
                            color: AppColors.surfaceDark,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Search Shortlist',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15.0, height: 1.5),
                              ),
                              Text(
                                '${selectedProductIds.length} Items',
                                style: Theme.of(context).textTheme.labelMedium!.copyWith(height: 1.5),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Container(
                              width: double.infinity,
                              child: TextFormField(
                                controller: textController3,
                                focusNode: textFieldFocusNode3,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.textController3',
                                  Duration(milliseconds: 100),
                                  () => setState(() {}),
                                ),
                                autofocus: false,
                                enabled: true,
                                obscureText: false,
                                decoration: appInputDecoration(
                                  'Search your shortlist',
                                  prefix: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                ),
                                style: appTextFieldStyle,
                                cursorColor: AppColors.textPrimary,
                                enableInteractiveSelection: true,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Row(
                              children: [
                                Container(
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
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: Text(
                                      'Requested',
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 15.0),
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
                          if (selectedProductIds.isEmpty) ...[
                            Text(
                              'Your Shortlist has no products added.',
                              style: GoogleFonts.inter(
                                fontSize: 18.0,
                                color: AppColors.textPrimary,
                                height: 1.5,
                              ),
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
                                childAspectRatio: 0.62,
                              ),
                              itemCount: selectedProductIds.length,
                              itemBuilder: (context, index) {
                                final productId = selectedProductIds[index];
                                final product = _productDetails[productId];
                                final imageUrl = _productImages[productId];
                                return _buildProductCard(
                                    product, imageUrl, index);
                              },
                            ),
                          ],
                          Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: InkWell(
                              onTap: () async {
                                final result =
                                    await Navigator.push<List<String>>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        HomeDashoardShortlistAddWidget(),
                                  ),
                                );
                                if (result != null && result.isNotEmpty) {
                                  final newIds = <String>[];
                                  for (final id in result) {
                                    if (!selectedProductIds.contains(id)) {
                                      selectedProductIds.add(id);
                                      newIds.add(id);
                                    }
                                  }
                                  setState(() {});
                                  _loadProductDetails(newIds);
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: AppColors.brandPurpleLight,
                                    size: 24.0,
                                  ),
                                  Text(
                                    'Add Products',
                                    style: GoogleFonts.inter(
                                      fontSize: 14.0,
                                      color: AppColors.brandPurpleLight,
                                      height: 1.5,
                                    ),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  AppGradientButton(
                    text: _isSaving ? 'Creating...' : 'Create Shortlist',
                    enabled: !_isSaving,
                    onPressed: () async {
                      setState(() => _isSaving = true);
                      final discountPct =
                          double.tryParse(textController1!.text.trim());
                      final result = await actions.createShortlist(
                        name: widget.name,
                        eventName: widget.eventName,
                        startDate: widget.startDate,
                        endDate: widget.endDate,
                        isPublic: widget.isPublic,
                        discountPercentage: discountPct,
                        notes: textController2!.text,
                        status: 'active',
                        productIds: selectedProductIds,
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
                        // Pop back to shortlist list (Step2 → Step1 → list)
                        context.pop();
                        context.pop();
                      }
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: TextButton(
                      onPressed: _isSaving
                          ? null
                          : () async {
                              setState(() => _isSaving = true);
                              final discountPct =
                                  double.tryParse(textController1!.text.trim());
                              final result = await actions.createShortlist(
                                name: widget.name,
                                eventName: widget.eventName,
                                startDate: widget.startDate,
                                endDate: widget.endDate,
                                isPublic: widget.isPublic,
                                discountPercentage: discountPct,
                                notes: textController2!.text,
                                status: 'draft',
                                productIds: selectedProductIds,
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
                                Navigator.of(context)
                                  ..pop()
                                  ..pop();
                              }
                            },
                      style: TextButton.styleFrom(
                        minimumSize: Size(double.infinity, 56.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          side: BorderSide(color: AppColors.neutral800),
                        ),
                      ),
                      child: Text(
                        _isSaving ? 'Saving...' : 'Save as Draft',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500, fontSize: 17.0, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ].addToEnd(SizedBox(height: 32.0)),
        ),
      ),
    );
  }
}

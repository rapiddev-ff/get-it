import '/backend/supabase/supabase.dart';
import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/auth/data/supabase_auth/auth_util.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeDashoardShortlistAddWidget extends StatefulWidget {
  const HomeDashoardShortlistAddWidget({super.key});

  static String routeName = 'homeDashoardShortlistAdd';
  static String routePath = 'homeDashoardShortlistAdd';

  @override
  State<HomeDashoardShortlistAddWidget> createState() =>
      _HomeDashoardShortlistAddWidgetState();
}

class _HomeDashoardShortlistAddWidgetState
    extends State<HomeDashoardShortlistAddWidget> {
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;

  List<ProductsRow> products = [];
  Set<String> selectedIds = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textFieldFocusNode = FocusNode();
    textFieldFocusNode!.addListener(() => setState(() {}));
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final rows = await ProductsTable().queryRows(
      queryFn: (q) => q
          .eqOrNull('seller_id', currentUserUid)
          .eqOrNull('status', 'active')
          .order('created_at'),
    );
    if (!mounted) return;
    setState(() {
      products = rows;
      _isLoading = false;
    });
  }

  List<ProductsRow> get _filteredProducts {
    final query = textController?.text.trim().toLowerCase() ?? '';
    if (query.isEmpty) return products;
    return products
        .where((p) => p.title.toLowerCase().contains(query))
        .toList();
  }

  bool get _allSelected =>
      _filteredProducts.isNotEmpty &&
      _filteredProducts.every((p) => selectedIds.contains(p.id));

  void _toggleSelectAll() {
    setState(() {
      if (_allSelected) {
        selectedIds.clear();
      } else {
        selectedIds = _filteredProducts.map((p) => p.id).toSet();
      }
    });
  }

  @override
  void dispose() {
    textController?.dispose();
    textFieldFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;

    return DismissKeyboard(
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
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
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'Add to Shortlist',
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
                    icon: Icon(
                      Icons.more_vert,
                      color: AppColors.info,
                      size: 20.0,
                    ),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 24.0),
                      Container(
                        width: double.infinity,
                        child: TextFormField(
                          controller: textController,
                          focusNode: textFieldFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            'shortlistAddSearch',
                            Duration(milliseconds: 300),
                            () => setState(() {}),
                          ),
                          autofocus: false,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: false,
                            hintText: 'Search products, characters, years...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 15.0,
                              color: AppColors.textSecondary,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.neutral700,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(
                                  AppConstants.radiusTextField4),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.secondary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(
                                  AppConstants.radiusTextField4),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(
                                  AppConstants.radiusTextField4),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.error,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(
                                  AppConstants.radiusTextField4),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 24.0,
                            ),
                          ),
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            color: AppColors.textPrimary,
                          ),
                          cursorColor: AppColors.textPrimary,
                          enableInteractiveSelection: true,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.secondary,
                                    Color(0xFF6187F1)
                                  ],
                                  stops: [0.0, 1.0],
                                  begin: Alignment.topCenter,
                                  end: AlignmentDirectional(0, 1.0),
                                ),
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                  '${selectedIds.length} selected',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: GestureDetector(
                          onTap: _toggleSelectAll,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.backgroundSecondary,
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 7.0,
                                  top: 7.0,
                                  right: 16.0,
                                  bottom: 7.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 22.0,
                                    height: 22.0,
                                    decoration: BoxDecoration(
                                      color: _allSelected
                                          ? AppColors.secondary
                                          : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: _allSelected
                                            ? AppColors.secondary
                                            : Color(0xFF7B7B7B),
                                      ),
                                    ),
                                    child: _allSelected
                                        ? Icon(Icons.check,
                                            color: Colors.white, size: 14.0)
                                        : null,
                                  ),
                                  Text(
                                    'Select All',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.0,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ].divide(SizedBox(width: 8.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Expanded(
                        child: _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.secondary,
                                ),
                              )
                            : filtered.isEmpty
                                ? Center(
                                    child: Text(
                                      'No products found',
                                      style: GoogleFonts.inter(
                                        fontSize: 16.0,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    padding: EdgeInsets.only(bottom: 24.0),
                                    itemCount: filtered.length,
                                    separatorBuilder: (_, __) =>
                                        SizedBox(height: 8.0),
                                    itemBuilder: (context, index) {
                                      final product = filtered[index];
                                      final isSelected =
                                          selectedIds.contains(product.id);
                                      return _buildProductItem(
                                          product, isSelected);
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: AppGradientButton(
                  text:
                      'Add ${selectedIds.length} Product${selectedIds.length == 1 ? '' : 's'}',
                  enabled: selectedIds.isNotEmpty,
                  onPressed: () {
                    Navigator.pop(context, selectedIds.toList());
                  },
                ),
              ),
            ].addToEnd(SizedBox(height: 32.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(ProductsRow product, bool isSelected) {
    final priceFormatted =
        NumberFormat('#,##0.00', 'en_US').format(product.price);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedIds.remove(product.id);
          } else {
            selectedIds.add(product.id);
          }
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                width: 22.0,
                height: 22.0,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.secondary : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.secondary : Color(0xFF7B7B7B),
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check, color: Colors.white, size: 14.0)
                    : null,
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Row(
                      children: [
                        Text(
                          '\$$priceFormatted',
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: 16.0),
                        Text(
                          'Qty ${product.quantity ?? 0}',
                          style: GoogleFonts.inter(
                            fontSize: 14.0,
                            color: AppColors.textSecondary,
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
      ),
    );
  }
}

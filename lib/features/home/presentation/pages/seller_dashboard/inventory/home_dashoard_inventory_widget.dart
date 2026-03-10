import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '/features/browse/domain/models/category_model.dart';
import '/features/home/domain/models/seller_product_model.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/constants/app_constants.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/home/presentation/pages/seller_dashboard/inventory_item/inventory_item_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/inventory_add/home_dashoard_inventory_add_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/shortlist/home_dashoard_shortlist_widget.dart';

class HomeDashoardInventoryWidget extends ConsumerStatefulWidget {
  const HomeDashoardInventoryWidget({super.key});

  static String routeName = 'homeDashoardInventory';
  static String routePath = 'homeDashoardInventory';

  @override
  ConsumerState<HomeDashoardInventoryWidget> createState() =>
      _HomeDashoardInventoryWidgetState();
}

class _HomeDashoardInventoryWidgetState
    extends ConsumerState<HomeDashoardInventoryWidget>
    with KeyboardVisibilityMixin {
  // Inlined model state
  Category? choosenCategory;
  int? itemsCount = 0;
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;

  @override
  void initState() {
    super.initState();

    textController ??= TextEditingController();
    textFieldFocusNode ??= FocusNode();
    textFieldFocusNode!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    textController?.dispose();
    textFieldFocusNode?.dispose();
    super.dispose();
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
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppColors.info,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.pop();
                  },
                ),
                Text(
                  'Inventory',
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                Opacity(
                  opacity: 0.0,
                  child: IconButton(
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
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            child: TextFormField(
                              controller: textController,
                              focusNode: textFieldFocusNode,
                              onChanged: (_) => EasyDebounce.debounce(
                                '_model.textController',
                                Duration(milliseconds: 100),
                                () => setState(() {}),
                              ),
                              autofocus: false,
                              enabled: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: false,
                                hintText: 'Search inventory...',
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
                              style: Theme.of(context).textTheme.bodyMedium!,
                              cursorColor: AppColors.textPrimary,
                              enableInteractiveSelection: true,
                            ),
                          ),
                        ),
                        IconButton(
                          style: IconButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(
                                color: AppColors.neutral700,
                                width: 1.0,
                              ),
                            ),
                          ),
                          iconSize: 50.0,
                          icon: FaIcon(
                            FontAwesomeIcons.filter,
                            color: AppColors.info,
                            size: 16.0,
                          ),
                          onPressed: () {},
                        ),
                      ].divide(SizedBox(width: 12.0)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              choosenCategory = null;
                              setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    choosenCategory == null
                                        ? AppColors.brandPurple
                                        : AppColors.backgroundSecondary,
                                    choosenCategory == null
                                        ? AppColors.brandBlue
                                        : AppColors.backgroundSecondary
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
                                  'All ',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium!,
                                ),
                              ),
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              final categories = <Category>[];

                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(categories.length,
                                    (categoriesIndex) {
                                  final categoriesItem =
                                      categories[categoriesIndex];
                                  return InkWell(
                                    onTap: () async {
                                      choosenCategory = categoriesItem;
                                      setState(() {});
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            choosenCategory == categoriesItem
                                                ? AppColors.brandPurple
                                                : AppColors.backgroundSecondary,
                                            choosenCategory == categoriesItem
                                                ? AppColors.brandBlue
                                                : AppColors.backgroundSecondary
                                          ],
                                          stops: [0.0, 1.0],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Text(
                                          categoriesItem.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!,
                                        ),
                                      ),
                                    ),
                                  );
                                }).divide(SizedBox(width: 8.0)),
                              );
                            },
                          ),
                        ]
                            .divide(SizedBox(width: 8.0))
                            .addToStart(SizedBox(width: 16.0))
                            .addToEnd(SizedBox(width: 16.0)),
                      ),
                    ),
                  ),
                  Divider(
                    height: 48.0,
                    thickness: 1.0,
                    color: AppColors.surfaceDark,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '${itemsCount?.toString()} Items',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: custom_widgets.InfiniteProductGrid(
                        width: double.infinity,
                        height: double.infinity,
                        sellerId: ref.read(currentUserIdProvider),
                        userId: ref.read(currentUserIdProvider),
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 16.0,
                        padding: 16.0,
                        pageSize: 20,
                        searchText: textController!.text,
                        categoryId: choosenCategory?.id,
                        onProductTap: (productId) async {
                          context.pushNamed(
                            HomeDashoardInventoryAddWidget.routeName,
                            queryParameters: {
                              'productId': productId.toString(),
                            },
                          );
                        },
                        onTotalChanged: (total) async {
                          itemsCount = total;
                          setState(() {});
                        },
                        itemBuilder: (SellerProduct? sellerProduct) =>
                            InventoryItemWidget(
                          sellerProduct: sellerProduct,
                        ),
                      ),
                    ),
                  ),
                ]
                    .addToStart(SizedBox(height: 24.0))
                    .addToEnd(SizedBox(height: 24.0)),
              ),
            ),
            if (!isKeyboardShowing(context))
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0, top: 12.0, right: 16.0, bottom: 36.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(
                              color: AppColors.neutral800,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(top: 12.0, bottom: 14.0),
                            child: Column(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.camera,
                                  color: AppColors.textPrimary,
                                  size: 16.0,
                                ),
                                Text(
                                  'Scan Item',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium!,
                                ),
                              ].divide(SizedBox(height: 4.0)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            context.pushNamed(
                                HomeDashoardInventoryAddWidget.routeName);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                color: AppColors.neutral800,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 12.0, bottom: 14.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: AppColors.textPrimary,
                                    size: 16.0,
                                  ),
                                  Text(
                                    'Add Manual',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium!,
                                  ),
                                ].divide(SizedBox(height: 4.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            context.pushNamed(
                                HomeDashoardShortlistWidget.routeName);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: Border.all(
                                color: AppColors.neutral800,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(top: 12.0, bottom: 14.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.playlist_add_sharp,
                                    color: AppColors.textPrimary,
                                    size: 16.0,
                                  ),
                                  Text(
                                    'Shortlists',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium!,
                                  ),
                                ].divide(SizedBox(height: 4.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 12.0)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

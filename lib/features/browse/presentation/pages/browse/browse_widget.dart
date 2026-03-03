import '/features/auth/data/supabase_auth/auth_util.dart';
import '/features/browse/domain/models/browse_product_model.dart';
import '/features/browse/presentation/widgets/browse_products_item/browse_products_item_widget.dart';
import '/features/home/presentation/widgets/empty_state/empty_state_widget.dart';
import '/features/home/presentation/widgets/nav_bar/nav_bar_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/constants/app_constants.dart';
import '/core/utils/list_extensions.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'browse_model.dart';
export 'browse_model.dart';

class BrowseWidget extends StatefulWidget {
  const BrowseWidget({super.key});

  static String routeName = 'browse';
  static String routePath = 'browse';

  @override
  State<BrowseWidget> createState() => _BrowseWidgetState();
}

class _BrowseWidgetState extends State<BrowseWidget> {
  late BrowseModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = BrowseModel();

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode!.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.backgroundPrimary,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: AppBar(
            backgroundColor: AppColors.backgroundSecondary,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  iconSize: 24.0,
                  icon: const Icon(
                    Icons.menu,
                    color: AppColors.info,
                  ),
                  onPressed: () {
                    context.pushNamed(SettingsWidget.routeName);
                  },
                ),
                Text(
                  AppConstants.appName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  iconSize: 20.0,
                  icon: const FaIcon(
                    FontAwesomeIcons.solidBell,
                    color: AppColors.info,
                  ),
                  onPressed: () {
                    context.pushNamed(NotificationWidget.routeName);
                  },
                ),
              ],
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0.0,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    16.0, 0.0, 16.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: TextFormField(
                        controller: _model.textController,
                        focusNode: _model.textFieldFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.textController',
                          const Duration(milliseconds: 100),
                          () => setState(() {}),
                        ),
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText:
                              'Search products, characters, years...',
                          hintStyle: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            fontSize: 15.0,
                            color: AppColors.textSecondary,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.neutral700,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusTextField4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.secondary,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusTextField4),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusTextField4),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: AppColors.error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(
                                AppConstants.radiusTextField4),
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 24.0,
                          ),
                        ),
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 14.0,
                        ),
                        cursorColor: AppColors.textPrimary,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 24.0, 0.0, 0.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: custom_widgets.BrowseProductsGrid(
                            width: double.infinity,
                            height: double.infinity,
                            userId: currentUserUid,
                            searchQuery:
                                _model.textController?.text ?? '',
                            categoryId: null,
                            subcategoryId: null,
                            crossAxisCount: 2,
                            childAspectRatio: 0.67,
                            crossAxisSpacing: 16.0,
                            mainAxisSpacing: 16.0,
                            paddingLeft: 0.0,
                            paddingRight: 0.0,
                            paddingTop: 0.0,
                            paddingBottom: 0.0,
                            pageSize: 20,
                            onProductTap: (productId) async {
                              HapticFeedback.lightImpact();

                              context.pushNamed(
                                HomeProductWidget.routeName,
                                queryParameters: {
                                  'productId': productId.toString(),
                                },
                              );
                            },
                            onTotalChanged: (total) async {},
                            itemBuilder:
                                (BrowseProduct product) =>
                                    BrowseProductsItemWidget(
                              browseDataType: product,
                            ),
                            emptyStateWidget: () => EmptyStateWidget(
                              icon: const Icon(
                                Icons.search_off,
                                color: AppColors.neutral800,
                                size: 140.0,
                              ),
                              title:
                                  'No results for "${_model.textController?.text ?? ''}"',
                              description:
                                  'Try a different keyword or use fewer words.',
                              hasButton: true,
                              sidePadding: 0.0,
                              buttonText: 'Clear Search',
                              buttonAction: () async {
                                setState(() {
                                  _model.textController?.clear();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                      .addToStart(const SizedBox(height: 24.0))
                      .addToEnd(const SizedBox(height: 24.0)),
                ),
              ),
            ),
            NavBarWidget(),
          ],
        ),
      ),
    );
  }
}

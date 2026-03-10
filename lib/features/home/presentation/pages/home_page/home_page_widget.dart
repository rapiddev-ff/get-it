import '/features/auth/data/supabase_auth/auth_util.dart';
import '/features/home/domain/models/feed_product_model.dart';
import '/features/home/presentation/providers/feed_provider.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/backend/supabase/supabase.dart';
import '/features/home/presentation/widgets/nav_bar/nav_bar_widget.dart';
import '/features/home/presentation/widgets/components/seller_dashboard_ship_item_widget.dart';
import '/features/checkout/presentation/widgets/quick_purchase_popup/quick_purchase_popup_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/core/utils/data_converters.dart' as functions;
import '/index.dart';
import '/core/theme/app_colors.dart';
import '/core/constants/app_constants.dart';
import '/core/utils/value_utils.dart';
import '/core/utils/list_extensions.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class HomePageWidget extends ConsumerStatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'homePage';
  static String routePath = 'homePage';

  @override
  ConsumerState<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends ConsumerState<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Inlined from HomePageModel
  String _state = 'Shop';
  bool hasMoreProducts = true;
  bool isLoadingMore = false;
  List<FeedProduct>? getFeed;
  dynamic getSellerDashboard;
  List<StripeAccountsRow>? getStripe;
  late ExpandableController expandableExpandableController;
  bool _connectingStripe = false;
  List<Map<String, dynamic>> _itemsToShip = [];
  int _pendingShipCount = 0;

  /// Helper to safely extract a string from a JSON map.
  static String? _jsonStr(dynamic json, String key) {
    return (json is Map) ? json[key]?.toString() : null;
  }

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      try {
        await Future.wait([
          Future(() async {
            if (!mounted) return;
            getFeed = await actions.initFeedProductsStream(
              ref,
              currentUserUid,
              ref.read(feedProvider).swipedProductIds.toList(),
            );
          }),
          Future(() async {
            if (!mounted) return;
            getSellerDashboard = await actions.callRpc(
              context,
              'get_seller_dashboard',
              <String, dynamic>{},
            );
          }),
          Future(() async {
            if (!mounted) return;
            _itemsToShip = await actions.getSellerOrders(
              statusFilter: 'to_ship',
              limit: 3,
            );
            final counts = await actions.getSellerOrderCounts();
            _pendingShipCount = counts['to_ship'] ?? 0;
          }),
        ]);
      } catch (_) {
        // Network or API error — dashboard shows fallback values.
      }
      if (!mounted) return;
      setState(() {});
    });

    expandableExpandableController = ExpandableController(initialExpanded: true)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    expandableExpandableController.dispose();

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
          preferredSize: Size.fromHeight(56.0),
          child: AppBar(
            backgroundColor: AppColors.backgroundSecondary,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    minimumSize: Size(40.0, 40.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: Icon(
                    Icons.menu,
                    color: AppColors.info,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.pushNamed(SettingsWidget.routeName);
                  },
                ),
                Text(
                  AppConstants.appName,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
                IconButton(
                  style: IconButton.styleFrom(
                    minimumSize: Size(40.0, 40.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  icon: Icon(
                    Icons.notifications_none,
                    color: AppColors.info,
                    size: 20.0,
                  ),
                  onPressed: () async {
                    context.pushNamed(NotificationWidget.routeName);
                  },
                ),
              ],
            ),
            actions: [],
            centerTitle: true,
            elevation: 0.0,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: double.infinity,
              height: 53.0,
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _state = 'Shop';
                          setState(() {});
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 10.0),
                              child: Text(
                                'Shop',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.normal,
                                  color: _state == 'Shop'
                                      ? AppColors.textPrimary
                                      : Color(0xFFAFAFB4),
                                  height: 2.0,
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: (_state == 'Shop' ? 1 : 0).toDouble(),
                              child: Container(
                                width: double.infinity,
                                height: 2.0,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _state = 'Seller Dashboard';
                          setState(() {});
                          if (ref.read(authProvider).stripe?.needsOnboarding ??
                              true) {
                            getStripe = await StripeAccountsTable().queryRows(
                              queryFn: (q) => q.eqOrNull(
                                'user_id',
                                currentUserUid,
                              ),
                            );
                            if (!mounted) return;
                            ref.read(authProvider.notifier).updateUser(
                                  (e) => e.copyWith(
                                    stripe: functions.convertStripeStatus(
                                        getStripe?.firstOrNull),
                                  ),
                                );
                            setState(() {});
                          }
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 10.0),
                              child: Text(
                                'Seller Dashboard',
                                style: GoogleFonts.inter(
                                  color: _state == 'Seller Dashboard'
                                      ? AppColors.textPrimary
                                      : Color(0xFFAFAFB4),
                                  height: 2.0,
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: (_state == 'Seller Dashboard' ? 1 : 0)
                                  .toDouble(),
                              child: Container(
                                width: double.infinity,
                                height: 2.0,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
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
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (_state == 'Shop') {
                    return Builder(
                      builder: (context) => Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 32.0, 16.0, 32.0),
                        child: Container(
                          width: double.infinity,
                          height: 500.0,
                          child: custom_widgets.SwipeableProductStack(
                            width: double.infinity,
                            height: 500.0,
                            colorBuy: Color(0xFF8E6CFF),
                            colorHide: Color(0xFF3570FC),
                            colorSkip: AppColors.accent2,
                            cardBgColor: AppColors.backgroundSecondary,
                            priceTextColor: AppColors.primary,
                            emptyMessage: 'test',
                            products: ref.watch(feedProvider).feedProducts,
                            onBuy: (product) async {
                              final user = ref.read(authProvider);
                              final settings = user.userSettings;
                              final swipeEnabled =
                                  settings?.swipePaymentEnabled ?? false;

                              if (!swipeEnabled) {
                                // Standard checkout flow
                                context.pushNamed(
                                  CheckoutWidget.routeName,
                                  queryParameters: {
                                    'feedProductItem': product.serialize(),
                                  },
                                );
                                return;
                              }

                              // Quick Purchase: validate prerequisites
                              final hasAddress = user.shippingAddress != null &&
                                  (user.shippingAddress!.addressLine1)
                                      .isNotEmpty;
                              final defaultCard = user.paymentMethod
                                  .where((e) => e.isDefault)
                                  .firstOrNull;

                              if (!hasAddress || defaultCard == null) {
                                // Missing address or payment → redirect to Checkout
                                context.pushNamed(
                                  CheckoutWidget.routeName,
                                  queryParameters: {
                                    'feedProductItem': product.serialize(),
                                  },
                                );
                                return;
                              }

                              // Budget validation
                              final dailyBudget =
                                  settings?.dailyBudget ?? 0.0;
                              final dailyBudgetUsed =
                                  settings?.dailyBudgetUsed ?? 0.0;
                              final remaining =
                                  dailyBudget - dailyBudgetUsed;

                              if (dailyBudget > 0 &&
                                  product.price > remaining) {
                                // Budget exceeded → show error and redirect to Checkout
                                actions.toastificationshow(
                                  context,
                                  'Budget Exceeded',
                                  'Swipe Purchase Budget Exceeded',
                                  'error',
                                );
                                context.pushNamed(
                                  CheckoutWidget.routeName,
                                  queryParameters: {
                                    'feedProductItem': product.serialize(),
                                  },
                                );
                                return;
                              }

                              // All checks passed → show Quick Purchase popup
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (dialogContext) {
                                  return Dialog(
                                    elevation: 0,
                                    insetPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    alignment:
                                        AlignmentDirectional(0.0, 1.0)
                                            .resolve(
                                                Directionality.of(context)),
                                    child: WebViewAware(
                                      child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(dialogContext)
                                              .unfocus();
                                          FocusManager
                                              .instance.primaryFocus
                                              ?.unfocus();
                                        },
                                        child: QuickPurchasePopupWidget(
                                          feedProduct: product,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );

                              setState(() {});
                            },
                            onHide: (productId, index) async {
                              ref
                                  .read(feedProvider.notifier)
                                  .addToSwipedProductIds(productId);
                              ref
                                  .read(feedProvider.notifier)
                                  .removeAtIndexFromFeedProducts(index);
                              await actions.hideProduct(
                                currentUserUid,
                                productId,
                              );
                            },
                            onSkip: (productId, index) async {
                              ref
                                  .read(feedProvider.notifier)
                                  .addToSwipedProductIds(productId);
                              ref
                                  .read(feedProvider.notifier)
                                  .removeAtIndexFromFeedProducts(index);
                            },
                            onLike: (productId, index) async {
                              await Future.wait([
                                Future(() async {
                                  await actions.toggleWishlist(
                                    currentUserUid,
                                    productId,
                                  );
                                }),
                                Future(() async {
                                  ref
                                      .read(feedProvider.notifier)
                                      .updateFeedProductsAtIndex(
                                        index,
                                        (e) => e.copyWith(
                                            isInWishlist: !e.isInWishlist),
                                      );
                                  setState(() {});
                                }),
                              ]);
                            },
                            onTapDetails: (productId, index) async {
                              context.pushNamed(
                                HomeProductWidget.routeName,
                                queryParameters: {
                                  'productId': productId,
                                },
                              );
                            },
                            onEmpty: () async {},
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Builder(
                      builder: (context) {
                        final authData = ref.watch(authProvider);
                        if (authData.stripe?.onboardingCompleted ??
                            false) {
                          return Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back, ${authData.firstName}',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.0,
                                    ),
                                  ),
                                  Text(
                                    'Here\'s your business overview',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 40.0, 0.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundSecondary,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16.0, 12.0, 16.0, 12.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Revenue',
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.normal,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                            Text(
                                              valueOrDefault<String>(
                                                _jsonStr(
                                                  getSellerDashboard,
                                                  'revenue',
                                                ),
                                                '-',
                                              ),
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24.0,
                                              ),
                                            ),
                                            if (_jsonStr(getSellerDashboard, 'revenue_change_pct') != null)
                                              Text(
                                                '${_jsonStr(getSellerDashboard, 'revenue_change_pct')}% from last month',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xFF4ADE80),
                                                ),
                                              ),
                                          ].divide(SizedBox(height: 3.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 16.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  AppColors.backgroundSecondary,
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 12.0, 16.0, 16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    valueOrDefault<String>(
                                                      _jsonStr(
                                                        getSellerDashboard,
                                                        'active_listings',
                                                      ),
                                                      '-',
                                                    ),
                                                    style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Active',
                                                    style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: AppColors
                                                          .textSecondary,
                                                    ),
                                                  ),
                                                ].divide(SizedBox(height: 4.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  AppColors.backgroundSecondary,
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 12.0, 16.0, 16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    valueOrDefault<String>(
                                                      _jsonStr(
                                                        getSellerDashboard,
                                                        'total_views',
                                                      ),
                                                      '-',
                                                    ),
                                                    style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Views',
                                                    style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: AppColors
                                                          .textSecondary,
                                                    ),
                                                  ),
                                                ].divide(SizedBox(height: 4.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  AppColors.backgroundSecondary,
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 12.0, 16.0, 16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    valueOrDefault<String>(
                                                      _jsonStr(
                                                        getSellerDashboard,
                                                        'total_sales',
                                                      ),
                                                      '-',
                                                    ),
                                                    style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24.0,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Sales',
                                                    style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: AppColors
                                                          .textSecondary,
                                                    ),
                                                  ),
                                                ].divide(SizedBox(height: 4.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 16.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 40.0, 0.0, 0.0),
                                    child: Text(
                                      'Catalog New Items',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 12.0, 0.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF7D56FF),
                                            Color(0xFF6187F1)
                                          ],
                                          stops: [0.0, 1.0],
                                          begin:
                                              AlignmentDirectional(-1.0, -0.87),
                                          end: AlignmentDirectional(1.0, 0.87),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(24.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            FaIcon(
                                              FontAwesomeIcons.camera,
                                              color: AppColors.textPrimary,
                                              size: 30.0,
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(0.0, 8.0, 0.0, 0.0),
                                              child: Text(
                                                'AI Scan Item',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Take a photo to auto-catalog',
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.normal,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 16.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                  HomeDashoardInventoryAddWidget
                                                      .routeName);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .backgroundSecondary,
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 12.0, 16.0, 16.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons
                                                          .solidEdit,
                                                      color:
                                                          AppColors.secondary,
                                                      size: 22.0,
                                                    ),
                                                    Text(
                                                      'Manual Entry',
                                                      style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 14.0,
                                                      ),
                                                    ),
                                                  ].divide(
                                                      SizedBox(height: 8.0)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  AppColors.backgroundSecondary,
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      16.0, 12.0, 16.0, 16.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  FaIcon(
                                                    FontAwesomeIcons.shopify,
                                                    color: AppColors.secondary,
                                                    size: 22.0,
                                                  ),
                                                  Text(
                                                    'Shopify Sync',
                                                    style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ].divide(SizedBox(height: 8.0)),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 16.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 40.0, 0.0, 0.0),
                                    child: Text(
                                      'Quick Actions',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 16.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                  HomeDashoardInventoryWidget
                                                      .routeName);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .backgroundSecondary,
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 12.0, 16.0, 16.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons.boxes,
                                                      color:
                                                          AppColors.secondary,
                                                      size: 22.0,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  8.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Inventory',
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ),
                                                    if (_jsonStr(getSellerDashboard, 'active_listings') != null)
                                                      Text(
                                                        '${_jsonStr(getSellerDashboard, 'active_listings')} Items',
                                                        style: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: AppColors
                                                              .textSecondary,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                  HomeDashoardEarningsWidget
                                                      .routeName);
                                            },
                                            child: Container(
                                              height: 97.0,
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .backgroundSecondary,
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 12.0, 16.0, 16.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons
                                                          .chartLine,
                                                      color:
                                                          AppColors.secondary,
                                                      size: 22.0,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  8.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Analytics',
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 16.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 16.0, 0.0, 0.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                  HomeDashoardPromoteStep1Widget
                                                      .routeName);
                                            },
                                            child: Container(
                                              height: 97.0,
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .backgroundSecondary,
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 12.0, 16.0, 16.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons.bullhorn,
                                                      color:
                                                          AppColors.secondary,
                                                      size: 22.0,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  8.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Promote',
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              context.pushNamed(
                                                  HomeDashoardShortlistWidget
                                                      .routeName);
                                            },
                                            child: Container(
                                              height: 97.0,
                                              decoration: BoxDecoration(
                                                color: AppColors
                                                    .backgroundSecondary,
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 12.0, 16.0, 12.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    FaIcon(
                                                      FontAwesomeIcons.qrcode,
                                                      color:
                                                          AppColors.secondary,
                                                      size: 22.0,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  8.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Text(
                                                        'Shortlists',
                                                        style:
                                                            GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ),
                                                    if (_jsonStr(getSellerDashboard, 'shortlist_count') != null)
                                                      Text(
                                                        '${_jsonStr(getSellerDashboard, 'shortlist_count')} Items',
                                                        style: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          color: AppColors
                                                              .textSecondary,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ].divide(SizedBox(width: 16.0)),
                                    ),
                                  ),
                                  // Items to Ship section
                                  if (_itemsToShip.isNotEmpty) ...[
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 40.0, 0.0, 0.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Items to Ship',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          if (_pendingShipCount > 0)
                                            Text(
                                              '$_pendingShipCount pending',
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14.0,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 16.0, 0.0, 0.0),
                                      child: Column(
                                        children: _itemsToShip
                                            .map((order) =>
                                                SellerDashboardShipItemWidget(
                                                  order: order,
                                                  onShipped: () {
                                                    // Reload items to ship
                                                    Future(() async {
                                                      if (!mounted) return;
                                                      _itemsToShip =
                                                          await actions
                                                              .getSellerOrders(
                                                        statusFilter:
                                                            'to_ship',
                                                        limit: 3,
                                                      );
                                                      final counts =
                                                          await actions
                                                              .getSellerOrderCounts();
                                                      _pendingShipCount =
                                                          counts['to_ship'] ??
                                                              0;
                                                      if (mounted) {
                                                        setState(() {});
                                                      }
                                                    });
                                                  },
                                                ))
                                            .toList()
                                            .divide(SizedBox(height: 12.0)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 16.0, 0.0, 0.0),
                                      child: InkWell(
                                        onTap: () {
                                          context.pushNamed(
                                              HomeDashoardShippingWidget
                                                  .routeName);
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 12.0),
                                          decoration: BoxDecoration(
                                            color:
                                                AppColors.backgroundSecondary,
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'View All Orders',
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.0,
                                                color: AppColors.secondary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ]
                                    .addToStart(SizedBox(height: 28.0))
                                    .addToEnd(SizedBox(height: 32.0)),
                              ),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Start selling on Get It',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24.0,
                                          height: 1.5,
                                        ),
                                      ),
                                      Text(
                                        'Connect Stripe to get paid and enable payouts',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.normal,
                                          color: AppColors.textSecondary,
                                          fontSize: 16.0,
                                          height: 1.5,
                                        ),
                                      ),
                                      if (authData.stripe?.detailsSubmitted ?? false) ...[
                                        // Account submitted but not fully active — show status badge
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              0.0, 24.0, 0.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0, vertical: 14.0),
                                            decoration: BoxDecoration(
                                              color: AppColors.backgroundSecondary,
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  'Stripe Status',
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 4.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(int.parse(
                                                            (authData.stripe?.statusColor ?? '#9E9E9E')
                                                                .replaceFirst('#', ''),
                                                            radix: 16) |
                                                        0xFF000000),
                                                    borderRadius:
                                                        BorderRadius.circular(4.0),
                                                  ),
                                                  child: Text(
                                                    authData.stripe?.statusLabel ??
                                                        'Unknown',
                                                    style: GoogleFonts.inter(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ] else ...[
                                        // No account yet — show Connect Stripe button
                                        Padding(
                                          padding: EdgeInsetsDirectional.fromSTEB(
                                              16.0, 52.0, 16.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFF7D56FF),
                                                  Color(0xFF6187F1)
                                                ],
                                                stops: [0.0, 1.0],
                                                begin: AlignmentDirectional(
                                                    0.0, -1.0),
                                                end: AlignmentDirectional(0, 1.0),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: TextButton(
                                              onPressed: _connectingStripe
                                                  ? null
                                                  : () async {
                                                      setState(() => _connectingStripe = true);
                                                      try {
                                                        await actions
                                                            .startStripeConnectOnboarding();
                                                      } finally {
                                                        if (mounted) {
                                                          setState(() => _connectingStripe = false);
                                                        }
                                                      }
                                                    },
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Color(0x008E6CFF),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8.0),
                                                ),
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        16.0, 0.0, 16.0, 0.0),
                                              ),
                                              child: _connectingStripe
                                                  ? SizedBox(
                                                      width: 22.0,
                                                      height: 22.0,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2.0,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : Text(
                                                      'Connect Stripe',
                                                      style: GoogleFonts.inter(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      color: Color(0x00000000),
                                      child: ExpandableNotifier(
                                        controller:
                                            expandableExpandableController,
                                        child: ExpandablePanel(
                                          header: Text(
                                            'Why Stripe?',
                                            style: GoogleFonts.inter(
                                              color: AppColors.textPrimary,
                                              fontSize: 18.0,
                                              height: 1.5,
                                            ),
                                          ),
                                          collapsed: Container(),
                                          expanded: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                'Secure payments and payouts. Get It never stores your bank details.',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.normal,
                                                  color:
                                                      AppColors.textSecondary,
                                                  fontSize: 16.0,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                          theme: ExpandableThemeData(
                                            tapHeaderToExpand: true,
                                            tapBodyToExpand: false,
                                            tapBodyToCollapse: false,
                                            headerAlignment:
                                                ExpandablePanelHeaderAlignment
                                                    .center,
                                            hasIcon: true,
                                            iconColor: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]
                                  .addToStart(SizedBox(height: 24.0))
                                  .addToEnd(SizedBox(height: 32.0)),
                            ),
                          );
                        }
                      },
                    );
                  }
                },
              ),
            ),
            NavBarWidget(),
          ],
        ),
      ),
    );
  }
}

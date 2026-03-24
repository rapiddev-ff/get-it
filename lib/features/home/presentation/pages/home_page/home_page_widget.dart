import '/core/widgets/app_loading_indicator.dart';
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
import '/features/profile/presentation/pages/settings/settings_widget.dart';
import '/features/notifications/presentation/pages/notification/notification_widget.dart';
import '/features/home/presentation/pages/home_product/home_product_widget.dart';
import '/features/checkout/presentation/pages/checkout/checkout_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/earnings/home_dashoard_earnings_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/shipping/home_dashoard_shipping_widget.dart';
import '/features/home/presentation/pages/buyer_dashboard/purchases/buyer_purchases_widget.dart';
import '/features/home/presentation/pages/buyer_dashboard/order_detail/buyer_order_detail_widget.dart';
import '/features/wishlist/presentation/providers/wishlist_provider.dart';
import '/features/home/presentation/pages/seller_dashboard/inventory/home_dashoard_inventory_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/inventory_add/home_dashoard_inventory_add_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/ai_scan/ai_scan_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/shortlist/home_dashoard_shortlist_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/constants/app_constants.dart';
import '/core/utils/value_utils.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '/core/router/app_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class HomePageWidget extends ConsumerStatefulWidget {
  const HomePageWidget({super.key});

  static const String routeName = 'homePage';
  static const String routePath = 'homePage';

  @override
  ConsumerState<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends ConsumerState<HomePageWidget> {
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

  // Buyer Dashboard state
  List<Map<String, dynamic>> _recentPurchases = [];
  int _totalPurchaseCount = 0;

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
              ref.read(currentUserIdProvider),
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
            final uid = ref.read(currentUserIdProvider);
            _itemsToShip = await actions.getSellerOrders(
              sellerId: uid,
              statusFilter: 'to_ship',
              limit: 3,
            );
            final counts = await actions.getSellerOrderCounts(sellerId: uid);
            _pendingShipCount = counts['to_ship'] ?? 0;
          }),
          Future(() async {
            if (!mounted) return;
            final uid = ref.read(currentUserIdProvider);
            _recentPurchases = await actions.getBuyerOrders(
              buyerId: uid,
              limit: 5,
            );
            final counts = await actions.getBuyerOrderCounts(buyerId: uid);
            _totalPurchaseCount =
                (counts['active'] ?? 0) + (counts['delivered'] ?? 0) + (counts['cancelled'] ?? 0);
          }),
        ]);
      } catch (_) {
        // Network or API error — dashboard shows fallback values.
      }
      if (!mounted) return;
      setState(() {});
    });

    expandableExpandableController = ExpandableController(initialExpanded: true);
  }

  @override
  void dispose() {
    expandableExpandableController.dispose();
    actions.disposeFeedProductsStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  style: Theme.of(context).textTheme.titleMedium!,
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
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 53.0,
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          _state = 'Shop';
                          setState(() {});
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Shop',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.normal,
                                  color: _state == 'Shop'
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
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
                        onTap: () async {
                          _state = 'Sell';
                          setState(() {});
                          if (ref.read(authProvider).stripe?.needsOnboarding ??
                              true) {
                            getStripe = await StripeAccountsTable().queryRows(
                              queryFn: (q) => q.eqOrNull(
                                'user_id',
                                ref.read(currentUserIdProvider),
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Sell',
                                style: GoogleFonts.inter(
                                  color: _state == 'Sell'
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                  height: 2.0,
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: (_state == 'Sell' ? 1 : 0)
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
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          _state = 'Buy';
                          setState(() {});
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                'Buy',
                                style: GoogleFonts.inter(
                                  color: _state == 'Buy'
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                  height: 2.0,
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: (_state == 'Buy' ? 1 : 0)
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
              child: _state == 'Shop'
                  ? _buildShopTab()
                  : _state == 'Buy'
                      ? _buildBuyerDashboardTab()
                      : _buildSellerDashboardTab(),
            ),
            NavBarWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildShopTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Container(
        width: double.infinity,
        height: 500.0,
        child: custom_widgets.SwipeableProductStack(
          width: double.infinity,
          height: 500.0,
          colorBuy: AppColors.primary,
          colorHide: AppColors.brandBlueStrong,
          colorSkip: AppColors.accent2,
          cardBgColor: AppColors.backgroundSecondary,
          priceTextColor: AppColors.primary,
          emptyMessage: 'No Items Yet',
          products: ref.watch(feedProvider).feedProducts,
          onBuy: (product) async {
            final user = ref.read(authProvider);
            final settings = user.userSettings;
            final swipeEnabled = settings?.swipePaymentEnabled ?? false;

            if (!swipeEnabled) {
              context.pushNamed(
                CheckoutWidget.routeName,
                queryParameters: {
                  'feedProductItem': product.serialize(),
                },
              );
              return;
            }

            final hasAddress = user.shippingAddress != null &&
                (user.shippingAddress!.addressLine1).isNotEmpty;
            final defaultCard =
                user.paymentMethod.where((e) => e.isDefault).firstOrNull;

            if (!hasAddress || defaultCard == null) {
              context.pushNamed(
                CheckoutWidget.routeName,
                queryParameters: {
                  'feedProductItem': product.serialize(),
                },
              );
              return;
            }

            final dailyBudget = settings?.dailyBudget ?? 0.0;
            final dailyBudgetUsed = settings?.dailyBudgetUsed ?? 0.0;
            final remaining = dailyBudget - dailyBudgetUsed;

            if (dailyBudget > 0 && product.price > remaining) {
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

            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (dialogContext) {
                return Dialog(
                  elevation: 0,
                  insetPadding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  alignment: Alignment.bottomCenter
                      .resolve(Directionality.of(context)),
                  child: WebViewAware(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(dialogContext).unfocus();
                        FocusManager.instance.primaryFocus?.unfocus();
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
            ref.read(feedProvider.notifier).addToSwipedProductIds(productId);
            ref
                .read(feedProvider.notifier)
                .removeAtIndexFromFeedProducts(index);
            await actions.hideProduct(
              ref.read(currentUserIdProvider),
              productId,
            );
          },
          onSkip: (productId, index) async {
            ref.read(feedProvider.notifier).addToSwipedProductIds(productId);
            ref
                .read(feedProvider.notifier)
                .removeAtIndexFromFeedProducts(index);
          },
          onLike: (productId, index) async {
            await Future.wait([
              Future(() async {
                await actions.toggleWishlist(
                  ref.read(currentUserIdProvider),
                  productId,
                );
              }),
              Future(() async {
                ref.read(feedProvider.notifier).updateFeedProductsAtIndex(
                      index,
                      (e) => e.copyWith(isInWishlist: !e.isInWishlist),
                    );
                if (!mounted) return;
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
    );
  }

  Widget _buildSellerDashboardTab() {
    final authData = ref.watch(authProvider);
    if (authData.stripe?.onboardingCompleted ?? false) {
      return _buildSellerDashboardActive(authData);
    } else {
      return _buildSellerDashboardOnboarding(authData);
    }
  }

  Widget _buildSellerDashboardActive(dynamic authData) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, ${authData.firstName}',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Here\'s your business overview',
              style: Theme.of(context).textTheme.labelMedium!,
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Revenue',
                        style: Theme.of(context).textTheme.labelMedium!,
                      ),
                      Text(
                        valueOrDefault<String>(
                          _jsonStr(getSellerDashboard, 'revenue'),
                          '-',
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (_jsonStr(getSellerDashboard, 'revenue_change_pct') !=
                          null)
                        Text(
                          '${_jsonStr(getSellerDashboard, 'revenue_change_pct')}% from last month',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            color: AppColors.statusSuccess,
                          ),
                        ),
                    ].divide(SizedBox(height: 3.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  _buildStatCard('active_listings', 'Active'),
                  _buildStatCard('total_views', 'Views'),
                  _buildStatCard('total_sales', 'Sales'),
                ].divide(SizedBox(width: 16.0)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text(
                'Catalog New Items',
                style: Theme.of(context).textTheme.titleMedium!,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AiScanWidget()),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.brandPurple, AppColors.brandBlue],
                      stops: [0.0, 1.0],
                      begin: AlignmentDirectional(-1.0, -0.87),
                      end: AlignmentDirectional(1.0, 0.87),
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.camera,
                          color: AppColors.textPrimary,
                          size: 30.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'AI Scan Item',
                            style: Theme.of(context).textTheme.titleSmall!,
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
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  _buildCatalogActionCard(
                    icon: FontAwesomeIcons.solidPenToSquare,
                    label: 'Manual Entry',
                    onTap: () => context
                        .pushNamed(HomeDashoardInventoryAddWidget.routeName),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleMedium!,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  _buildQuickActionCard(
                    icon: FontAwesomeIcons.boxesStacked,
                    label: 'Inventory',
                    subtitle: _jsonStr(getSellerDashboard, 'active_listings') !=
                            null
                        ? '${_jsonStr(getSellerDashboard, 'active_listings')} Items'
                        : null,
                    onTap: () => context
                        .pushNamed(HomeDashoardInventoryWidget.routeName),
                  ),
                  _buildQuickActionCard(
                    icon: FontAwesomeIcons.chartLine,
                    label: 'Analytics',
                    onTap: () =>
                        context.pushNamed(HomeDashoardEarningsWidget.routeName),
                  ),
                ].divide(SizedBox(width: 16.0)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  _buildQuickActionCard(
                    icon: FontAwesomeIcons.qrcode,
                    label: 'Shortlists',
                    subtitle: _jsonStr(getSellerDashboard, 'shortlist_count') !=
                            null
                        ? '${_jsonStr(getSellerDashboard, 'shortlist_count')} Items'
                        : null,
                    onTap: () => context
                        .pushNamed(HomeDashoardShortlistWidget.routeName),
                  ),
                ],
              ),
            ),
            // Items to Ship section
            if (_itemsToShip.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Items to Ship',
                      style: Theme.of(context).textTheme.titleMedium!,
                    ),
                    if (_pendingShipCount > 0)
                      Text(
                        '$_pendingShipCount pending',
                        style: Theme.of(context).textTheme.labelMedium!,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Column(
                  children: _itemsToShip
                      .map((order) => SellerDashboardShipItemWidget(
                            order: order,
                            onShipped: () {
                              Future(() async {
                                if (!mounted) return;
                                final uid = ref.read(currentUserIdProvider);
                                _itemsToShip = await actions.getSellerOrders(
                                  sellerId: uid,
                                  statusFilter: 'to_ship',
                                  limit: 3,
                                );
                                final counts = await actions
                                    .getSellerOrderCounts(sellerId: uid);
                                _pendingShipCount = counts['to_ship'] ?? 0;
                                if (mounted) setState(() {});
                              });
                            },
                          ))
                      .toList()
                      .divide(SizedBox(height: 12.0)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: InkWell(
                  onTap: () =>
                      context.pushNamed(HomeDashoardShippingWidget.routeName),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Center(
                      child: Text(
                        'View All Orders',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.secondary),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ].addToStart(SizedBox(height: 28.0)).addToEnd(SizedBox(height: 32.0)),
        ),
      ),
    );
  }

  Widget _buildSellerDashboardOnboarding(dynamic authData) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start selling on Get It',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold, height: 1.5),
                ),
                Text(
                  'Connect Stripe to get paid and enable payouts',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(height: 1.5),
                ),
                if (authData.stripe?.detailsSubmitted ?? false) ...[
                  Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 14.0),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Stripe Status',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: Color(int.tryParse(
                                      (authData.stripe?.statusColor ??
                                              '#9E9E9E')
                                          .replaceFirst('#', ''),
                                      radix: 16) ??
                                  0x9E9E9E |
                                  0xFF000000),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              authData.stripe?.statusLabel ?? 'Unknown',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Padding(
                    padding:
                        EdgeInsets.only(left: 16.0, top: 52.0, right: 16.0),
                    child: Container(
                      width: double.infinity,
                      height: 56.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.brandPurple, AppColors.brandBlue],
                          stops: [0.0, 1.0],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextButton(
                        onPressed: _connectingStripe
                            ? null
                            : () async {
                                setState(() => _connectingStripe = true);
                                try {
                                  await actions.startStripeConnectOnboarding();
                                } finally {
                                  if (mounted) {
                                    setState(() => _connectingStripe = false);
                                  }
                                }
                              },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        child: _connectingStripe
                            ? SizedBox(
                                width: 22.0,
                                height: 22.0,
                                child: AppLoadingIndicator(
                                    strokeWidth: 2.0, color: Colors.white),
                              )
                            : Text(
                                'Connect Stripe',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                color: Color(0x00000000),
                child: ExpandableNotifier(
                  controller: expandableExpandableController,
                  child: ExpandablePanel(
                    header: Text(
                      'Why Stripe?',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.normal, height: 1.5),
                    ),
                    collapsed: Container(),
                    expanded: Column(
                      children: [
                        Text(
                          'Secure payments and payouts. Get It never stores your bank details.',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(height: 1.5),
                        ),
                      ],
                    ),
                    theme: ExpandableThemeData(
                      tapHeaderToExpand: true,
                      tapBodyToExpand: false,
                      tapBodyToCollapse: false,
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      hasIcon: true,
                      iconColor: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ].addToStart(SizedBox(height: 24.0)).addToEnd(SizedBox(height: 32.0)),
      ),
    );
  }

  Widget _buildBuyerDashboardTab() {
    final authData = ref.watch(authProvider);
    final userSettings = authData.userSettings;
    final swipeEnabled = userSettings?.swipePaymentEnabled ?? false;
    final dailyBudget = userSettings?.dailyBudget ?? 0.0;
    final dailyBudgetUsed = userSettings?.dailyBudgetUsed ?? 0.0;
    final remainingBudget = dailyBudget - dailyBudgetUsed;
    final showBudget = swipeEnabled && dailyBudget > 0;
    final wishlistCount = ref.watch(wishlistProvider).products.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, ${authData.firstName}',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'Here\'s your purchase overview',
              style: Theme.of(context).textTheme.labelMedium!,
            ),
            // Daily Budget + Wishlist row
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Daily Budget card
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Daily Budget',
                                style:
                                    Theme.of(context).textTheme.labelMedium!,
                              ),
                              Text(
                                showBudget
                                    ? '\$${NumberFormat('#,##0.00', 'en_US').format(remainingBudget)}'
                                    : 'Not set',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                showBudget
                                    ? 'of \$${NumberFormat('#,##0.00', 'en_US').format(dailyBudget)}'
                                    : ' ',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!,
                              ),
                            ].divide(SizedBox(height: 3.0)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    // Wishlist Items card
                    Expanded(
                      child: InkWell(
                        onTap: () => context.goNamed(
                          'wishlist',
                          extra: <String, dynamic>{
                            kTransitionInfoKey: TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.fade,
                              duration: Duration(milliseconds: 0),
                            ),
                          },
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.backgroundSecondary,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Wishlist',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!,
                              ),
                              Text(
                                '$wishlistCount',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Items',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!,
                              ),
                            ].divide(SizedBox(height: 3.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ),
            ),
            // Recent Purchases
            Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Purchases',
                    style: Theme.of(context).textTheme.titleMedium!,
                  ),
                  if (_totalPurchaseCount > 0)
                    Text(
                      '$_totalPurchaseCount total',
                      style: Theme.of(context).textTheme.labelMedium!,
                    ),
                ],
              ),
            ),
            if (_recentPurchases.isEmpty)
              Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Center(
                  child: Text(
                    'No purchases yet',
                    style: Theme.of(context).textTheme.labelLarge!,
                  ),
                ),
              )
            else ...[
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Column(
                  children: _recentPurchases
                      .map((order) => _buildBuyerOrderCard(order))
                      .toList()
                      .divide(SizedBox(height: 12.0)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: InkWell(
                  onTap: () =>
                      context.pushNamed(BuyerPurchasesWidget.routeName),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Center(
                      child: Text(
                        'View All Purchases',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.secondary),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ].addToStart(SizedBox(height: 28.0)).addToEnd(SizedBox(height: 32.0)),
        ),
      ),
    );
  }

  Widget _buildBuyerOrderCard(Map<String, dynamic> order) {
    final status = order['status']?.toString() ?? '';
    final orderId = order['id']?.toString() ?? '';
    final imageUrl = _getBuyerProductImageUrl(order);
    final items = order['order_items'];
    final productTitle = (items is List && items.isNotEmpty)
        ? items[0]['product_title']?.toString() ?? 'Unknown Product'
        : 'Unknown Product';
    final quantity = (items is List && items.isNotEmpty)
        ? (items[0]['quantity'] as num?)?.toInt() ?? 1
        : 1;

    return InkWell(
      onTap: () async {
        await context.pushNamed(
          BuyerOrderDetailWidget.routeName,
          queryParameters: {'orderId': orderId},
        );
        // Reload buyer data after returning
        final uid = ref.read(currentUserIdProvider);
        _recentPurchases = await actions.getBuyerOrders(buyerId: uid, limit: 5);
        final counts = await actions.getBuyerOrderCounts(buyerId: uid);
        _totalPurchaseCount =
            (counts['active'] ?? 0) + (counts['delivered'] ?? 0) + (counts['cancelled'] ?? 0);
        if (mounted) setState(() {});
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(left: 10.0, top: 16.0, right: 16.0, bottom: 16.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        width: 66.0,
                        height: 66.0,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 66.0,
                          height: 66.0,
                          color: AppColors.backgroundPrimary,
                          child:
                              Icon(Icons.image, color: AppColors.textSecondary),
                        ),
                      )
                    : Container(
                        width: 66.0,
                        height: 66.0,
                        color: AppColors.backgroundPrimary,
                        child:
                            Icon(Icons.image, color: AppColors.textSecondary),
                      ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productTitle,
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Qty: $quantity',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelSmall!,
                    ),
                    RichText(
                      textScaler: MediaQuery.of(context).textScaler,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Order #${order['order_number'] ?? ''}',
                            style: Theme.of(context).textTheme.bodySmall!,
                          ),
                          TextSpan(text: ' • '),
                          TextSpan(
                            text:
                                '\$${NumberFormat('#,##0.00', 'en_US').format((order['total_amount'] as num?)?.toDouble() ?? 0.0)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: AppColors.brandBlueMedium),
                          ),
                        ],
                        style: Theme.of(context).textTheme.bodyMedium!,
                      ),
                    ),
                  ].divide(SizedBox(height: 2.0)),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: _buyerStatusColor(status).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Text(
                    _buyerStatusLabel(status),
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 11.0,
                          color: _buyerStatusColor(status),
                        ),
                  ),
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
        ),
      ),
    );
  }

  String _getBuyerProductImageUrl(Map<String, dynamic> order) {
    final items = order['order_items'];
    if (items is List && items.isNotEmpty) {
      final product = items[0]['products'];
      if (product is Map) {
        return product['main_image_url']?.toString() ?? '';
      }
    }
    return '';
  }

  Color _buyerStatusColor(String status) {
    switch (status) {
      case 'sale_pending':
        return AppColors.statusWarning;
      case 'paid':
        return AppColors.secondary;
      case 'shipped':
        return AppColors.brandBlueDark;
      case 'delivered':
        return AppColors.statusSuccess;
      case 'cancelled':
        return AppColors.error;
      case 'refunded':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _buyerStatusLabel(String status) {
    switch (status) {
      case 'sale_pending':
        return 'Pending';
      case 'paid':
        return 'Purchased';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      case 'refunded':
        return 'Refunded';
      default:
        return status;
    }
  }

  Widget _buildStatCard(String key, String label) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(left: 16.0, top: 12.0, right: 16.0, bottom: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                valueOrDefault<String>(
                  _jsonStr(getSellerDashboard, key),
                  '-',
                ),
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium!,
              ),
            ].divide(SizedBox(height: 4.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildCatalogActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 97.0,
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: 16.0, top: 12.0, right: 16.0, bottom: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  icon,
                  color: AppColors.secondary,
                  size: 22.0,
                ),
                Text(
                  label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ].divide(SizedBox(height: 8.0)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 97.0,
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                left: 16.0, top: 12.0, right: 16.0, bottom: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  icon,
                  color: AppColors.secondary,
                  size: 22.0,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.labelMedium!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

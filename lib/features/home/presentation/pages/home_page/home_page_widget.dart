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
import '/features/home/presentation/pages/seller_dashboard/inventory/home_dashoard_inventory_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/inventory_add/home_dashoard_inventory_add_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/promote_step1/home_dashoard_promote_step1_widget.dart';
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
                          _state = 'Seller Dashboard';
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
                                'Seller Dashboard',
                                style: GoogleFonts.inter(
                                  color: _state == 'Seller Dashboard'
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
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
              child: _state == 'Shop'
                  ? _buildShopTab()
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
          colorHide: Color(0xFF3570FC),
          colorSkip: AppColors.accent2,
          cardBgColor: AppColors.backgroundSecondary,
          priceTextColor: AppColors.primary,
          emptyMessage: 'test',
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
                  Expanded(
                    child: Container(
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
                              FontAwesomeIcons.shopify,
                              color: AppColors.secondary,
                              size: 22.0,
                            ),
                            Text(
                              'Shopify Sync',
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
                ].divide(SizedBox(width: 16.0)),
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
                    height: 97.0,
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
                    icon: FontAwesomeIcons.bullhorn,
                    label: 'Promote',
                    height: 97.0,
                    onTap: () => context
                        .pushNamed(HomeDashoardPromoteStep1Widget.routeName),
                  ),
                  _buildQuickActionCard(
                    icon: FontAwesomeIcons.qrcode,
                    label: 'Shortlists',
                    subtitle: _jsonStr(getSellerDashboard, 'shortlist_count') !=
                            null
                        ? '${_jsonStr(getSellerDashboard, 'shortlist_count')} Items'
                        : null,
                    height: 97.0,
                    onTap: () => context
                        .pushNamed(HomeDashoardShortlistWidget.routeName),
                  ),
                ].divide(SizedBox(width: 16.0)),
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
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                    height: 1.5,
                  ),
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
                              color: Color(int.parse(
                                      (authData.stripe?.statusColor ??
                                              '#9E9E9E')
                                          .replaceFirst('#', ''),
                                      radix: 16) |
                                  0xFF000000),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              authData.stripe?.statusLabel ?? 'Unknown',
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
                          backgroundColor: Color(0x008E6CFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 18.0,
                        height: 1.5,
                      ),
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
    double? height,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: height,
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

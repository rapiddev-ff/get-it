import 'dart:convert';

import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/core/constants/app_constants.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import '/core/nav_bar/nav_bar_widget.dart';
import '/home/checkout/fast_checkout/fast_checkout_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/home/presentation/providers/feed_provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends ConsumerStatefulWidget {
  const HomePageWidget({super.key});

  static const String routeName = 'homePage';
  static const String routePath = 'homePage';

  @override
  ConsumerState<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends ConsumerState<HomePageWidget> {
  late HomePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = HomePageModel();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          _model.getFeed = await actions.initFeedProductsStream(
            currentUserUid,
            ref.read(feedProvider).swipedProductIds.toList(),
          );
          if (_model.getFeed != null && mounted) {
            ref.read(feedProvider.notifier).setProducts(_model.getFeed!);
          }
        }),
        Future(() async {
          _model.getSellerDashboard = await actions.callRpc(
            context,
            'get_seller_dashboard',
            <String, dynamic>{},
          );
        }),
      ]);
      if (mounted) setState(() {});
    });

    _model.expandableExpandableController =
        ExpandableController(initialExpanded: true)
          ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ── helpers ────────────────────────────────────────────────────────────────

  static String _jsonStr(dynamic json, String key, [String fallback = '-']) =>
      (json is Map) ? (json[key]?.toString() ?? fallback) : fallback;

  static String _getRequirementMessages(List<String> requirements) {
    const Map<String, String> messages = {
      'individual.first_name': 'Enter your first name',
      'individual.last_name': 'Enter your last name',
      'individual.dob.day': 'Enter your date of birth',
      'individual.dob.month': 'Enter your date of birth',
      'individual.dob.year': 'Enter your date of birth',
      'individual.email': 'Enter your email address',
      'individual.phone': 'Enter your phone number',
      'individual.ssn_last_4': 'Enter the last 4 digits of your SSN',
      'individual.ssn_full': 'Enter your full SSN',
      'individual.id_number': 'Enter your ID number',
      'individual.address.line1': 'Enter your street address',
      'individual.address.city': 'Enter your city',
      'individual.address.state': 'Enter your state',
      'individual.address.postal_code': 'Enter your postal code',
      'individual.address.country': 'Enter your country',
      'individual.verification.document': 'Upload an identity document',
      'individual.verification.additional_document':
          'Upload an additional document',
      'company.name': 'Enter your company name',
      'company.tax_id': 'Enter your tax ID',
      'company.address.line1': 'Enter your company address',
      'company.address.city': 'Enter your company city',
      'company.address.state': 'Enter your company state',
      'company.address.postal_code': 'Enter your company postal code',
      'company.address.country': 'Enter your company country',
      'company.phone': 'Enter your company phone number',
      'company.verification.document': 'Upload a company document',
      'business_profile.url': 'Enter your business website',
      'business_profile.mcc': 'Select your business category',
      'business_profile.product_description':
          'Describe your product or service',
      'external_account': 'Add a bank account for payouts',
      'bank_account.account_number': 'Enter your bank account number',
      'bank_account.routing_number': 'Enter your bank routing number',
      'tos_acceptance.date': 'Accept the terms of service',
      'tos_acceptance.ip': 'Accept the terms of service',
    };
    if (requirements.isEmpty) return '';
    return requirements
        .map((req) => messages[req] ?? 'Additional information required')
        .toSet()
        .join('\n');
  }

  static StripeAccountStatusStruct _convertStripeStatus(
      StripeAccountsRow? stripeData) {
    if (stripeData == null) {
      return StripeAccountStatusStruct(
        hasAccount: false,
        chargesEnabled: false,
        payoutsEnabled: false,
        detailsSubmitted: false,
        onboardingCompleted: false,
        needsOnboarding: true,
        hasPastDue: false,
        currentlyDue: [],
        pastDue: [],
      );
    }
    List<String> currentlyDue = [];
    List<String> pastDue = [];
    String? disabledReason;
    if (stripeData.requirements != null) {
      try {
        Map<String, dynamic> requirements;
        if (stripeData.requirements is String) {
          requirements =
              jsonDecode(stripeData.requirements as String) as Map<String, dynamic>;
        } else if (stripeData.requirements is Map) {
          requirements =
              Map<String, dynamic>.from(stripeData.requirements as Map);
        } else {
          requirements = {};
        }
        currentlyDue = List<String>.from(requirements['currently_due'] ?? []);
        pastDue = List<String>.from(requirements['past_due'] ?? []);
        disabledReason = requirements['disabled_reason'] as String?;
      } catch (e) {
        debugPrint('Error parsing requirements: $e');
      }
    }
    return StripeAccountStatusStruct(
      hasAccount: true,
      stripeAccountId: stripeData.stripeAccountId,
      chargesEnabled: stripeData.chargesEnabled ?? false,
      payoutsEnabled: stripeData.payoutsEnabled ?? false,
      detailsSubmitted: stripeData.detailsSubmitted ?? false,
      onboardingCompleted: stripeData.onboardingCompleted ?? false,
      needsOnboarding: !(stripeData.onboardingCompleted ?? false),
      disabledReason: disabledReason,
      currentlyDue: currentlyDue,
      pastDue: pastDue,
      hasPastDue: pastDue.isNotEmpty,
    );
  }

  // ── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedProvider);
    final userData = ref.watch(authProvider);

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                  icon: const Icon(Icons.menu,
                      color: AppColors.white, size: 24.0),
                  onPressed: () => context.pushNamed('settings'),
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
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                  icon: const Icon(Icons.notifications_none,
                      color: AppColors.white, size: 20.0),
                  onPressed: () => context.pushNamed('notification'),
                ),
              ],
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0.0,
          ),
        ),
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(child: _buildBody(feedState, userData)),
            const NavBarWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      width: double.infinity,
      height: 53.0,
      decoration:
          const BoxDecoration(color: AppColors.backgroundSecondary),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  _model.state = 'Shop';
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                      child: Text(
                        'Shop',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.normal,
                          color: _model.state == 'Shop'
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          height: 2.0,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity:
                          (_model.state == 'Shop' ? 1 : 0).toDouble(),
                      child: Container(
                        width: double.infinity,
                        height: 2.0,
                        decoration: const BoxDecoration(
                            color: AppColors.secondary),
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
                  _model.state = 'Seller Dashboard';
                  setState(() {});
                  if (ref.read(authProvider).stripe.needsOnboarding) {
                    _model.getStripe =
                        await StripeAccountsTable().queryRows(
                      queryFn: (q) =>
                          q.eqOrNull('user_id', currentUserUid),
                    );
                    ref.read(authProvider.notifier).updateUser(
                          (e) => e
                            ..stripe = _convertStripeStatus(
                                _model.getStripe?.firstOrNull),
                        );
                    setState(() {});
                  }
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                      child: Text(
                        'Seller Dashboard',
                        style: GoogleFonts.inter(
                          color: _model.state == 'Seller Dashboard'
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          height: 2.0,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity:
                          (_model.state == 'Seller Dashboard' ? 1 : 0)
                              .toDouble(),
                      child: Container(
                        width: double.infinity,
                        height: 2.0,
                        decoration: const BoxDecoration(
                            color: AppColors.secondary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(FeedState feedState, UserDataStruct userData) {
    if (_model.state == 'Shop') {
      return Builder(
        builder: (context) => Padding(
          padding:
              const EdgeInsetsDirectional.fromSTEB(16.0, 32.0, 16.0, 32.0),
          child: SizedBox(
            width: double.infinity,
            height: 500.0,
            child: custom_widgets.SwipeableProductStack(
              width: double.infinity,
              height: 500.0,
              colorBuy: const Color(0xFF8E6CFF),
              colorHide: const Color(0xFF3570FC),
              colorSkip: AppColors.accent2,
              cardBgColor: AppColors.backgroundSecondary,
              priceTextColor: AppColors.primary,
              emptyMessage: 'test',
              products: feedState.products,
              onBuy: (product) async {
                if (userData.userSettings.swipePaymentEnabled) {
                  _model.createOrder = await OrdersTable().insert({
                    'buyer_id': currentUserUid,
                    'seller_id': product.sellerId,
                    'total_amount': product.price,
                    'tax_amount': 10.0,
                    'status': 'pending',
                    'subtotal': product.price,
                  });
                  if (!mounted) return;
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (dialogContext) => Dialog(
                      elevation: 0,
                      insetPadding: EdgeInsets.zero,
                      backgroundColor: Colors.transparent,
                      alignment: AlignmentDirectional(0.0, 1.0)
                          .resolve(Directionality.of(context)),
                      child: WebViewAware(
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(dialogContext).unfocus();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: FastCheckoutWidget(
                            feedProduct: product,
                            orderId: _model.createOrder!.id,
                          ),
                        ),
                      ),
                    ),
                  );
                  await actions.payWithSavedCard(
                    _model.createOrder!.id,
                    userData.paymentMethod
                        .where((e) => e.isDefault)
                        .toList()
                        .firstOrNull!
                        .id,
                    7,
                  );
                } else {
                  if (!mounted) return;
                  context.pushNamed(
                    'checkout',
                    queryParameters: {
                      'feedProductItem': product.serialize(),
                    },
                  );
                }
                if (mounted) setState(() {});
              },
              onHide: (productId, index) async {},
              onSkip: (productId, index) async {},
              onLike: (productId, index) async {
                await Future.wait([
                  Future(() async {
                    await actions.toggleWishlist(
                      currentUserUid,
                      productId,
                    );
                  }),
                  Future(() async {
                    ref.read(feedProvider.notifier).updateProductAtIndex(
                          index,
                          (e) => e..isInWishlist = !e.isInWishlist,
                        );
                    if (mounted) setState(() {});
                  }),
                ]);
              },
              onTapDetails: (productId, index) async {
                context.pushNamed(
                  'homeProduct',
                  queryParameters: {'productId': productId},
                );
              },
              onEmpty: () async {},
            ),
          ),
        ),
      );
    } else {
      return _buildSellerDashboard(userData);
    }
  }

  Widget _buildSellerDashboard(UserDataStruct userData) {
    if (userData.stripe.onboardingCompleted) {
      return _buildDashboardContent();
    } else {
      return _buildStripeOnboarding(userData);
    }
  }

  Widget _buildDashboardContent() {
    final dash = _model.getSellerDashboard;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, ${ref.watch(authProvider).firstName}',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Here\'s your business overview',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.normal,
                color: AppColors.textSecondary,
              ),
            ),
            // Revenue card
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 12.0, 16.0, 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            _jsonStr(dash, 'revenue'), '-'),
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${_jsonStr(dash, 'revenue_change_pct', '0')}% from last month',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF4ADE80),
                        ),
                      ),
                    ].divide(const SizedBox(height: 3.0)),
                  ),
                ),
              ),
            ),
            // Stats row
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
              child: Row(
                children: [
                  Expanded(
                      child: _statCard(
                          _jsonStr(dash, 'active_listings'), 'Active')),
                  Expanded(
                      child:
                          _statCard(_jsonStr(dash, 'total_views'), 'Views')),
                  Expanded(
                      child:
                          _statCard(_jsonStr(dash, 'total_sales'), 'Sales')),
                ].divide(const SizedBox(width: 16.0)),
              ),
            ),
            // Catalog New Items
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
              child: Text(
                'Catalog New Items',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7D56FF), Color(0xFF6187F1)],
                    stops: [0.0, 1.0],
                    begin: AlignmentDirectional(-1.0, -0.87),
                    end: AlignmentDirectional(1.0, 0.87),
                  ),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.camera,
                          color: AppColors.textPrimary, size: 30.0),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0, 8, 0, 0),
                        child: Text(
                          'AI Scan Item',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: AppColors.textPrimary,
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
            // Catalog actions row
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () =>
                          context.pushNamed('homeDashoardInventoryAdd'),
                      child: _actionCard(
                          FontAwesomeIcons.solidPenToSquare, 'Manual Entry',
                          sub: null),
                    ),
                  ),
                  Expanded(
                    child: _actionCard(
                        FontAwesomeIcons.shopify, 'Shopify Sync',
                        sub: null),
                  ),
                ].divide(const SizedBox(width: 16.0)),
              ),
            ),
            // Quick Actions
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
              child: Text(
                'Quick Actions',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () =>
                          context.pushNamed('homeDashoardInventory'),
                      child: _actionCard(
                          FontAwesomeIcons.boxesStacked, 'Inventory',
                          sub:
                              '${_jsonStr(dash, 'active_listings', '0')} Items'),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () =>
                          context.pushNamed('homeDashoardEarnings'),
                      child: _actionCard(
                          FontAwesomeIcons.chartLine, 'Analytics',
                          sub: null, height: 97.0),
                    ),
                  ),
                ].divide(const SizedBox(width: 16.0)),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () =>
                          context.pushNamed('homeDashoardPromoteStep1'),
                      child: _actionCard(
                          FontAwesomeIcons.bullhorn, 'Promote',
                          sub: null, height: 97.0),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () =>
                          context.pushNamed('homeDashoardShortlist'),
                      child: _actionCard(
                          FontAwesomeIcons.qrcode, 'Shortlists',
                          sub:
                              '${valueOrDefault<String>(_jsonStr(dash, 'shortlist_count'), '0')} Items',
                          height: 97.0),
                    ),
                  ),
                ].divide(const SizedBox(width: 16.0)),
              ),
            ),
          ]
              .addToStart(const SizedBox(height: 28.0))
              .addToEnd(const SizedBox(height: 32.0)),
        ),
      ),
    );
  }

  Widget _statCard(String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding:
            const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                  color: AppColors.textPrimary),
            ),
            Text(
              label,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.normal,
                  color: AppColors.textSecondary),
            ),
          ].divide(const SizedBox(height: 4.0)),
        ),
      ),
    );
  }

  Widget _actionCard(IconData icon, String label,
      {String? sub, double? height}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding:
            const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(icon, color: AppColors.secondary, size: 22.0),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (sub != null)
              Text(
                sub,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.normal,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStripeOnboarding(UserDataStruct userData) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
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
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
                Text(
                  _getRequirementMessages(
                      userData.stripe.currentlyDue.toList()),
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                    color: AppColors.textPrimary,
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 52.0, 16.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    height: 56.0,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7D56FF), Color(0xFF6187F1)],
                        stops: [0.0, 1.0],
                        begin: AlignmentDirectional(0.0, -1.0),
                        end: AlignmentDirectional(0, 1.0),
                      ),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        await actions.startStripeConnectOnboarding();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        backgroundColor: Colors.transparent,
                      ),
                      child: Text(
                        'Connect Stripe',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                color: const Color(0x00000000),
                child: ExpandableNotifier(
                  controller: _model.expandableExpandableController,
                  child: ExpandablePanel(
                    header: Text(
                      'Why Stripe?',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                    ),
                    collapsed: const SizedBox.shrink(),
                    expanded: Column(
                      children: [
                        Text(
                          'Secure payments and payouts. Get It never stores your bank details.',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            color: AppColors.textSecondary,
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
                          ExpandablePanelHeaderAlignment.center,
                      hasIcon: true,
                      iconColor: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]
            .addToStart(const SizedBox(height: 24.0))
            .addToEnd(const SizedBox(height: 32.0)),
      ),
    );
  }
}

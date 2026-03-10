import '/features/auth/data/supabase_auth/auth_util.dart';
import '/backend/schema/enums/enums.dart';
import '/features/home/domain/models/seller_product_model.dart';
import '/features/home/domain/models/seller_model.dart';
import '/features/messages/domain/models/conversation_model.dart';
import '/features/home/presentation/widgets/empty_state/empty_state_widget.dart';
import '/features/home/presentation/pages/home_seller_product/home_seller_product_widget.dart';
import '/features/home/presentation/pages/home_seller_profile_more/home_seller_profile_more_widget.dart';
import '/features/home/presentation/pages/seller_dashboard/shortlist_item/shortlist_item_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/core/theme/app_colors.dart';
import '/core/constants/app_constants.dart';
import '/core/utils/value_utils.dart';
import '/core/utils/list_extensions.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/index.dart';
import '/features/messages/presentation/providers/messages_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:webviewx_plus/webviewx_plus.dart';

class HomeSellerProfileWidget extends ConsumerStatefulWidget {
  const HomeSellerProfileWidget({
    super.key,
    required this.sellerId,
  });

  final String? sellerId;

  static String routeName = 'homeSellerProfile';
  static String routePath = 'homeSellerProfile';

  @override
  ConsumerState<HomeSellerProfileWidget> createState() =>
      _HomeSellerProfileWidgetState();
}

class _HomeSellerProfileWidgetState
    extends ConsumerState<HomeSellerProfileWidget> {
  // Local state fields (inlined from model).
  String state = 'Products';
  String choosenFilter = 'All';
  List<SellerProduct> products = [];
  String roleState = 'As Seller';

  // Action output results.
  Seller? getSellerData;
  Conversation? getOrCreateConversation;

  // Text field state.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;

  // List helper methods.
  void addToProducts(SellerProduct item) => products.add(item);
  void removeFromProducts(SellerProduct item) => products.remove(item);
  void removeAtIndexFromProducts(int index) => products.removeAt(index);
  void insertAtIndexInProducts(int index, SellerProduct item) =>
      products.insert(index, item);
  void updateProductsAtIndex(int index, Function(SellerProduct) updateFn) =>
      products[index] = updateFn(products[index]);

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final sellerId = widget.sellerId;
      if (!mounted || sellerId == null || sellerId.isEmpty) return;
      try {
        getSellerData = await actions.getSellerInfo(
          sellerId,
          currentUserUid,
        );
      } catch (_) {
        // Network or API error — leave getSellerData null (shimmer stays).
      }
      if (!mounted) return;
      setState(() {});
    });

    textController ??= TextEditingController();
    textFieldFocusNode ??= FocusNode();
    textFieldFocusNode!.addListener(() => setState(() {}));
  }

  Future<void> _refreshSellerData() async {
    final updated = await actions.getSellerInfo(
      widget.sellerId!,
      currentUserUid,
    );
    if (!mounted) return;
    if (updated != null) {
      setState(() {
        getSellerData = updated;
      });
    }
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
    super.dispose();
  }

  Widget _buildShimmerProfile() {
    return Shimmer.fromColors(
      baseColor: AppColors.backgroundSecondary,
      highlightColor: Colors.white.withValues(alpha: 0.1),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile header: avatar + username + rating + stats
            Row(
              children: [
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSecondary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120.0,
                        height: 18.0,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        width: 180.0,
                        height: 14.0,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundSecondary,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: List.generate(
                          3,
                          (_) => Column(
                            children: [
                              Container(
                                width: 30.0,
                                height: 16.0,
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundSecondary,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Container(
                                width: 45.0,
                                height: 12.0,
                                decoration: BoxDecoration(
                                  color: AppColors.backgroundSecondary,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                              ),
                            ],
                          ),
                        ).divide(SizedBox(width: 24.0)).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Bio lines
            SizedBox(height: 24.0),
            Container(
              width: double.infinity,
              height: 14.0,
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              width: 200.0,
              height: 14.0,
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            // Message button
            SizedBox(height: 24.0),
            Container(
              width: double.infinity,
              height: 56.0,
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
            // Tabs
            SizedBox(height: 28.0),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: Container(
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
              ],
            ),
            // Product grid skeleton (2x2)
            SizedBox(height: 20.0),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 0.7,
              ),
              itemCount: 4,
              itemBuilder: (_, __) => Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
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
                    Icons.arrow_back,
                    color: AppColors.info,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
                Text(
                  'Seller Profile',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                ),
                Builder(
                  builder: (context) => IconButton(
                    style: IconButton.styleFrom(
                      minimumSize: Size(40.0, 40.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    icon: Icon(
                      Icons.more_vert,
                      color: AppColors.info,
                      size: 20.0,
                    ),
                    onPressed: () async {
                      await showAlignedDialog(
                        context: context,
                        isGlobal: false,
                        avoidOverflow: true,
                        targetAnchor: AlignmentDirectional(-4.0, 5.5)
                            .resolve(Directionality.of(context)),
                        followerAnchor: AlignmentDirectional(0.0, 0.0)
                            .resolve(Directionality.of(context)),
                        builder: (dialogContext) {
                          return Material(
                            color: Colors.transparent,
                            child: WebViewAware(
                              child: GestureDetector(
                                onTap: () {
                                  FocusScope.of(dialogContext).unfocus();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                child: HomeSellerProfileMoreWidget(
                                  userId: widget.sellerId!,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: getSellerData == null
            ? _buildShimmerProfile()
            : Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            width: 80.0,
                            height: 80.0,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CachedNetworkImage(
                              fadeInDuration: Duration(milliseconds: 100),
                              fadeOutDuration: Duration(milliseconds: 100),
                              imageUrl: valueOrDefault<String>(
                                getSellerData?.avatarUrl,
                                'https://media.istockphoto.com/id/1223671392/vector/default-profile-picture-avatar-photo-placeholder-vector-illustration.jpg?s=612x612&w=0&k=20&c=s0aTdmT5aU6b8ot7VKm11DeID6NctRCpB755rA1BIP0=',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    getSellerData?.username,
                                    'N/A',
                                  ),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 8.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      RatingBarIndicator(
                                        itemBuilder: (context, index) => Icon(
                                          Icons.star_rounded,
                                          color: Color(0xFFFACC15),
                                        ),
                                        direction: Axis.horizontal,
                                        rating: valueOrDefault<double>(
                                          roleState == 'As Buyer'
                                              ? getSellerData?.ratingAsBuyer
                                              : getSellerData?.ratingAsSeller,
                                          0.0,
                                        ),
                                        unratedColor: Color(0xFF7B7B7B),
                                        itemCount: 5,
                                        itemSize: 18.0,
                                      ),
                                      Text(
                                        valueOrDefault<String>(
                                          (roleState == 'As Buyer'
                                                  ? getSellerData?.ratingAsBuyer
                                                  : getSellerData
                                                      ?.ratingAsSeller)
                                              ?.toString(),
                                          '0',
                                        ),
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.0,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        '(${(roleState == 'As Buyer' ? getSellerData?.totalReviewsAsBuyer : getSellerData?.totalReviewsAsSeller)?.toString()}) reviews',
                                        style: GoogleFonts.inter(
                                          fontSize: 14.0,
                                          color: Color(0xFFAFAFB4),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 8.0)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 8.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            valueOrDefault<String>(
                                              getSellerData?.totalProducts
                                                  .toString(),
                                              '0',
                                            ),
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          Text(
                                            'Items',
                                            style: GoogleFonts.inter(
                                              fontSize: 12.0,
                                              color: Color(0xFFAFAFB4),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            valueOrDefault<String>(
                                              getSellerData?.totalSales
                                                  .toString(),
                                              '0 ',
                                            ),
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          Text(
                                            'Sold',
                                            style: GoogleFonts.inter(
                                              fontSize: 12.0,
                                              color: Color(0xFFAFAFB4),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            valueOrDefault<String>(
                                              getSellerData?.followersCount
                                                  .toString(),
                                              '0',
                                            ),
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          Text(
                                            'Followers',
                                            style: GoogleFonts.inter(
                                              fontSize: 12.0,
                                              color: Color(0xFFAFAFB4),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ].divide(SizedBox(width: 24.0)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ].divide(SizedBox(width: 12.0)),
                      ),
                      if (valueOrDefault<String>(
                            getSellerData?.bio,
                            'N/A',
                          ) !=
                          '')
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Text(
                            valueOrDefault<String>(
                              getSellerData?.bio,
                              'N/A',
                            ),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                        child: Container(
                          width: double.infinity,
                          height: 56.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF7D56FF), Color(0xFF6187F1)],
                              stops: [0.0, 1.0],
                              begin: AlignmentDirectional(0.0, -1.0),
                              end: AlignmentDirectional(0, 1.0),
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: TextButton.icon(
                            onPressed: () async {
                              getOrCreateConversation =
                                  await actions.getOrCreateConversation(
                                widget.sellerId!,
                                '',
                              );
                              ref
                                  .read(messagesProvider.notifier)
                                  .setCurrentConversation(
                                      getOrCreateConversation!);
                              setState(() {});

                              context.pushNamed(
                                ChatPageWidget.routeName,
                                queryParameters: {
                                  'conversation':
                                      getOrCreateConversation?.serialize(),
                                },
                              );

                              setState(() {});
                            },
                            icon: Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: Colors.white,
                              size: 24.0,
                            ),
                            label: Text(
                              'Message',
                              style: GoogleFonts.inter(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  16.0, 0.0, 16.0, 0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 53.0,
                              decoration: BoxDecoration(),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        roleState = 'As Buyer';
                                        setState(() {});
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 10.0),
                                            child: Text(
                                              'As Buyer',
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14.0,
                                                color: roleState == 'As Buyer'
                                                    ? AppColors.textPrimary
                                                    : Color(0xFFAFAFB4),
                                                height: 2.0,
                                              ),
                                            ),
                                          ),
                                          Opacity(
                                            opacity: (roleState == 'As Buyer'
                                                    ? 1
                                                    : 0)
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
                                        roleState = 'As Seller';
                                        setState(() {});
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 0.0, 0.0, 10.0),
                                            child: Text(
                                              'As Seller',
                                              style: GoogleFonts.inter(
                                                fontSize: 14.0,
                                                color: roleState == 'As Seller'
                                                    ? AppColors.textPrimary
                                                    : Color(0xFFAFAFB4),
                                                height: 2.0,
                                              ),
                                            ),
                                          ),
                                          Opacity(
                                            opacity: (roleState == 'As Seller'
                                                    ? 1
                                                    : 0)
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
                            roleState == 'As Buyer'
                                ? _buildReviewsSection(
                                    reviews: getSellerData?.reviewsAsBuyer
                                            .toList() ??
                                        [],
                                    hasButton: false,
                                  )
                                : _buildReviewsSection(
                                    reviews: getSellerData?.reviewsAsSeller
                                            .toList() ??
                                        [],
                                    hasButton: getSellerData
                                            ?.purchasedProducts.isNotEmpty ??
                                        false,
                                    buttonText: 'Write a Review',
                                  ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              child: InkWell(
                                onTap: () async {
                                  state = 'Products';
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
                                        'Products (234)',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14.0,
                                          color: state == 'Products'
                                              ? AppColors.textPrimary
                                              : Color(0xFFAFAFB4),
                                          height: 2.0,
                                        ),
                                      ),
                                    ),
                                    Opacity(
                                      opacity: (state == 'Products' ? 1 : 0)
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
                            Flexible(
                              child: InkWell(
                                onTap: () async {
                                  state = 'Short Lists';
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
                                        'Short Lists (23)',
                                        style: GoogleFonts.inter(
                                          fontSize: 14.0,
                                          color: state == 'Short Lists'
                                              ? AppColors.textPrimary
                                              : Color(0xFFAFAFB4),
                                          height: 2.0,
                                        ),
                                      ),
                                    ),
                                    Opacity(
                                      opacity: (state == 'Short Lists' ? 1 : 0)
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
                      Builder(
                        builder: (context) {
                          if (state == 'Products') {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: textController,
                                    focusNode: textFieldFocusNode,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_textController',
                                      Duration(milliseconds: 100),
                                      () => setState(() {}),
                                    ),
                                    autofocus: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      isDense: false,
                                      hintText:
                                          'Search products, characters, years...',
                                      hintStyle: GoogleFonts.inter(
                                        fontWeight: FontWeight.normal,
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
                                    ),
                                    cursorColor: AppColors.textPrimary,
                                    enableInteractiveSelection: true,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 24.0, 0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          choosenFilter = 'All';
                                          setState(() {});
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                choosenFilter == 'All'
                                                    ? Color(0xFF7D56FF)
                                                    : AppColors
                                                        .backgroundSecondary,
                                                choosenFilter == 'All'
                                                    ? Color(0xFF6187F1)
                                                    : AppColors
                                                        .backgroundSecondary
                                              ],
                                              stops: [0.0, 1.0],
                                              begin: AlignmentDirectional(
                                                  0.0, -1.0),
                                              end: AlignmentDirectional(0, 1.0),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    16.0, 8.0, 16.0, 8.0),
                                            child: Text(
                                              'All (24)',
                                              style: GoogleFonts.inter(
                                                fontSize: 14.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            AlignmentDirectional(-1.0, 0.0),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[]
                                                .divide(SizedBox(width: 8.0)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 24.0, 0.0, 0.0),
                                  child: custom_widgets.SellerProductsGrid(
                                    width: double.infinity,
                                    height: 200.0,
                                    sellerId: widget.sellerId!,
                                    userId: currentUserUid,
                                    status: ProductStatus.active.name,
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                    mainAxisSpacing: 16.0,
                                    crossAxisSpacing: 16.0,
                                    padding: 0.0,
                                    pageSize: 20,
                                    onProductTap: (productId) async {
                                      context.pushNamed(
                                        HomeProductWidget.routeName,
                                        queryParameters: {
                                          'productId': productId,
                                        },
                                      );
                                    },
                                    itemBuilder:
                                        (SellerProduct? sellerProduct) =>
                                            HomeSellerProductWidget(
                                      productDataType: sellerProduct,
                                    ),
                                  ),
                                ),
                              ]
                                  .addToStart(SizedBox(height: 24.0))
                                  .addToEnd(SizedBox(height: 24.0)),
                            );
                          } else {
                            return Builder(
                              builder: (context) {
                                final shortlists =
                                    getSellerData?.shortlists.toList() ?? [];

                                return ListView.separated(
                                  padding: EdgeInsets.fromLTRB(
                                    0,
                                    16.0,
                                    0,
                                    32.0,
                                  ),
                                  primary: false,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: shortlists.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 16.0),
                                  itemBuilder: (context, shortlistsIndex) {
                                    final shortlistRow =
                                        shortlists[shortlistsIndex];
                                    return ShortlistItemWidget.fromSeller(
                                      key: Key(
                                          'Key0vf_${shortlistsIndex}_of_${shortlists.length}'),
                                      shortlist: shortlistRow,
                                    );
                                  },
                                );
                              },
                            );
                          }
                        },
                      ),
                    ]
                        .addToStart(SizedBox(height: 32.0))
                        .addToEnd(SizedBox(height: 32.0)),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildReviewsSection({
    required List<dynamic> reviews,
    required bool hasButton,
    String? buttonText,
  }) {
    if (reviews.isEmpty) {
      return Container(
        width: double.infinity,
        child: EmptyStateWidget(
          icon: Icon(
            Icons.verified,
            color: Color(0x008E6CFF),
            size: 0.0,
          ),
          title: 'No reviews yet',
          description: 'Be the first to leave feedback after your purchase.',
          hasButton: hasButton,
          sidePadding: 25.0,
          buttonText: buttonText,
          buttonAction: () async {
            await context.pushNamed(
              HomeSellerProfileReviewsWidget.routeName,
              queryParameters: {
                'sellerDataType': getSellerData?.serialize(),
              },
            );
            await _refreshSellerData();
          },
        ),
      );
    }

    final displayReviews = reviews.take(2).toList();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.separated(
          padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: displayReviews.length,
          separatorBuilder: (_, __) => SizedBox(height: 16.0),
          itemBuilder: (context, reviewsIndex) {
            final reviewsItem = reviews[reviewsIndex];
            return _buildReviewCard(reviewsItem);
          },
        ),
        if (reviews.length > 2)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
            child: TextButton(
              onPressed: () async {
                await context.pushNamed(
                  HomeSellerProfileReviewsWidget.routeName,
                  queryParameters: {
                    'sellerDataType': getSellerData?.serialize(),
                  },
                );
                await _refreshSellerData();
              },
              child: Text(
                'View All',
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReviewCard(dynamic reviewsItem) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32.0,
                  height: 32.0,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: (reviewsItem.reviewer?.avatarUrl ?? '').isNotEmpty
                      ? CachedNetworkImage(
                          fadeInDuration: Duration(milliseconds: 500),
                          fadeOutDuration: Duration(milliseconds: 500),
                          imageUrl: reviewsItem.reviewer!.avatarUrl,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.person,
                          size: 20.0,
                          color: AppColors.textSecondary,
                        ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reviewsItem.reviewer?.username ?? '',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                      ),
                      RatingBarIndicator(
                        itemBuilder: (context, index) => Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFACC15),
                        ),
                        direction: Axis.horizontal,
                        rating: reviewsItem.rating.toDouble(),
                        unratedColor: Color(0xFF7B7B7B),
                        itemCount: 5,
                        itemSize: 18.0,
                      ),
                    ],
                  ),
                ),
                Text(
                  reviewsItem.createdAt != null
                      ? DateFormat('yMMMd').format(reviewsItem.createdAt!)
                      : '',
                  style: GoogleFonts.inter(
                    fontSize: 12.0,
                    color: Color(0xFFAFAFB4),
                  ),
                ),
              ].divide(SizedBox(width: 12.0)),
            ),
            Text(
              reviewsItem.content,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
              ),
            ),
          ].divide(SizedBox(height: 12.0)),
        ),
      ),
    );
  }
}

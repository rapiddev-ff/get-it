import '/features/auth/data/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/features/home/domain/models/review_model.dart';
import '/features/profile/presentation/pages/review_item/review_item_widget.dart';
import '/index.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'settings_my_profile_model.dart';
export 'settings_my_profile_model.dart';

class SettingsMyProfileWidget extends ConsumerStatefulWidget {
  const SettingsMyProfileWidget({super.key});

  static String routeName = 'settingsMyProfile';
  static String routePath = 'settingsMyProfile';

  @override
  ConsumerState<SettingsMyProfileWidget> createState() =>
      _SettingsMyProfileWidgetState();
}

class _SettingsMyProfileWidgetState
    extends ConsumerState<SettingsMyProfileWidget> {
  late SettingsMyProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Helper to extract a value from JSON by key path like `$.as_buyer.avg_rating`.
  static dynamic _jsonGet(dynamic json, String key) {
    if (json == null) return null;
    final parts = key.split('.');
    dynamic current = json;
    for (final part in parts) {
      // Handle array indexing like `stars[0]`
      final bracketIndex = part.indexOf('[');
      if (bracketIndex != -1) {
        final field = part.substring(0, bracketIndex);
        final idx =
            int.parse(part.substring(bracketIndex + 1, part.length - 1));
        if (current is Map) {
          current = current[field];
        } else {
          return null;
        }
        if (current is List && idx < current.length) {
          current = current[idx];
        } else {
          return null;
        }
      } else {
        if (current is Map) {
          current = current[part];
        } else {
          return null;
        }
      }
    }
    return current;
  }

  @override
  void initState() {
    super.initState();
    _model = SettingsMyProfileModel();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.getReviews =
          await SupabaseRPCGroup.getuserprofilewithreviewsCall.call(
        pUserId: currentUserUid,
        pOffset: 0,
        pLimit: 10,
      );

      setState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final json = _model.getReviews?.jsonBody ?? '';

    return DismissKeyboard(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.backgroundPrimary,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundSecondary,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 24.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'My Profile',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.normal,
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            authState.avatarUrl,
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
                              '@${authState.username}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0,
                                color: AppColors.textPrimary,
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
                                    rating: authState.isSeller
                                        ? (valueOrDefault<int>(
                                            _jsonGet(
                                                json, 'as_seller.avg_rating'),
                                            0,
                                          ).toDouble())
                                        : (valueOrDefault<int>(
                                            _jsonGet(
                                                json, 'as_buyer.avg_rating'),
                                            0,
                                          ).toDouble()),
                                    unratedColor: Color(0xFF7B7B7B),
                                    itemCount: 5,
                                    itemSize: 18.0,
                                  ),
                                  Text(
                                    valueOrDefault<String>(
                                      (authState.isSeller
                                              ? (valueOrDefault<int>(
                                                  _jsonGet(json,
                                                      'as_seller.avg_rating'),
                                                  0,
                                                ).toDouble())
                                              : (valueOrDefault<int>(
                                                  _jsonGet(json,
                                                      'as_buyer.avg_rating'),
                                                  0,
                                                ).toDouble()))
                                          .toString(),
                                      '0',
                                    ),
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '(${authState.isSeller ? valueOrDefault<String>(
                                        _jsonGet(json, 'as_seller.total')
                                            ?.toString(),
                                        '0',
                                      ) : valueOrDefault<String>(
                                        _jsonGet(json, 'as_buyer.total')
                                            ?.toString(),
                                        '0',
                                      )} reviews)',
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
                              child: InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context.pushNamed(
                                      SettingsMyProfileFollowersWidget
                                          .routeName);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    if (authState.isSeller)
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            valueOrDefault<String>(
                                              _jsonGet(json,
                                                      'profile.itemsCount')
                                                  ?.toString(),
                                              '0',
                                            ),
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0,
                                              color: AppColors.textPrimary,
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
                                    if (authState.isSeller)
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            valueOrDefault<String>(
                                              _jsonGet(
                                                      json, 'profile.soldCount')
                                                  ?.toString(),
                                              '0',
                                            ),
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0,
                                              color: AppColors.textPrimary,
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
                                            _jsonGet(json,
                                                    'profile.followersCount')
                                                ?.toString(),
                                            '0',
                                          ),
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.0,
                                            color: AppColors.textPrimary,
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
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          valueOrDefault<String>(
                                            _jsonGet(json,
                                                    'profile.followingCount')
                                                ?.toString(),
                                            '0',
                                          ),
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16.0,
                                            color: AppColors.textPrimary,
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
                            ),
                          ],
                        ),
                      ),
                    ].divide(SizedBox(width: 12.0)),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                    child: Text(
                      authState.bio,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.normal,
                        fontSize: 14.0,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Divider(
                    height: 48.0,
                    thickness: 1.0,
                    color: Color(0xFF363636),
                  ),
                  Builder(
                    builder: (context) {
                      if (!authState.isSeller) {
                        return _buildBuyerOnlySection(json);
                      } else {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTabBar(),
                            Builder(
                              builder: (context) {
                                if (_model.state == 'As Buyer') {
                                  return _buildBuyerRatingsSection(
                                      json, 'listView2');
                                } else {
                                  return _buildSellerRatingsSection(
                                      json, 'listView3');
                                }
                              },
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context
                            .pushNamed(SettingsDeleteAccountWidget.routeName);
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Color(0xFF545454),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.trash,
                                color: AppColors.textPrimary,
                                size: 20.0,
                              ),
                              Expanded(
                                child: Text(
                                  'Delete Account',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_outlined,
                                color: Color(0xFFAFAFB4),
                                size: 24.0,
                              ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pushNamed(
                            SettingsDeactivateAccountWidget.routeName);
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Color(0xFF545454),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.powerOff,
                                color: AppColors.textPrimary,
                                size: 20.0,
                              ),
                              Expanded(
                                child: Text(
                                  'Deactivate Account',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_outlined,
                                color: Color(0xFFAFAFB4),
                                size: 24.0,
                              ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ].addToEnd(SizedBox(height: 32.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      width: double.infinity,
      height: 53.0,
      decoration: BoxDecoration(),
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
                  _model.state = 'As Buyer';
                  setState(() {});
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                      child: Text(
                        'As Buyer',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.normal,
                          color: _model.state == 'As Buyer'
                              ? AppColors.textPrimary
                              : Color(0xFFAFAFB4),
                          height: 2.0,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: (_model.state == 'As Buyer' ? 1 : 0).toDouble(),
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
                  _model.state = 'As Seller';
                  setState(() {});
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
                      child: Text(
                        'As Seller',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.normal,
                          color: _model.state == 'As Seller'
                              ? AppColors.textPrimary
                              : Color(0xFFAFAFB4),
                          height: 2.0,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: (_model.state == 'As Seller' ? 1 : 0).toDouble(),
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
    );
  }

  /// Buyer-only section (when user is not a seller) -- no tabs.
  Widget _buildBuyerOnlySection(dynamic json) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'My Ratings from Sellers',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
              child: Text(
                '${valueOrDefault<String>(
                  _jsonGet(json, 'as_buyer.total')?.toString(),
                  '0',
                )} reviews',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ].divide(SizedBox(width: 12.0)),
        ),
        _buildRatingsCard(json, 'as_buyer'),
        if (_jsonGet(json, 'as_buyer.reviews') != null)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
            child: _buildReviewsList(json, 'as_buyer', 'Keys29'),
          ),
        if (_jsonGet(json, 'as_buyer.reviews') != null)
          _buildViewAllReviewsButton(),
      ].addToStart(SizedBox(height: 24.0)),
    );
  }

  /// Buyer ratings section for the tabbed view.
  Widget _buildBuyerRatingsSection(dynamic json, String animKey) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'My Ratings from Sellers',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
              child: Text(
                '${valueOrDefault<String>(
                  _jsonGet(json, 'as_buyer.total')?.toString(),
                  '0',
                )} reviews',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ].divide(SizedBox(width: 12.0)),
        ),
        _buildRatingsCard(json, 'as_buyer'),
        if (_jsonGet(json, 'as_buyer.reviews') != null)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
            child: _buildReviewsList(json, 'as_buyer', 'Keyh7p'),
          ),
        if (_jsonGet(json, 'as_buyer.reviews') != null)
          _buildViewAllReviewsButton(),
      ].addToStart(SizedBox(height: 24.0)),
    );
  }

  /// Seller ratings section for the tabbed view.
  Widget _buildSellerRatingsSection(dynamic json, String animKey) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'My Ratings from Buyers',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
              child: Text(
                '${valueOrDefault<String>(
                  _jsonGet(json, 'as_seller.total')?.toString(),
                  '0',
                )} reviews',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                  color: AppColors.secondary,
                ),
              ),
            ),
          ].divide(SizedBox(width: 12.0)),
        ),
        _buildRatingsCard(json, 'as_seller'),
        if (_jsonGet(json, 'as_seller.reviews') != null)
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
            child: _buildReviewsList(json, 'as_seller', 'Key2m1'),
          ),
        if (_jsonGet(json, 'as_seller.reviews') != null)
          _buildViewAllReviewsButton(),
      ].addToStart(SizedBox(height: 24.0)),
    );
  }

  Widget _buildRatingsCard(dynamic json, String role) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            valueOrDefault<String>(
                              _jsonGet(json, '$role.avg_rating')?.toString(),
                              '0',
                            ),
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 24.0,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        RatingBarIndicator(
                          itemBuilder: (context, index) => Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFACC15),
                          ),
                          direction: Axis.horizontal,
                          rating: valueOrDefault<int>(
                            _jsonGet(json, '$role.avg_rating'),
                            0,
                          ).toDouble(),
                          unratedColor: Color(0xFF7B7B7B),
                          itemCount: 5,
                          itemSize: 18.0,
                        ),
                      ],
                    ),
                    _buildStarRow(json, role, 0, '5', Color(0xFF16A349)),
                    _buildStarRow(json, role, 1, '4', Color(0xFF4ADE80)),
                    _buildStarRow(json, role, 2, '3', Color(0xFFEABD08)),
                  ],
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildStarRow(
      dynamic json, String role, int index, String star, Color color) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
          0.0, index == 0 ? 12.0 : 8.0, 0.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            '$star\u2605',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.normal,
              fontSize: 12.0,
              color: AppColors.textPrimary,
            ),
          ),
          Expanded(
            child: LinearPercentIndicator(
              percent: valueOrDefault<int>(
                _jsonGet(json, '$role.stars[$index].percent'),
                0,
              ).toDouble() / 100.0,
              lineHeight: 12.0,
              animation: true,
              animateFromLastPercent: true,
              progressColor: color,
              backgroundColor: Color(0xFF363636),
              barRadius: Radius.circular(100.0),
              padding: EdgeInsets.zero,
            ),
          ),
          Text(
            valueOrDefault<String>(
              _jsonGet(json, '$role.stars[$index].count')?.toString(),
              '0',
            ),
            style: GoogleFonts.inter(
              fontWeight: FontWeight.normal,
              fontSize: 12.0,
              color: AppColors.textPrimary,
            ),
          ),
        ].divide(SizedBox(width: 12.0)),
      ),
    );
  }

  Widget _buildReviewsList(dynamic json, String role, String keyPrefix) {
    return Builder(
      builder: (context) {
        final reviews = _parseReviews(json, role);

        return ListView.separated(
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: reviews.length,
          separatorBuilder: (_, __) => SizedBox(height: 16.0),
          itemBuilder: (context, reviewsIndex) {
            final reviewsItem = reviews[reviewsIndex];
            return ReviewItemWidget(
              key: Key('${keyPrefix}_${reviewsIndex}_of_${reviews.length}'),
              reviewDataType: reviewsItem,
            );
          },
        ).animate().shimmer(duration: 600.ms);
      },
    );
  }

  List<Review> _parseReviews(dynamic json, String role) {
    final rawList = _jsonGet(json, '$role.reviews');
    if (rawList == null || rawList is! List) return [];
    return rawList
        .map<Review?>(
            (e) => e is Map<String, dynamic> ? Review.fromJson(e) : null)
        .where((e) => e != null)
        .cast<Review>()
        .toList();
  }

  Widget _buildViewAllReviewsButton() {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
      child: SizedBox(
        width: double.infinity,
        height: 56.0,
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: Color(0x008E6CFF),
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            'View All Reviews',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 17.0,
              color: Color(0xFF9B85FF),
            ),
          ),
        ),
      ),
    );
  }
}

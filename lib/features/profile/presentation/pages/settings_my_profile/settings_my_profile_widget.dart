import '/backend/api_requests/api_calls.dart';
import '/features/home/domain/models/review_model.dart';
import '/features/profile/presentation/pages/review_item/review_item_widget.dart';
import '/features/profile/presentation/pages/settings_my_profile_followers/settings_my_profile_followers_widget.dart';
import '/features/profile/presentation/pages/settings_delete_account/settings_delete_account_widget.dart';
import '/features/profile/presentation/pages/settings_deactivate_account/settings_deactivate_account_widget.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '/core/providers/current_user_provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
  String? _tabState = 'As Buyer';
  ApiCallResponse? _getReviews;

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

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _getReviews =
          await SupabaseRPCGroup.getuserprofilewithreviewsCall.call(
        pUserId: ref.read(currentUserIdProvider),
        pOffset: 0,
        pLimit: 10,
      );

      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final json = _getReviews?.jsonBody ?? '';

    return DismissKeyboard(
      child: Scaffold(
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
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(fontWeight: FontWeight.normal, color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, top: 24.0, right: 16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Row(
                                children: [
                                  RatingBarIndicator(
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star_rounded,
                                      color: AppColors.statusYellow,
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
                                    unratedColor: AppColors.neutral700,
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.w500),
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!,
                                  ),
                                ].divide(SizedBox(width: 8.0)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: InkWell(
                                onTap: () async {
                                  context.pushNamed(
                                      SettingsMyProfileFollowersWidget
                                          .routeName);
                                },
                                child: Row(
                                  children: [
                                    if (authState.isSeller)
                                      Column(
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!,
                                          ),
                                          Text(
                                            'Items',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!,
                                          ),
                                        ],
                                      ),
                                    if (authState.isSeller)
                                      Column(
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!,
                                          ),
                                          Text(
                                            'Sold',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall!,
                                          ),
                                        ],
                                      ),
                                    Column(
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!,
                                        ),
                                        Text(
                                          'Followers',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!,
                                        ),
                                      ],
                                    ),
                                    Column(
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!,
                                        ),
                                        Text(
                                          'Followers',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!,
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
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      authState.bio,
                      style: Theme.of(context).textTheme.bodyMedium!,
                    ),
                  ),
                  Divider(
                    height: 48.0,
                    thickness: 1.0,
                    color: AppColors.surfaceDark,
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
                                if (_tabState == 'As Buyer') {
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
                    padding: EdgeInsets.only(top: 16.0),
                    child: InkWell(
                      onTap: () async {
                        context
                            .pushNamed(SettingsDeleteAccountWidget.routeName);
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: AppColors.neutral800,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.trash,
                                color: AppColors.textPrimary,
                                size: 20.0,
                              ),
                              Expanded(
                                child: Text(
                                  'Delete Account',
                                  style: Theme.of(context).textTheme.bodyLarge!,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_outlined,
                                color: AppColors.textSecondary,
                                size: 24.0,
                              ),
                            ].divide(SizedBox(width: 12.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.0),
                    child: InkWell(
                      onTap: () async {
                        context.pushNamed(
                            SettingsDeactivateAccountWidget.routeName);
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: AppColors.neutral800,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.powerOff,
                                color: AppColors.textPrimary,
                                size: 20.0,
                              ),
                              Expanded(
                                child: Text(
                                  'Deactivate Account',
                                  style: Theme.of(context).textTheme.bodyLarge!,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_outlined,
                                color: AppColors.textSecondary,
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
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () async {
                  _tabState = 'As Buyer';
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'As Buyer',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.normal,
                          color: _tabState == 'As Buyer'
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          height: 2.0,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: (_tabState == 'As Buyer' ? 1 : 0).toDouble(),
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
                  _tabState = 'As Seller';
                  setState(() {});
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'As Seller',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.normal,
                          color: _tabState == 'As Seller'
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          height: 2.0,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: (_tabState == 'As Seller' ? 1 : 0).toDouble(),
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
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'My Ratings from Sellers',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Text(
                '${valueOrDefault<String>(
                  _jsonGet(json, 'as_buyer.total')?.toString(),
                  '0',
                )} reviews',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500, color: AppColors.secondary),
              ),
            ),
          ].divide(SizedBox(width: 12.0)),
        ),
        _buildRatingsCard(json, 'as_buyer'),
        if (_jsonGet(json, 'as_buyer.reviews') != null)
          Padding(
            padding: EdgeInsets.only(top: 20.0),
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
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'My Ratings from Sellers',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Text(
                '${valueOrDefault<String>(
                  _jsonGet(json, 'as_buyer.total')?.toString(),
                  '0',
                )} reviews',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500, color: AppColors.secondary),
              ),
            ),
          ].divide(SizedBox(width: 12.0)),
        ),
        _buildRatingsCard(json, 'as_buyer'),
        if (_jsonGet(json, 'as_buyer.reviews') != null)
          Padding(
            padding: EdgeInsets.only(top: 20.0),
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
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'My Ratings from Buyers',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Text(
                '${valueOrDefault<String>(
                  _jsonGet(json, 'as_seller.total')?.toString(),
                  '0',
                )} reviews',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w500, color: AppColors.secondary),
              ),
            ),
          ].divide(SizedBox(width: 12.0)),
        ),
        _buildRatingsCard(json, 'as_seller'),
        if (_jsonGet(json, 'as_seller.reviews') != null)
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: _buildReviewsList(json, 'as_seller', 'Key2m1'),
          ),
        if (_jsonGet(json, 'as_seller.reviews') != null)
          _buildViewAllReviewsButton(),
      ].addToStart(SizedBox(height: 24.0)),
    );
  }

  Widget _buildRatingsCard(dynamic json, String role) {
    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            valueOrDefault<String>(
                              _jsonGet(json, '$role.avg_rating')?.toString(),
                              '0',
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        RatingBarIndicator(
                          itemBuilder: (context, index) => Icon(
                            Icons.star_rounded,
                            color: AppColors.statusYellow,
                          ),
                          direction: Axis.horizontal,
                          rating: valueOrDefault<int>(
                            _jsonGet(json, '$role.avg_rating'),
                            0,
                          ).toDouble(),
                          unratedColor: AppColors.neutral700,
                          itemCount: 5,
                          itemSize: 18.0,
                        ),
                      ],
                    ),
                    _buildStarRow(json, role, 0, '5', Color(0xFF16A349)),
                    _buildStarRow(json, role, 1, '4', AppColors.statusSuccess),
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
      padding: EdgeInsets.only(top: index == 0 ? 12.0 : 8.0),
      child: Row(
        children: [
          Text(
            '$star\u2605',
            style: Theme.of(context).textTheme.bodySmall!,
          ),
          Expanded(
            child: LinearPercentIndicator(
              percent: valueOrDefault<int>(
                    _jsonGet(json, '$role.stars[$index].percent'),
                    0,
                  ).toDouble() /
                  100.0,
              lineHeight: 12.0,
              animation: true,
              animateFromLastPercent: true,
              progressColor: color,
              backgroundColor: AppColors.surfaceDark,
              barRadius: Radius.circular(100.0),
              padding: EdgeInsets.zero,
            ),
          ),
          Text(
            valueOrDefault<String>(
              _jsonGet(json, '$role.stars[$index].count')?.toString(),
              '0',
            ),
            style: Theme.of(context).textTheme.bodySmall!,
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
      padding: EdgeInsets.only(top: 16.0),
      child: SizedBox(
        width: double.infinity,
        height: 56.0,
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            backgroundColor: AppColors.primary.withValues(alpha: 0),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(
            'View All Reviews',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 17.0,
              color: AppColors.brandPurpleLight,
            ),
          ),
        ),
      ),
    );
  }
}

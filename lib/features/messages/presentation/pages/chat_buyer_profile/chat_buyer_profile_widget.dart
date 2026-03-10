import '/backend/api_requests/api_calls.dart';
import '/features/home/domain/models/review_model.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/features/profile/presentation/pages/review_item/review_item_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class ChatBuyerProfileWidget extends ConsumerStatefulWidget {
  const ChatBuyerProfileWidget({
    super.key,
    required this.buyerId,
  });

  final String? buyerId;

  static String routeName = 'chatBuyerProfile';
  static String routePath = 'chatBuyerProfile';

  @override
  ConsumerState<ChatBuyerProfileWidget> createState() =>
      _ChatBuyerProfileWidgetState();
}

class _ChatBuyerProfileWidgetState
    extends ConsumerState<ChatBuyerProfileWidget> {
  String? _state = 'Reviews';
  ApiCallResponse? _getReviews;

  static dynamic _jsonField(dynamic json, String key) {
    if (json is Map) return json[key];
    return null;
  }

  @override
  void initState() {
    super.initState();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _getReviews = await SupabaseRPCGroup.getuserprofilewithreviewsCall.call(
        pUserId: widget.buyerId,
        pOffset: 0,
        pLimit: 10,
      );

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(authProvider);

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
            'Buyer Profile',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
                size: 28.0,
              ),
              onPressed: () {},
            ),
          ],
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
                        width: 66.0,
                        height: 66.0,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CachedNetworkImage(
                          fadeInDuration: Duration(milliseconds: 100),
                          fadeOutDuration: Duration(milliseconds: 100),
                          imageUrl: valueOrDefault<String>(
                            userData.avatarUrl.isNotEmpty
                                ? userData.avatarUrl
                                : null,
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
                              '@${userData.username}',
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Member since March 2025',
                              style: Theme.of(context).textTheme.labelMedium!,
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star_rounded,
                                    color: AppColors.statusYellow,
                                  ),
                                  direction: Axis.horizontal,
                                  rating: userData.isSeller
                                      ? (valueOrDefault<int>(
                                          _jsonField(
                                            (_getReviews?.jsonBody ?? ''),
                                            'as_seller',
                                          ) is Map
                                              ? (_jsonField(
                                                      _jsonField(
                                                          (_getReviews
                                                                  ?.jsonBody ??
                                                              ''),
                                                          'as_seller'),
                                                      'avg_rating') as num?)
                                                  ?.toInt()
                                              : null,
                                          0,
                                        ).toDouble())
                                      : (valueOrDefault<int>(
                                          _jsonField(
                                            (_getReviews?.jsonBody ?? ''),
                                            'as_buyer',
                                          ) is Map
                                              ? (_jsonField(
                                                      _jsonField(
                                                          (_getReviews
                                                                  ?.jsonBody ??
                                                              ''),
                                                          'as_buyer'),
                                                      'avg_rating') as num?)
                                                  ?.toInt()
                                              : null,
                                          0,
                                        ).toDouble()),
                                  unratedColor: AppColors.neutral700,
                                  itemCount: 5,
                                  itemSize: 18.0,
                                ),
                                Text(
                                  valueOrDefault<String>(
                                    (userData.isSeller
                                            ? (valueOrDefault<int>(
                                                _jsonField(
                                                  (_getReviews?.jsonBody ?? ''),
                                                  'as_seller',
                                                ) is Map
                                                    ? (_jsonField(
                                                            _jsonField(
                                                                (_getReviews
                                                                        ?.jsonBody ??
                                                                    ''),
                                                                'as_seller'),
                                                            'avg_rating') as num?)
                                                        ?.toInt()
                                                    : null,
                                                0,
                                              ).toDouble())
                                            : (valueOrDefault<int>(
                                                _jsonField(
                                                  (_getReviews?.jsonBody ?? ''),
                                                  'as_buyer',
                                                ) is Map
                                                    ? (_jsonField(
                                                            _jsonField(
                                                                (_getReviews
                                                                        ?.jsonBody ??
                                                                    ''),
                                                                'as_buyer'),
                                                            'avg_rating') as num?)
                                                        ?.toInt()
                                                    : null,
                                                0,
                                              ).toDouble()))
                                        .toString(),
                                    '0',
                                  ),
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textPrimary,
                                    fontSize: 14.0,
                                  ),
                                ),
                                Text(
                                  '(${userData.isSeller ? valueOrDefault<String>(
                                      _jsonField(
                                        (_getReviews?.jsonBody ?? ''),
                                        'as_seller',
                                      ) is Map
                                          ? _jsonField(
                                                  _jsonField(
                                                      (_getReviews?.jsonBody ??
                                                          ''),
                                                      'as_seller'),
                                                  'total')
                                              ?.toString()
                                          : null,
                                      '0',
                                    ) : valueOrDefault<String>(
                                      _jsonField(
                                        (_getReviews?.jsonBody ?? ''),
                                        'as_buyer',
                                      ) is Map
                                          ? _jsonField(
                                                  _jsonField(
                                                      (_getReviews?.jsonBody ??
                                                          ''),
                                                      'as_buyer'),
                                                  'total')
                                              ?.toString()
                                          : null,
                                      '0',
                                    )} reviews)',
                                  style: Theme.of(context).textTheme.labelMedium!,
                                ),
                              ].divide(SizedBox(width: 8.0)),
                            ),
                          ].divide(SizedBox(height: 4.0)),
                        ),
                      ),
                    ].divide(SizedBox(width: 12.0)),
                  ),
                  Divider(
                    height: 32.0,
                    thickness: 1.0,
                    color: AppColors.surfaceDark,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 53.0,
                        decoration: BoxDecoration(),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  _state = 'Reviews';
                                  setState(() {});
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        'Reviews',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14.0,
                                          color: _state == 'Reviews'
                                              ? AppColors.textPrimary
                                              : AppColors.textSecondary,
                                          height: 2.0,
                                        ),
                                      ),
                                    ),
                                    Opacity(
                                      opacity: (_state == 'Reviews' ? 1 : 0)
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
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      'Blocked Sellers',
                                      style: GoogleFonts.inter(
                                        fontSize: 14.0,
                                        color: _state == 'As Seller'
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary,
                                        height: 2.0,
                                      ),
                                    ),
                                  ),
                                  Opacity(
                                    opacity: (_state == 'As Seller' ? 1 : 0)
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
                          ],
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          if (_state == 'Reviews') {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Seller Reviews',
                                        style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        '${valueOrDefault<String>(
                                          _jsonField(
                                            (_getReviews?.jsonBody ?? ''),
                                            'as_buyer',
                                          ) is Map
                                              ? _jsonField(
                                                      _jsonField(
                                                          (_getReviews
                                                                  ?.jsonBody ??
                                                              ''),
                                                          'as_buyer'),
                                                      'total')
                                                  ?.toString()
                                              : null,
                                          '0',
                                        )} reviews',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.secondary,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 12.0)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Reviews from sellers about your purchases',
                                    style: Theme.of(context).textTheme.labelMedium!,
                                  ),
                                ),
                                if (_jsonField(
                                      (_getReviews?.jsonBody ?? ''),
                                      'as_buyer',
                                    ) !=
                                    null)
                                  Padding(
                                    padding: EdgeInsets.only(top: 20.0),
                                    child: Builder(
                                      builder: (context) {
                                        final dynamic asBuyerData = _jsonField(
                                            (_getReviews?.jsonBody ?? ''),
                                            'as_buyer');
                                        final dynamic reviewsJson =
                                            asBuyerData is Map
                                                ? asBuyerData['reviews']
                                                : null;
                                        final buyerReviews = (reviewsJson
                                                is List
                                            ? reviewsJson
                                                .map<Review?>((e) =>
                                                    e is Map<String, dynamic>
                                                        ? Review.fromJson(e)
                                                        : null)
                                                .whereType<Review>()
                                                .toList()
                                            : <Review>[]);

                                        return ListView.separated(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: buyerReviews.length,
                                          separatorBuilder: (_, __) =>
                                              SizedBox(height: 16.0),
                                          itemBuilder:
                                              (context, buyerReviewsIndex) {
                                            final buyerReviewsItem =
                                                buyerReviews[buyerReviewsIndex];
                                            return ReviewItemWidget(
                                              key: Key(
                                                  'Keywip_${buyerReviewsIndex}_of_${buyerReviews.length}'),
                                              reviewDataType: buyerReviewsItem,
                                            );
                                          },
                                        ).animate().shimmer(
                                              duration: 600.ms,
                                              color: Color(0x80FFFFFF),
                                            );
                                      },
                                    ),
                                  ),
                                if (_jsonField(
                                      (_getReviews?.jsonBody ?? ''),
                                      'as_buyer',
                                    ) !=
                                    null)
                                  Padding(
                                    padding: EdgeInsets.only(top: 16.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 56.0,
                                      child: TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          backgroundColor: Color(0x008E6CFF),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        child: Text(
                                          'View All Reviews',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.brandPurpleLight,
                                            fontSize: 17.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ].addToStart(SizedBox(height: 24.0)),
                            );
                          } else {
                            return Text(
                              'Hello World',
                              style: Theme.of(context).textTheme.bodyMedium!,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ].addToEnd(SizedBox(height: 32.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/utils/value_utils.dart';
import '/features/auth/presentation/providers/auth_provider.dart';
import '/profile/review_item/review_item_widget.dart';
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
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
      _getReviews =
          await SupabaseRPCGroup.getuserprofilewithreviewsCall.call(
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
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
              onPressed: () {
                print('IconButton pressed ...');
              },
            ),
          ],
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
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontSize: 18.0,
                              ),
                            ),
                            Text(
                              'Member since March 2025',
                              style: GoogleFonts.inter(
                                color: Color(0xFFAFAFB4),
                                fontSize: 14.0,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                RatingBarIndicator(
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star_rounded,
                                    color: Color(0xFFFACC15),
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
                                  unratedColor: Color(0xFF7B7B7B),
                                  itemCount: 5,
                                  itemSize: 18.0,
                                ),
                                Text(
                                  valueOrDefault<String>(
                                    (userData.isSeller
                                            ? (valueOrDefault<int>(
                                                _jsonField(
                                                          (_getReviews
                                                                  ?.jsonBody ??
                                                              ''),
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
                                                          (_getReviews
                                                                  ?.jsonBody ??
                                                              ''),
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
                                  style: GoogleFonts.inter(
                                    color: Color(0xFFAFAFB4),
                                    fontSize: 14.0,
                                  ),
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
                    color: Color(0xFF363636),
                  ),
                  Column(
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
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  _state = 'Reviews';
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
                                        'Reviews',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14.0,
                                          color: _state == 'Reviews'
                                              ? AppColors.textPrimary
                                              : Color(0xFFAFAFB4),
                                          height: 2.0,
                                        ),
                                      ),
                                    ),
                                    Opacity(
                                      opacity:
                                          (_state == 'Reviews' ? 1 : 0)
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
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 10.0),
                                    child: Text(
                                      'Blocked Sellers',
                                      style: GoogleFonts.inter(
                                        fontSize: 14.0,
                                        color: _state == 'As Seller'
                                            ? AppColors.textPrimary
                                            : Color(0xFFAFAFB4),
                                        height: 2.0,
                                      ),
                                    ),
                                  ),
                                  Opacity(
                                    opacity:
                                        (_state == 'As Seller' ? 1 : 0)
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
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Seller Reviews',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 8.0, 0.0),
                                      child: Text(
                                        '${valueOrDefault<String>(
                                          _jsonField(
                                                    (_getReviews?.jsonBody ??
                                                        ''),
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
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 4.0, 0.0, 0.0),
                                  child: Text(
                                    'Reviews from sellers about your purchases',
                                    style: GoogleFonts.inter(
                                      color: Color(0xFFAFAFB4),
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                                if (_jsonField(
                                      (_getReviews?.jsonBody ?? ''),
                                      'as_buyer',
                                    ) !=
                                    null)
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 20.0, 0.0, 0.0),
                                    child: Builder(
                                      builder: (context) {
                                        final dynamic asBuyerData =
                                            _jsonField(
                                                (_getReviews?.jsonBody ??
                                                    ''),
                                                'as_buyer');
                                        final dynamic reviewsJson =
                                            asBuyerData is Map
                                                ? asBuyerData['reviews']
                                                : null;
                                        final buyerReviews = (reviewsJson
                                                    is List
                                                ? reviewsJson
                                                    .map<ReviewStruct?>(
                                                        ReviewStruct
                                                            .maybeFromMap)
                                                    .whereType<ReviewStruct>()
                                                    .toList()
                                                : <ReviewStruct>[]);

                                        return ListView.separated(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: buyerReviews.length,
                                          separatorBuilder: (_, __) =>
                                              SizedBox(height: 16.0),
                                          itemBuilder:
                                              (context, buyerReviewsIndex) {
                                            final buyerReviewsItem =
                                                buyerReviews[
                                                    buyerReviewsIndex];
                                            return ReviewItemWidget(
                                              key: Key(
                                                  'Keywip_${buyerReviewsIndex}_of_${buyerReviews.length}'),
                                              reviewDataType:
                                                  buyerReviewsItem,
                                            );
                                          },
                                        )
                                            .animate()
                                            .shimmer(
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 16.0, 0.0, 0.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 56.0,
                                      child: TextButton(
                                        onPressed: () {
                                          print('Button pressed ...');
                                        },
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
                                            color: Color(0xFF9B85FF),
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
                              style: GoogleFonts.inter(fontSize: 14.0),
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

import '/core/theme/app_colors.dart';
import '/core/utils/keyboard_visibility_mixin.dart';
import '/core/utils/list_extensions.dart';
import '/core/router/app_router.dart';
import '/features/home/presentation/pages/home_page/home_page_widget.dart';
import '/features/browse/presentation/pages/browse/browse_widget.dart';
import '/features/messages/presentation/pages/messages/messages_widget.dart';
import '/features/wishlist/presentation/pages/wishlist/wishlist_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';

class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget>
    with KeyboardVisibilityMixin {
  @override
  void initState() {
    super.initState();
  }

  String _currentRoute(BuildContext context) =>
      GoRouterState.of(context).uri.toString();

  @override
  Widget build(BuildContext context) {
    final route = _currentRoute(context);
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    final bottomPadding = bottomInset > 0 ? bottomInset : 12.0;

    return Visibility(
      visible: !isKeyboardShowing(context),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding + 8.0),
          child: SizedBox(
            height: 64.0,
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if (route != '/homePage') {
                      context.goNamed(
                        HomePageWidget.routeName,
                        extra: <String, dynamic>{
                          kTransitionInfoKey: TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                            duration: Duration(milliseconds: 0),
                          ),
                        },
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              () {
                                if (route == '/homePage') {
                                  return AppColors.brandPurple;
                                } else if (route == '/homeDashoardEarnings' || route == '/buyerPurchases' || route == '/buyerOrderDetail') {
                                  return AppColors.brandPurple;
                                } else {
                                  return Colors.transparent;
                                }
                              }(),
                              () {
                                if (route == '/homePage') {
                                  return AppColors.brandBlue;
                                } else if (route == '/homeDashoardEarnings' || route == '/buyerPurchases' || route == '/buyerOrderDetail') {
                                  return AppColors.brandBlue;
                                } else {
                                  return Colors.transparent;
                                }
                              }()
                            ],
                            stops: [0.0, 1.0],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: FaIcon(
                          FontAwesomeIcons.house,
                          color: () {
                            if (route == '/homePage') {
                              return AppColors.textPrimary;
                            } else if (route == '/homeDashoardEarnings' || route == '/buyerPurchases' || route == '/buyerOrderDetail') {
                              return AppColors.textPrimary;
                            } else {
                              return AppColors.textSecondary;
                            }
                          }(),
                          size: 18.0,
                        ),
                      ),
                      Text(
                        'Home',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(height: 1.67, letterSpacing: 0.0),
                      ),
                    ].divide(SizedBox(height: 4.0)),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if (route != '/browse') {
                      context.goNamed(
                        BrowseWidget.routeName,
                        extra: <String, dynamic>{
                          kTransitionInfoKey: TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                            duration: Duration(milliseconds: 0),
                          ),
                        },
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              () {
                                if (route == '/browse') {
                                  return AppColors.brandPurple;
                                } else if (route == '/browseCategories') {
                                  return AppColors.brandPurple;
                                } else if (route == '/browseProducts') {
                                  return AppColors.brandPurple;
                                } else {
                                  return Colors.transparent;
                                }
                              }(),
                              () {
                                if (route == '/browse') {
                                  return AppColors.brandBlue;
                                } else if (route == '/browseCategories') {
                                  return AppColors.brandBlue;
                                } else if (route == '/browseProducts') {
                                  return AppColors.brandBlue;
                                } else {
                                  return Colors.transparent;
                                }
                              }()
                            ],
                            stops: [0.0, 1.0],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.search,
                            color: () {
                              if (route == '/browse') {
                                return AppColors.textPrimary;
                              } else if (route == '/browseCategories') {
                                return AppColors.textPrimary;
                              } else if (route == '/browseProducts') {
                                return AppColors.textPrimary;
                              } else {
                                return AppColors.textSecondary;
                              }
                            }(),
                            size: 18.0,
                          ),
                        ),
                      ),
                      Text(
                        'Browse',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(height: 1.67, letterSpacing: 0.0),
                      ),
                    ].divide(SizedBox(height: 4.0)),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if (route != '/messages') {
                      context.goNamed(
                        MessagesWidget.routeName,
                        extra: <String, dynamic>{
                          kTransitionInfoKey: TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                            duration: Duration(milliseconds: 0),
                          ),
                        },
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              route == '/messages'
                                  ? AppColors.brandPurple
                                  : Colors.transparent,
                              route == '/messages'
                                  ? AppColors.brandBlue
                                  : Colors.transparent
                            ],
                            stops: [0.0, 1.0],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.solidMessage,
                            color: route == '/messages'
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            size: 18.0,
                          ),
                        ),
                      ),
                      Text(
                        'Messages',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(height: 1.67, letterSpacing: 0.0),
                      ),
                    ].divide(SizedBox(height: 4.0)),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    if (route != '/wishlist') {
                      context.goNamed(
                        WishlistWidget.routeName,
                        extra: <String, dynamic>{
                          kTransitionInfoKey: TransitionInfo(
                            hasTransition: true,
                            transitionType: PageTransitionType.fade,
                            duration: Duration(milliseconds: 0),
                          ),
                        },
                      );
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              route == '/wishlist'
                                  ? AppColors.brandPurple
                                  : Colors.transparent,
                              route == '/wishlist'
                                  ? AppColors.brandBlue
                                  : Colors.transparent
                            ],
                            stops: [0.0, 1.0],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.favorite_outlined,
                            color: route == '/wishlist'
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                            size: 18.0,
                          ),
                        ),
                      ),
                      Text(
                        'Wishlist',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(height: 1.67, letterSpacing: 0.0),
                      ),
                    ].divide(SizedBox(height: 4.0)),
                  ),
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

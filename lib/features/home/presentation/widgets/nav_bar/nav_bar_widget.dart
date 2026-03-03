import 'dart:async';

import '/core/theme/app_colors.dart';
import '/core/utils/list_extensions.dart';
import '/core/router/app_router.dart';
import '/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class NavBarWidget extends StatefulWidget {
  const NavBarWidget({super.key});

  @override
  State<NavBarWidget> createState() => _NavBarWidgetState();
}

class _NavBarWidgetState extends State<NavBarWidget> {
  late StreamSubscription<bool> _keyboardVisibilitySubscription;
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();

    if (!kIsWeb) {
      _keyboardVisibilitySubscription =
          KeyboardVisibilityController().onChange.listen((bool visible) {
        setState(() {
          _isKeyboardVisible = visible;
        });
      });
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _keyboardVisibilitySubscription.cancel();
    }
    super.dispose();
  }

  String _currentRoute(BuildContext context) =>
      GoRouterState.of(context).uri.toString();

  @override
  Widget build(BuildContext context) {
    final route = _currentRoute(context);

    return Visibility(
      visible: !(kIsWeb
          ? MediaQuery.viewInsetsOf(context).bottom > 0
          : _isKeyboardVisible),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 1.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
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
                    mainAxisSize: MainAxisSize.max,
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
                                  return Color(0xFF7D56FF);
                                } else if (route == '/homeDashoardEarnings') {
                                  return Color(0xFF7D56FF);
                                } else {
                                  return Colors.transparent;
                                }
                              }(),
                              () {
                                if (route == '/homePage') {
                                  return Color(0xFF6187F1);
                                } else if (route == '/homeDashoardEarnings') {
                                  return Color(0xFF6187F1);
                                } else {
                                  return Colors.transparent;
                                }
                              }()
                            ],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(0.0, -1.0),
                            end: AlignmentDirectional(0, 1.0),
                          ),
                          shape: BoxShape.circle,
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: FaIcon(
                          FontAwesomeIcons.home,
                          color: () {
                            if (route == '/homePage') {
                              return AppColors.textPrimary;
                            } else if (route == '/homeDashoardEarnings') {
                              return AppColors.textPrimary;
                            } else {
                              return Color(0xFFAFAFB4);
                            }
                          }(),
                          size: 18.0,
                        ),
                      ),
                      Text(
                        'Home',
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          height: 1.67,
                        ),
                      ),
                    ].divide(SizedBox(height: 4.0)),
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
                    mainAxisSize: MainAxisSize.max,
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
                                  return Color(0xFF7D56FF);
                                } else if (route == '/browseCategories') {
                                  return Color(0xFF7D56FF);
                                } else if (route == '/browseProducts') {
                                  return Color(0xFF7D56FF);
                                } else {
                                  return Colors.transparent;
                                }
                              }(),
                              () {
                                if (route == '/browse') {
                                  return Color(0xFF6187F1);
                                } else if (route == '/browseCategories') {
                                  return Color(0xFF6187F1);
                                } else if (route == '/browseProducts') {
                                  return Color(0xFF6187F1);
                                } else {
                                  return Colors.transparent;
                                }
                              }()
                            ],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(0.0, -1.0),
                            end: AlignmentDirectional(0, 1.0),
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
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
                                return Color(0xFFAFAFB4);
                              }
                            }(),
                            size: 18.0,
                          ),
                        ),
                      ),
                      Text(
                        'Browse',
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          height: 1.67,
                        ),
                      ),
                    ].divide(SizedBox(height: 4.0)),
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
                    if (route != '/videos') {
                      context.goNamed(
                        VideosWidget.routeName,
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
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              route == '/videos'
                                  ? Color(0xFF7D56FF)
                                  : Colors.transparent,
                              route == '/videos'
                                  ? Color(0xFF6187F1)
                                  : Colors.transparent
                            ],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(0.0, -1.0),
                            end: AlignmentDirectional(0, 1.0),
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Icon(
                            Icons.play_arrow,
                            color: route == '/videos'
                                ? AppColors.textPrimary
                                : Color(0xFFAFAFB4),
                            size: 18.0,
                          ),
                        ),
                      ),
                      Text(
                        'Videos',
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          height: 1.67,
                        ),
                      ),
                    ].divide(SizedBox(height: 4.0)),
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
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              route == '/messages'
                                  ? Color(0xFF7D56FF)
                                  : Colors.transparent,
                              route == '/messages'
                                  ? Color(0xFF6187F1)
                                  : Colors.transparent
                            ],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(0.0, -1.0),
                            end: AlignmentDirectional(0, 1.0),
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: FaIcon(
                            FontAwesomeIcons.solidCommentAlt,
                            color: route == '/messages'
                                ? AppColors.textPrimary
                                : Color(0xFFAFAFB4),
                            size: 18.0,
                          ),
                        ),
                      ),
                      Text(
                        'Messages',
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          height: 1.67,
                        ),
                      ),
                    ].divide(SizedBox(height: 4.0)),
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
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              route == '/wishlist'
                                  ? Color(0xFF7D56FF)
                                  : Colors.transparent,
                              route == '/wishlist'
                                  ? Color(0xFF6187F1)
                                  : Colors.transparent
                            ],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(0.0, -1.0),
                            end: AlignmentDirectional(0, 1.0),
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Icon(
                            Icons.favorite_outlined,
                            color: route == '/wishlist'
                                ? AppColors.textPrimary
                                : Color(0xFFAFAFB4),
                            size: 18.0,
                          ),
                        ),
                      ),
                      Text(
                        'Wishlist',
                        style: GoogleFonts.inter(
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          height: 1.67,
                        ),
                      ),
                    ].divide(SizedBox(height: 4.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

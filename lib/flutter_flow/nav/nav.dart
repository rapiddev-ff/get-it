import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/backend/schema/structs/index.dart';

import '/auth/base_auth_user_provider.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  String? _redirectLocation;

  /// Determines whether the app will refresh and build again when a sign
  /// in or sign out happens. This is useful when the app is launched or
  /// on an unexpected logout. However, this must be turned off when we
  /// intend to sign in/out and then navigate or perform any actions after.
  /// Otherwise, this will trigger a refresh and interrupt the action(s).
  bool notifyOnAuthChange = true;

  bool get loading => user == null || showSplashImage;
  bool get loggedIn => user?.loggedIn ?? false;
  bool get initiallyLoggedIn => initialUser?.loggedIn ?? false;
  bool get shouldRedirect => loggedIn && _redirectLocation != null;

  String getRedirectLocation() => _redirectLocation!;
  bool hasRedirect() => _redirectLocation != null;
  void setRedirectLocationIfUnset(String loc) => _redirectLocation ??= loc;
  void clearRedirectLocation() => _redirectLocation = null;

  /// Mark as not needing to notify on a sign in / out when we intend
  /// to perform subsequent actions (such as navigation) afterwards.
  void updateNotifyOnAuthChange(bool notify) => notifyOnAuthChange = notify;

  void update(BaseAuthUser newUser) {
    final shouldUpdate =
        user?.uid == null || newUser.uid == null || user?.uid != newUser.uid;
    initialUser ??= newUser;
    user = newUser;
    // Refresh the app on auth change unless explicitly marked otherwise.
    // No need to update unless the user has changed.
    if (notifyOnAuthChange && shouldUpdate) {
      notifyListeners();
    }
    // Once again mark the notifier as needing to update on auth change
    // (in order to catch sign in / out events).
    updateNotifyOnAuthChange(true);
  }

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) =>
          appStateNotifier.loggedIn ? CheckDataWidget() : WelcomeWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) =>
              appStateNotifier.loggedIn ? CheckDataWidget() : WelcomeWidget(),
          routes: [
            FFRoute(
              name: SignInWidget.routeName,
              path: SignInWidget.routePath,
              builder: (context, params) => SignInWidget(),
            ),
            FFRoute(
              name: WelcomeWidget.routeName,
              path: WelcomeWidget.routePath,
              builder: (context, params) => WelcomeWidget(),
            ),
            FFRoute(
              name: HomePageWidget.routeName,
              path: HomePageWidget.routePath,
              builder: (context, params) => HomePageWidget(),
            ),
            FFRoute(
              name: PhoneVerificationPageWidget.routeName,
              path: PhoneVerificationPageWidget.routePath,
              builder: (context, params) => PhoneVerificationPageWidget(
                isOnboarding: params.getParam(
                  'isOnboarding',
                  ParamType.bool,
                ),
              ),
            ),
            FFRoute(
              name: PhoneVerificationPage2Widget.routeName,
              path: PhoneVerificationPage2Widget.routePath,
              builder: (context, params) => PhoneVerificationPage2Widget(
                phoneNumber: params.getParam(
                  'phoneNumber',
                  ParamType.String,
                ),
                isOnborading: params.getParam(
                  'isOnborading',
                  ParamType.bool,
                ),
              ),
            ),
            FFRoute(
              name: SignUpWidget.routeName,
              path: SignUpWidget.routePath,
              builder: (context, params) => SignUpWidget(),
            ),
            FFRoute(
              name: ForgotPasswordWidget.routeName,
              path: ForgotPasswordWidget.routePath,
              builder: (context, params) => ForgotPasswordWidget(),
            ),
            FFRoute(
              name: ForgotPasswordStep2Widget.routeName,
              path: ForgotPasswordStep2Widget.routePath,
              builder: (context, params) => ForgotPasswordStep2Widget(
                email: params.getParam(
                  'email',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: ForgotPasswordStep3Widget.routeName,
              path: ForgotPasswordStep3Widget.routePath,
              builder: (context, params) => ForgotPasswordStep3Widget(
                code: params.getParam(
                  'code',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: PermissionsWidget.routeName,
              path: PermissionsWidget.routePath,
              builder: (context, params) => PermissionsWidget(),
            ),
            FFRoute(
              name: AdditionalInfoWidget.routeName,
              path: AdditionalInfoWidget.routePath,
              builder: (context, params) => AdditionalInfoWidget(),
            ),
            FFRoute(
              name: CheckDataWidget.routeName,
              path: CheckDataWidget.routePath,
              builder: (context, params) => CheckDataWidget(
                fromSignIn: params.getParam(
                  'fromSignIn',
                  ParamType.bool,
                ),
              ),
            ),
            FFRoute(
              name: SettingsWidget.routeName,
              path: SettingsWidget.routePath,
              builder: (context, params) => SettingsWidget(),
            ),
            FFRoute(
              name: SettingsReferralWidget.routeName,
              path: SettingsReferralWidget.routePath,
              builder: (context, params) => SettingsReferralWidget(),
            ),
            FFRoute(
              name: SettingsPaymentMethodWidget.routeName,
              path: SettingsPaymentMethodWidget.routePath,
              builder: (context, params) => SettingsPaymentMethodWidget(),
            ),
            FFRoute(
              name: NotificationWidget.routeName,
              path: NotificationWidget.routePath,
              builder: (context, params) => NotificationWidget(),
            ),
            FFRoute(
              name: NotificationSettingsWidget.routeName,
              path: NotificationSettingsWidget.routePath,
              builder: (context, params) => NotificationSettingsWidget(),
            ),
            FFRoute(
              name: SettingsPaymentMethodAddWidget.routeName,
              path: SettingsPaymentMethodAddWidget.routePath,
              builder: (context, params) => SettingsPaymentMethodAddWidget(),
            ),
            FFRoute(
              name: SettingsMyProfileWidget.routeName,
              path: SettingsMyProfileWidget.routePath,
              builder: (context, params) => SettingsMyProfileWidget(),
            ),
            FFRoute(
              name: SettingsBlockListWidget.routeName,
              path: SettingsBlockListWidget.routePath,
              builder: (context, params) => SettingsBlockListWidget(),
            ),
            FFRoute(
              name: SettingsTermsWidget.routeName,
              path: SettingsTermsWidget.routePath,
              builder: (context, params) => SettingsTermsWidget(),
            ),
            FFRoute(
              name: SettingsPrivacyWidget.routeName,
              path: SettingsPrivacyWidget.routePath,
              builder: (context, params) => SettingsPrivacyWidget(),
            ),
            FFRoute(
              name: SettingsReportWidget.routeName,
              path: SettingsReportWidget.routePath,
              builder: (context, params) => SettingsReportWidget(),
            ),
            FFRoute(
              name: WishlistWidget.routeName,
              path: WishlistWidget.routePath,
              builder: (context, params) => WishlistWidget(),
            ),
            FFRoute(
              name: MessagesWidget.routeName,
              path: MessagesWidget.routePath,
              builder: (context, params) => MessagesWidget(),
            ),
            FFRoute(
              name: BrowseWidget.routeName,
              path: BrowseWidget.routePath,
              builder: (context, params) => BrowseWidget(),
            ),
            FFRoute(
              name: HomeProductWidget.routeName,
              path: HomeProductWidget.routePath,
              builder: (context, params) => HomeProductWidget(
                productId: params.getParam(
                  'productId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: VideosWidget.routeName,
              path: VideosWidget.routePath,
              builder: (context, params) => VideosWidget(),
            ),
            FFRoute(
              name: HomeSellerProfileWidget.routeName,
              path: HomeSellerProfileWidget.routePath,
              builder: (context, params) => HomeSellerProfileWidget(
                sellerId: params.getParam(
                  'sellerId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: ChatPageWidget.routeName,
              path: ChatPageWidget.routePath,
              builder: (context, params) => ChatPageWidget(
                conversation: params.getParam(
                  'conversation',
                  ParamType.DataStruct,
                  isList: false,
                  structBuilder: ConversationStruct.fromSerializableMap,
                ),
              ),
            ),
            FFRoute(
              name: StripeSuccessWidget.routeName,
              path: StripeSuccessWidget.routePath,
              builder: (context, params) => StripeSuccessWidget(),
            ),
            FFRoute(
              name: StripeRefreshWidget.routeName,
              path: StripeRefreshWidget.routePath,
              builder: (context, params) => StripeRefreshWidget(),
            ),
            FFRoute(
              name: StripeCreateChekOutWidget.routeName,
              path: StripeCreateChekOutWidget.routePath,
              requireAuth: true,
              builder: (context, params) => StripeCreateChekOutWidget(
                checkoutDetail: params.getParam(
                  'checkoutDetail',
                  ParamType.JSON,
                ),
                amount: params.getParam(
                  'amount',
                  ParamType.double,
                ),
                orderId: params.getParam(
                  'orderId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: HomeDashoardEarningsWidget.routeName,
              path: HomeDashoardEarningsWidget.routePath,
              builder: (context, params) => HomeDashoardEarningsWidget(),
            ),
            FFRoute(
              name: HomeDashoardShippingWidget.routeName,
              path: HomeDashoardShippingWidget.routePath,
              builder: (context, params) => HomeDashoardShippingWidget(),
            ),
            FFRoute(
              name: HomeDashoardShippingDetailedWidget.routeName,
              path: HomeDashoardShippingDetailedWidget.routePath,
              builder: (context, params) =>
                  HomeDashoardShippingDetailedWidget(),
            ),
            FFRoute(
              name: HomeDashoardInventoryWidget.routeName,
              path: HomeDashoardInventoryWidget.routePath,
              builder: (context, params) => HomeDashoardInventoryWidget(),
            ),
            FFRoute(
              name: HomeDashoardInventoryAddWidget.routeName,
              path: HomeDashoardInventoryAddWidget.routePath,
              builder: (context, params) => HomeDashoardInventoryAddWidget(
                productId: params.getParam(
                  'productId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: HomeDashoardPromoteStep1Widget.routeName,
              path: HomeDashoardPromoteStep1Widget.routePath,
              builder: (context, params) => HomeDashoardPromoteStep1Widget(),
            ),
            FFRoute(
              name: HomeDashoardPromoteStep2Widget.routeName,
              path: HomeDashoardPromoteStep2Widget.routePath,
              builder: (context, params) => HomeDashoardPromoteStep2Widget(),
            ),
            FFRoute(
              name: HomeDashoardShortlistCreateWidget.routeName,
              path: HomeDashoardShortlistCreateWidget.routePath,
              builder: (context, params) => HomeDashoardShortlistCreateWidget(),
            ),
            FFRoute(
              name: HomeDashoardShortlistCreateStep2Widget.routeName,
              path: HomeDashoardShortlistCreateStep2Widget.routePath,
              builder: (context, params) =>
                  HomeDashoardShortlistCreateStep2Widget(),
            ),
            FFRoute(
              name: HomeDashoardShortlistAddWidget.routeName,
              path: HomeDashoardShortlistAddWidget.routePath,
              builder: (context, params) => HomeDashoardShortlistAddWidget(),
            ),
            FFRoute(
              name: HomeDashoardShortlistWidget.routeName,
              path: HomeDashoardShortlistWidget.routePath,
              builder: (context, params) => HomeDashoardShortlistWidget(),
            ),
            FFRoute(
              name: CheckoutWidget.routeName,
              path: CheckoutWidget.routePath,
              builder: (context, params) => CheckoutWidget(
                feedProductItem: params.getParam(
                  'feedProductItem',
                  ParamType.DataStruct,
                  isList: false,
                  structBuilder: FeedProductStruct.fromSerializableMap,
                ),
                initialQuantity: params.getParam(
                  'initialQuantity',
                  ParamType.int,
                ),
                shortlistId: params.getParam(
                  'shortlistId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: SettingsEditProfileWidget.routeName,
              path: SettingsEditProfileWidget.routePath,
              builder: (context, params) => SettingsEditProfileWidget(),
            ),
            FFRoute(
              name: SettingsPaymentMethodEditWidget.routeName,
              path: SettingsPaymentMethodEditWidget.routePath,
              builder: (context, params) => SettingsPaymentMethodEditWidget(
                paymentMethod: params.getParam(
                  'paymentMethod',
                  ParamType.DataStruct,
                  isList: false,
                  structBuilder: PaymentMethodStruct.fromSerializableMap,
                ),
                index: params.getParam(
                  'index',
                  ParamType.int,
                ),
              ),
            ),
            FFRoute(
              name: SettingsChangePhoneWidget.routeName,
              path: SettingsChangePhoneWidget.routePath,
              builder: (context, params) => SettingsChangePhoneWidget(
                isOnboarding: params.getParam(
                  'isOnboarding',
                  ParamType.bool,
                ),
              ),
            ),
            FFRoute(
              name: SettingsChangeEmailWidget.routeName,
              path: SettingsChangeEmailWidget.routePath,
              builder: (context, params) => SettingsChangeEmailWidget(
                isOnboarding: params.getParam(
                  'isOnboarding',
                  ParamType.bool,
                ),
              ),
            ),
            FFRoute(
              name: SettingsChangePasswordWidget.routeName,
              path: SettingsChangePasswordWidget.routePath,
              builder: (context, params) => SettingsChangePasswordWidget(),
            ),
            FFRoute(
              name: SettingsDeactivateAccountWidget.routeName,
              path: SettingsDeactivateAccountWidget.routePath,
              builder: (context, params) => SettingsDeactivateAccountWidget(),
            ),
            FFRoute(
              name: SettingsDeleteAccountWidget.routeName,
              path: SettingsDeleteAccountWidget.routePath,
              builder: (context, params) => SettingsDeleteAccountWidget(),
            ),
            FFRoute(
              name: SettingsBusinessAddressWidget.routeName,
              path: SettingsBusinessAddressWidget.routePath,
              builder: (context, params) => SettingsBusinessAddressWidget(),
            ),
            FFRoute(
              name: SettingsMyProfileFollowersWidget.routeName,
              path: SettingsMyProfileFollowersWidget.routePath,
              builder: (context, params) => SettingsMyProfileFollowersWidget(),
            ),
            FFRoute(
              name: SettingsDailyBudgetWidget.routeName,
              path: SettingsDailyBudgetWidget.routePath,
              builder: (context, params) => SettingsDailyBudgetWidget(),
            ),
            FFRoute(
              name: TestWidget.routeName,
              path: TestWidget.routePath,
              builder: (context, params) => TestWidget(),
            ),
            FFRoute(
              name: StripeSuccessCopyWidget.routeName,
              path: StripeSuccessCopyWidget.routePath,
              builder: (context, params) => StripeSuccessCopyWidget(),
            ),
            FFRoute(
              name: ChatBuyerProfileWidget.routeName,
              path: ChatBuyerProfileWidget.routePath,
              builder: (context, params) => ChatBuyerProfileWidget(
                buyerId: params.getParam(
                  'buyerId',
                  ParamType.String,
                ),
              ),
            ),
            FFRoute(
              name: HomeSellerProfileReviewsWidget.routeName,
              path: HomeSellerProfileReviewsWidget.routePath,
              builder: (context, params) => HomeSellerProfileReviewsWidget(
                sellerDataType: params.getParam(
                  'sellerDataType',
                  ParamType.DataStruct,
                  isList: false,
                  structBuilder: SellerStruct.fromSerializableMap,
                ),
              ),
            ),
            FFRoute(
              name: HomeSellerProfileReviewsStep1Widget.routeName,
              path: HomeSellerProfileReviewsStep1Widget.routePath,
              builder: (context, params) => HomeSellerProfileReviewsStep1Widget(
                sellerDataType: params.getParam(
                  'sellerDataType',
                  ParamType.DataStruct,
                  isList: false,
                  structBuilder: SellerStruct.fromSerializableMap,
                ),
              ),
            ),
            FFRoute(
              name: HomeSellerProfileReviewsStep2Widget.routeName,
              path: HomeSellerProfileReviewsStep2Widget.routePath,
              builder: (context, params) => HomeSellerProfileReviewsStep2Widget(
                sellerDataType: params.getParam(
                  'sellerDataType',
                  ParamType.DataStruct,
                  isList: false,
                  structBuilder: SellerStruct.fromSerializableMap,
                ),
                product: params.getParam(
                  'product',
                  ParamType.DataStruct,
                  isList: false,
                  structBuilder: SellerProductStruct.fromSerializableMap,
                ),
              ),
            ),
            FFRoute(
              name: SettingsShippingDefaultsWidget.routeName,
              path: SettingsShippingDefaultsWidget.routePath,
              builder: (context, params) => SettingsShippingDefaultsWidget(),
            ),
            FFRoute(
              name: HomeDashoardInventoryAddTagsWidget.routeName,
              path: HomeDashoardInventoryAddTagsWidget.routePath,
              builder: (context, params) =>
                  HomeDashoardInventoryAddTagsWidget(),
            ),
            FFRoute(
              name: CheckoutEditShippingAddressWidget.routeName,
              path: CheckoutEditShippingAddressWidget.routePath,
              builder: (context, params) => CheckoutEditShippingAddressWidget(),
            )
          ].map((r) => r.toRoute(appStateNotifier)).toList(),
        ),
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void goNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : goNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void pushNamedAuth(
    String name,
    bool mounted, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
    bool ignoreRedirect = false,
  }) =>
      !mounted || GoRouter.of(this).shouldRedirect(ignoreRedirect)
          ? null
          : pushNamed(
              name,
              pathParameters: pathParameters,
              queryParameters: queryParameters,
              extra: extra,
            );

  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension GoRouterExtensions on GoRouter {
  AppStateNotifier get appState => AppStateNotifier.instance;
  void prepareAuthEvent([bool ignoreRedirect = false]) =>
      appState.hasRedirect() && !ignoreRedirect
          ? null
          : appState.updateNotifyOnAuthChange(false);
  bool shouldRedirect(bool ignoreRedirect) =>
      !ignoreRedirect && appState.hasRedirect();
  void clearRedirectLocation() => appState.clearRedirectLocation();
  void setRedirectLocationIfUnset(String location) =>
      appState.updateNotifyOnAuthChange(false);
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        redirect: (context, state) {
          if (appStateNotifier.shouldRedirect) {
            final redirectLocation = appStateNotifier.getRedirectLocation();
            appStateNotifier.clearRedirectLocation();
            return redirectLocation;
          }

          if (requireAuth && !appStateNotifier.loggedIn) {
            appStateNotifier.setRedirectLocationIfUnset(state.uri.toString());
            return '/welcome';
          }
          return null;
        },
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = appStateNotifier.loading
              ? Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                )
              : page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}

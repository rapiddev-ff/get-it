import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

import '/backend/schema/util/schema_util.dart';
import '/core/router/serialization_util.dart';
import '/core/theme/app_colors.dart';
import '/features/messages/domain/models/conversation_model.dart';
import '/features/home/domain/models/feed_product_model.dart';
import '/features/home/domain/models/seller_model.dart';
import '/features/home/domain/models/seller_product_model.dart';
import '/features/checkout/domain/models/payment_method_model.dart';

import '/features/auth/data/base_auth_user_provider.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export '/core/router/serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  BaseAuthUser? initialUser;
  BaseAuthUser? user;
  bool showSplashImage = true;
  bool initialDataLoaded = false;
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
    // Reset initialDataLoaded when user changes or logs out
    if (shouldUpdate) {
      initialDataLoaded = false;
    }
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
        AppRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.loggedIn
              ? (appStateNotifier.initialDataLoaded
                  ? HomePageWidget()
                  : CheckDataWidget())
              : WelcomeWidget(),
          routes: [
            AppRoute(
              name: SignInWidget.routeName,
              path: SignInWidget.routePath,
              builder: (context, params) => SignInWidget(),
            ),
            AppRoute(
              name: WelcomeWidget.routeName,
              path: WelcomeWidget.routePath,
              builder: (context, params) => WelcomeWidget(),
            ),
            AppRoute(
              name: HomePageWidget.routeName,
              path: HomePageWidget.routePath,
              builder: (context, params) => HomePageWidget(),
            ),
            AppRoute(
              name: PhoneVerificationPageWidget.routeName,
              path: PhoneVerificationPageWidget.routePath,
              builder: (context, params) => PhoneVerificationPageWidget(
                isOnboarding: params.getParam(
                  'isOnboarding',
                  ParamType.bool,
                ),
              ),
            ),
            AppRoute(
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
            AppRoute(
              name: SignUpWidget.routeName,
              path: SignUpWidget.routePath,
              builder: (context, params) => SignUpWidget(),
            ),
            AppRoute(
              name: ForgotPasswordWidget.routeName,
              path: ForgotPasswordWidget.routePath,
              builder: (context, params) => ForgotPasswordWidget(),
            ),
            AppRoute(
              name: ForgotPasswordStep2Widget.routeName,
              path: ForgotPasswordStep2Widget.routePath,
              builder: (context, params) => ForgotPasswordStep2Widget(
                email: params.getParam(
                  'email',
                  ParamType.String,
                ),
              ),
            ),
            AppRoute(
              name: ForgotPasswordStep3Widget.routeName,
              path: ForgotPasswordStep3Widget.routePath,
              builder: (context, params) => ForgotPasswordStep3Widget(
                code: params.getParam(
                  'code',
                  ParamType.String,
                ),
              ),
            ),
            AppRoute(
              name: PermissionsWidget.routeName,
              path: PermissionsWidget.routePath,
              builder: (context, params) => PermissionsWidget(),
            ),
            AppRoute(
              name: AdditionalInfoWidget.routeName,
              path: AdditionalInfoWidget.routePath,
              builder: (context, params) => AdditionalInfoWidget(),
            ),
            AppRoute(
              name: CheckDataWidget.routeName,
              path: CheckDataWidget.routePath,
              builder: (context, params) => CheckDataWidget(
                fromSignIn: params.getParam(
                  'fromSignIn',
                  ParamType.bool,
                ),
              ),
            ),
            AppRoute(
              name: SettingsWidget.routeName,
              path: SettingsWidget.routePath,
              builder: (context, params) => SettingsWidget(),
            ),
            AppRoute(
              name: SettingsReferralWidget.routeName,
              path: SettingsReferralWidget.routePath,
              builder: (context, params) => SettingsReferralWidget(),
            ),
            AppRoute(
              name: SettingsPaymentMethodWidget.routeName,
              path: SettingsPaymentMethodWidget.routePath,
              builder: (context, params) => SettingsPaymentMethodWidget(),
            ),
            AppRoute(
              name: NotificationWidget.routeName,
              path: NotificationWidget.routePath,
              builder: (context, params) => NotificationWidget(),
            ),
            AppRoute(
              name: NotificationSettingsWidget.routeName,
              path: NotificationSettingsWidget.routePath,
              builder: (context, params) => NotificationSettingsWidget(),
            ),
            AppRoute(
              name: SettingsPaymentMethodAddWidget.routeName,
              path: SettingsPaymentMethodAddWidget.routePath,
              builder: (context, params) => SettingsPaymentMethodAddWidget(),
            ),
            AppRoute(
              name: SettingsMyProfileWidget.routeName,
              path: SettingsMyProfileWidget.routePath,
              builder: (context, params) => SettingsMyProfileWidget(),
            ),
            AppRoute(
              name: SettingsBlockListWidget.routeName,
              path: SettingsBlockListWidget.routePath,
              builder: (context, params) => SettingsBlockListWidget(),
            ),
            AppRoute(
              name: SettingsTermsWidget.routeName,
              path: SettingsTermsWidget.routePath,
              builder: (context, params) => SettingsTermsWidget(),
            ),
            AppRoute(
              name: SettingsPrivacyWidget.routeName,
              path: SettingsPrivacyWidget.routePath,
              builder: (context, params) => SettingsPrivacyWidget(),
            ),
            AppRoute(
              name: SettingsReportWidget.routeName,
              path: SettingsReportWidget.routePath,
              builder: (context, params) => SettingsReportWidget(),
            ),
            AppRoute(
              name: WishlistWidget.routeName,
              path: WishlistWidget.routePath,
              builder: (context, params) => WishlistWidget(),
            ),
            AppRoute(
              name: MessagesWidget.routeName,
              path: MessagesWidget.routePath,
              builder: (context, params) => MessagesWidget(),
            ),
            AppRoute(
              name: BrowseWidget.routeName,
              path: BrowseWidget.routePath,
              builder: (context, params) => BrowseWidget(),
            ),
            AppRoute(
              name: HomeProductWidget.routeName,
              path: HomeProductWidget.routePath,
              builder: (context, params) => HomeProductWidget(
                productId: params.getParam(
                  'productId',
                  ParamType.String,
                ),
              ),
            ),
            AppRoute(
              name: VideosWidget.routeName,
              path: VideosWidget.routePath,
              builder: (context, params) => VideosWidget(),
            ),
            AppRoute(
              name: HomeSellerProfileWidget.routeName,
              path: HomeSellerProfileWidget.routePath,
              builder: (context, params) => HomeSellerProfileWidget(
                sellerId: params.getParam(
                  'sellerId',
                  ParamType.String,
                ),
              ),
            ),
            AppRoute(
              name: ChatPageWidget.routeName,
              path: ChatPageWidget.routePath,
              builder: (context, params) => ChatPageWidget(
                conversation: params.getParam(
                  'conversation',
                  ParamType.DataStruct,
                  isList: false,
                  structBuilder: Conversation.fromSerializableMap,
                ),
              ),
            ),
            AppRoute(
              name: StripeSuccessWidget.routeName,
              path: StripeSuccessWidget.routePath,
              builder: (context, params) => StripeSuccessWidget(),
            ),
            AppRoute(
              name: StripeRefreshWidget.routeName,
              path: StripeRefreshWidget.routePath,
              builder: (context, params) => StripeRefreshWidget(),
            ),
            AppRoute(
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
            AppRoute(
              name: HomeDashoardEarningsWidget.routeName,
              path: HomeDashoardEarningsWidget.routePath,
              builder: (context, params) => HomeDashoardEarningsWidget(),
            ),
            AppRoute(
              name: HomeDashoardShippingWidget.routeName,
              path: HomeDashoardShippingWidget.routePath,
              builder: (context, params) => HomeDashoardShippingWidget(),
            ),
            AppRoute(
              name: HomeDashoardShippingDetailedWidget.routeName,
              path: HomeDashoardShippingDetailedWidget.routePath,
              builder: (context, params) =>
                  HomeDashoardShippingDetailedWidget(),
            ),
            AppRoute(
              name: HomeDashoardInventoryWidget.routeName,
              path: HomeDashoardInventoryWidget.routePath,
              builder: (context, params) => HomeDashoardInventoryWidget(),
            ),
            AppRoute(
              name: HomeDashoardInventoryAddWidget.routeName,
              path: HomeDashoardInventoryAddWidget.routePath,
              builder: (context, params) => HomeDashoardInventoryAddWidget(
                productId: params.getParam(
                  'productId',
                  ParamType.String,
                ),
              ),
            ),
            AppRoute(
              name: HomeDashoardPromoteStep1Widget.routeName,
              path: HomeDashoardPromoteStep1Widget.routePath,
              builder: (context, params) => HomeDashoardPromoteStep1Widget(),
            ),
            AppRoute(
              name: HomeDashoardPromoteStep2Widget.routeName,
              path: HomeDashoardPromoteStep2Widget.routePath,
              builder: (context, params) => HomeDashoardPromoteStep2Widget(),
            ),
            AppRoute(
              name: HomeDashoardShortlistCreateWidget.routeName,
              path: HomeDashoardShortlistCreateWidget.routePath,
              builder: (context, params) => HomeDashoardShortlistCreateWidget(),
            ),
            AppRoute(
              name: HomeDashoardShortlistCreateStep2Widget.routeName,
              path: HomeDashoardShortlistCreateStep2Widget.routePath,
              builder: (context, params) {
                final allParams = params.state.uri.queryParameters;
                return HomeDashoardShortlistCreateStep2Widget(
                  name: allParams['name'] ?? '',
                  eventName: allParams['eventName'] ?? '',
                  startDate: allParams['startDate'] ?? '',
                  endDate: allParams['endDate'] ?? '',
                  isPublic: allParams['isPublic'] != 'false',
                  shortlistId: allParams['shortlistId'],
                );
              },
            ),
            AppRoute(
              name: HomeDashoardShortlistAddWidget.routeName,
              path: HomeDashoardShortlistAddWidget.routePath,
              builder: (context, params) => HomeDashoardShortlistAddWidget(),
            ),
            AppRoute(
              name: HomeDashoardShortlistWidget.routeName,
              path: HomeDashoardShortlistWidget.routePath,
              builder: (context, params) => HomeDashoardShortlistWidget(),
            ),
            AppRoute(
              name: CheckoutWidget.routeName,
              path: CheckoutWidget.routePath,
              builder: (context, params) => CheckoutWidget(
                feedProductItem: params.getParam(
                  'feedProductItem',
                  ParamType.DataStruct,
                  isList: false,
                  structBuilder: FeedProduct.fromSerializableMap,
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
            AppRoute(
              name: SettingsEditProfileWidget.routeName,
              path: SettingsEditProfileWidget.routePath,
              builder: (context, params) => SettingsEditProfileWidget(),
            ),
            AppRoute(
              name: SettingsPaymentMethodEditWidget.routeName,
              path: SettingsPaymentMethodEditWidget.routePath,
              builder: (context, params) => SettingsPaymentMethodEditWidget(
                paymentMethod: params.getParam(
                  'paymentMethod',
                  ParamType.DataStruct,
                  isList: false,
                  structBuilder: PaymentMethod.fromSerializableMap,
                ),
                index: params.getParam(
                  'index',
                  ParamType.int,
                ),
              ),
            ),
            AppRoute(
              name: SettingsChangePhoneWidget.routeName,
              path: SettingsChangePhoneWidget.routePath,
              builder: (context, params) => SettingsChangePhoneWidget(
                isOnboarding: params.getParam(
                  'isOnboarding',
                  ParamType.bool,
                ),
              ),
            ),
            AppRoute(
              name: SettingsChangeEmailWidget.routeName,
              path: SettingsChangeEmailWidget.routePath,
              builder: (context, params) => SettingsChangeEmailWidget(
                isOnboarding: params.getParam(
                  'isOnboarding',
                  ParamType.bool,
                ),
              ),
            ),
            AppRoute(
              name: SettingsChangePasswordWidget.routeName,
              path: SettingsChangePasswordWidget.routePath,
              builder: (context, params) => SettingsChangePasswordWidget(),
            ),
            AppRoute(
              name: SettingsDeactivateAccountWidget.routeName,
              path: SettingsDeactivateAccountWidget.routePath,
              builder: (context, params) => SettingsDeactivateAccountWidget(),
            ),
            AppRoute(
              name: SettingsDeleteAccountWidget.routeName,
              path: SettingsDeleteAccountWidget.routePath,
              builder: (context, params) => SettingsDeleteAccountWidget(),
            ),
            AppRoute(
              name: SettingsBusinessAddressWidget.routeName,
              path: SettingsBusinessAddressWidget.routePath,
              builder: (context, params) => SettingsBusinessAddressWidget(),
            ),
            AppRoute(
              name: SettingsMyProfileFollowersWidget.routeName,
              path: SettingsMyProfileFollowersWidget.routePath,
              builder: (context, params) => SettingsMyProfileFollowersWidget(),
            ),
            AppRoute(
              name: SettingsDailyBudgetWidget.routeName,
              path: SettingsDailyBudgetWidget.routePath,
              builder: (context, params) => SettingsDailyBudgetWidget(),
            ),
            AppRoute(
              name: StripeSuccessCopyWidget.routeName,
              path: StripeSuccessCopyWidget.routePath,
              builder: (context, params) => StripeSuccessCopyWidget(),
            ),
            AppRoute(
              name: ChatBuyerProfileWidget.routeName,
              path: ChatBuyerProfileWidget.routePath,
              builder: (context, params) => ChatBuyerProfileWidget(
                buyerId: params.getParam(
                  'buyerId',
                  ParamType.String,
                ),
              ),
            ),
            AppRoute(
              name: HomeSellerProfileReviewsWidget.routeName,
              path: HomeSellerProfileReviewsWidget.routePath,
              builder: (context, params) => HomeSellerProfileReviewsWidget(
                sellerDataType: params.getParam(
                  'sellerDataType',
                  ParamType.DataStruct,
                  isList: false,
                  structBuilder: Seller.fromSerializableMap,
                ),
              ),
            ),
            AppRoute(
              name: HomeSellerProfileReviewsStep1Widget.routeName,
              path: HomeSellerProfileReviewsStep1Widget.routePath,
              builder: (context, params) => HomeSellerProfileReviewsStep1Widget(
                sellerDataType: params.getParam(
                  'sellerDataType',
                  ParamType.DataStruct,
                  isList: false,
                  structBuilder: Seller.fromSerializableMap,
                ),
                reviewRole: params.getParam(
                  'reviewRole',
                  ParamType.String,
                ) ?? 'as_buyer',
              ),
            ),
            AppRoute(
              name: HomeSellerProfileReviewsStep2Widget.routeName,
              path: HomeSellerProfileReviewsStep2Widget.routePath,
              builder: (context, params) => HomeSellerProfileReviewsStep2Widget(
                sellerDataType: params.getParam(
                  'sellerDataType',
                  ParamType.DataStruct,
                  isList: false,
                  structBuilder: Seller.fromSerializableMap,
                ),
                product: params.getParam(
                  'product',
                  ParamType.DataStruct,
                  isList: false,
                  structBuilder: SellerProduct.fromSerializableMap,
                ),
                reviewRole: params.getParam(
                  'reviewRole',
                  ParamType.String,
                ) ?? 'as_buyer',
              ),
            ),
            AppRoute(
              name: SettingsShippingDefaultsWidget.routeName,
              path: SettingsShippingDefaultsWidget.routePath,
              builder: (context, params) => SettingsShippingDefaultsWidget(),
            ),
            AppRoute(
              name: HomeDashoardInventoryAddTagsWidget.routeName,
              path: HomeDashoardInventoryAddTagsWidget.routePath,
              builder: (context, params) =>
                  HomeDashoardInventoryAddTagsWidget(),
            ),
            AppRoute(
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
      appState.setRedirectLocationIfUnset(location);
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

class AppRouteParameters {
  AppRouteParameters(this.state, [this.asyncParams = const {}]);

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

void fixStatusBarOniOS16AndBelow(BuildContext context) {
  if (kIsWeb || !Platform.isIOS) return;
  final brightness = Theme.of(context).brightness;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: brightness,
      systemStatusBarContrastEnforced: true,
    ),
  );
}

class AppRoute {
  const AppRoute({
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
  final Widget Function(BuildContext, AppRouteParameters) builder;
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
          final ffParams = AppRouteParameters(state, asyncParams);
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
                        AppColors.primary,
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

class RootPageContext extends InheritedWidget {
  const RootPageContext({
    super.key,
    required this.isRootPage,
    this.errorRoute,
    required super.child,
  });

  final bool isRootPage;
  final String? errorRoute;

  static RootPageContext? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RootPageContext>();

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = RootPageContext.of(context);
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => RootPageContext(
        isRootPage: true,
        errorRoute: errorRoute,
        child: child,
      );

  @override
  bool updateShouldNotify(RootPageContext oldWidget) =>
      isRootPage != oldWidget.isRootPage || errorRoute != oldWidget.errorRoute;
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

import '/features/messages/domain/models/conversation_model.dart';
import '/features/home/domain/models/feed_product_model.dart';
import '/features/home/domain/models/seller_model.dart';
import '/features/home/domain/models/seller_product_model.dart';
import '/features/checkout/domain/models/payment_method_model.dart';

import '/core/router/app_router.dart';

import '/index.dart';

/// All app route definitions, extracted from app_router.dart for readability.
List<AppRoute> appRoutes() => [
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
          isOnboarding: params.getParam('isOnboarding', ParamType.bool),
        ),
      ),
      AppRoute(
        name: PhoneVerificationPage2Widget.routeName,
        path: PhoneVerificationPage2Widget.routePath,
        builder: (context, params) => PhoneVerificationPage2Widget(
          phoneNumber: params.getParam('phoneNumber', ParamType.String),
          isOnborading: params.getParam('isOnborading', ParamType.bool),
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
          email: params.getParam('email', ParamType.String),
        ),
      ),
      AppRoute(
        name: ForgotPasswordStep3Widget.routeName,
        path: ForgotPasswordStep3Widget.routePath,
        builder: (context, params) => ForgotPasswordStep3Widget(
          code: params.getParam('code', ParamType.String),
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
          fromSignIn: params.getParam('fromSignIn', ParamType.bool),
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
          productId: params.getParam('productId', ParamType.String),
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
          sellerId: params.getParam('sellerId', ParamType.String),
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
          checkoutDetail: params.getParam('checkoutDetail', ParamType.JSON),
          amount: params.getParam('amount', ParamType.double),
          orderId: params.getParam('orderId', ParamType.String),
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
        builder: (context, params) {
          final allParams = params.state.uri.queryParameters;
          return HomeDashoardShippingDetailedWidget(
            orderId: allParams['orderId'],
          );
        },
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
          productId: params.getParam('productId', ParamType.String),
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
          initialQuantity: params.getParam('initialQuantity', ParamType.int),
          shortlistId: params.getParam('shortlistId', ParamType.String),
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
          index: params.getParam('index', ParamType.int),
        ),
      ),
      AppRoute(
        name: SettingsChangePhoneWidget.routeName,
        path: SettingsChangePhoneWidget.routePath,
        builder: (context, params) => SettingsChangePhoneWidget(
          isOnboarding: params.getParam('isOnboarding', ParamType.bool),
        ),
      ),
      AppRoute(
        name: SettingsChangeEmailWidget.routeName,
        path: SettingsChangeEmailWidget.routePath,
        builder: (context, params) => SettingsChangeEmailWidget(
          isOnboarding: params.getParam('isOnboarding', ParamType.bool),
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
          buyerId: params.getParam('buyerId', ParamType.String),
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
          reviewRole:
              params.getParam('reviewRole', ParamType.String) ?? 'as_buyer',
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
          reviewRole:
              params.getParam('reviewRole', ParamType.String) ?? 'as_buyer',
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
        builder: (context, params) => HomeDashoardInventoryAddTagsWidget(),
      ),
      AppRoute(
        name: CheckoutEditShippingAddressWidget.routeName,
        path: CheckoutEditShippingAddressWidget.routePath,
        builder: (context, params) => CheckoutEditShippingAddressWidget(),
      ),
    ];

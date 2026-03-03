import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/core/config/environment_values.dart';
import '/core/utils/json_utils.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start Twillio Group Code

class TwillioGroup {
  static String getBaseUrl({
    String? authToken,
    String? serviceSID,
  }) {
    authToken ??= FFDevEnvironmentValues().twillioBase64;
    serviceSID ??= FFDevEnvironmentValues().serviceSid;
    return 'https://verify.twilio.com/v2';
  }

  static Map<String, String> headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': 'Basic [authToken]',
  };
  static SendVerificationCall sendVerificationCall = SendVerificationCall();
  static VerifyCodeCall verifyCodeCall = VerifyCodeCall();
}

class SendVerificationCall {
  Future<ApiCallResponse> call({
    String? to = '',
    String? authToken,
    String? serviceSID,
  }) async {
    authToken ??= FFDevEnvironmentValues().twillioBase64;
    serviceSID ??= FFDevEnvironmentValues().serviceSid;
    final baseUrl = TwillioGroup.getBaseUrl(
      authToken: authToken,
      serviceSID: serviceSID,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'SendVerification',
      apiUrl: '${baseUrl}/Services/${serviceSID}/Verifications',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ${authToken}',
      },
      params: {
        'To': to,
        'Channel': "sms",
      },
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class VerifyCodeCall {
  Future<ApiCallResponse> call({
    String? to = '',
    String? code = '',
    String? authToken,
    String? serviceSID,
  }) async {
    authToken ??= FFDevEnvironmentValues().twillioBase64;
    serviceSID ??= FFDevEnvironmentValues().serviceSid;
    final baseUrl = TwillioGroup.getBaseUrl(
      authToken: authToken,
      serviceSID: serviceSID,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'VerifyCode',
      apiUrl: '${baseUrl}/Services/${serviceSID}/VerificationCheck',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Basic ${authToken}',
      },
      params: {
        'To': to,
        'Code': code,
      },
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? isValid(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.valid''',
      ));
  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.status''',
      ));
}

/// End Twillio Group Code

/// Start Supabase RPC Group Code

class SupabaseRPCGroup {
  static String getBaseUrl({
    String? apikey,
    String? url,
  }) {
    apikey ??= FFDevEnvironmentValues().supabaseAnonKey;
    url ??= FFDevEnvironmentValues().supabaseHost;
    return '${url}/rest/v1/rpc';
  }

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'apikey': '[apikey]',
    'Authorization': 'Bearer [apikey]',
  };
  static WishlistProductsCall wishlistProductsCall = WishlistProductsCall();
  static ProductsCall productsCall = ProductsCall();
  static ProductsCopyCall productsCopyCall = ProductsCopyCall();
  static GetuserprofilewithreviewsCall getuserprofilewithreviewsCall =
      GetuserprofilewithreviewsCall();
  static CheckphoneexistsCall checkphoneexistsCall = CheckphoneexistsCall();
  static GetuserreviewsCall getuserreviewsCall = GetuserreviewsCall();
}

class WishlistProductsCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
    String? apikey,
    String? url,
  }) async {
    apikey ??= FFDevEnvironmentValues().supabaseAnonKey;
    url ??= FFDevEnvironmentValues().supabaseHost;
    final baseUrl = SupabaseRPCGroup.getBaseUrl(
      apikey: apikey,
      url: url,
    );

    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'wishlistProducts',
      apiUrl: '${baseUrl}/get_wishlist_products',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ProductsCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
    String? apikey,
    String? url,
  }) async {
    apikey ??= FFDevEnvironmentValues().supabaseAnonKey;
    url ??= FFDevEnvironmentValues().supabaseHost;
    final baseUrl = SupabaseRPCGroup.getBaseUrl(
      apikey: apikey,
      url: url,
    );

    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_limit": "10",
  "p_exclude_ids": "{}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Products',
      apiUrl: '${baseUrl}/get_feed_products',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ProductsCopyCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
    String? apikey,
    String? url,
  }) async {
    apikey ??= FFDevEnvironmentValues().supabaseAnonKey;
    url ??= FFDevEnvironmentValues().supabaseHost;
    final baseUrl = SupabaseRPCGroup.getBaseUrl(
      apikey: apikey,
      url: url,
    );

    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_limit": "10",
  "p_exclude_ids": "{}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Products Copy',
      apiUrl: '${baseUrl}/get_feed_products',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetuserprofilewithreviewsCall {
  Future<ApiCallResponse> call({
    String? pUserId = '',
    int? pOffset = 0,
    int? pLimit = 5,
    String? apikey,
    String? url,
  }) async {
    apikey ??= FFDevEnvironmentValues().supabaseAnonKey;
    url ??= FFDevEnvironmentValues().supabaseHost;
    final baseUrl = SupabaseRPCGroup.getBaseUrl(
      apikey: apikey,
      url: url,
    );

    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",
  "p_limit": ${pLimit},
  "p_offset": ${pOffset}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getuserprofilewithreviews',
      apiUrl: '${baseUrl}/get_user_profile_with_reviews',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CheckphoneexistsCall {
  Future<ApiCallResponse> call({
    String? userId = '',
    String? role = '',
    int? limit,
    int? offset,
    String? apikey,
    String? url,
  }) async {
    apikey ??= FFDevEnvironmentValues().supabaseAnonKey;
    url ??= FFDevEnvironmentValues().supabaseHost;
    final baseUrl = SupabaseRPCGroup.getBaseUrl(
      apikey: apikey,
      url: url,
    );

    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(userId)}",
  "p_role": "${escapeStringForJson(role)}",
  "p_limit": ${limit},
  "p_offset": ${offset}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'checkphoneexists',
      apiUrl: '${baseUrl}/get_user_reviews',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetuserreviewsCall {
  Future<ApiCallResponse> call({
    String? userId = '',
    String? role = '',
    int? limit,
    int? offset,
    String? apikey,
    String? url,
  }) async {
    apikey ??= FFDevEnvironmentValues().supabaseAnonKey;
    url ??= FFDevEnvironmentValues().supabaseHost;
    final baseUrl = SupabaseRPCGroup.getBaseUrl(
      apikey: apikey,
      url: url,
    );

    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(userId)}",
  "p_role": "${escapeStringForJson(role)}",
  "p_limit": ${limit},
  "p_offset": ${offset}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getuserreviews',
      apiUrl: '${baseUrl}/get_user_reviews',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Supabase RPC Group Code

/// Start Stripe Group Code

class StripeGroup {
  static String getBaseUrl({
    String? skStripe,
  }) {
    skStripe ??= FFDevEnvironmentValues().stripeSecret;
    return 'https://api.stripe.com/v1';
  }

  static Map<String, String> headers = {
    'Authorization': 'Bearer [skStripe]',
  };
  static CreateACustomerCall createACustomerCall = CreateACustomerCall();
  static CreateAnAccountCall createAnAccountCall = CreateAnAccountCall();
  static CreateAnAccountLinkCall createAnAccountLinkCall =
      CreateAnAccountLinkCall();
}

class CreateACustomerCall {
  Future<ApiCallResponse> call({
    String? name = '',
    String? email = '',
    String? userId = '',
    String? shoperId = '',
    String? skStripe,
  }) async {
    skStripe ??= FFDevEnvironmentValues().stripeSecret;
    final baseUrl = StripeGroup.getBaseUrl(
      skStripe: skStripe,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'Create a customer',
      apiUrl: '${baseUrl}/customers',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${skStripe}',
      },
      params: {
        'name': name,
        'email': email,
        'metadata[user]': userId,
        'metadata[test2]': shoperId,
      },
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? customerId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.id''',
      ));
}

class CreateAnAccountCall {
  Future<ApiCallResponse> call({
    String? userId = '',
    String? type = '',
    String? id = '',
    String? email = '',
    String? skStripe,
  }) async {
    skStripe ??= FFDevEnvironmentValues().stripeSecret;
    final baseUrl = StripeGroup.getBaseUrl(
      skStripe: skStripe,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'Create an account',
      apiUrl: '${baseUrl}/accounts',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${skStripe}',
      },
      params: {
        'business_type': "individual",
        'type': "express",
        'metadata[user_id]': userId,
        'metadata[type]': type,
        'metadata[id]': id,
        'settings[payouts][schedule][delay_days]': 7,
        'email': email,
      },
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateAnAccountLinkCall {
  Future<ApiCallResponse> call({
    String? account = '',
    String? type = '',
    String? skStripe,
  }) async {
    skStripe ??= FFDevEnvironmentValues().stripeSecret;
    final baseUrl = StripeGroup.getBaseUrl(
      skStripe: skStripe,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'Create an account link',
      apiUrl: '${baseUrl}/account_links',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${skStripe}',
      },
      params: {
        'account': account,
        'type': type,
        'refresh_url': "https://reelshoppers.flutterflow.app/stripe_error",
        'return_url': "https://reelshoppers.flutterflow.app/stripe_done",
        'collection_options[fields]': "eventually_due",
        'collection_options[future_requirements]': "include",
      },
      bodyType: BodyType.X_WWW_FORM_URL_ENCODED,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End Stripe Group Code

/// Start supabase Edge Group Code

class SupabaseEdgeGroup {
  static String getBaseUrl({
    String? apikey,
  }) {
    apikey ??= FFDevEnvironmentValues().supabaseAnonKey;
    return 'https://xvdugwnatoqsbfssugsu.supabase.co/functions/v1';
  }

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'apikey': '[apikey]',
    'Authorization': 'Bearer [apikey]',
  };
  static ResetPasswordCall resetPasswordCall = ResetPasswordCall();
  static TaxDocumentsCall taxDocumentsCall = TaxDocumentsCall();
}

class ResetPasswordCall {
  Future<ApiCallResponse> call({
    String? code = '',
    String? newPassword = '',
    String? apikey,
  }) async {
    apikey ??= FFDevEnvironmentValues().supabaseAnonKey;
    final baseUrl = SupabaseEdgeGroup.getBaseUrl(
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "code": "${escapeStringForJson(code)}",
  "newPassword": "${escapeStringForJson(newPassword)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'resetPassword',
      apiUrl: '${baseUrl}/reset-password',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class TaxDocumentsCall {
  Future<ApiCallResponse> call({
    String? userId = '',
    String? apikey,
  }) async {
    apikey ??= FFDevEnvironmentValues().supabaseAnonKey;
    final baseUrl = SupabaseEdgeGroup.getBaseUrl(
      apikey: apikey,
    );

    final ffApiRequestBody = '''
{
  "userId": "${escapeStringForJson(userId)}",
  "action": "list"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'tax documents',
      apiUrl: '${baseUrl}/download-stripe-tax-documents',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': '${apikey}',
        'Authorization': 'Bearer ${apikey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List? documents(dynamic response) => getJsonField(
        response,
        r'''$.documents''',
        true,
      ) as List?;
}

/// End supabase Edge Group Code

/// Start googlePlaces Group Code

class GooglePlacesGroup {
  static String getBaseUrl({
    String? google,
  }) {
    google ??= FFDevEnvironmentValues().google;
    return 'https://places.googleapis.com/v1/places';
  }

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'X-Goog-Api-Key': '[google]',
  };
  static AutocompleteCall autocompleteCall = AutocompleteCall();
  static GetPlaceCall getPlaceCall = GetPlaceCall();
}

class AutocompleteCall {
  Future<ApiCallResponse> call({
    String? searchingString = '',
    String? google,
  }) async {
    google ??= FFDevEnvironmentValues().google;
    final baseUrl = GooglePlacesGroup.getBaseUrl(
      google: google,
    );

    final ffApiRequestBody = '''
{
  "input": "${escapeStringForJson(searchingString)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'autocomplete',
      apiUrl: '${baseUrl}:autocomplete',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': '${google}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List<String>? predictionPlaceText(dynamic response) => (getJsonField(
        response,
        r'''$.suggestions[*].placePrediction.text.text''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  dynamic autocompletePredictions(dynamic response) => getJsonField(
        response,
        r'''$.suggestions[*].placePrediction.placeId''',
      );
}

class GetPlaceCall {
  Future<ApiCallResponse> call({
    String? placeId = '',
    String? google,
  }) async {
    google ??= FFDevEnvironmentValues().google;
    final baseUrl = GooglePlacesGroup.getBaseUrl(
      google: google,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'getPlace',
      apiUrl: '${baseUrl}/${placeId}',
      callType: ApiCallType.GET,
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': '${google}',
        'X-Goog-FieldMask': 'addressComponents',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

/// End googlePlaces Group Code

class StripeCreateCheckoutCall {
  static Future<ApiCallResponse> call({
    String? jwt = '',
    String? orderId = '',
    String? successUrl = '',
    String? cancelUrl = '',
  }) async {
    final ffApiRequestBody = '''
{
  "orderId": "d825df3e-1234-5678-90ab-cdef12345678",
  "successUrl": "https://ваше-приложение.com/orders/success?session_id={CHECKOUT_SESSION_ID}",
  "cancelUrl": "https://ваше-приложение.com/orders/cart"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Stripe create checkout',
      apiUrl:
          'https://xvdugwnatoqsbfssugsu.supabase.co/functions/v1/create-checkout-session',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${jwt}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}

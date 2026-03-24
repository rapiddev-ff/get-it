import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';

import '/core/config/app_config.dart';
import '/core/utils/json_utils.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

/// Start Twillio Group Code (via Supabase Edge Functions)

class TwillioGroup {
  static SendVerificationCall sendVerificationCall = SendVerificationCall();
  static VerifyCodeCall verifyCodeCall = VerifyCodeCall();
}

class SendVerificationCall {
  Future<ApiCallResponse> call({
    String? to = '',
  }) async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.functions.invoke(
        'twilio-send-verification',
        body: {'to': to},
      );

      final statusCode = response.status;
      final jsonBody = response.data;

      final body = jsonBody is Map
          ? jsonBody
          : (jsonBody is String ? jsonDecode(jsonBody) : {});

      return ApiCallResponse(body, {}, statusCode);
    } on FunctionException catch (e) {
      final details = e.details;
      final body = details is Map ? details : {'error': e.reasonPhrase ?? 'Unknown error'};
      return ApiCallResponse(body, {}, e.status);
    }
  }
}

class VerifyCodeCall {
  Future<ApiCallResponse> call({
    String? to = '',
    String? code = '',
  }) async {
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase.functions.invoke(
        'twilio-verify-code',
        body: {'to': to, 'code': code},
      );

      final statusCode = response.status;
      final jsonBody = response.data;
      final body = jsonBody is Map
          ? jsonBody
          : (jsonBody is String ? jsonDecode(jsonBody) : {});

      return ApiCallResponse(body, {}, statusCode);
    } on FunctionException catch (e) {
      final details = e.details;
      final body = details is Map ? details : {'error': e.reasonPhrase ?? 'Unknown error'};
      return ApiCallResponse(body, {}, e.status);
    }
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
    apikey ??= AppConfig.supabaseAnonKey;
    url ??= AppConfig.supabaseHost;
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
    apikey ??= AppConfig.supabaseAnonKey;
    url ??= AppConfig.supabaseHost;
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
    apikey ??= AppConfig.supabaseAnonKey;
    url ??= AppConfig.supabaseHost;
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
    apikey ??= AppConfig.supabaseAnonKey;
    url ??= AppConfig.supabaseHost;
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
    apikey ??= AppConfig.supabaseAnonKey;
    url ??= AppConfig.supabaseHost;
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
    apikey ??= AppConfig.supabaseAnonKey;
    url ??= AppConfig.supabaseHost;
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
    apikey ??= AppConfig.supabaseAnonKey;
    url ??= AppConfig.supabaseHost;
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

/// Stripe operations are handled via Supabase Edge Functions.
/// See lib/custom_code/actions/ for Stripe-related actions.

/// Start supabase Edge Group Code

class SupabaseEdgeGroup {
  static String getBaseUrl({
    String? apikey,
  }) {
    apikey ??= AppConfig.supabaseAnonKey;
    return '${AppConfig.supabaseUrl}/functions/v1';
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
    apikey ??= AppConfig.supabaseAnonKey;
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
    apikey ??= AppConfig.supabaseAnonKey;
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
    google ??= AppConfig.google;
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
    google ??= AppConfig.google;
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
    google ??= AppConfig.google;
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
        'X-Goog-FieldMask': 'addressComponents,formattedAddress,displayName',
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
          '${AppConfig.supabaseUrl}/functions/v1/create-checkout-session',
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

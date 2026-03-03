import 'dart:convert';

import 'package:flutter/material.dart';

import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';

import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';

/// SERIALIZATION HELPERS

String dateTimeRangeToString(DateTimeRange dateTimeRange) {
  final startStr = dateTimeRange.start.millisecondsSinceEpoch.toString();
  final endStr = dateTimeRange.end.millisecondsSinceEpoch.toString();
  return '$startStr|$endStr';
}

String placeToString(FFPlace place) => jsonEncode({
      'latLng': place.latLng.serialize(),
      'name': place.name,
      'address': place.address,
      'city': place.city,
      'state': place.state,
      'country': place.country,
      'zipCode': place.zipCode,
    });

String uploadedFileToString(FFUploadedFile uploadedFile) =>
    uploadedFile.serialize();

String? serializeParam(
  dynamic param,
  ParamType paramType, {
  bool isList = false,
}) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final serializedValues = (param as Iterable)
          .map((p) => serializeParam(p, paramType, isList: false))
          .where((p) => p != null)
          .map((p) => p!)
          .toList();
      return json.encode(serializedValues);
    }
    String? data;
    switch (paramType) {
      case ParamType.int:
        data = param.toString();
      case ParamType.double:
        data = param.toString();
      case ParamType.String:
        data = param;
      case ParamType.bool:
        data = param ? 'true' : 'false';
      case ParamType.DateTime:
        data = (param as DateTime).millisecondsSinceEpoch.toString();
      case ParamType.DateTimeRange:
        data = dateTimeRangeToString(param as DateTimeRange);
      case ParamType.LatLng:
        data = (param as LatLng).serialize();
      case ParamType.Color:
        data = (param as Color).toCssString();
      case ParamType.FFPlace:
        data = placeToString(param as FFPlace);
      case ParamType.FFUploadedFile:
        data = uploadedFileToString(param as FFUploadedFile);
      case ParamType.JSON:
        data = json.encode(param);

      case ParamType.DataStruct:
        data = param is BaseStruct ? param.serialize() : null;

      case ParamType.Enum:
        data = (param is Enum) ? param.serialize() : null;

      case ParamType.SupabaseRow:
        return json.encode((param as SupabaseDataRow).data);

      default:
        data = null;
    }
    return data;
  } catch (e) {
    print('Error serializing parameter: $e');
    return null;
  }
}

/// END SERIALIZATION HELPERS

/// DESERIALIZATION HELPERS

DateTimeRange? dateTimeRangeFromString(String dateTimeRangeStr) {
  final pieces = dateTimeRangeStr.split('|');
  if (pieces.length != 2) {
    return null;
  }
  return DateTimeRange(
    start: DateTime.fromMillisecondsSinceEpoch(int.parse(pieces.first)),
    end: DateTime.fromMillisecondsSinceEpoch(int.parse(pieces.last)),
  );
}

LatLng? latLngFromString(String? latLngStr) {
  final pieces = latLngStr?.split(',');
  if (pieces == null || pieces.length != 2) {
    return null;
  }
  return LatLng(
    double.parse(pieces.first.trim()),
    double.parse(pieces.last.trim()),
  );
}

FFPlace placeFromString(String placeStr) {
  final serializedData = jsonDecode(placeStr) as Map<String, dynamic>;
  final data = {
    'latLng': serializedData.containsKey('latLng')
        ? latLngFromString(serializedData['latLng'] as String)
        : const LatLng(0.0, 0.0),
    'name': serializedData['name'] ?? '',
    'address': serializedData['address'] ?? '',
    'city': serializedData['city'] ?? '',
    'state': serializedData['state'] ?? '',
    'country': serializedData['country'] ?? '',
    'zipCode': serializedData['zipCode'] ?? '',
  };
  return FFPlace(
    latLng: data['latLng'] as LatLng,
    name: data['name'] as String,
    address: data['address'] as String,
    city: data['city'] as String,
    state: data['state'] as String,
    country: data['country'] as String,
    zipCode: data['zipCode'] as String,
  );
}

FFUploadedFile uploadedFileFromString(String uploadedFileStr) =>
    FFUploadedFile.deserialize(uploadedFileStr);

enum ParamType {
  int,
  double,
  String,
  bool,
  DateTime,
  DateTimeRange,
  LatLng,
  Color,
  FFPlace,
  FFUploadedFile,
  JSON,

  DataStruct,
  Enum,
  SupabaseRow,

  CustomClass,
  CustomEnum,
}

dynamic deserializeParam<T>(
  String? param,
  ParamType paramType,
  bool isList, {
  StructBuilder<T>? structBuilder,
}) {
  try {
    if (param == null) {
      return null;
    }
    if (isList) {
      final paramValues = json.decode(param);
      if (paramValues is! Iterable || paramValues.isEmpty) {
        return null;
      }
      return paramValues
          .where((p) => p is String)
          .map((p) => p as String)
          .map((p) => deserializeParam<T>(
                p,
                paramType,
                false,
                structBuilder: structBuilder,
              ))
          .where((p) => p != null)
          .map((p) => p! as T)
          .toList();
    }
    switch (paramType) {
      case ParamType.int:
        return int.tryParse(param);
      case ParamType.double:
        return double.tryParse(param);
      case ParamType.String:
        return param;
      case ParamType.bool:
        return param == 'true';
      case ParamType.DateTime:
        final milliseconds = int.tryParse(param);
        return milliseconds != null
            ? DateTime.fromMillisecondsSinceEpoch(milliseconds)
            : null;
      case ParamType.DateTimeRange:
        return dateTimeRangeFromString(param);
      case ParamType.LatLng:
        return latLngFromString(param);
      case ParamType.Color:
        return fromCssColor(param);
      case ParamType.FFPlace:
        return placeFromString(param);
      case ParamType.FFUploadedFile:
        return uploadedFileFromString(param);
      case ParamType.JSON:
        return json.decode(param);

      case ParamType.SupabaseRow:
        final data = json.decode(param) as Map<String, dynamic>;
        switch (T) {
          case UserSettingsRow:
            return UserSettingsRow(data);
          case PromotionsRow:
            return PromotionsRow(data);
          case ReferralsRow:
            return ReferralsRow(data);
          case TaxDocumentDownloadsRow:
            return TaxDocumentDownloadsRow(data);
          case SyncLogsRow:
            return SyncLogsRow(data);
          case ProductTagsRow:
            return ProductTagsRow(data);
          case WishlistsRow:
            return WishlistsRow(data);
          case ConditionsRow:
            return ConditionsRow(data);
          case OrdersRow:
            return OrdersRow(data);
          case VideoProductsRow:
            return VideoProductsRow(data);
          case StripeAccountsRow:
            return StripeAccountsRow(data);
          case PasswordResetCodesRow:
            return PasswordResetCodesRow(data);
          case PaymentMethodsRow:
            return PaymentMethodsRow(data);
          case SubcategoriesRow:
            return SubcategoriesRow(data);
          case ProductViewsRow:
            return ProductViewsRow(data);
          case BlockedUsersRow:
            return BlockedUsersRow(data);
          case ReviewImagesRow:
            return ReviewImagesRow(data);
          case VProductSyncStatusRow:
            return VProductSyncStatusRow(data);
          case TransactionsRow:
            return TransactionsRow(data);
          case VideosRow:
            return VideosRow(data);
          case ShopifyWebhookEventsRow:
            return ShopifyWebhookEventsRow(data);
          case ShortlistsRow:
            return ShortlistsRow(data);
          case SyncJobsRow:
            return SyncJobsRow(data);
          case FollowsRow:
            return FollowsRow(data);
          case MessageImagesRow:
            return MessageImagesRow(data);
          case ProductsRow:
            return ProductsRow(data);
          case ShopifyIntegrationsRow:
            return ShopifyIntegrationsRow(data);
          case ShippingAddressesRow:
            return ShippingAddressesRow(data);
          case StripeRefundsRow:
            return StripeRefundsRow(data);
          case StripePayoutsRow:
            return StripePayoutsRow(data);
          case VSyncHistoryRow:
            return VSyncHistoryRow(data);
          case ShopifyWebhooksRow:
            return ShopifyWebhooksRow(data);
          case TaxDocumentsRow:
            return TaxDocumentsRow(data);
          case OrderItemsRow:
            return OrderItemsRow(data);
          case ProductHistoryRow:
            return ProductHistoryRow(data);
          case UserProfilesRow:
            return UserProfilesRow(data);
          case ShopifyCategoryMappingRow:
            return ShopifyCategoryMappingRow(data);
          case ShortlistItemsRow:
            return ShortlistItemsRow(data);
          case MessagesRow:
            return MessagesRow(data);
          case ProductImagesRow:
            return ProductImagesRow(data);
          case VideoLikesRow:
            return VideoLikesRow(data);
          case StripePaymentIntentsRow:
            return StripePaymentIntentsRow(data);
          case TagsRow:
            return TagsRow(data);
          case VProductFeedRow:
            return VProductFeedRow(data);
          case ProductShopifyMappingRow:
            return ProductShopifyMappingRow(data);
          case CounterOffersRow:
            return CounterOffersRow(data);
          case StripeCustomersRow:
            return StripeCustomersRow(data);
          case CategoriesRow:
            return CategoriesRow(data);
          case ReviewsRow:
            return ReviewsRow(data);
          case NotificationsRow:
            return NotificationsRow(data);
          case ConversationsRow:
            return ConversationsRow(data);
          case AuditLogsRow:
            return AuditLogsRow(data);
          default:
            return null;
        }

      case ParamType.DataStruct:
        final data = json.decode(param) as Map<String, dynamic>? ?? {};
        return structBuilder != null ? structBuilder(data) : null;

      case ParamType.Enum:
        return deserializeEnum<T>(param);

      default:
        return null;
    }
  } catch (e) {
    print('Error deserializing parameter: $e');
    return null;
  }
}

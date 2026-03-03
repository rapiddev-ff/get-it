// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stripe_account_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StripeAccountStatusImpl _$$StripeAccountStatusImplFromJson(
        Map<String, dynamic> json) =>
    _$StripeAccountStatusImpl(
      hasAccount: json['hasAccount'] as bool? ?? false,
      stripeAccountId: json['stripeAccountId'] as String?,
      chargesEnabled: json['chargesEnabled'] as bool? ?? false,
      payoutsEnabled: json['payoutsEnabled'] as bool? ?? false,
      detailsSubmitted: json['detailsSubmitted'] as bool? ?? false,
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
      needsOnboarding: json['needsOnboarding'] as bool? ?? true,
      disabledReason: json['disabledReason'] as String?,
      currentlyDue: (json['currentlyDue'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pastDue: (json['pastDue'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      hasPastDue: json['hasPastDue'] as bool? ?? false,
      accountStatus: json['accountStatus'] as String? ?? '',
      statusLabel: json['statusLabel'] as String? ?? '',
      statusColor: json['statusColor'] as String? ?? '',
      canSell: json['canSell'] as bool? ?? false,
      needsAttention: json['needsAttention'] as bool? ?? false,
    );

Map<String, dynamic> _$$StripeAccountStatusImplToJson(
        _$StripeAccountStatusImpl instance) =>
    <String, dynamic>{
      'hasAccount': instance.hasAccount,
      'stripeAccountId': instance.stripeAccountId,
      'chargesEnabled': instance.chargesEnabled,
      'payoutsEnabled': instance.payoutsEnabled,
      'detailsSubmitted': instance.detailsSubmitted,
      'onboardingCompleted': instance.onboardingCompleted,
      'needsOnboarding': instance.needsOnboarding,
      'disabledReason': instance.disabledReason,
      'currentlyDue': instance.currentlyDue,
      'pastDue': instance.pastDue,
      'hasPastDue': instance.hasPastDue,
      'accountStatus': instance.accountStatus,
      'statusLabel': instance.statusLabel,
      'statusColor': instance.statusColor,
      'canSell': instance.canSell,
      'needsAttention': instance.needsAttention,
    };

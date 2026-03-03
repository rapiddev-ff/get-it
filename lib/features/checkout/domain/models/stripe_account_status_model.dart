import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stripe_account_status_model.freezed.dart';
part 'stripe_account_status_model.g.dart';

@freezed
class StripeAccountStatus with _$StripeAccountStatus {
  const StripeAccountStatus._();
  const factory StripeAccountStatus({
    @Default(false) bool hasAccount,
    String? stripeAccountId,
    @Default(false) bool chargesEnabled,
    @Default(false) bool payoutsEnabled,
    @Default(false) bool detailsSubmitted,
    @Default(false) bool onboardingCompleted,
    @Default(true) bool needsOnboarding,
    String? disabledReason,
    @Default([]) List<String> currentlyDue,
    @Default([]) List<String> pastDue,
    @Default(false) bool hasPastDue,
    @Default('') String accountStatus,
    @Default('') String statusLabel,
    @Default('') String statusColor,
    @Default(false) bool canSell,
    @Default(false) bool needsAttention,
  }) = _StripeAccountStatus;

  factory StripeAccountStatus.fromJson(Map<String, dynamic> json) =>
      _$StripeAccountStatusFromJson(json);

  String serialize() => jsonEncode(toJson());
  static StripeAccountStatus fromSerializableMap(Map<String, dynamic> data) =>
      StripeAccountStatus.fromJson(data);
}

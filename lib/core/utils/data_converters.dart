import 'dart:convert';

import 'package:flutter/material.dart';

import '/features/auth/domain/models/user_model.dart';
import '/features/auth/domain/models/user_settings_model.dart';
import '/features/auth/domain/models/business_address_model.dart';
import '/features/browse/domain/models/category_model.dart';
import '/features/browse/domain/models/subcategory_model.dart';
import '/features/browse/domain/models/condition_model.dart';
import '/features/checkout/domain/models/stripe_account_status_model.dart';
import '/features/checkout/domain/models/payment_method_model.dart';
import '/features/checkout/domain/models/payment_card_model.dart';
import '/features/checkout/domain/models/billing_details_model.dart';
import '/features/checkout/domain/models/shipping_address_model.dart';
import '/backend/supabase/supabase.dart';

UserData convertUserToDataType(
  dynamic initialData,
  dynamic paymentMethods,
) {
  final userRow = initialData['user_profile'] as Map<String, dynamic>? ?? {};
  final stripeRow = initialData['stripe'] as Map<String, dynamic>?;
  final userSettingsRow = initialData['user_settings'] as Map<String, dynamic>?;
  final shippingAddresses =
      initialData['shipping_addresses'] as List<dynamic>? ?? [];

  // ── Parse requirements from stripeRow ──────────────────────────────────
  List<String> currentlyDue = [];
  List<String> pastDue = [];
  String? disabledReason;

  if (stripeRow?['requirements'] != null) {
    try {
      Map<String, dynamic> requirements;
      if (stripeRow!['requirements'] is String) {
        requirements = jsonDecode(stripeRow['requirements']);
      } else if (stripeRow['requirements'] is Map) {
        requirements = Map<String, dynamic>.from(stripeRow['requirements']);
      } else {
        requirements = {};
      }
      currentlyDue = List<String>.from(requirements['currently_due'] ?? []);
      pastDue = List<String>.from(requirements['past_due'] ?? []);
      disabledReason = requirements['disabled_reason'];
    } catch (e) {
      debugPrint('Error parsing requirements: $e');
    }
  }

  // ── Derive account status ──────────────────────────────────────────────
  String accountStatus = 'not_connected';
  String statusLabel = 'Not Connected';
  String statusColor = '#9E9E9E';
  bool canSell = false;
  bool needsAttention = false;

  if (stripeRow != null) {
    accountStatus = stripeRow['account_status'] ?? 'onboarding';

    if (stripeRow['account_status'] == null) {
      if (disabledReason != null && disabledReason.startsWith('rejected')) {
        accountStatus = 'rejected';
      } else if ((stripeRow['charges_enabled'] ?? false) &&
          (stripeRow['payouts_enabled'] ?? false) &&
          (stripeRow['details_submitted'] ?? false)) {
        accountStatus = 'enabled';
      } else if (stripeRow['details_submitted'] ?? false) {
        accountStatus = pastDue.isNotEmpty ? 'restricted' : 'in_review';
      } else {
        accountStatus = 'onboarding';
      }
    }

    switch (accountStatus) {
      case 'enabled':
        statusLabel = 'Active';
        statusColor = '#4CAF50';
        canSell = true;
        needsAttention = currentlyDue.isNotEmpty;
        break;
      case 'restricted':
        statusLabel = 'Restricted';
        statusColor = '#FF9800';
        canSell = false;
        needsAttention = true;
        break;
      case 'in_review':
        statusLabel = 'In Review';
        statusColor = '#2196F3';
        canSell = false;
        needsAttention = false;
        break;
      case 'rejected':
        statusLabel = 'Rejected';
        statusColor = '#F44336';
        canSell = false;
        needsAttention = true;
        break;
      case 'disabled':
        statusLabel = 'Disabled';
        statusColor = '#F44336';
        canSell = false;
        needsAttention = true;
        break;
      case 'onboarding':
        statusLabel = 'Pending Setup';
        statusColor = '#FF9800';
        canSell = false;
        needsAttention = true;
        break;
      default:
        statusLabel = 'Not Connected';
        statusColor = '#9E9E9E';
        canSell = false;
        needsAttention = false;
    }
  }

  // ── Build Stripe status struct ─────────────────────────────────────────
  StripeAccountStatus stripeStatus = StripeAccountStatus(
    hasAccount: stripeRow != null,
    stripeAccountId: stripeRow?['stripe_account_id'],
    chargesEnabled: stripeRow?['charges_enabled'] ?? false,
    payoutsEnabled: stripeRow?['payouts_enabled'] ?? false,
    detailsSubmitted: stripeRow?['details_submitted'] ?? false,
    onboardingCompleted: stripeRow?['onboarding_completed'] ?? false,
    needsOnboarding:
        stripeRow == null || !(stripeRow['onboarding_completed'] ?? false),
    disabledReason: disabledReason,
    currentlyDue: currentlyDue,
    pastDue: pastDue,
    hasPastDue: pastDue.isNotEmpty,
    accountStatus: accountStatus,
    statusLabel: statusLabel,
    statusColor: statusColor,
    canSell: canSell,
    needsAttention: needsAttention,
  );

  // ── Parse payment methods ──────────────────────────────────────────────
  List<PaymentMethod> paymentMethodsList = [];
  String? defaultPaymentMethodId;
  bool hasStripeCustomer = false;

  if (paymentMethods != null) {
    try {
      Map<String, dynamic> responseMap;
      if (paymentMethods is String) {
        responseMap = jsonDecode(paymentMethods);
      } else if (paymentMethods is Map) {
        responseMap = Map<String, dynamic>.from(paymentMethods);
      } else {
        responseMap = {};
      }

      hasStripeCustomer = responseMap['has_customer'] ?? false;
      defaultPaymentMethodId = responseMap['default_payment_method_id'];

      final List<dynamic> methods = responseMap['payment_methods'] ?? [];
      paymentMethodsList = methods.map((pm) {
        PaymentCard? cardStruct;
        if (pm['card'] != null) {
          final card = pm['card'];
          cardStruct = PaymentCard(
            brand: card['brand'] ?? '',
            last4: card['last4'] ?? '',
            expMonth: card['exp_month'] ?? 0,
            expYear: card['exp_year'] ?? 0,
            funding: card['funding'] ?? '',
          );
        }

        BillingDetails? billingStruct;
        if (pm['billing_details'] != null) {
          final billing = pm['billing_details'];
          final address = billing['address'] ?? {};
          billingStruct = BillingDetails(
            name: billing['name'] ?? '',
            email: billing['email'] ?? '',
            phone: billing['phone'] ?? '',
            addressLine1: address['line1'] ?? '',
            addressLine2: address['line2'] ?? '',
            city: address['city'] ?? '',
            state: address['state'] ?? '',
            postalCode: address['postal_code'] ?? '',
            country: address['country'] ?? '',
          );
        }

        return PaymentMethod(
          id: pm['id'] ?? '',
          type: pm['type'] ?? 'card',
          card: cardStruct,
          billingDetails: billingStruct,
          isDefault: pm['is_default'] ?? false,
          created: pm['created'] ?? 0,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error parsing payment methods: $e');
    }
  }

  // ── Parse business address ─────────────────────────────────────────────
  BusinessAddress businessAddressStruct = BusinessAddress(
    addressLine1: userRow['business_address_line1'] ?? '',
    addressLine2: userRow['business_address_line2'] ?? '',
    country: userRow['business_country'] ?? '',
    state: userRow['business_state'] ?? '',
    city: userRow['business_city'] ?? '',
    zipCode: userRow['business_zip'] ?? '',
  );

  // ── Parse user settings ────────────────────────────────────────────────
  UserSettings userSettingsStruct = UserSettings(
    swipePaymentEnabled: userSettingsRow?['swipe_payment_enabled'] ?? false,
    dailyBudget: userSettingsRow?['daily_budget'] ?? 0,
    dailyBudgetUsed: userSettingsRow?['daily_budget_used'] ?? 0,
    budgetResetAt: userSettingsRow?['budget_reset_at'] != null
        ? DateTime.tryParse(userSettingsRow!['budget_reset_at'])
        : null,
    defaultPaymentMethodId: userSettingsRow?['default_payment_method_id'],
    defaultShippingAddressId: userSettingsRow?['default_shipping_address_id'],
    fcmToken: userSettingsRow?['fcm_token'],
    defaultFlatShippingRate: userSettingsRow?['default_flat_shipping_rate'],
    defaultAdditionalItemFee: userSettingsRow?['default_additional_item_fee'],
  );

  // ── Parse shipping addresses ───────────────────────────────────────────
  final defaultAddress = shippingAddresses.isNotEmpty
      ? shippingAddresses.first as Map<String, dynamic>
      : null;

  ShippingAddress shippingAddressStruct = ShippingAddress(
    fullName: defaultAddress?['full_name'] ?? '',
    addressLine1: defaultAddress?['address_line1'] ?? '',
    addressLine2: defaultAddress?['address_line2'] ?? '',
    city: defaultAddress?['city'] ?? '',
    state: defaultAddress?['state'] ?? '',
    zipCode: defaultAddress?['zip_code'] ?? '',
    country: defaultAddress?['country'] ?? '',
  );

  // ── Build and return UserData ────────────────────────────────────
  return UserData(
    id: userRow['id'],
    userId: userRow['user_id'],
    username: userRow['username'],
    firstName: userRow['first_name'],
    lastName: userRow['last_name'],
    avatarUrl: userRow['avatar_url'],
    bio: userRow['bio'],
    phone: userRow['phone'],
    phoneVerified: userRow['phone_verified'] ?? false,
    isSeller: userRow['is_seller'] ?? false,
    sellerSince: userRow['seller_since'] != null
        ? DateTime.tryParse(userRow['seller_since'])
        : null,
    businessName: userRow['business_name'],
    businessAddress: businessAddressStruct,
    businessEmail: userRow['business_email'],
    ratingAsSeller: userRow['rating_as_seller']?.toDouble(),
    ratingAsBuyer: userRow['rating_as_buyer']?.toDouble(),
    totalReviewsAsSeller: userRow['total_reviews_as_seller'] ?? 0,
    totalReviewsAsBuyer: userRow['total_reviews_as_buyer'] ?? 0,
    totalSales: userRow['total_sales'] ?? 0,
    totalPurchases: userRow['total_purchases'] ?? 0,
    totalRefunds: userRow['total_refunds'] ?? 0,
    totalCancelled: userRow['total_cancelled'] ?? 0,
    followersCount: userRow['followers_count'] ?? 0,
    followingCount: userRow['following_count'] ?? 0,
    isPrivate: userRow['is_private'] ?? false,
    referralCode: userRow['referral_code'],
    referredBy: userRow['referred_by'],
    createdAt: userRow['created_at'] != null
        ? DateTime.tryParse(userRow['created_at'])
        : null,
    updatedAt: userRow['updated_at'] != null
        ? DateTime.tryParse(userRow['updated_at'])
        : null,
    deletedAt: userRow['deleted_at'] != null
        ? DateTime.tryParse(userRow['deleted_at'])
        : null,
    totalReferrals: userRow['total_referrals'] ?? 0,
    email: userRow['email'] ?? '',
    stripe: stripeStatus,
    paymentMethod: paymentMethodsList,
    defaultPaymentMethodId: defaultPaymentMethodId ?? '',
    hasStripeCustomer: hasStripeCustomer,
    userSettings: userSettingsStruct,
    shippingAddress: shippingAddressStruct,
  );
}

List<Category>? convertCategoriesToDataType(
  List<dynamic> categoriesRows,
  List<dynamic> subcategories,
) {
  if (categoriesRows.isEmpty) return null;

  return categoriesRows.map((cat) {
    final categoryRow = cat as Map<String, dynamic>;

    final categorySubcategories = subcategories
        .map((s) => s as Map<String, dynamic>)
        .where((sub) => sub['category_id'] == categoryRow['id'])
        .map((sub) => Subcategory(
              id: sub['id'] ?? '',
              name: sub['name'] ?? '',
              categoryId: sub['category_id'] ?? '',
            ))
        .toList();

    return Category(
      id: categoryRow['id'] ?? '',
      name: categoryRow['name'] ?? '',
      slug: categoryRow['slug'] ?? '',
      subcategories: categorySubcategories,
    );
  }).toList();
}

List<Condition>? convertConditionsToDataType(List<dynamic> conditionsRows) {
  if (conditionsRows.isEmpty) return null;

  return conditionsRows.map((c) {
    final row = c as Map<String, dynamic>;
    return Condition(
      id: row['id'] ?? '',
      name: row['name'] ?? '',
      code: row['code'] ?? '',
      description: row['description'] ?? '',
    );
  }).toList();
}

String getRequirementMessages(List<String> requirements) {
  const Map<String, String> messages = {
    'individual.first_name': 'Enter your first name',
    'individual.last_name': 'Enter your last name',
    'individual.dob.day': 'Enter your date of birth',
    'individual.dob.month': 'Enter your date of birth',
    'individual.dob.year': 'Enter your date of birth',
    'individual.email': 'Enter your email address',
    'individual.phone': 'Enter your phone number',
    'individual.ssn_last_4': 'Enter the last 4 digits of your SSN',
    'individual.ssn_full': 'Enter your full SSN',
    'individual.id_number': 'Enter your ID number',
    'individual.address.line1': 'Enter your street address',
    'individual.address.city': 'Enter your city',
    'individual.address.state': 'Enter your state',
    'individual.address.postal_code': 'Enter your postal code',
    'individual.address.country': 'Enter your country',
    'individual.verification.document': 'Upload an identity document',
    'individual.verification.additional_document':
        'Upload an additional document',
    'company.name': 'Enter your company name',
    'company.tax_id': 'Enter your tax ID',
    'company.address.line1': 'Enter your company address',
    'company.address.city': 'Enter your company city',
    'company.address.state': 'Enter your company state',
    'company.address.postal_code': 'Enter your company postal code',
    'company.address.country': 'Enter your company country',
    'company.phone': 'Enter your company phone number',
    'company.verification.document': 'Upload a company document',
    'business_profile.url': 'Enter your business website',
    'business_profile.mcc': 'Select your business category',
    'business_profile.product_description': 'Describe your product or service',
    'external_account': 'Add a bank account for payouts',
    'bank_account.account_number': 'Enter your bank account number',
    'bank_account.routing_number': 'Enter your bank routing number',
    'tos_acceptance.date': 'Accept the terms of service',
    'tos_acceptance.ip': 'Accept the terms of service',
  };

  if (requirements.isEmpty) return '';

  return requirements
      .map((req) => messages[req] ?? 'Additional information required')
      .toSet()
      .join('\n');
}

StripeAccountStatus convertStripeStatus(StripeAccountsRow? stripeData) {
  if (stripeData == null) {
    return StripeAccountStatus(
      hasAccount: false,
      chargesEnabled: false,
      payoutsEnabled: false,
      detailsSubmitted: false,
      onboardingCompleted: false,
      needsOnboarding: true,
      hasPastDue: false,
      currentlyDue: [],
      pastDue: [],
    );
  }

  // Parse requirements
  List<String> currentlyDue = [];
  List<String> pastDue = [];
  String? disabledReason;

  if (stripeData.requirements != null) {
    try {
      Map<String, dynamic> requirements;
      if (stripeData.requirements is String) {
        requirements = jsonDecode(stripeData.requirements as String);
      } else if (stripeData.requirements is Map) {
        requirements =
            Map<String, dynamic>.from(stripeData.requirements as Map);
      } else {
        requirements = {};
      }

      currentlyDue = List<String>.from(requirements['currently_due'] ?? []);
      pastDue = List<String>.from(requirements['past_due'] ?? []);
      disabledReason = requirements['disabled_reason'];
    } catch (e) {
      debugPrint('Error parsing requirements: $e');
    }
  }

  return StripeAccountStatus(
    hasAccount: true,
    stripeAccountId: stripeData.stripeAccountId,
    chargesEnabled: stripeData.chargesEnabled ?? false,
    payoutsEnabled: stripeData.payoutsEnabled ?? false,
    detailsSubmitted: stripeData.detailsSubmitted ?? false,
    onboardingCompleted: stripeData.onboardingCompleted ?? false,
    needsOnboarding: !(stripeData.onboardingCompleted ?? false),
    disabledReason: disabledReason,
    currentlyDue: currentlyDue,
    pastDue: pastDue,
    hasPastDue: pastDue.isNotEmpty,
  );
}

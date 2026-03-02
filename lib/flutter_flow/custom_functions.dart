import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';

bool checkEmailFormat(String email) {
  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+$");
  return emailRegex.hasMatch(email);
}

bool containsProfanity(String text) {
  final normalized = text
      .toLowerCase()
      .replaceAll('0', 'o')
      .replaceAll('1', 'i')
      .replaceAll('3', 'e')
      .replaceAll('4', 'a')
      .replaceAll('5', 's')
      .replaceAll('7', 't')
      .replaceAll('8', 'b')
      .replaceAll('\$', 's')
      .replaceAll('_', '')
      .replaceAll('-', '')
      .replaceAll('.', '');

  const blockedWords = [
    'fuck',
    'shit',
    'ass',
    'bitch',
    'cunt',
    'dick',
    'porn',
    'xxx',
    'asshole',
    'bastard',
    'slut',
    'whore',
    'faggot',
    'nigger',
    'nigga',
    'cock',
    'pussy',
    'penis',
    'vagina',
    'boob',
    'tits',
    'anal',
    'sex',
    'rape',
    'molest',
    'pedo',
    'nazi',
    'hitler',
    'retard',
    'fag',
  ];

  for (final word in blockedWords) {
    if (normalized.contains(word)) {
      return true;
    }
  }

  return false;
}

UserDataStruct convertUserToDataType(
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
  StripeAccountStatusStruct stripeStatus = StripeAccountStatusStruct(
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
  List<PaymentMethodStruct> paymentMethodsList = [];
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
        PaymentCardStruct? cardStruct;
        if (pm['card'] != null) {
          final card = pm['card'];
          cardStruct = PaymentCardStruct(
            brand: card['brand'] ?? '',
            last4: card['last4'] ?? '',
            expMonth: card['exp_month'] ?? 0,
            expYear: card['exp_year'] ?? 0,
            funding: card['funding'] ?? '',
          );
        }

        BillingDetailsStruct? billingStruct;
        if (pm['billing_details'] != null) {
          final billing = pm['billing_details'];
          final address = billing['address'] ?? {};
          billingStruct = BillingDetailsStruct(
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

        return PaymentMethodStruct(
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
  BusinessAddressStruct businessAddressStruct = BusinessAddressStruct(
    addressLine1: userRow['business_address_line1'] ?? '',
    addressLine2: userRow['business_address_line2'] ?? '',
    country: userRow['business_country'] ?? '',
    state: userRow['business_state'] ?? '',
    city: userRow['business_city'] ?? '',
    zipCode: userRow['business_zip'] ?? '',
  );

  // ── Parse user settings ────────────────────────────────────────────────
  UserSettingsStruct userSettingsStruct = UserSettingsStruct(
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
  // Берём первый (дефолтный) адрес
  final defaultAddress = shippingAddresses.isNotEmpty
      ? shippingAddresses.first as Map<String, dynamic>
      : null;

  ShippingAddressStruct shippingAddressStruct = ShippingAddressStruct(
    fullName: defaultAddress?['full_name'] ?? '',
    addressLine1: defaultAddress?['address_line1'] ?? '',
    addressLine2: defaultAddress?['address_line2'] ?? '',
    city: defaultAddress?['city'] ?? '',
    state: defaultAddress?['state'] ?? '',
    zipCode: defaultAddress?['zip_code'] ?? '',
    country: defaultAddress?['country'] ?? '',
  );

  // ── Build and return UserDataStruct ────────────────────────────────────
  return UserDataStruct(
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
    email: userRow['email'],
    stripe: stripeStatus,
    paymentMethod: paymentMethodsList,
    defaultPaymentMethodId: defaultPaymentMethodId,
    hasStripeCustomer: hasStripeCustomer,
    userSettings: userSettingsStruct,
    shippingAddress: shippingAddressStruct,
  );
}

String stringToImage(String value) {
  return value;
}

String? phoneValidationResult(String? phoneNumber) {
  // Check for null or empty
  if (phoneNumber == null || phoneNumber.trim().isEmpty) {
    return 'Phone number is required';
  }

  // Remove all non-digit characters except leading +
  String cleaned = phoneNumber.trim();
  bool hasPlus = cleaned.startsWith('+');
  String digitsOnly = cleaned.replaceAll(RegExp(r'[^\d]'), '');

  // Check minimum length (at least 10 digits for most countries)
  if (digitsOnly.length < 10) {
    return 'Phone number is too short';
  }

  // Check maximum length (max 15 digits per E.164 standard)
  if (digitsOnly.length > 15) {
    return 'Phone number is too long';
  }

  // Validate format based on length
  if (digitsOnly.length == 10) {
    // US/Canada format without country code - valid
    return null;
  }

  if (digitsOnly.length == 11) {
    // Should start with country code 1 (US/Canada) or 7 (Russia/KZ)
    if (!digitsOnly.startsWith('1') && !digitsOnly.startsWith('7')) {
      return 'Invalid country code';
    }
    return null;
  }

  // For other international numbers (12-15 digits)
  if (digitsOnly.length >= 12 && digitsOnly.length <= 15) {
    return null;
  }

  return 'Invalid phone number format';
}

String normalizeUsername(String? username) {
  if (username == null || username.trim().isEmpty) {
    return '';
  }

  String cleaned = username.trim();

  // Remove @ from the beginning if present
  if (cleaned.startsWith('@')) {
    cleaned = cleaned.substring(1);
  }

  return cleaned;
}

String usernameValidationResult(String? username) {
  if (username == null || username.trim().isEmpty) {
    return 'Username is required';
  }

  String cleaned = username.trim();

  // Check if @ appears not at the beginning or more than once
  int atCount = '@'.allMatches(cleaned).length;
  bool startsWithAt = cleaned.startsWith('@');

  if (atCount > 1 || (atCount == 1 && !startsWithAt)) {
    return '"@" can only be used at the beginning of the username.';
  }

  // Remove @ from the beginning for further validation
  String normalized = startsWithAt ? cleaned.substring(1) : cleaned;

  // Check if empty after removing @
  if (normalized.isEmpty) {
    return 'Username is required';
  }

  // Check minimum length (3 characters without @)
  if (normalized.length < 3) {
    return 'Username must be at least 3 characters long.';
  }

  // Check maximum length (20 characters without @)
  if (normalized.length > 20) {
    return 'Username must be no longer than 20 characters.';
  }

  // Check for valid characters: only letters, numbers, _ and .
  RegExp validChars = RegExp(r'^[a-zA-Z0-9_\.]+$');
  if (!validChars.hasMatch(normalized)) {
    return 'Username can contain only letters, numbers, "_" and "."';
  }

  // Valid username
  return 'valid';
}

List<ProductDetailsStruct>? filterProductsWishlist(
  List<ProductDetailsStruct> products,
  String? searchQuery,
  String? categoryId,
) {
  if (products.isEmpty) return [];

  return products.where((product) {
    // 1. Фильтр по категории
    if (categoryId != null && categoryId.isNotEmpty) {
      if (product.category?.id != categoryId) {
        return false;
      }
    }

    // 2. Поиск по title и description
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final query = searchQuery.toLowerCase().trim();
      final title = (product.title ?? '').toLowerCase();
      final description = (product.description ?? '').toLowerCase();

      if (!title.contains(query) && !description.contains(query)) {
        return false;
      }
    }

    return true;
  }).toList();
}

List<CategoryStruct>? convertCategoriesToDataType(
  List<dynamic> categoriesRows,
  List<dynamic> subcategories,
) {
  if (categoriesRows.isEmpty) return null;

  return categoriesRows.map((cat) {
    final categoryRow = cat as Map<String, dynamic>;

    final categorySubcategories = subcategories
        .map((s) => s as Map<String, dynamic>)
        .where((sub) => sub['category_id'] == categoryRow['id'])
        .map((sub) => SubcategoryStruct(
              id: sub['id'],
              name: sub['name'],
              slug: sub['slug'],
            ))
        .toList();

    return CategoryStruct(
      id: categoryRow['id'],
      name: categoryRow['name'],
      slug: categoryRow['slug'],
      subcategories: categorySubcategories,
    );
  }).toList();
}

List<ConditionStruct>? convertConditionsToDataType(
    List<dynamic> conditionsRows) {
  if (conditionsRows.isEmpty) return null;

  return conditionsRows.map((c) {
    final row = c as Map<String, dynamic>;
    return ConditionStruct(
      id: row['id'],
      name: row['name'],
      code: row['code'],
      description: row['description'],
    );
  }).toList();
}

String formatPhoneNumber(String phone) {
  String cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');

  // Ensure it starts with + if original had it
  if (phone.startsWith('+') && !cleaned.startsWith('+')) {
    cleaned = '+$cleaned';
  }

  return cleaned;
}

dynamic parseMonthYear(String value) {
  final parts = value.split('/');

  return {
    'month': parts[0],
    'year': parts[1],
  };
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

StripeAccountStatusStruct convertStripeStatus(StripeAccountsRow? stripeData) {
  if (stripeData == null) {
    return StripeAccountStatusStruct(
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

  return StripeAccountStatusStruct(
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

dynamic paymentValidator(
  String cardNumber,
  String expiryDate,
  String cvc,
  String cardholderName,
  String email,
  String fullName,
  String address,
  String? apartment,
  String country,
  String state,
  String city,
  String? zipCode,
) {
  bool isValidCardNumber(String cardNumber) {
    String cleaned = cardNumber.replaceAll(RegExp(r'[\s\.\•]'), '');

    if (cleaned.length < 13 || cleaned.length > 19) {
      return false;
    }

    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
      return false;
    }

    int sum = 0;
    bool alternate = false;

    for (int i = cleaned.length - 1; i >= 0; i--) {
      int digit = int.parse(cleaned[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  bool isValidExpiryDate(String expiryDate) {
    if (expiryDate.isEmpty) return false;

    final parts = expiryDate.split('/');
    if (parts.length != 2) return false;

    final month = int.tryParse(parts[0].trim());
    final yearStr = parts[1].trim();

    if (month == null) return false;
    if (month < 1 || month > 12) return false;

    // Поддержка формата MM/YY или MM/YYYY
    int? year;
    if (yearStr.length == 2) {
      // Формат YY - добавляем 2000
      final twoDigitYear = int.tryParse(yearStr);
      if (twoDigitYear == null) return false;
      year = 2000 + twoDigitYear;
    } else if (yearStr.length == 4) {
      // Формат YYYY
      year = int.tryParse(yearStr);
      if (year == null) return false;
    } else {
      return false;
    }

    // Проверка что карта не истекла
    final now = DateTime.now();
    final expiryDateTime =
        DateTime(year, month + 1, 0); // Последний день месяца

    return expiryDateTime.isAfter(now);
  }

  bool isValidCVC(String cvc) {
    if (cvc.isEmpty) return false;
    return RegExp(r'^\d{3,4}$').hasMatch(cvc);
  }

  bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  bool isValidZipCode(String zipCode, String countryCode) {
    if (zipCode.isEmpty) return false;

    switch (countryCode.toUpperCase()) {
      case 'US':
      case 'USA':
        return RegExp(r'^\d{5}(-\d{4})?$').hasMatch(zipCode);
      case 'CA':
      case 'CANADA':
        return RegExp(r'^[A-Za-z]\d[A-Za-z] ?\d[A-Za-z]\d$').hasMatch(zipCode);
      case 'GB':
      case 'UK':
      case 'UNITED KINGDOM':
        return RegExp(r'^[A-Z]{1,2}\d{1,2}[A-Z]?\s?\d[A-Z]{2}$',
                caseSensitive: false)
            .hasMatch(zipCode);
      case 'AU':
      case 'AUSTRALIA':
        return RegExp(r'^\d{4}$').hasMatch(zipCode);
      default:
        return zipCode.trim().isNotEmpty;
    }
  }

  // Validate fields in order and return first error found

  // Card number
  if (cardNumber.isEmpty) {
    return {
      'success': false,
      'message': 'Card number is required',
      'field': 'cardNumber',
    };
  }
  if (!isValidCardNumber(cardNumber)) {
    return {
      'success': false,
      'message': 'Invalid card number',
      'field': 'cardNumber',
    };
  }

  // Expiry date
  if (expiryDate.isEmpty) {
    return {
      'success': false,
      'message': 'Expiry date is required',
      'field': 'expiryDate',
    };
  }
  if (!isValidExpiryDate(expiryDate)) {
    return {
      'success': false,
      'message': 'Invalid or expired date',
      'field': 'expiryDate',
    };
  }

  // CVC
  if (cvc.isEmpty) {
    return {
      'success': false,
      'message': 'CVC is required',
      'field': 'cvc',
    };
  }
  if (!isValidCVC(cvc)) {
    return {
      'success': false,
      'message': 'Invalid CVC code',
      'field': 'cvc',
    };
  }

  // Cardholder name
  if (cardholderName.trim().isEmpty) {
    return {
      'success': false,
      'message': 'Cardholder name is required',
      'field': 'cardholderName',
    };
  }
  if (cardholderName.trim().length < 2) {
    return {
      'success': false,
      'message': 'Cardholder name is too short',
      'field': 'cardholderName',
    };
  }

  // Email
  if (email.isEmpty) {
    return {
      'success': false,
      'message': 'Email is required',
      'field': 'email',
    };
  }
  if (!isValidEmail(email)) {
    return {
      'success': false,
      'message': 'Invalid email address',
      'field': 'email',
    };
  }

  // Full name
  if (fullName.trim().isEmpty) {
    return {
      'success': false,
      'message': 'Full name is required',
      'field': 'fullName',
    };
  }
  if (fullName.trim().length < 2) {
    return {
      'success': false,
      'message': 'Full name is too short',
      'field': 'fullName',
    };
  }

  // Address
  if (address.trim().isEmpty) {
    return {
      'success': false,
      'message': 'Address is required',
      'field': 'address',
    };
  }
  if (address.trim().length < 5) {
    return {
      'success': false,
      'message': 'Address is too short',
      'field': 'address',
    };
  }

  // Country
  if (country.trim().isEmpty) {
    return {
      'success': false,
      'message': 'Country is required',
      'field': 'country',
    };
  }

  // State
  if (state.trim().isEmpty) {
    return {
      'success': false,
      'message': 'State is required',
      'field': 'state',
    };
  }

  // City
  if (city.trim().isEmpty) {
    return {
      'success': false,
      'message': 'City is required',
      'field': 'city',
    };
  }

  // Zip code
  if (zipCode == null || zipCode.trim().isEmpty) {
    return {
      'success': false,
      'message': 'Zip code is required',
      'field': 'zipCode',
    };
  }
  if (!isValidZipCode(zipCode, country)) {
    return {
      'success': false,
      'message': 'Invalid zip code format',
      'field': 'zipCode',
    };
  }

  // All validations passed
  return {
    'success': true,
    'message': 'Validation successful',
  };
}

List<dynamic> getStatesAndProvinces() {
  return [
    // США - 50 штатов
    {"name": "Alabama", "code": "AL", "country": "US"},
    {"name": "Alaska", "code": "AK", "country": "US"},
    {"name": "Arizona", "code": "AZ", "country": "US"},
    {"name": "Arkansas", "code": "AR", "country": "US"},
    {"name": "California", "code": "CA", "country": "US"},
    {"name": "Colorado", "code": "CO", "country": "US"},
    {"name": "Connecticut", "code": "CT", "country": "US"},
    {"name": "Delaware", "code": "DE", "country": "US"},
    {"name": "Florida", "code": "FL", "country": "US"},
    {"name": "Georgia", "code": "GA", "country": "US"},
    {"name": "Hawaii", "code": "HI", "country": "US"},
    {"name": "Idaho", "code": "ID", "country": "US"},
    {"name": "Illinois", "code": "IL", "country": "US"},
    {"name": "Indiana", "code": "IN", "country": "US"},
    {"name": "Iowa", "code": "IA", "country": "US"},
    {"name": "Kansas", "code": "KS", "country": "US"},
    {"name": "Kentucky", "code": "KY", "country": "US"},
    {"name": "Louisiana", "code": "LA", "country": "US"},
    {"name": "Maine", "code": "ME", "country": "US"},
    {"name": "Maryland", "code": "MD", "country": "US"},
    {"name": "Massachusetts", "code": "MA", "country": "US"},
    {"name": "Michigan", "code": "MI", "country": "US"},
    {"name": "Minnesota", "code": "MN", "country": "US"},
    {"name": "Mississippi", "code": "MS", "country": "US"},
    {"name": "Missouri", "code": "MO", "country": "US"},
    {"name": "Montana", "code": "MT", "country": "US"},
    {"name": "Nebraska", "code": "NE", "country": "US"},
    {"name": "Nevada", "code": "NV", "country": "US"},
    {"name": "New Hampshire", "code": "NH", "country": "US"},
    {"name": "New Jersey", "code": "NJ", "country": "US"},
    {"name": "New Mexico", "code": "NM", "country": "US"},
    {"name": "New York", "code": "NY", "country": "US"},
    {"name": "North Carolina", "code": "NC", "country": "US"},
    {"name": "North Dakota", "code": "ND", "country": "US"},
    {"name": "Ohio", "code": "OH", "country": "US"},
    {"name": "Oklahoma", "code": "OK", "country": "US"},
    {"name": "Oregon", "code": "OR", "country": "US"},
    {"name": "Pennsylvania", "code": "PA", "country": "US"},
    {"name": "Rhode Island", "code": "RI", "country": "US"},
    {"name": "South Carolina", "code": "SC", "country": "US"},
    {"name": "South Dakota", "code": "SD", "country": "US"},
    {"name": "Tennessee", "code": "TN", "country": "US"},
    {"name": "Texas", "code": "TX", "country": "US"},
    {"name": "Utah", "code": "UT", "country": "US"},
    {"name": "Vermont", "code": "VT", "country": "US"},
    {"name": "Virginia", "code": "VA", "country": "US"},
    {"name": "Washington", "code": "WA", "country": "US"},
    {"name": "West Virginia", "code": "WV", "country": "US"},
    {"name": "Wisconsin", "code": "WI", "country": "US"},
    {"name": "Wyoming", "code": "WY", "country": "US"},

    // США - District of Columbia и территории
    {"name": "District of Columbia", "code": "DC", "country": "US"},
    {"name": "American Samoa", "code": "AS", "country": "US"},
    {"name": "Guam", "code": "GU", "country": "US"},
    {"name": "Northern Mariana Islands", "code": "MP", "country": "US"},
    {"name": "Puerto Rico", "code": "PR", "country": "US"},
    {"name": "U.S. Virgin Islands", "code": "VI", "country": "US"},

    // Канада - 10 провинций и 3 территории
    {"name": "Alberta", "code": "AB", "country": "CA"},
    {"name": "British Columbia", "code": "BC", "country": "CA"},
    {"name": "Manitoba", "code": "MB", "country": "CA"},
    {"name": "New Brunswick", "code": "NB", "country": "CA"},
    {"name": "Newfoundland and Labrador", "code": "NL", "country": "CA"},
    {"name": "Northwest Territories", "code": "NT", "country": "CA"},
    {"name": "Nova Scotia", "code": "NS", "country": "CA"},
    {"name": "Nunavut", "code": "NU", "country": "CA"},
    {"name": "Ontario", "code": "ON", "country": "CA"},
    {"name": "Prince Edward Island", "code": "PE", "country": "CA"},
    {"name": "Quebec", "code": "QC", "country": "CA"},
    {"name": "Saskatchewan", "code": "SK", "country": "CA"},
    {"name": "Yukon", "code": "YT", "country": "CA"}
  ];
}

List<dynamic> getCountries() {
  return [
    {"name": "Afghanistan", "code": "AF"},
    {"name": "Albania", "code": "AL"},
    {"name": "Algeria", "code": "DZ"},
    {"name": "American Samoa", "code": "AS"},
    {"name": "Andorra", "code": "AD"},
    {"name": "Angola", "code": "AO"},
    {"name": "Antigua and Barbuda", "code": "AG"},
    {"name": "Argentina", "code": "AR"},
    {"name": "Armenia", "code": "AM"},
    {"name": "Aruba", "code": "AW"},
    {"name": "Australia", "code": "AU"},
    {"name": "Austria", "code": "AT"},
    {"name": "Azerbaijan", "code": "AZ"},
    {"name": "Bahamas", "code": "BS"},
    {"name": "Bangladesh", "code": "BD"},
    {"name": "Barbados", "code": "BB"},
    {"name": "Belarus", "code": "BY"},
    {"name": "Belgium", "code": "BE"},
    {"name": "Belize", "code": "BZ"},
    {"name": "Benin", "code": "BJ"},
    {"name": "Bermuda", "code": "BM"},
    {"name": "Bhutan", "code": "BT"},
    {"name": "Bolivia, Plurinational State of bolivia", "code": "BO"},
    {"name": "Bosnia and Herzegovina", "code": "BA"},
    {"name": "Botswana", "code": "BW"},
    {"name": "Brazil", "code": "BR"},
    {"name": "Brunei Darussalam", "code": "BN"},
    {"name": "Bulgaria", "code": "BG"},
    {"name": "Burkina Faso", "code": "BF"},
    {"name": "Cambodia", "code": "KH"},
    {"name": "Cameroon", "code": "CM"},
    {"name": "Canada", "code": "CA"},
    {"name": "Cape Verde", "code": "CV"},
    {"name": "Cayman Islands", "code": "KY"},
    {"name": "Central African Republic", "code": "CF"},
    {"name": "Chile", "code": "CL"},
    {"name": "Curaçao", "code": "CW"},
    {"name": "Colombia", "code": "CO"},
    {"name": "Comoros", "code": "KM"},
    {"name": "Congo", "code": "CG"},
    {"name": "Congo, The Democratic Republic of the Congo", "code": "CD"},
    {"name": "Cook Islands", "code": "CK"},
    {"name": "Costa Rica", "code": "CR"},
    {"name": "Cote d'Ivoire", "code": "CI"},
    {"name": "Croatia", "code": "HR"},
    {"name": "Cyprus", "code": "CY"},
    {"name": "Czech Republic", "code": "CZ"},
    {"name": "Denmark", "code": "DK"},
    {"name": "Djibouti", "code": "DJ"},
    {"name": "Dominica", "code": "DM"},
    {"name": "Dominican Republic", "code": "DO"},
    {"name": "Ecuador", "code": "EC"},
    {"name": "Egypt", "code": "EG"},
    {"name": "El Salvador", "code": "SV"},
    {"name": "Equatorial Guinea", "code": "GQ"},
    {"name": "Ethiopia", "code": "ET"},
    {"name": "Falkland Islands (Malvinas)", "code": "FK"},
    {"name": "Faroe Islands", "code": "FO"},
    {"name": "Fiji", "code": "FJ"},
    {"name": "Finland", "code": "FI"},
    {"name": "France", "code": "FR"},
    {"name": "French Guiana", "code": "GF"},
    {"name": "Gabon", "code": "GA"},
    {"name": "Gambia", "code": "GM"},
    {"name": "Georgia", "code": "GE"},
    {"name": "Germany", "code": "DE"},
    {"name": "Ghana", "code": "GH"},
    {"name": "Gibraltar", "code": "GI"},
    {"name": "Greece", "code": "GR"},
    {"name": "Greenland", "code": "GL"},
    {"name": "Grenada", "code": "GD"},
    {"name": "Guadeloupe", "code": "GP"},
    {"name": "Guatemala", "code": "GT"},
    {"name": "Guernsey", "code": "GG"},
    {"name": "Guyana", "code": "GY"},
    {"name": "Haiti", "code": "HT"},
    {"name": "Honduras", "code": "HN"},
    {"name": "Hong Kong", "code": "HK"},
    {"name": "Hungary", "code": "HU"},
    {"name": "India", "code": "IN"},
    {"name": "Indonesia", "code": "ID"},
    {"name": "Iraq", "code": "IQ"},
    {"name": "Ireland", "code": "IE"},
    {"name": "Isle of Man", "code": "IM"},
    {"name": "Israel", "code": "IL"},
    {"name": "Italy", "code": "IT"},
    {"name": "Jamaica", "code": "JM"},
    {"name": "Japan", "code": "JP"},
    {"name": "Jersey", "code": "JE"},
    {"name": "Jordan", "code": "JO"},
    {"name": "Kazakhstan", "code": "KZ"},
    {"name": "Kenya", "code": "KE"},
    {"name": "Korea, Republic of South Korea", "code": "KR"},
    {"name": "Kuwait", "code": "KW"},
    {"name": "Kyrgyzstan", "code": "KG"},
    {"name": "Laos", "code": "LA"},
    {"name": "Latvia", "code": "LV"},
    {"name": "Lebanon", "code": "LB"},
    {"name": "Lesotho", "code": "LS"},
    {"name": "Libyan Arab Jamahiriya", "code": "LY"},
    {"name": "Liechtenstein", "code": "LI"},
    {"name": "Lithuania", "code": "LT"},
    {"name": "Luxembourg", "code": "LU"},
    {"name": "Macao", "code": "MO"},
    {"name": "Macedonia", "code": "MK"},
    {"name": "Madagascar", "code": "MG"},
    {"name": "Malawi", "code": "MW"},
    {"name": "Malaysia", "code": "MY"},
    {"name": "Malta", "code": "MT"},
    {"name": "Mauritius", "code": "MU"},
    {"name": "Mayotte", "code": "YT"},
    {"name": "Mexico", "code": "MX"},
    {"name": "Micronesia, Federated States of Micronesia", "code": "FM"},
    {"name": "Moldova", "code": "MD"},
    {"name": "Mongolia", "code": "MN"},
    {"name": "Montenegro", "code": "ME"},
    {"name": "Montserrat", "code": "MS"},
    {"name": "Morocco", "code": "MA"},
    {"name": "Mozambique", "code": "MZ"},
    {"name": "Myanmar", "code": "MM"},
    {"name": "Namibia", "code": "NA"},
    {"name": "Nepal", "code": "NP"},
    {"name": "Netherlands", "code": "NL"},
    {"name": "New Caledonia", "code": "NC"},
    {"name": "New Zealand", "code": "NZ"},
    {"name": "Nicaragua", "code": "NI"},
    {"name": "Niger", "code": "NE"},
    {"name": "Nigeria", "code": "NG"},
    {"name": "Norfolk Island", "code": "NF"},
    {"name": "Norway", "code": "NO"},
    {"name": "Oman", "code": "OM"},
    {"name": "Pakistan", "code": "PK"},
    {"name": "Palestinian Territory, Occupied", "code": "PS"},
    {"name": "Panama", "code": "PA"},
    {"name": "Papua New Guinea", "code": "PG"},
    {"name": "Paraguay", "code": "PY"},
    {"name": "Peru", "code": "PE"},
    {"name": "Philippines", "code": "PH"},
    {"name": "Poland", "code": "PL"},
    {"name": "Portugal", "code": "PT"},
    {"name": "Puerto Rico", "code": "PR"},
    {"name": "Qatar", "code": "QA"},
    {"name": "Romania", "code": "RO"},
    {"name": "Russia", "code": "RU"},
    {"name": "Rwanda", "code": "RW"},
    {"name": "Reunion", "code": "RE"},
    {"name": "Saint Helena, Ascension and Tristan Da Cunha", "code": "SH"},
    {"name": "Saint Kitts and Nevis", "code": "KN"},
    {"name": "Saint Lucia", "code": "LC"},
    {"name": "Saint Martin", "code": "MF"},
    {"name": "Saint Pierre and Miquelon", "code": "PM"},
    {"name": "Saint Vincent and the Grenadines", "code": "VC"},
    {"name": "Samoa", "code": "WS"},
    {"name": "Sao Tome and Principe", "code": "ST"},
    {"name": "Saudi Arabia", "code": "SA"},
    {"name": "Senegal", "code": "SN"},
    {"name": "Serbia", "code": "RS"},
    {"name": "Seychelles", "code": "SC"},
    {"name": "Sierra Leone", "code": "SL"},
    {"name": "Singapore", "code": "SG"},
    {"name": "Slovakia", "code": "SK"},
    {"name": "Slovenia", "code": "SI"},
    {"name": "South Africa", "code": "ZA"},
    {"name": "Spain", "code": "ES"},
    {"name": "Sri Lanka", "code": "LK"},
    {"name": "Suriname", "code": "SR"},
    {"name": "Swaziland", "code": "SZ"},
    {"name": "Sweden", "code": "SE"},
    {"name": "Switzerland", "code": "CH"},
    {"name": "Taiwan", "code": "TW"},
    {"name": "Tanzania, United Republic of Tanzania", "code": "TZ"},
    {"name": "Thailand", "code": "TH"},
    {"name": "Timor-Leste", "code": "TL"},
    {"name": "Togo", "code": "TG"},
    {"name": "Tonga", "code": "TO"},
    {"name": "Trinidad and Tobago", "code": "TT"},
    {"name": "Turkey", "code": "TR"},
    {"name": "Turkmenistan", "code": "TM"},
    {"name": "Turks and Caicos Islands", "code": "TC"},
    {"name": "Uganda", "code": "UG"},
    {"name": "Ukraine", "code": "UA"},
    {"name": "United Arab Emirates", "code": "AE"},
    {"name": "United Kingdom", "code": "GB"},
    {"name": "United States", "code": "US"},
    {"name": "Uruguay", "code": "UY"},
    {"name": "Uzbekistan", "code": "UZ"},
    {"name": "Venezuela, Bolivarian Republic of Venezuela", "code": "VE"},
    {"name": "Vietnam", "code": "VN"},
    {"name": "Virgin Islands, British", "code": "VG"},
    {"name": "Virgin Islands, U.S.", "code": "VI"},
    {"name": "Yemen", "code": "YE"},
    {"name": "Zambia", "code": "ZM"},
    {"name": "Zimbabwe", "code": "ZW"}
  ];
}

List<dynamic> getStatesByCountry(String? countryCode) {
  if (countryCode == null || countryCode.isEmpty) {
    return [];
  }

  final allStates = getStatesAndProvinces();
  return allStates.where((state) => state['country'] == countryCode).toList();
}

bool checkConditionsContains(
  List<ConditionsRow> conditionsList,
  ConditionsRow choosenCondition,
) {
  return conditionsList.any((condition) => condition.id == choosenCondition.id);
}

List<TagsRow>? searchTags(
  String? searchingText,
  List<TagsRow>? tags,
) {
  if (tags == null) return null;
  if (searchingText == null || searchingText.isEmpty) return tags;

  final query = searchingText.toLowerCase();
  return tags.where((tag) => tag.name.toLowerCase().contains(query)).toList();
}

int? getIndexByVal(
  String val,
  List<String> valList,
) {
  int index = valList.indexOf(val);
  return index != -1 ? index : null;
}

String? extractCity(dynamic placeJson) {
  if (placeJson == null) return null;

  // 1. Попробовать postalAddress.locality
  if (placeJson['postalAddress'] != null &&
      placeJson['postalAddress']['locality'] != null &&
      (placeJson['postalAddress']['locality'] as String).isNotEmpty) {
    return placeJson['postalAddress']['locality'];
  }

  // 2. Если не найдено, пройтись по addressComponents
  if (placeJson['addressComponents'] != null &&
      placeJson['addressComponents'] is List) {
    for (var component in placeJson['addressComponents']) {
      if (component['types'] != null &&
          component['types'] is List &&
          (component['types'] as List).contains('locality') &&
          component['longText'] != null &&
          (component['longText'] as String).isNotEmpty) {
        return component['longText'];
      }
    }
  }

  // 3. Если не найдено, попробовать извлечь из shortFormattedAddress
  if (placeJson['shortFormattedAddress'] != null &&
      (placeJson['shortFormattedAddress'] as String).isNotEmpty) {
    // Обычно формат: "улица, город"
    final parts = (placeJson['shortFormattedAddress'] as String).split(',');
    if (parts.length >= 2) {
      // Берём второй элемент после улицы
      return parts[1].trim();
    }
  }

  // 4. Если город не найден, вернуть null
  return null;
}

dynamic parseAddressComponents(dynamic addressResponse) {
  final components = addressResponse['addressComponents'] as List? ?? [];

  String streetNumber = '';
  String route = '';
  String city = '';
  String state = '';
  String zip = '';
  String country = '';

  for (final c in components) {
    final types = (c['types'] as List).cast<String>();
    final longText = c['longText'] ?? '';
    final shortText = c['shortText'] ?? '';

    if (types.contains('street_number')) streetNumber = longText;
    if (types.contains('route')) route = longText;
    if (types.contains('locality') ||
        types.contains('sublocality') ||
        types.contains('sublocality_level_1')) city = longText;
    if (types.contains('administrative_area_level_1')) state = longText;
    if (types.contains('postal_code')) zip = longText;
    if (types.contains('country')) country = shortText;
  }

  return {
    'street': '$streetNumber $route'.trim(),
    'city': city,
    'state': state,
    'zip': zip,
    'country': country,
  };
}

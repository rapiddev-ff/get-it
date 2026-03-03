import '/backend/supabase/supabase.dart';
import '/core/config/app_config.dart';

import 'package:flutter_stripe/flutter_stripe.dart';

Future<dynamic> addPaymentCard(
  String cardNumber,
  String expMonth,
  String expYear,
  String cvc,
  String? cardHolderName,
  String? email,
  String? addressLine1,
  String? addressLine2,
  String? city,
  String? state,
  String? postalCode,
  String? country,
  bool setAsDefault,
) async {
  try {
    // Инициализация Stripe
    //
    final stripeKey = AppConfig.stripePublishable;

    if (stripeKey.isEmpty) {
      return {
        'success': false,
        'error': 'Stripe publishable key not configured'
      };
    }

    // Always set the key and apply settings
    try {
      Stripe.publishableKey = stripeKey;
      await Stripe.instance.applySettings();
    } catch (e) {
      return {'success': false, 'error': 'Failed to initialize Stripe'};
    }

    if (Stripe.publishableKey.isEmpty) {
      Stripe.publishableKey = stripeKey;
      await Stripe.instance.applySettings();
    }

    // Парсим данные
    final int expMonthInt = int.tryParse(expMonth) ?? 0;
    int expYearInt = int.tryParse(expYear) ?? 0;

    if (expYearInt > 0 && expYearInt < 100) {
      expYearInt = 2000 + expYearInt;
    }

    final cleanCardNumber = cardNumber.replaceAll(RegExp(r'[\s\-]'), '');

    // Валидация
    if (expMonthInt < 1 || expMonthInt > 12) {
      return {'success': false, 'error': 'Invalid expiration month (1-12)'};
    }

    if (expYearInt < DateTime.now().year) {
      return {'success': false, 'error': 'Card has expired'};
    }

    if (cleanCardNumber.length < 13 || cleanCardNumber.length > 19) {
      return {'success': false, 'error': 'Invalid card number'};
    }

    if (cvc.length < 3 || cvc.length > 4) {
      return {'success': false, 'error': 'Invalid CVC'};
    }

    // Создаём CardDetails
    final cardDetails = CardDetails(
      number: cleanCardNumber,
      expirationMonth: expMonthInt,
      expirationYear: expYearInt,
      cvc: cvc,
    );

    await Stripe.instance.dangerouslyUpdateCardDetails(cardDetails);

    // Хелпер: возвращает null если строка пустая
    String? nonEmpty(String? value) {
      if (value == null || value.trim().isEmpty) return null;
      return value.trim();
    }

    // Создаём BillingDetails только с непустыми полями
    BillingDetails? billingDetails;

    final name = nonEmpty(cardHolderName);
    final emailVal = nonEmpty(email);
    final line1 = nonEmpty(addressLine1);
    final line2 = nonEmpty(addressLine2);
    final cityVal = nonEmpty(city);
    final stateVal = nonEmpty(state);
    final postal = nonEmpty(postalCode);
    final countryVal = nonEmpty(country);

    // Создаём Address только если есть хотя бы одно поле
    Address? address;
    if (line1 != null ||
        line2 != null ||
        cityVal != null ||
        stateVal != null ||
        postal != null ||
        countryVal != null) {
      address = Address(
        line1: line1,
        line2: line2,
        city: cityVal,
        state: stateVal,
        postalCode: postal,
        country: countryVal,
      );
    }

    // Создаём BillingDetails только если есть данные
    if (name != null || emailVal != null || address != null) {
      billingDetails = BillingDetails(
        name: name,
        email: emailVal,
        address: address,
      );
    }

    // Создаём Payment Method
    final paymentMethod = await Stripe.instance.createPaymentMethod(
      params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: billingDetails,
        ),
      ),
    );

    // Сохраняем в Supabase
    final supabase = Supabase.instance.client;

    final response = await supabase.functions.invoke(
      'stripe-save-card',
      body: {
        'payment_method_id': paymentMethod.id,
        'set_as_default': setAsDefault,
        'billing_details': {
          if (name != null) 'name': name,
          if (emailVal != null) 'email': emailVal,
          if (line1 != null) 'address_line1': line1,
          if (line2 != null) 'address_line2': line2,
          if (cityVal != null) 'city': cityVal,
          if (stateVal != null) 'state': stateVal,
          if (postal != null) 'postal_code': postal,
          if (countryVal != null) 'country': countryVal,
        },
      },
    );

    if (response.status != 200) {
      return {
        'success': false,
        'error': response.data?['error'] ?? 'Failed to save card',
      };
    }

    final data = response.data as Map<String, dynamic>;

    return {
      'success': true,
      'payment_method_id': paymentMethod.id,
      'card_brand': data['card_brand'] ?? paymentMethod.card.brand ?? 'unknown',
      'card_last4': data['card_last4'] ?? paymentMethod.card.last4 ?? '',
      'card_exp_month': expMonthInt,
      'card_exp_year': expYearInt,
      'is_default': setAsDefault,
    };
  } on StripeException catch (e) {
    return {
      'success': false,
      'error': e.error.message ?? 'Card validation failed',
    };
  } catch (e) {
    return {'success': false, 'error': e.toString()};
  }
}

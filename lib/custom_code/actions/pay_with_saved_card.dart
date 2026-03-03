import '/backend/supabase/supabase.dart';
import '/core/config/environment_values.dart';

import 'package:flutter_stripe/flutter_stripe.dart';

Future<dynamic> payWithSavedCard(
  String orderId,
  String paymentMethodId,
  int? holdDays,
) async {
  try {
    // Инициализация Stripe (для 3D Secure если понадобится)
    final stripeKey = FFDevEnvironmentValues().stripePublishable;

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

    final supabase = Supabase.instance.client;

    // Вызываем Edge Function для создания и подтверждения платежа
    final response = await supabase.functions.invoke(
      'stripe-create-payment',
      body: {
        'order_id': orderId,
        'payment_method_id': paymentMethodId,
        'capture_method': 'automatic',
        'hold_days': holdDays ?? 7,
      },
    );

    if (response.status != 200) {
      return {
        'success': false,
        'error': response.data?['error'] ?? 'Payment failed',
        'code': response.data?['code'],
      };
    }

    final data = response.data as Map<String, dynamic>;
    final status = data['status'] as String?;

    // Проверяем статус платежа
    if (status == 'succeeded') {
      // Платёж успешен!
      return {
        'success': true,
        'status': 'succeeded',
        'payment_intent_id': data['payment_intent_id'],
        'amount': data['amount'],
        'seller_amount': data['seller_amount'],
        'platform_fee': data['platform_fee'],
      };
    }

    if (status == 'requires_action' || status == 'requires_confirmation') {
      // Нужна 3D Secure аутентификация
      final clientSecret = data['client_secret'] as String?;

      if (clientSecret == null) {
        return {
          'success': false,
          'error': 'Missing client secret for 3D Secure',
        };
      }

      // Обрабатываем 3D Secure
      final result = await Stripe.instance.handleNextAction(clientSecret);

      if (result.status == PaymentIntentsStatus.Succeeded) {
        return {
          'success': true,
          'status': 'succeeded',
          'payment_intent_id': data['payment_intent_id'],
          'amount': data['amount'],
        };
      } else if (result.status == PaymentIntentsStatus.RequiresPaymentMethod) {
        return {
          'success': false,
          'error': 'Card was declined. Please try another card.',
          'code': 'CARD_DECLINED',
        };
      } else {
        return {
          'success': false,
          'error': '3D Secure authentication failed',
          'code': '3DS_FAILED',
          'status': result.status.toString(),
        };
      }
    }

    if (status == 'requires_payment_method') {
      return {
        'success': false,
        'error': 'Card was declined. Please try another card.',
        'code': 'CARD_DECLINED',
      };
    }

    // Другие статусы
    return {
      'success': false,
      'error': 'Payment is pending: $status',
      'status': status,
    };
  } on StripeException catch (e) {
    return {
      'success': false,
      'error': e.error.message ?? 'Payment failed',
      'code': 'STRIPE_ERROR',
      'decline_code': e.error.declineCode,
    };
  } catch (e) {
    return {
      'success': false,
      'error': e.toString(),
    };
  }
}

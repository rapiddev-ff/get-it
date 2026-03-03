import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import 'index.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<String?> refundOrderAction(String orderId) async {
  final supabase = Supabase.instance.client;

  try {
    // Вызываем нашу универсальную функцию
    await supabase.functions.invoke(
      'stripe-create-refund',
      body: {
        'order_id': orderId,
        // reason, amount и т.д. можно не передавать,
        // функция сама поймет, что это "полный возврат от покупателя"
      },
    );

    // Успех (возвращаем null)
    return null;
  } on FunctionException catch (e) {
    // Обработка ошибок от Edge Function
    if (e.details != null && e.details is Map) {
      final details = e.details as Map;
      if (details['error'] != null) {
        return details['error'].toString();
      }
      if (details['message'] != null) {
        return details['message'].toString();
      }
    }
    // Если нет JSON деталей, возвращаем reasonPhrase или статус
    return e.reasonPhrase ?? 'Error: ${e.status}';
  } catch (e) {
    // Прочие ошибки (сеть и т.д.)
    return e.toString();
  }
}

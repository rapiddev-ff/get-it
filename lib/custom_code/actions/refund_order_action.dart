// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

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

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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Вызывать при onChange на поле SKU Prefix (с debounce ~500ms в FlutterFlow)
/// excludeProductId — передавать при редактировании чтобы не считать текущий товар
///
/// Возвращает:
///   success: bool
///   nextNumber: String  ('001', '042' ...)
///   fullSku:   String  ('A1-001')
///   message:   String  (для показа пользователю)
Future<dynamic> getNextSkuNumber(
  String skuPrefix,
  String? excludeProductId,
) async {
  try {
    if (skuPrefix.trim().isEmpty) {
      return {
        'success': false,
        'nextNumber': '',
        'fullSku': '',
        'message': '',
      };
    }

    final supabase = Supabase.instance.client;

    final Map<String, dynamic> params = {
      'p_sku_prefix': skuPrefix.trim().toUpperCase(),
    };

    if (_isValidUuid(excludeProductId)) {
      params['p_exclude_product_id'] = excludeProductId!.trim();
    }

    final response = await supabase.rpc('get_next_sku_number', params: params);

    if (response == null || response['success'] != true) {
      return {
        'success': false,
        'nextNumber': '',
        'fullSku': '',
        'message': response?['error']?.toString() ?? 'Error fetching SKU',
      };
    }

    final String nextNumber = response['nextNumber']?.toString() ?? '001';
    final String fullSku = response['fullSku']?.toString() ?? '';

    return {
      'success': true,
      'nextNumber': nextNumber,
      'fullSku': fullSku,
      'message': 'Next available: $fullSku',
    };
  } catch (e) {
    return {
      'success': false,
      'nextNumber': '',
      'fullSku': '',
      'message': 'Error: ${e.toString()}',
    };
  }
}

bool _isValidUuid(String? value) {
  if (value == null || value.trim().isEmpty) return false;
  final uuidRegex = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );
  return uuidRegex.hasMatch(value.trim());
}

import '/backend/supabase/supabase.dart';
import 'package:flutter/material.dart';

Future<dynamic> callRpc(
  BuildContext context,
  String rpcName,
  dynamic params,
) async {
  final response = await SupaFlow.client.rpc(
    rpcName,
    params: params != null ? Map<String, dynamic>.from(params as Map) : {},
  );

  // Trigger rebuild
  if (context.mounted) {
    (context as Element).markNeedsBuild();
  }

  return response;
}

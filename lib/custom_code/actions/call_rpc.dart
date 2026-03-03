// Automatic FlutterFlow imports
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

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

import '/features/profile/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _repository = UserRepository(Supabase.instance.client);

Future<dynamic> callRpc(
  BuildContext context,
  String rpcName,
  dynamic params,
) async {
  final response = await _repository.callRpc(
    rpcName,
    params != null ? Map<String, dynamic>.from(params as Map) : null,
  );

  // Trigger rebuild
  if (context.mounted) {
    (context as Element).markNeedsBuild();
  }

  return response;
}

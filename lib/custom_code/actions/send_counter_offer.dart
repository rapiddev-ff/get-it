import '/features/home/domain/models/counter_offer_model.dart';
import '/backend/supabase/supabase.dart';

// Custom Action: sendCounterOffer
// Return Type: CounterOffer? (nullable)
// Arguments:
//   - conversationId (String)
//   - offeredPrice (double)

import 'package:supabase_flutter/supabase_flutter.dart';

Future<CounterOffer?> sendCounterOffer(
  String conversationId,
  double offeredPrice,
) async {
  final client = Supabase.instance.client;

  try {
    final response = await client.rpc(
      'send_counter_offer',
      params: {
        'p_conversation_id': conversationId,
        'p_offered_price': offeredPrice,
      },
    );

    if (response == null || (response as List).isEmpty) return null;

    final json = response[0];

    return CounterOffer(
      id: json['counter_offer_id'] ?? '',
      originalPrice: (json['original_price'] as num?)?.toDouble() ?? 0,
      offeredPrice: (json['offered_price'] as num?)?.toDouble() ?? 0,
      status: json['status'] ?? 'pending',
      fromUserId: '',
      toUserId: '',
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,
    );
  } catch (e) {
    return null;
  }
}

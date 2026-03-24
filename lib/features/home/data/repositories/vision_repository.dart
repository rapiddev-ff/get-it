import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/features/home/domain/models/ai_scan_result_model.dart';

final visionRepositoryProvider = Provider<VisionRepository>((ref) {
  return VisionRepository(Supabase.instance.client);
});

class VisionRepository {
  final SupabaseClient _client;

  VisionRepository(this._client);

  /// Sends image bytes to the vision-analyze Edge Function
  /// and returns structured scan results.
  Future<AiScanResult> analyzeImage(Uint8List imageBytes) async {
    try {
      final base64Image = base64Encode(imageBytes);

      final response = await _client.functions.invoke(
        'vision-analyze',
        body: {'image': base64Image},
      );

      if (response.status != 200) {
        final errorData = response.data;
        final message = errorData is Map
            ? errorData['error'] ?? 'Analysis failed'
            : 'Analysis failed (status ${response.status})';
        throw Exception(message);
      }

      final data = response.data as Map<String, dynamic>;
      return AiScanResult.fromJson(data);
    } catch (e) {
      debugPrint('VisionRepository.analyzeImage error: $e');
      rethrow;
    }
  }
}

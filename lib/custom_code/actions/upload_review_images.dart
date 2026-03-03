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

import '/custom_code/actions/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'dart:typed_data';
import 'package:uuid/uuid.dart';

// Custom Action: uploadReviewImages
// Return Type: List<String> (uploaded URLs)
// Arguments:
//   images (List<FFUploadedFile>, required)

Future<List<String>> uploadReviewImages(
  List<FFUploadedFile> images,
) async {
  final List<String> uploadedUrls = [];
  final userId = SupaFlow.client.auth.currentUser?.id;

  if (userId == null) return [];

  for (final image in images) {
    try {
      if (image.bytes == null) continue;

      final ext = image.name?.split('.').last ?? 'jpg';
      final fileName = '${const Uuid().v4()}.$ext';
      final path = '$userId/reviews/$fileName';

      await SupaFlow.client.storage.from('review-images').uploadBinary(
            path,
            image.bytes!,
            fileOptions: FileOptions(
              contentType: 'image/$ext',
              upsert: true,
            ),
          );

      final publicUrl =
          SupaFlow.client.storage.from('review-images').getPublicUrl(path);

      uploadedUrls.add(publicUrl);
    } catch (e) {
      print('❌ Error uploading review image: $e');
    }
  }

  return uploadedUrls;
}

import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/core/utils/uploaded_file.dart';
import 'index.dart';
import 'package:flutter/material.dart';

import 'dart:typed_data';
import 'package:http/http.dart' as http;

Future<FFUploadedFile?> convertUrlToUploadedFile(String imageUrl) async {
  try {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      final Uint8List bytes = response.bodyBytes;

      // Определяем расширение файла
      String fileName = 'image.jpg';
      final contentType = response.headers['content-type'];
      if (contentType != null) {
        if (contentType.contains('png')) {
          fileName = 'image.png';
        } else if (contentType.contains('gif')) {
          fileName = 'image.gif';
        } else if (contentType.contains('webp')) {
          fileName = 'image.webp';
        }
      }

      return FFUploadedFile(
        name: fileName,
        bytes: bytes,
      );
    }
    return null;
  } catch (e) {
    print('Error converting URL to FFUploadedFile: $e');
    return null;
  }
}

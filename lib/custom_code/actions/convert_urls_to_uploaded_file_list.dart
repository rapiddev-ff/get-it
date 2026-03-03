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

import 'dart:typed_data';
import 'package:http/http.dart' as http;

Future<List<FFUploadedFile>> convertUrlsToUploadedFileList(
    List<String> imageUrls) async {
  final List<FFUploadedFile> results = [];

  await Future.wait(imageUrls.map((imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final Uint8List bytes = response.bodyBytes;
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
        results.add(FFUploadedFile(name: fileName, bytes: bytes));
      }
    } catch (e) {
      print('Error converting URL $imageUrl: $e');
    }
  }));

  return results;
}

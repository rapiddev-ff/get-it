import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/core/utils/uploaded_file.dart';
import 'index.dart';
import 'package:flutter/material.dart';

import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:mime/mime.dart';

Future<String?> uploadImageToStorage(
  FFUploadedFile uploadedFile,
  String bucket,
  String folder,
) async {
  try {
    final supabase = Supabase.instance.client;
    final bytes = uploadedFile.bytes;

    if (bytes == null || bytes.isEmpty) {
      print('Error: No file bytes');
      return null;
    }

    final uuid = const Uuid().v4();
    final extension = _getFileExtension(uploadedFile.name ?? 'image.jpg');
    final fileName = '$uuid$extension';

    final filePath =
        folder != null && folder.isNotEmpty ? '$folder/$fileName' : fileName;

    final mimeType = lookupMimeType(uploadedFile.name ?? '') ?? 'image/jpeg';

    await supabase.storage.from(bucket).uploadBinary(
          filePath,
          bytes,
          fileOptions: FileOptions(
            contentType: mimeType,
            upsert: true,
          ),
        );

    final publicUrl = supabase.storage.from(bucket).getPublicUrl(filePath);

    return publicUrl;
  } catch (e) {
    print('Upload error: $e');
    return null;
  }
}

String _getFileExtension(String fileName) {
  final dotIndex = fileName.lastIndexOf('.');
  if (dotIndex != -1 && dotIndex < fileName.length - 1) {
    return fileName.substring(dotIndex).toLowerCase();
  }
  return '.jpg';
}

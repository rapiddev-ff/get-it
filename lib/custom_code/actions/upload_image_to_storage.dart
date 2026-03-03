import '/core/utils/uploaded_file.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:mime/mime.dart';

Future<String?> uploadImageToStorage(
  UploadedFile uploadedFile,
  String bucket,
  String folder,
) async {
  try {
    final supabase = Supabase.instance.client;
    final bytes = uploadedFile.bytes;

    if (bytes == null || bytes.isEmpty) {
      return null;
    }

    final uuid = const Uuid().v4();
    final extension = _getFileExtension(uploadedFile.name ?? 'image.jpg');
    final fileName = '$uuid$extension';

    final filePath = folder.isNotEmpty ? '$folder/$fileName' : fileName;

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

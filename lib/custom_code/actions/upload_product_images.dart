import '/core/utils/uploaded_file.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:mime/mime.dart';

Future<List<String>?> uploadProductImages(
  List<UploadedFile> uploadedFiles,
  String productId,
) async {
  try {
    final supabase = Supabase.instance.client;

    // Получаем user ID для пути в storage
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      return null;
    }

    if (uploadedFiles.isEmpty) {
      return null;
    }

    final List<String> uploadedUrls = [];
    const bucket = 'product-images';

    // 1. Загружаем все изображения в Storage
    for (int i = 0; i < uploadedFiles.length; i++) {
      final file = uploadedFiles[i];
      final bytes = file.bytes;

      if (bytes == null || bytes.isEmpty) {
        continue;
      }

      final uuid = const Uuid().v4();
      final extension = _getFileExtension(file.name ?? 'image.jpg');
      final fileName = '$uuid$extension';
      final filePath = '$userId/$productId/$fileName';

      final mimeType = lookupMimeType(file.name ?? '') ?? 'image/jpeg';

      await supabase.storage.from(bucket).uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(
              contentType: mimeType,
              upsert: true,
            ),
          );

      final publicUrl = supabase.storage.from(bucket).getPublicUrl(filePath);
      uploadedUrls.add(publicUrl);
    }

    // 2. Создаем записи в product_images
    for (int i = 0; i < uploadedUrls.length; i++) {
      await supabase.from('product_images').insert({
        'product_id': productId,
        'image_url': uploadedUrls[i],
        'is_main': i == 0, // Первое изображение = главное
        'sort_order': i,
      });
    }

    return uploadedUrls;
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

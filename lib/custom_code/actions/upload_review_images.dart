import '/backend/supabase/supabase.dart';
import '/core/utils/uploaded_file.dart';

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
    } catch (e) {}
  }

  return uploadedUrls;
}

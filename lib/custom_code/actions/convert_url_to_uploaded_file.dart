import 'dart:typed_data';
import '/core/utils/uploaded_file.dart';
import 'package:http/http.dart' as http;

Future<UploadedFile?> convertUrlToUploadedFile(String imageUrl) async {
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

      return UploadedFile(
        name: fileName,
        bytes: bytes,
      );
    }
    return null;
  } catch (e) {
    return null;
  }
}

import 'dart:typed_data';
import '/core/utils/uploaded_file.dart';
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
    } catch (e) {}
  }));

  return results;
}

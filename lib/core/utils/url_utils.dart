import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url) async {
  final uri = Uri.parse(url);
  try {
    await launchUrl(uri);
  } catch (e) {
    throw 'Could not launch $uri: $e';
  }
}

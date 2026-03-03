import 'package:shared_preferences/shared_preferences.dart';

Future<void> resetPasswordRecoveryState() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('last_processed_reset_link');
  await prefs.remove('last_used_reset_code');
  await prefs.remove('pending_reset_code');
}

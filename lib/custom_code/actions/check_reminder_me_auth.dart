import '/backend/supabase/supabase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future checkReminderMeAuth() async {
  final storage = FlutterSecureStorage();
  final raw = await storage.read(key: 'ff_keepSignedIn');
  final keepSignedIn = raw == 'true';

  if (!keepSignedIn && SupaFlow.client.auth.currentSession != null) {
    await SupaFlow.client.auth.signOut();
  }
}

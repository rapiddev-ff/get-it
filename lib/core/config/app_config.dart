import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static String get stripePublishable =>
      dotenv.env['STRIPE_PUBLISHABLE'] ?? '';
  static String get stripeSecret => dotenv.env['STRIPE_SECRET'] ?? '';
  static String get twillioSid => dotenv.env['TWILLIO_SID'] ?? '';
  static String get twillioAuth => dotenv.env['TWILLIO_AUTH'] ?? '';
  static String get twillioBase64 => dotenv.env['TWILLIO_BASE64'] ?? '';
  static String get serviceSid => dotenv.env['SERVICE_SID'] ?? '';
  static String get google => dotenv.env['GOOGLE'] ?? '';
}

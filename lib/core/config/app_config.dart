import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseHost => supabaseUrl;
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static String get stripePublishable => dotenv.env['STRIPE_PUBLISHABLE'] ?? '';
  static String get google => dotenv.env['GOOGLE'] ?? '';
}

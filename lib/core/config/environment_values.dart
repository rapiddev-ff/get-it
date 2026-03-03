import 'dart:convert';
import 'package:flutter/services.dart';

class FFDevEnvironmentValues {
  static const String currentEnvironment = 'Production';
  static const String environmentValuesPath =
      'assets/environment_values/environment.json';

  static final FFDevEnvironmentValues _instance =
      FFDevEnvironmentValues._internal();

  factory FFDevEnvironmentValues() {
    return _instance;
  }

  FFDevEnvironmentValues._internal();

  Future<void> initialize() async {
    try {
      final String response =
          await rootBundle.loadString(environmentValuesPath);
      final data = await json.decode(response);
      _supabaseHost = data['supabaseHost'];
      _supabaseAnonKey = data['supabaseAnonKey'];
      _serviceSid = data['serviceSid'];
      _twillioAuth = data['twillioAuth'];
      _twillioSid = data['twillioSid'];
      _twillioBase64 = data['twillioBase64'];
      _stripeSecret = data['stripeSecret'];
      _stripePublishable = data['stripePublishable'];
      _google = data['google'];
    } catch (e) {
      print('Error loading environment values: $e');
    }
  }

  String _supabaseHost = '';
  String get supabaseHost => _supabaseHost;

  String _supabaseAnonKey = '';
  String get supabaseAnonKey => _supabaseAnonKey;

  String _serviceSid = '';
  String get serviceSid => _serviceSid;

  String _twillioAuth = '';
  String get twillioAuth => _twillioAuth;

  String _twillioSid = '';
  String get twillioSid => _twillioSid;

  String _twillioBase64 = '';
  String get twillioBase64 => _twillioBase64;

  String _stripeSecret = '';
  String get stripeSecret => _stripeSecret;

  String _stripePublishable = '';
  String get stripePublishable => _stripePublishable;

  String _google = '';
  String get google => _google;
}

import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/core/state/app_state_service.dart';
import 'index.dart';
import 'package:flutter/material.dart';

Future checkReminderMeAuth() async {
  if (!FFAppState().keepSignedIn &&
      SupaFlow.client.auth.currentSession != null) {
    await SupaFlow.client.auth.signOut();
  }
}

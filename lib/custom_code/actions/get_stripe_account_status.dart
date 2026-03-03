import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import 'index.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<dynamic> getStripeAccountStatus() async {
  try {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      return {
        'has_account': false,
        'status': 'not_connected',
        'status_label': 'Not Connected',
        'status_color': '#9E9E9E', // grey
        'can_sell': false,
        'needs_attention': false,
      };
    }

    final response = await supabase.from('stripe_accounts').select('''
          account_status,
          charges_enabled,
          payouts_enabled,
          details_submitted,
          currently_due,
          past_due,
          disabled_reason,
          requirements_deadline
        ''').eq('user_id', user.id).maybeSingle();

    if (response == null) {
      return {
        'has_account': false,
        'status': 'not_connected',
        'status_label': 'Not Connected',
        'status_color': '#9E9E9E',
        'can_sell': false,
        'needs_attention': false,
      };
    }

    final status = response['account_status'] as String? ?? 'onboarding';
    final pastDue = (response['past_due'] as List?)?.length ?? 0;
    final currentlyDue = (response['currently_due'] as List?)?.length ?? 0;

    String statusLabel;
    String statusColor;
    bool canSell;
    bool needsAttention;

    switch (status) {
      case 'enabled':
        statusLabel = 'Active';
        statusColor = '#4CAF50'; // green
        canSell = true;
        needsAttention = currentlyDue > 0;
        break;
      case 'restricted':
        statusLabel = 'Restricted';
        statusColor = '#FF9800'; // orange
        canSell = false;
        needsAttention = true;
        break;
      case 'in_review':
        statusLabel = 'In Review';
        statusColor = '#2196F3'; // blue
        canSell = false;
        needsAttention = false;
        break;
      case 'rejected':
        statusLabel = 'Rejected';
        statusColor = '#F44336'; // red
        canSell = false;
        needsAttention = true;
        break;
      case 'disabled':
        statusLabel = 'Disabled';
        statusColor = '#F44336'; // red
        canSell = false;
        needsAttention = true;
        break;
      case 'onboarding':
        statusLabel = 'Pending Setup';
        statusColor = '#FF9800'; // orange
        canSell = false;
        needsAttention = true;
        break;
      default:
        statusLabel = 'Unknown';
        statusColor = '#9E9E9E';
        canSell = false;
        needsAttention = false;
    }

    return {
      'has_account': true,
      'status': status,
      'status_label': statusLabel,
      'status_color': statusColor,
      'can_sell': canSell,
      'needs_attention': needsAttention,
      'past_due_count': pastDue,
      'currently_due_count': currentlyDue,
      'disabled_reason': response['disabled_reason'],
    };
  } catch (e) {
    print('Error getting Stripe status: $e');
    return {
      'has_account': false,
      'status': 'error',
      'status_label': 'Error',
      'status_color': '#9E9E9E',
      'can_sell': false,
      'needs_attention': false,
    };
  }
}

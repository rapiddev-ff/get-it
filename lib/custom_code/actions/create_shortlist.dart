import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<Map<String, dynamic>> createShortlist({
  required String name,
  String? eventName,
  String? startDate,
  String? endDate,
  required bool isPublic,
  double? discountPercentage,
  String? notes,
  required String status,
  List<String> productIds = const [],
}) async {
  Map<String, dynamic> errorResult(String title, String message) => {
        'success': false,
        'title': title,
        'message': message,
      };

  try {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      return errorResult('Not Logged In', 'You must be logged in to create a shortlist.');
    }

    if (name.trim().isEmpty) {
      return errorResult('Missing Name', 'Shortlist name is required.');
    }

    if (!['active', 'draft'].contains(status)) {
      return errorResult('Invalid Status', 'Status must be "active" or "draft".');
    }

    // Generate random 8-char share code
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final shareCode = List.generate(8, (_) => chars[random.nextInt(chars.length)]).join();

    // Parse dates
    DateTime? parsedStartDate;
    DateTime? parsedEndDate;
    if (startDate != null && startDate.trim().isNotEmpty) {
      parsedStartDate = _parseDate(startDate.trim());
    }
    if (endDate != null && endDate.trim().isNotEmpty) {
      parsedEndDate = _parseDate(endDate.trim());
    }

    // Insert shortlist
    final shortlistData = <String, dynamic>{
      'seller_id': userId,
      'name': name.trim(),
      'status': status,
      'is_public': isPublic,
      'share_code': shareCode,
      'total_items': productIds.length,
    };

    if (eventName != null && eventName.trim().isNotEmpty) {
      shortlistData['event_name'] = eventName.trim();
    }
    if (notes != null && notes.trim().isNotEmpty) {
      shortlistData['description'] = notes.trim();
    }
    if (discountPercentage != null && discountPercentage > 0) {
      shortlistData['discount_percentage'] = discountPercentage;
    }
    if (parsedStartDate != null) {
      shortlistData['start_date'] = parsedStartDate.toIso8601String();
    }
    if (parsedEndDate != null) {
      shortlistData['end_date'] = parsedEndDate.toIso8601String();
    }

    final response = await supabase
        .from('shortlists')
        .insert(shortlistData)
        .select()
        .single();

    final shortlistId = response['id'] as String;

    // Insert shortlist items
    if (productIds.isNotEmpty) {
      final items = productIds.asMap().entries.map((entry) => {
            'shortlist_id': shortlistId,
            'product_id': entry.value,
            'sort_order': entry.key,
          }).toList();

      await supabase.from('shortlist_items').insert(items);
    }

    return {
      'success': true,
      'title': status == 'draft' ? 'Draft Saved' : 'Shortlist Created',
      'message': status == 'draft'
          ? 'Your shortlist has been saved as a draft.'
          : 'Your shortlist is now live with ${productIds.length} product(s).',
      'shortlistId': shortlistId,
    };
  } catch (e) {
    return {
      'success': false,
      'title': 'Error',
      'message': 'Failed to create shortlist: ${e.toString()}',
    };
  }
}

/// Parse MM/DD/YYYY format to DateTime
DateTime? _parseDate(String input) {
  try {
    final parts = input.split('/');
    if (parts.length == 3) {
      final month = int.parse(parts[0]);
      final day = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    }
  } catch (_) {}
  return null;
}

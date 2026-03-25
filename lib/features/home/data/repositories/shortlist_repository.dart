import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/features/home/domain/models/shortlist_item_detail_model.dart';
import '/features/home/domain/models/shortlist_product_model.dart';

final shortlistRepositoryProvider = Provider<ShortlistRepository>((ref) {
  return ShortlistRepository(Supabase.instance.client);
});

class ShortlistRepository {
  ShortlistRepository(this._client);
  final SupabaseClient _client;

  /// Get seller's active products available for shortlist selection.
  Future<List<ShortlistProduct>> getSellerProductsForShortlist({
    required String sellerId,
    String? searchQuery,
    List<String>? categoryIds,
    List<String>? subcategoryIds,
    String? existingShortlistId,
  }) async {
    final response = await _client.rpc('get_seller_products_for_shortlist',
        params: {
          'p_seller_id': sellerId,
          if (searchQuery != null && searchQuery.isNotEmpty)
            'p_search_query': searchQuery,
          if (categoryIds != null && categoryIds.isNotEmpty)
            'p_category_ids': categoryIds,
          if (subcategoryIds != null && subcategoryIds.isNotEmpty)
            'p_subcategory_ids': subcategoryIds,
          if (existingShortlistId != null)
            'p_existing_shortlist_id': existingShortlistId,
        });

    final list = response is List ? response : <dynamic>[];
    return list
        .map((e) => ShortlistProduct.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Get detailed shortlist items for display on the shortlist page.
  Future<List<ShortlistItemDetail>> getShortlistItems(
      String shortlistId) async {
    final response = await _client
        .rpc('get_shortlist_items_detail', params: {
      'p_shortlist_id': shortlistId,
    });

    final list = response is List ? response : <dynamic>[];
    return list
        .map((e) => ShortlistItemDetail.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Atomically reserve product quantities for a shortlist.
  /// Returns `{success: true}` or `{success: false, conflicts: [...]}`.
  Future<Map<String, dynamic>> reserveItems({
    required String shortlistId,
    required Map<String, int> items,
    required String sellerId,
  }) async {
    final itemsJson = items.entries
        .map((e) => {'product_id': e.key, 'quantity': e.value})
        .toList();

    final response =
        await _client.rpc('reserve_shortlist_items', params: {
      'p_shortlist_id': shortlistId,
      'p_items': itemsJson,
      'p_seller_id': sellerId,
    });

    return response is Map<String, dynamic>
        ? response
        : {'success': false, 'error': 'Unexpected response'};
  }

  /// Release reserved quantities back to products.
  Future<Map<String, dynamic>> releaseItems({
    required String shortlistId,
    List<String>? productIds,
    String? sellerId,
  }) async {
    final response =
        await _client.rpc('release_shortlist_items', params: {
      'p_shortlist_id': shortlistId,
      if (productIds != null) 'p_product_ids': productIds,
      if (sellerId != null) 'p_seller_id': sellerId,
    });

    return response is Map<String, dynamic>
        ? response
        : {'success': false, 'error': 'Unexpected response'};
  }

  /// Update a shortlist item's status (sold / damaged).
  Future<Map<String, dynamic>> updateItemStatus({
    required String shortlistItemId,
    required String newStatus,
    required String sellerId,
  }) async {
    final response =
        await _client.rpc('update_shortlist_item_status', params: {
      'p_shortlist_item_id': shortlistItemId,
      'p_new_status': newStatus,
      'p_seller_id': sellerId,
    });

    return response is Map<String, dynamic>
        ? response
        : {'success': false, 'error': 'Unexpected response'};
  }

  /// Create a new shortlist with optional product reservations.
  Future<Map<String, dynamic>> createShortlist({
    required String name,
    String? eventName,
    String? startDate,
    String? endDate,
    required bool isPublic,
    String? notes,
    required String status,
    Map<String, int> productQuantities = const {},
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        return _error('Not Logged In',
            'You must be logged in to create a shortlist.');
      }
      if (name.trim().isEmpty) {
        return _error('Missing Name', 'Shortlist name is required.');
      }
      if (!['active', 'draft'].contains(status)) {
        return _error(
            'Invalid Status', 'Status must be "active" or "draft".');
      }

      // Generate random 8-char share code
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      final random = Random();
      final shareCode =
          List.generate(8, (_) => chars[random.nextInt(chars.length)]).join();

      // Parse dates
      DateTime? parsedStart;
      DateTime? parsedEnd;
      if (startDate != null && startDate.trim().isNotEmpty) {
        parsedStart = _parseDate(startDate.trim());
      }
      if (endDate != null && endDate.trim().isNotEmpty) {
        parsedEnd = _parseDate(endDate.trim());
      }

      final shortlistData = <String, dynamic>{
        'seller_id': userId,
        'name': name.trim(),
        'status': status,
        'is_public': isPublic,
        'share_code': shareCode,
        'total_items': 0,
      };
      if (eventName != null && eventName.trim().isNotEmpty) {
        shortlistData['event_name'] = eventName.trim();
      }
      if (notes != null && notes.trim().isNotEmpty) {
        shortlistData['description'] = notes.trim();
      }
      if (parsedStart != null) {
        shortlistData['start_date'] = parsedStart.toIso8601String();
      }
      if (parsedEnd != null) {
        shortlistData['end_date'] = parsedEnd.toIso8601String();
      }

      final response = await _client
          .from('shortlists')
          .insert(shortlistData)
          .select()
          .single();

      final shortlistId = response['id'] as String;

      // Reserve products if any
      if (productQuantities.isNotEmpty) {
        final reserveResult = await reserveItems(
          shortlistId: shortlistId,
          items: productQuantities,
          sellerId: userId,
        );

        if (reserveResult['success'] != true) {
          return {
            'success': false,
            'title': 'Reservation Failed',
            'message': 'Some products could not be reserved.',
            'shortlistId': shortlistId,
            'conflicts': reserveResult['conflicts'],
          };
        }
      }

      return {
        'success': true,
        'title': status == 'draft' ? 'Draft Saved' : 'Shortlist Created',
        'message': status == 'draft'
            ? 'Your shortlist has been saved as a draft.'
            : 'Your shortlist is now live.',
        'shortlistId': shortlistId,
      };
    } catch (e) {
      return _error('Error', 'Failed to create shortlist: $e');
    }
  }

  /// Update shortlist metadata (name, dates, etc.)
  Future<void> updateShortlist(
      String shortlistId, Map<String, dynamic> data) async {
    data['updated_at'] = DateTime.now().toIso8601String();
    await _client
        .from('shortlists')
        .update(data)
        .eq('id', shortlistId);
  }

  /// Update shortlist status (publish, end, etc.)
  Future<void> updateShortlistStatus(
      String shortlistId, String status) async {
    await updateShortlist(shortlistId, {'status': status});
  }

  // ── helpers ──

  Map<String, dynamic> _error(String title, String message) => {
        'success': false,
        'title': title,
        'message': message,
      };

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
}

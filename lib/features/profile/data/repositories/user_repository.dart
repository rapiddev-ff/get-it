import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(Supabase.instance.client);
});

class UserRepository {
  final SupabaseClient _client;

  UserRepository(this._client);

  /// Checks if a username is available.
  Future<bool> checkUsernameAvailable(String username) async {
    try {
      final response = await _client.rpc(
        'check_username_available',
        params: {'p_username': username},
      );
      return response == true;
    } catch (e) {
      return false;
    }
  }

  /// Checks if an email is already registered.
  Future<bool> checkEmailRegistered(String email) async {
    try {
      final response = await _client.rpc(
        'check_email_registered',
        params: {'p_email': email},
      );
      return response == true;
    } catch (e) {
      return false;
    }
  }

  /// Updates user profile fields.
  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    await _client
        .from('user_profiles')
        .update(data)
        .eq('user_id', userId);
  }

  /// Deactivates the user account.
  Future<void> deactivateAccount(String userId) async {
    await _client.from('user_profiles').update({
      'is_active': false,
      'deactivated_at': DateTime.now().toUtc().toIso8601String(),
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('user_id', userId);
  }

  /// Reactivates the user account.
  Future<void> reactivateAccount(String userId) async {
    await _client.from('user_profiles').update({
      'is_active': true,
      'deactivated_at': null,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    }).eq('user_id', userId);
  }

  /// Permanently deletes the user account via RPC.
  Future<void> permanentlyDeleteAccount(String userId) async {
    await _client.rpc(
      'permanently_delete_account',
      params: {'p_user_id': userId},
    );
  }

  /// Submits a report.
  Future<void> submitReport(Map<String, dynamic> params) async {
    await _client.rpc('submit_report', params: params);
  }

  /// Block a user.
  Future<void> blockUser(String userId, String blockedUserId) async {
    await _client.rpc(
      'block_user',
      params: {
        'p_blocker_id': userId,
        'p_blocked_id': blockedUserId,
      },
    );
  }

  /// Unblock a user.
  Future<void> unblockUser(String userId, String blockedUserId) async {
    await _client.rpc(
      'unblock_user',
      params: {
        'p_blocker_id': userId,
        'p_blocked_id': blockedUserId,
      },
    );
  }

  /// Get block list.
  Future<List<Map<String, dynamic>>> getBlockList(String userId) async {
    try {
      final response = await _client.rpc(
        'get_block_list',
        params: {'p_user_id': userId},
      );
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get followers list.
  Future<List<Map<String, dynamic>>> getFollowers(
    String userId, {
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await _client.rpc(
        'get_followers',
        params: {
          'p_user_id': userId,
          if (limit != null) 'p_limit': limit,
          if (offset != null) 'p_offset': offset,
        },
      );
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get following list.
  Future<List<Map<String, dynamic>>> getFollowing(
    String userId, {
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await _client.rpc(
        'get_following',
        params: {
          'p_user_id': userId,
          if (limit != null) 'p_limit': limit,
          if (offset != null) 'p_offset': offset,
        },
      );
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Save shipping defaults.
  Future<void> saveShippingDefaults(Map<String, dynamic> params) async {
    await _client.rpc('save_shipping_settings', params: params);
  }

  /// Get user reviews.
  Future<List<Map<String, dynamic>>> getUserReviews(
    String userId,
    String role, {
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await _client.rpc(
        'get_user_reviews',
        params: {
          'p_user_id': userId,
          'p_role': role,
          if (limit != null) 'p_limit': limit,
          if (offset != null) 'p_offset': offset,
        },
      );
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Generic RPC call helper.
  Future<dynamic> callRpc(String rpcName, Map<String, dynamic>? params) async {
    return await _client.rpc(
      rpcName,
      params: params ?? {},
    );
  }
}

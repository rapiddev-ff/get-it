import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:get_it/features/profile/data/repositories/user_repository.dart';

import '../helpers/mock_supabase.dart';

void main() {
  late MockSupabaseClient mockClient;
  late UserRepository repository;

  setUp(() {
    mockClient = MockSupabaseClient();
    repository = UserRepository(mockClient);
  });

  // ---------------------------------------------------------------------------
  // checkUsernameAvailable
  // ---------------------------------------------------------------------------
  group('checkUsernameAvailable', () {
    test('returns true when RPC returns true', () async {
      stubRpcSuccess(mockClient, 'check_username_available', true);

      final result = await repository.checkUsernameAvailable('newuser');

      expect(result, isTrue);
    });

    test('returns false when RPC returns false', () async {
      stubRpcSuccess(mockClient, 'check_username_available', false);

      final result = await repository.checkUsernameAvailable('takenuser');

      expect(result, isFalse);
    });

    test('returns false on exception', () async {
      stubRpcError(
          mockClient, 'check_username_available', Exception('DB error'));

      final result = await repository.checkUsernameAvailable('anyuser');

      expect(result, isFalse);
    });

    test('passes username param', () async {
      stubRpcSuccess(mockClient, 'check_username_available', true);

      await repository.checkUsernameAvailable('specificuser');

      final captured = verify(() => mockClient.rpc(
            'check_username_available',
            params: captureAny(named: 'params'),
          )).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_username'], 'specificuser');
    });
  });

  // ---------------------------------------------------------------------------
  // checkEmailRegistered
  // ---------------------------------------------------------------------------
  group('checkEmailRegistered', () {
    test('returns true when email is already registered', () async {
      stubRpcSuccess(mockClient, 'check_email_registered', true);

      final result =
          await repository.checkEmailRegistered('existing@example.com');

      expect(result, isTrue);
    });

    test('returns false when email is not registered', () async {
      stubRpcSuccess(mockClient, 'check_email_registered', false);

      final result = await repository.checkEmailRegistered('new@example.com');

      expect(result, isFalse);
    });

    test('returns false on exception', () async {
      stubRpcError(
          mockClient, 'check_email_registered', Exception('Timeout'));

      final result = await repository.checkEmailRegistered('any@example.com');

      expect(result, isFalse);
    });

    test('passes email param', () async {
      stubRpcSuccess(mockClient, 'check_email_registered', true);

      await repository.checkEmailRegistered('test@example.com');

      final captured = verify(() => mockClient.rpc(
            'check_email_registered',
            params: captureAny(named: 'params'),
          )).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_email'], 'test@example.com');
    });
  });

  // ---------------------------------------------------------------------------
  // getBlockList
  // ---------------------------------------------------------------------------
  group('getBlockList', () {
    final rawBlockList = [
      {'blocked_user_id': 'user-2', 'blocked_username': 'badactor'},
      {'blocked_user_id': 'user-3', 'blocked_username': 'spammer'},
    ];

    test('returns block list on success', () async {
      stubRpcSuccess(mockClient, 'get_block_list', rawBlockList);

      final result = await repository.getBlockList('user-1');

      expect(result, hasLength(2));
      expect(result.first, isA<Map<String, dynamic>>());
      expect(result[0]['blocked_username'], 'badactor');
    });

    test('returns empty list when RPC returns empty list', () async {
      stubRpcSuccess(mockClient, 'get_block_list', <dynamic>[]);

      final result = await repository.getBlockList('user-1');

      expect(result, isEmpty);
    });

    test('returns empty list when RPC returns null', () async {
      stubRpcSuccess(mockClient, 'get_block_list', null);

      final result = await repository.getBlockList('user-1');

      expect(result, isEmpty);
    });

    test('returns empty list on exception', () async {
      stubRpcError(mockClient, 'get_block_list', Exception('DB error'));

      final result = await repository.getBlockList('user-1');

      expect(result, isEmpty);
    });

    test('passes userId param', () async {
      stubRpcSuccess(mockClient, 'get_block_list', rawBlockList);

      await repository.getBlockList('user-xyz');

      final captured = verify(() => mockClient.rpc(
            'get_block_list',
            params: captureAny(named: 'params'),
          )).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_user_id'], 'user-xyz');
    });
  });

  // ---------------------------------------------------------------------------
  // getFollowers
  // ---------------------------------------------------------------------------
  group('getFollowers', () {
    final rawFollowers = [
      {'follower_id': 'user-a', 'follower_username': 'alice'},
      {'follower_id': 'user-b', 'follower_username': 'bob'},
    ];

    test('returns followers list on success', () async {
      stubRpcSuccess(mockClient, 'get_followers', rawFollowers);

      final result = await repository.getFollowers('user-1');

      expect(result, hasLength(2));
      expect(result[0]['follower_username'], 'alice');
      expect(result[1]['follower_username'], 'bob');
    });

    test('returns empty list on exception', () async {
      stubRpcError(mockClient, 'get_followers', Exception('Server error'));

      final result = await repository.getFollowers('user-1');

      expect(result, isEmpty);
    });

    test('passes limit and offset params when provided', () async {
      stubRpcSuccess(mockClient, 'get_followers', rawFollowers);

      await repository.getFollowers('user-1', limit: 20, offset: 40);

      final captured = verify(() => mockClient.rpc(
            'get_followers',
            params: captureAny(named: 'params'),
          )).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_user_id'], 'user-1');
      expect(params['p_limit'], 20);
      expect(params['p_offset'], 40);
    });

    test('omits limit and offset when not provided', () async {
      stubRpcSuccess(mockClient, 'get_followers', rawFollowers);

      await repository.getFollowers('user-1');

      final captured = verify(() => mockClient.rpc(
            'get_followers',
            params: captureAny(named: 'params'),
          )).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params.containsKey('p_limit'), isFalse);
      expect(params.containsKey('p_offset'), isFalse);
    });
  });

  // ---------------------------------------------------------------------------
  // getFollowing
  // ---------------------------------------------------------------------------
  group('getFollowing', () {
    final rawFollowing = [
      {'following_id': 'user-c', 'following_username': 'charlie'},
    ];

    test('returns following list on success', () async {
      stubRpcSuccess(mockClient, 'get_following', rawFollowing);

      final result = await repository.getFollowing('user-1');

      expect(result, hasLength(1));
      expect(result[0]['following_username'], 'charlie');
    });

    test('returns empty list on exception', () async {
      stubRpcError(mockClient, 'get_following', Exception('DB error'));

      final result = await repository.getFollowing('user-1');

      expect(result, isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // getUserReviews
  // ---------------------------------------------------------------------------
  group('getUserReviews', () {
    final rawReviews = [
      {'review_id': 'rev-1', 'rating': 5, 'comment': 'Great seller!'},
      {'review_id': 'rev-2', 'rating': 4, 'comment': 'Good experience'},
    ];

    test('returns reviews list on success', () async {
      stubRpcSuccess(mockClient, 'get_user_reviews', rawReviews);

      final result = await repository.getUserReviews('user-1', 'seller');

      expect(result, hasLength(2));
      expect(result[0]['rating'], 5);
      expect(result[1]['comment'], 'Good experience');
    });

    test('returns empty list when RPC returns empty', () async {
      stubRpcSuccess(mockClient, 'get_user_reviews', <dynamic>[]);

      final result = await repository.getUserReviews('user-1', 'buyer');

      expect(result, isEmpty);
    });

    test('returns empty list on exception', () async {
      stubRpcError(mockClient, 'get_user_reviews', Exception('Timeout'));

      final result = await repository.getUserReviews('user-1', 'seller');

      expect(result, isEmpty);
    });

    test('passes role, limit, offset params', () async {
      stubRpcSuccess(mockClient, 'get_user_reviews', rawReviews);

      await repository.getUserReviews('user-1', 'seller',
          limit: 10, offset: 0);

      final captured = verify(() => mockClient.rpc(
            'get_user_reviews',
            params: captureAny(named: 'params'),
          )).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params['p_user_id'], 'user-1');
      expect(params['p_role'], 'seller');
      expect(params['p_limit'], 10);
      expect(params['p_offset'], 0);
    });
  });

  // ---------------------------------------------------------------------------
  // callRpc (generic helper)
  // ---------------------------------------------------------------------------
  group('callRpc', () {
    test('forwards call to supabase rpc and returns result', () async {
      stubRpcSuccess(mockClient, 'any_rpc_function', {'result': 42});

      final result = await repository.callRpc(
        'any_rpc_function',
        {'key': 'value'},
      );

      expect(result, isA<Map>());
      expect(result['result'], 42);
    });

    test('uses empty map when params is null', () async {
      stubRpcSuccess(mockClient, 'any_rpc_function', null);

      await repository.callRpc('any_rpc_function', null);

      final captured = verify(() => mockClient.rpc(
            'any_rpc_function',
            params: captureAny(named: 'params'),
          )).captured;

      final params = captured.last as Map<String, dynamic>;
      expect(params.isEmpty, isTrue);
    });
  });
}

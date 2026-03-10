/// Mock/fake helpers for Supabase-backed repository tests.
///
/// The repositories accept a [SupabaseClient] via constructor injection.
/// All repository methods use [SupabaseClient.rpc], which returns a
/// [PostgrestFilterBuilder<dynamic>] — an object that both implements
/// [Future<dynamic>] and provides the PostgREST query builder chain.
///
/// Strategy:
///  - [MockSupabaseClient] (mocktail) mocks the client.
///  - [FakePostgrestFilterBuilder] subclasses [PostgrestFilterBuilder] and
///    delegates all Future<dynamic> methods to an inner resolved [Future],
///    so `await client.rpc(...)` returns whatever value we configured.
///  - Helper functions [stubRpcSuccess] / [stubRpcError] keep test code clean.

import 'dart:async';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yet_another_json_isolate/yet_another_json_isolate.dart';

// ---------------------------------------------------------------------------
// Core mock
// ---------------------------------------------------------------------------

/// Mocktail mock for [SupabaseClient].
class MockSupabaseClient extends Mock implements SupabaseClient {}

// ---------------------------------------------------------------------------
// Fake PostgrestFilterBuilder
//
// Subclasses PostgrestFilterBuilder<dynamic> with a dummy QueryBuilder and
// overrides all Future<dynamic> methods to delegate to an inner Future.
// This lets `await mockClient.rpc(...)` resolve to whatever test data we want.
// ---------------------------------------------------------------------------

class FakePostgrestFilterBuilder extends PostgrestFilterBuilder<dynamic> {
  final Future<dynamic> _inner;

  FakePostgrestFilterBuilder(this._inner)
      : super(PostgrestQueryBuilder(
          url: Uri.parse('http://localhost'),
          headers: const {},
          schema: null,
          isolate: YAJsonIsolate(),
        ));

  @override
  Stream<dynamic> asStream() => _inner.asStream();

  @override
  Future<dynamic> catchError(
    Function onError, {
    bool Function(Object error)? test,
  }) =>
      _inner.catchError(onError, test: test);

  @override
  Future<R> then<R>(
    FutureOr<R> Function(dynamic value) onValue, {
    Function? onError,
  }) =>
      _inner.then(onValue, onError: onError);

  @override
  Future<dynamic> timeout(
    Duration timeLimit, {
    FutureOr<dynamic> Function()? onTimeout,
  }) =>
      _inner.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<dynamic> whenComplete(FutureOr<dynamic> Function() action) =>
      _inner.whenComplete(action);
}

// ---------------------------------------------------------------------------
// Convenience stub helpers
// ---------------------------------------------------------------------------

/// Stubs [MockSupabaseClient.rpc] for [rpcName] to resolve with [returnValue].
void stubRpcSuccess(
  MockSupabaseClient client,
  String rpcName,
  dynamic returnValue,
) {
  when(
    () => client.rpc(rpcName, params: any(named: 'params')),
  ).thenAnswer(
    (_) => FakePostgrestFilterBuilder(Future.value(returnValue)),
  );
}

/// Stubs [MockSupabaseClient.rpc] for [rpcName] to throw [error].
///
/// The error is delivered asynchronously (via a failed Future) so the
/// repository's try/catch blocks can handle it normally.
void stubRpcError(
  MockSupabaseClient client,
  String rpcName,
  Object error,
) {
  when(
    () => client.rpc(rpcName, params: any(named: 'params')),
  ).thenAnswer(
    (_) => FakePostgrestFilterBuilder(Future.error(error, StackTrace.empty)),
  );
}

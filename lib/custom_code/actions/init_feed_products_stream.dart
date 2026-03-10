import '/features/home/domain/models/feed_product_model.dart';
import '/features/home/presentation/providers/feed_provider.dart';
import '/features/home/data/repositories/product_repository.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

RealtimeChannel? _feedProductsSubscription;

Future<List<FeedProduct>> initFeedProductsStream(
  WidgetRef ref,
  String userId,
  List<String> excludeIds,
) async {
  final repository = ref.read(productRepositoryProvider);
  final data = await repository.getFeedProducts(userId, excludeIds);

  ref.read(feedProvider.notifier).setFeedProducts(data);

  _feedProductsSubscription?.unsubscribe();
  _feedProductsSubscription = repository.subscribeFeedProducts(() async {
    final freshData = await repository.getFeedProducts(
      userId,
      ref.read(feedProvider).swipedProductIds,
    );
    ref.read(feedProvider.notifier).setFeedProducts(freshData);
  });

  return data;
}

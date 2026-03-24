import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/features/home/domain/models/feed_product_model.dart';
import 'package:get_it/features/home/presentation/providers/feed_provider.dart';

FeedProduct _product(String id) => FeedProduct(id: id, title: 'P $id');

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  test('initial state has empty feedProducts and feedHasMore true', () {
    final state = container.read(feedProvider);
    expect(state.feedProducts, isEmpty);
    expect(state.feedHasMore, true);
    expect(state.swipedProductIds, isEmpty);
    expect(state.currentCardIndex, 0);
  });

  test('setFeedProducts replaces list', () {
    container
        .read(feedProvider.notifier)
        .setFeedProducts([_product('a'), _product('b')]);
    expect(container.read(feedProvider).feedProducts.length, 2);
  });

  test('addToFeedProducts appends', () {
    container.read(feedProvider.notifier).setFeedProducts([_product('a')]);
    container.read(feedProvider.notifier).addToFeedProducts(_product('b'));
    expect(container.read(feedProvider).feedProducts.length, 2);
    expect(container.read(feedProvider).feedProducts.last.id, 'b');
  });

  test('removeFromFeedProducts removes correct product', () {
    final p = _product('a');
    container
        .read(feedProvider.notifier)
        .setFeedProducts([p, _product('b')]);
    container.read(feedProvider.notifier).removeFromFeedProducts(p);
    expect(container.read(feedProvider).feedProducts.length, 1);
    expect(container.read(feedProvider).feedProducts.first.id, 'b');
  });

  test('removeAtIndexFromFeedProducts removes at correct index', () {
    container
        .read(feedProvider.notifier)
        .setFeedProducts([_product('a'), _product('b'), _product('c')]);
    container.read(feedProvider.notifier).removeAtIndexFromFeedProducts(1);
    final ids = container.read(feedProvider).feedProducts.map((p) => p.id);
    expect(ids, ['a', 'c']);
  });

  test('updateFeedProductsAtIndex applies transform without mutating original',
      () {
    container
        .read(feedProvider.notifier)
        .setFeedProducts([_product('a'), _product('b')]);
    container.read(feedProvider.notifier).updateFeedProductsAtIndex(
          0,
          (p) => p.copyWith(title: 'Updated'),
        );
    expect(container.read(feedProvider).feedProducts[0].title, 'Updated');
    expect(container.read(feedProvider).feedProducts[1].title, 'P b');
  });

  test('insertAtIndexInFeedProducts inserts at correct position', () {
    container
        .read(feedProvider.notifier)
        .setFeedProducts([_product('a'), _product('c')]);
    container
        .read(feedProvider.notifier)
        .insertAtIndexInFeedProducts(1, _product('b'));
    final ids = container.read(feedProvider).feedProducts.map((p) => p.id);
    expect(ids, ['a', 'b', 'c']);
  });

  test('setFeedHasMore updates only feedHasMore', () {
    container.read(feedProvider.notifier).setFeedHasMore(false);
    expect(container.read(feedProvider).feedHasMore, false);
  });

  test('addToSwipedProductIds accumulates ids across calls', () {
    container.read(feedProvider.notifier).addToSwipedProductIds('x');
    container.read(feedProvider.notifier).addToSwipedProductIds('y');
    expect(container.read(feedProvider).swipedProductIds, ['x', 'y']);
  });

  test('setSwipedProductIds replaces the list', () {
    container.read(feedProvider.notifier).addToSwipedProductIds('old');
    container.read(feedProvider.notifier).setSwipedProductIds(['a', 'b']);
    expect(container.read(feedProvider).swipedProductIds, ['a', 'b']);
  });

  test('setCurrentCardIndex updates only currentCardIndex', () {
    container.read(feedProvider.notifier).setCurrentCardIndex(5);
    expect(container.read(feedProvider).currentCardIndex, 5);
  });

  test('clear resets all fields to defaults', () {
    container
        .read(feedProvider.notifier)
        .setFeedProducts([_product('a')]);
    container.read(feedProvider.notifier).setFeedHasMore(false);
    container.read(feedProvider.notifier).addToSwipedProductIds('x');
    container.read(feedProvider.notifier).setCurrentCardIndex(3);

    container.read(feedProvider.notifier).clear();

    final state = container.read(feedProvider);
    expect(state.feedProducts, isEmpty);
    expect(state.feedHasMore, true);
    expect(state.swipedProductIds, isEmpty);
    expect(state.currentCardIndex, 0);
  });
}

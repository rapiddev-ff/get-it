import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/features/home/domain/models/product_details_model.dart';
import 'package:get_it/features/wishlist/presentation/providers/wishlist_provider.dart';

ProductDetails _product(String id) => ProductDetails(id: id, title: 'P $id');

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  test('initial state has empty products and isLoading true', () {
    final state = container.read(wishlistProvider);
    expect(state.products, isEmpty);
    expect(state.isLoading, true);
  });

  test('setProducts updates list and sets isLoading to false', () {
    container
        .read(wishlistProvider.notifier)
        .setProducts([_product('a'), _product('b')]);
    final state = container.read(wishlistProvider);
    expect(state.products.length, 2);
    expect(state.isLoading, false);
  });

  test('setLoading updates isLoading without changing products', () {
    container.read(wishlistProvider.notifier).setProducts([_product('a')]);
    container.read(wishlistProvider.notifier).setLoading(true);
    final state = container.read(wishlistProvider);
    expect(state.products.length, 1);
    expect(state.isLoading, true);
  });

  test('add appends product to list', () {
    container.read(wishlistProvider.notifier).setProducts([_product('a')]);
    container.read(wishlistProvider.notifier).add(_product('b'));
    expect(container.read(wishlistProvider).products.length, 2);
    expect(container.read(wishlistProvider).products.last.id, 'b');
  });

  test('removeById removes matching product and preserves others', () {
    container
        .read(wishlistProvider.notifier)
        .setProducts([_product('a'), _product('b'), _product('c')]);
    container.read(wishlistProvider.notifier).removeById('b');
    final ids = container.read(wishlistProvider).products.map((p) => p.id);
    expect(ids, ['a', 'c']);
  });

  test('removeById is no-op when id does not match', () {
    container.read(wishlistProvider.notifier).setProducts([_product('a')]);
    container.read(wishlistProvider.notifier).removeById('zzz');
    expect(container.read(wishlistProvider).products.length, 1);
  });

  test('remove calls removeById with product.id', () {
    container
        .read(wishlistProvider.notifier)
        .setProducts([_product('a'), _product('b')]);
    container.read(wishlistProvider.notifier).remove(_product('a'));
    expect(container.read(wishlistProvider).products.length, 1);
    expect(container.read(wishlistProvider).products.first.id, 'b');
  });

  test('removeAtIndex removes product at correct position', () {
    container
        .read(wishlistProvider.notifier)
        .setProducts([_product('a'), _product('b'), _product('c')]);
    container.read(wishlistProvider.notifier).removeAtIndex(1);
    final ids = container.read(wishlistProvider).products.map((p) => p.id);
    expect(ids, ['a', 'c']);
  });

  test('updateAtIndex applies transform function to correct element', () {
    container
        .read(wishlistProvider.notifier)
        .setProducts([_product('a'), _product('b')]);
    container
        .read(wishlistProvider.notifier)
        .updateAtIndex(1, (p) => p.copyWith(title: 'Updated'));
    expect(container.read(wishlistProvider).products[1].title, 'Updated');
    expect(container.read(wishlistProvider).products[0].title, 'P a');
  });

  test('insertAtIndex inserts at correct position', () {
    container
        .read(wishlistProvider.notifier)
        .setProducts([_product('a'), _product('c')]);
    container
        .read(wishlistProvider.notifier)
        .insertAtIndex(1, _product('b'));
    final ids = container.read(wishlistProvider).products.map((p) => p.id);
    expect(ids, ['a', 'b', 'c']);
  });

  test('clear resets to empty products and isLoading false', () {
    container
        .read(wishlistProvider.notifier)
        .setProducts([_product('a')]);
    container.read(wishlistProvider.notifier).clear();
    final state = container.read(wishlistProvider);
    expect(state.products, isEmpty);
    expect(state.isLoading, false);
  });
}

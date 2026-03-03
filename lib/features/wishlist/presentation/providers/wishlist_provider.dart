import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/home/domain/models/product_details_model.dart';

class WishlistNotifier extends Notifier<List<ProductDetails>> {
  @override
  List<ProductDetails> build() => [];

  void setProducts(List<ProductDetails> products) {
    state = products;
  }

  void add(ProductDetails product) {
    state = [...state, product];
  }

  void remove(ProductDetails product) {
    state = state.where((p) => p != product).toList();
  }

  void removeAtIndex(int index) {
    state = [...state]..removeAt(index);
  }

  void updateAtIndex(
    int index,
    ProductDetails Function(ProductDetails) updateFn,
  ) {
    final list = [...state];
    list[index] = updateFn(list[index]);
    state = list;
  }

  void insertAtIndex(int index, ProductDetails product) {
    state = [...state]..insert(index, product);
  }

  void clear() {
    state = [];
  }
}

final wishlistProvider =
    NotifierProvider<WishlistNotifier, List<ProductDetails>>(
  WishlistNotifier.new,
);

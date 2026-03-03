import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/backend/schema/structs/index.dart';

class WishlistNotifier extends Notifier<List<ProductDetailsStruct>> {
  @override
  List<ProductDetailsStruct> build() => [];

  void setProducts(List<ProductDetailsStruct> products) {
    state = products;
  }

  void add(ProductDetailsStruct product) {
    state = [...state, product];
  }

  void remove(ProductDetailsStruct product) {
    state = state.where((p) => p != product).toList();
  }

  void removeAtIndex(int index) {
    state = [...state]..removeAt(index);
  }

  void updateAtIndex(
    int index,
    ProductDetailsStruct Function(ProductDetailsStruct) updateFn,
  ) {
    final list = [...state];
    list[index] = updateFn(list[index]);
    state = list;
  }

  void insertAtIndex(int index, ProductDetailsStruct product) {
    state = [...state]..insert(index, product);
  }

  void clear() {
    state = [];
  }
}

final wishlistProvider =
    NotifierProvider<WishlistNotifier, List<ProductDetailsStruct>>(
  WishlistNotifier.new,
);

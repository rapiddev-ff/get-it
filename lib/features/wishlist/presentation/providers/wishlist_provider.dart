import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/home/domain/models/product_details_model.dart';

class WishlistState {
  final List<ProductDetails> products;
  final bool isLoading;

  const WishlistState({
    this.products = const [],
    this.isLoading = true,
  });

  WishlistState copyWith({
    List<ProductDetails>? products,
    bool? isLoading,
  }) {
    return WishlistState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class WishlistNotifier extends Notifier<WishlistState> {
  @override
  WishlistState build() => const WishlistState();

  void setProducts(List<ProductDetails> products) {
    state = state.copyWith(products: products, isLoading: false);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void add(ProductDetails product) {
    state = state.copyWith(products: [...state.products, product]);
  }

  void removeById(String productId) {
    state = state.copyWith(
      products: state.products.where((p) => p.id != productId).toList(),
    );
  }

  void remove(ProductDetails product) {
    removeById(product.id);
  }

  void removeAtIndex(int index) {
    state = state.copyWith(
      products: [...state.products]..removeAt(index),
    );
  }

  void updateAtIndex(
    int index,
    ProductDetails Function(ProductDetails) updateFn,
  ) {
    final list = [...state.products];
    list[index] = updateFn(list[index]);
    state = state.copyWith(products: list);
  }

  void insertAtIndex(int index, ProductDetails product) {
    state = state.copyWith(
      products: [...state.products]..insert(index, product),
    );
  }

  void clear() {
    state = const WishlistState(products: [], isLoading: false);
  }
}

final wishlistProvider = NotifierProvider<WishlistNotifier, WishlistState>(
  WishlistNotifier.new,
);

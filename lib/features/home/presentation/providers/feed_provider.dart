import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/backend/schema/structs/index.dart';

class FeedState {
  FeedState({
    this.feedProducts = const [],
    this.feedHasMore = true,
    this.swipedProductIds = const [],
    this.currentCardIndex = 0,
  });

  final List<FeedProductStruct> feedProducts;
  final bool feedHasMore;
  final List<String> swipedProductIds;
  final int currentCardIndex;

  FeedState copyWith({
    List<FeedProductStruct>? feedProducts,
    bool? feedHasMore,
    List<String>? swipedProductIds,
    int? currentCardIndex,
  }) {
    return FeedState(
      feedProducts: feedProducts ?? this.feedProducts,
      feedHasMore: feedHasMore ?? this.feedHasMore,
      swipedProductIds: swipedProductIds ?? this.swipedProductIds,
      currentCardIndex: currentCardIndex ?? this.currentCardIndex,
    );
  }
}

class FeedNotifier extends Notifier<FeedState> {
  @override
  FeedState build() => FeedState();

  void setFeedProducts(List<FeedProductStruct> products) {
    state = state.copyWith(feedProducts: products);
  }

  void addToFeedProducts(FeedProductStruct product) {
    state = state.copyWith(
      feedProducts: [...state.feedProducts, product],
    );
  }

  void removeFromFeedProducts(FeedProductStruct product) {
    state = state.copyWith(
      feedProducts: state.feedProducts.where((p) => p != product).toList(),
    );
  }

  void removeAtIndexFromFeedProducts(int index) {
    final list = [...state.feedProducts]..removeAt(index);
    state = state.copyWith(feedProducts: list);
  }

  void updateFeedProductsAtIndex(
    int index,
    FeedProductStruct Function(FeedProductStruct) updateFn,
  ) {
    final list = [...state.feedProducts];
    list[index] = updateFn(list[index]);
    state = state.copyWith(feedProducts: list);
  }

  void insertAtIndexInFeedProducts(int index, FeedProductStruct product) {
    final list = [...state.feedProducts]..insert(index, product);
    state = state.copyWith(feedProducts: list);
  }

  void setFeedHasMore(bool value) {
    state = state.copyWith(feedHasMore: value);
  }

  void setSwipedProductIds(List<String> ids) {
    state = state.copyWith(swipedProductIds: ids);
  }

  void addToSwipedProductIds(String id) {
    state = state.copyWith(
      swipedProductIds: [...state.swipedProductIds, id],
    );
  }

  void setCurrentCardIndex(int index) {
    state = state.copyWith(currentCardIndex: index);
  }

  void clear() {
    state = FeedState();
  }
}

final feedProvider = NotifierProvider<FeedNotifier, FeedState>(
  FeedNotifier.new,
);

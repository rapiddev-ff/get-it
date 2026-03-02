import 'package:flutter/material.dart';
import '/backend/schema/structs/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    secureStorage = FlutterSecureStorage();
    await _safeInitAsync(() async {
      _keepSignedIn =
          await secureStorage.getBool('ff_keepSignedIn') ?? _keepSignedIn;
    });
    await _safeInitAsync(() async {
      _isHomeViewed =
          await secureStorage.getBool('ff_isHomeViewed') ?? _isHomeViewed;
    });
    await _safeInitAsync(() async {
      _categories = (await secureStorage.getStringList('ff_categories'))
              ?.map((x) {
                try {
                  return CategoryStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _categories;
    });
    await _safeInitAsync(() async {
      _conditions = (await secureStorage.getStringList('ff_conditions'))
              ?.map((x) {
                try {
                  return ConditionStruct.fromSerializableMap(jsonDecode(x));
                } catch (e) {
                  print("Can't decode persisted data type. Error: $e.");
                  return null;
                }
              })
              .withoutNulls
              .toList() ??
          _conditions;
    });
    await _safeInitAsync(() async {
      _isPasswordRecovery =
          await secureStorage.getBool('ff_isPasswordRecovery') ??
              _isPasswordRecovery;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late FlutterSecureStorage secureStorage;

  bool _keepSignedIn = false;
  bool get keepSignedIn => _keepSignedIn;
  set keepSignedIn(bool value) {
    _keepSignedIn = value;
    secureStorage.setBool('ff_keepSignedIn', value);
  }

  void deleteKeepSignedIn() {
    secureStorage.delete(key: 'ff_keepSignedIn');
  }

  bool _isHomeViewed = false;
  bool get isHomeViewed => _isHomeViewed;
  set isHomeViewed(bool value) {
    _isHomeViewed = value;
    secureStorage.setBool('ff_isHomeViewed', value);
  }

  void deleteIsHomeViewed() {
    secureStorage.delete(key: 'ff_isHomeViewed');
  }

  UserDataStruct _userData = UserDataStruct();
  UserDataStruct get userData => _userData;
  set userData(UserDataStruct value) {
    _userData = value;
  }

  void updateUserDataStruct(Function(UserDataStruct) updateFn) {
    updateFn(_userData);
  }

  List<FeedProductStruct> _feedProducts = [];
  List<FeedProductStruct> get feedProducts => _feedProducts;
  set feedProducts(List<FeedProductStruct> value) {
    _feedProducts = value;
  }

  void addToFeedProducts(FeedProductStruct value) {
    feedProducts.add(value);
  }

  void removeFromFeedProducts(FeedProductStruct value) {
    feedProducts.remove(value);
  }

  void removeAtIndexFromFeedProducts(int index) {
    feedProducts.removeAt(index);
  }

  void updateFeedProductsAtIndex(
    int index,
    FeedProductStruct Function(FeedProductStruct) updateFn,
  ) {
    feedProducts[index] = updateFn(_feedProducts[index]);
  }

  void insertAtIndexInFeedProducts(int index, FeedProductStruct value) {
    feedProducts.insert(index, value);
  }

  List<ProductDetailsStruct> _wishlistProducts = [];
  List<ProductDetailsStruct> get wishlistProducts => _wishlistProducts;
  set wishlistProducts(List<ProductDetailsStruct> value) {
    _wishlistProducts = value;
  }

  void addToWishlistProducts(ProductDetailsStruct value) {
    wishlistProducts.add(value);
  }

  void removeFromWishlistProducts(ProductDetailsStruct value) {
    wishlistProducts.remove(value);
  }

  void removeAtIndexFromWishlistProducts(int index) {
    wishlistProducts.removeAt(index);
  }

  void updateWishlistProductsAtIndex(
    int index,
    ProductDetailsStruct Function(ProductDetailsStruct) updateFn,
  ) {
    wishlistProducts[index] = updateFn(_wishlistProducts[index]);
  }

  void insertAtIndexInWishlistProducts(int index, ProductDetailsStruct value) {
    wishlistProducts.insert(index, value);
  }

  List<CategoryStruct> _categories = [];
  List<CategoryStruct> get categories => _categories;
  set categories(List<CategoryStruct> value) {
    _categories = value;
    secureStorage.setStringList(
        'ff_categories', value.map((x) => x.serialize()).toList());
  }

  void deleteCategories() {
    secureStorage.delete(key: 'ff_categories');
  }

  void addToCategories(CategoryStruct value) {
    categories.add(value);
    secureStorage.setStringList(
        'ff_categories', _categories.map((x) => x.serialize()).toList());
  }

  void removeFromCategories(CategoryStruct value) {
    categories.remove(value);
    secureStorage.setStringList(
        'ff_categories', _categories.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromCategories(int index) {
    categories.removeAt(index);
    secureStorage.setStringList(
        'ff_categories', _categories.map((x) => x.serialize()).toList());
  }

  void updateCategoriesAtIndex(
    int index,
    CategoryStruct Function(CategoryStruct) updateFn,
  ) {
    categories[index] = updateFn(_categories[index]);
    secureStorage.setStringList(
        'ff_categories', _categories.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInCategories(int index, CategoryStruct value) {
    categories.insert(index, value);
    secureStorage.setStringList(
        'ff_categories', _categories.map((x) => x.serialize()).toList());
  }

  List<ConditionStruct> _conditions = [];
  List<ConditionStruct> get conditions => _conditions;
  set conditions(List<ConditionStruct> value) {
    _conditions = value;
    secureStorage.setStringList(
        'ff_conditions', value.map((x) => x.serialize()).toList());
  }

  void deleteConditions() {
    secureStorage.delete(key: 'ff_conditions');
  }

  void addToConditions(ConditionStruct value) {
    conditions.add(value);
    secureStorage.setStringList(
        'ff_conditions', _conditions.map((x) => x.serialize()).toList());
  }

  void removeFromConditions(ConditionStruct value) {
    conditions.remove(value);
    secureStorage.setStringList(
        'ff_conditions', _conditions.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromConditions(int index) {
    conditions.removeAt(index);
    secureStorage.setStringList(
        'ff_conditions', _conditions.map((x) => x.serialize()).toList());
  }

  void updateConditionsAtIndex(
    int index,
    ConditionStruct Function(ConditionStruct) updateFn,
  ) {
    conditions[index] = updateFn(_conditions[index]);
    secureStorage.setStringList(
        'ff_conditions', _conditions.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInConditions(int index, ConditionStruct value) {
    conditions.insert(index, value);
    secureStorage.setStringList(
        'ff_conditions', _conditions.map((x) => x.serialize()).toList());
  }

  bool _feedHasMore = true;
  bool get feedHasMore => _feedHasMore;
  set feedHasMore(bool value) {
    _feedHasMore = value;
  }

  List<String> _swipedProductIds = [];
  List<String> get swipedProductIds => _swipedProductIds;
  set swipedProductIds(List<String> value) {
    _swipedProductIds = value;
  }

  void addToSwipedProductIds(String value) {
    swipedProductIds.add(value);
  }

  void removeFromSwipedProductIds(String value) {
    swipedProductIds.remove(value);
  }

  void removeAtIndexFromSwipedProductIds(int index) {
    swipedProductIds.removeAt(index);
  }

  void updateSwipedProductIdsAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    swipedProductIds[index] = updateFn(_swipedProductIds[index]);
  }

  void insertAtIndexInSwipedProductIds(int index, String value) {
    swipedProductIds.insert(index, value);
  }

  int _currentCardIndex = 0;
  int get currentCardIndex => _currentCardIndex;
  set currentCardIndex(int value) {
    _currentCardIndex = value;
  }

  bool _isPasswordRecovery = false;
  bool get isPasswordRecovery => _isPasswordRecovery;
  set isPasswordRecovery(bool value) {
    _isPasswordRecovery = value;
    secureStorage.setBool('ff_isPasswordRecovery', value);
  }

  void deleteIsPasswordRecovery() {
    secureStorage.delete(key: 'ff_isPasswordRecovery');
  }

  List<ConversationStruct> _conversations = [];
  List<ConversationStruct> get conversations => _conversations;
  set conversations(List<ConversationStruct> value) {
    _conversations = value;
  }

  void addToConversations(ConversationStruct value) {
    conversations.add(value);
  }

  void removeFromConversations(ConversationStruct value) {
    conversations.remove(value);
  }

  void removeAtIndexFromConversations(int index) {
    conversations.removeAt(index);
  }

  void updateConversationsAtIndex(
    int index,
    ConversationStruct Function(ConversationStruct) updateFn,
  ) {
    conversations[index] = updateFn(_conversations[index]);
  }

  void insertAtIndexInConversations(int index, ConversationStruct value) {
    conversations.insert(index, value);
  }

  List<MessageStruct> _currentChatMessages = [];
  List<MessageStruct> get currentChatMessages => _currentChatMessages;
  set currentChatMessages(List<MessageStruct> value) {
    _currentChatMessages = value;
  }

  void addToCurrentChatMessages(MessageStruct value) {
    currentChatMessages.add(value);
  }

  void removeFromCurrentChatMessages(MessageStruct value) {
    currentChatMessages.remove(value);
  }

  void removeAtIndexFromCurrentChatMessages(int index) {
    currentChatMessages.removeAt(index);
  }

  void updateCurrentChatMessagesAtIndex(
    int index,
    MessageStruct Function(MessageStruct) updateFn,
  ) {
    currentChatMessages[index] = updateFn(_currentChatMessages[index]);
  }

  void insertAtIndexInCurrentChatMessages(int index, MessageStruct value) {
    currentChatMessages.insert(index, value);
  }

  ConversationStruct _currentConversation = ConversationStruct();
  ConversationStruct get currentConversation => _currentConversation;
  set currentConversation(ConversationStruct value) {
    _currentConversation = value;
  }

  void updateCurrentConversationStruct(Function(ConversationStruct) updateFn) {
    updateFn(_currentConversation);
  }

  int _activeTabIndex = 0;
  int get activeTabIndex => _activeTabIndex;
  set activeTabIndex(int value) {
    _activeTabIndex = value;
  }

  int _totalUnreadCount = 0;
  int get totalUnreadCount => _totalUnreadCount;
  set totalUnreadCount(int value) {
    _totalUnreadCount = value;
  }

  List<TagStruct> _choosenTags = [];
  List<TagStruct> get choosenTags => _choosenTags;
  set choosenTags(List<TagStruct> value) {
    _choosenTags = value;
  }

  void addToChoosenTags(TagStruct value) {
    choosenTags.add(value);
  }

  void removeFromChoosenTags(TagStruct value) {
    choosenTags.remove(value);
  }

  void removeAtIndexFromChoosenTags(int index) {
    choosenTags.removeAt(index);
  }

  void updateChoosenTagsAtIndex(
    int index,
    TagStruct Function(TagStruct) updateFn,
  ) {
    choosenTags[index] = updateFn(_choosenTags[index]);
  }

  void insertAtIndexInChoosenTags(int index, TagStruct value) {
    choosenTags.insert(index, value);
  }

  PaymentMethodStruct _choosenPaymentMethod = PaymentMethodStruct();
  PaymentMethodStruct get choosenPaymentMethod => _choosenPaymentMethod;
  set choosenPaymentMethod(PaymentMethodStruct value) {
    _choosenPaymentMethod = value;
  }

  void updateChoosenPaymentMethodStruct(
      Function(PaymentMethodStruct) updateFn) {
    updateFn(_choosenPaymentMethod);
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}

extension FlutterSecureStorageExtensions on FlutterSecureStorage {
  static final _lock = Lock();

  Future<void> writeSync({required String key, String? value}) async =>
      await _lock.synchronized(() async {
        await write(key: key, value: value);
      });

  void remove(String key) => delete(key: key);

  Future<String?> getString(String key) async => await read(key: key);
  Future<void> setString(String key, String value) async =>
      await writeSync(key: key, value: value);

  Future<bool?> getBool(String key) async => (await read(key: key)) == 'true';
  Future<void> setBool(String key, bool value) async =>
      await writeSync(key: key, value: value.toString());

  Future<int?> getInt(String key) async =>
      int.tryParse(await read(key: key) ?? '');
  Future<void> setInt(String key, int value) async =>
      await writeSync(key: key, value: value.toString());

  Future<double?> getDouble(String key) async =>
      double.tryParse(await read(key: key) ?? '');
  Future<void> setDouble(String key, double value) async =>
      await writeSync(key: key, value: value.toString());

  Future<List<String>?> getStringList(String key) async =>
      await read(key: key).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return CsvToListConverter()
            .convert(result)
            .first
            .map((e) => e.toString())
            .toList();
      });
  Future<void> setStringList(String key, List<String> value) async =>
      await writeSync(key: key, value: ListToCsvConverter().convert([value]));
}

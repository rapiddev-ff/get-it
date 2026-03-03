import 'package:flutter/material.dart';
import '/features/auth/domain/models/user_model.dart';
import '/features/home/domain/models/feed_product_model.dart';
import '/features/home/domain/models/product_details_model.dart';
import '/features/browse/domain/models/category_model.dart';
import '/features/browse/domain/models/condition_model.dart';
import '/features/browse/domain/models/tag_model.dart';
import '/features/messages/domain/models/conversation_model.dart';
import '/features/messages/domain/models/message_model.dart';
import '/features/checkout/domain/models/payment_method_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:csv/csv.dart';
import 'package:synchronized/synchronized.dart';
import '/core/utils/json_utils.dart';
import 'dart:convert' show jsonDecode;

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
                  return Category.fromSerializableMap(jsonDecode(x));
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
                  return Condition.fromSerializableMap(jsonDecode(x));
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

  UserData _userData = const UserData();
  UserData get userData => _userData;
  set userData(UserData value) {
    _userData = value;
  }

  void updateUserDataStruct(UserData Function(UserData) updateFn) {
    _userData = updateFn(_userData);
  }

  List<FeedProduct> _feedProducts = [];
  List<FeedProduct> get feedProducts => _feedProducts;
  set feedProducts(List<FeedProduct> value) {
    _feedProducts = value;
  }

  void addToFeedProducts(FeedProduct value) {
    feedProducts.add(value);
  }

  void removeFromFeedProducts(FeedProduct value) {
    feedProducts.remove(value);
  }

  void removeAtIndexFromFeedProducts(int index) {
    feedProducts.removeAt(index);
  }

  void updateFeedProductsAtIndex(
    int index,
    FeedProduct Function(FeedProduct) updateFn,
  ) {
    feedProducts[index] = updateFn(_feedProducts[index]);
  }

  void insertAtIndexInFeedProducts(int index, FeedProduct value) {
    feedProducts.insert(index, value);
  }

  List<ProductDetails> _wishlistProducts = [];
  List<ProductDetails> get wishlistProducts => _wishlistProducts;
  set wishlistProducts(List<ProductDetails> value) {
    _wishlistProducts = value;
  }

  void addToWishlistProducts(ProductDetails value) {
    wishlistProducts.add(value);
  }

  void removeFromWishlistProducts(ProductDetails value) {
    wishlistProducts.remove(value);
  }

  void removeAtIndexFromWishlistProducts(int index) {
    wishlistProducts.removeAt(index);
  }

  void updateWishlistProductsAtIndex(
    int index,
    ProductDetails Function(ProductDetails) updateFn,
  ) {
    wishlistProducts[index] = updateFn(_wishlistProducts[index]);
  }

  void insertAtIndexInWishlistProducts(int index, ProductDetails value) {
    wishlistProducts.insert(index, value);
  }

  List<Category> _categories = [];
  List<Category> get categories => _categories;
  set categories(List<Category> value) {
    _categories = value;
    secureStorage.setStringList(
        'ff_categories', value.map((x) => x.serialize()).toList());
  }

  void deleteCategories() {
    secureStorage.delete(key: 'ff_categories');
  }

  void addToCategories(Category value) {
    categories.add(value);
    secureStorage.setStringList(
        'ff_categories', _categories.map((x) => x.serialize()).toList());
  }

  void removeFromCategories(Category value) {
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
    Category Function(Category) updateFn,
  ) {
    categories[index] = updateFn(_categories[index]);
    secureStorage.setStringList(
        'ff_categories', _categories.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInCategories(int index, Category value) {
    categories.insert(index, value);
    secureStorage.setStringList(
        'ff_categories', _categories.map((x) => x.serialize()).toList());
  }

  List<Condition> _conditions = [];
  List<Condition> get conditions => _conditions;
  set conditions(List<Condition> value) {
    _conditions = value;
    secureStorage.setStringList(
        'ff_conditions', value.map((x) => x.serialize()).toList());
  }

  void deleteConditions() {
    secureStorage.delete(key: 'ff_conditions');
  }

  void addToConditions(Condition value) {
    conditions.add(value);
    secureStorage.setStringList(
        'ff_conditions', _conditions.map((x) => x.serialize()).toList());
  }

  void removeFromConditions(Condition value) {
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
    Condition Function(Condition) updateFn,
  ) {
    conditions[index] = updateFn(_conditions[index]);
    secureStorage.setStringList(
        'ff_conditions', _conditions.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInConditions(int index, Condition value) {
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

  List<Conversation> _conversations = [];
  List<Conversation> get conversations => _conversations;
  set conversations(List<Conversation> value) {
    _conversations = value;
  }

  void addToConversations(Conversation value) {
    conversations.add(value);
  }

  void removeFromConversations(Conversation value) {
    conversations.remove(value);
  }

  void removeAtIndexFromConversations(int index) {
    conversations.removeAt(index);
  }

  void updateConversationsAtIndex(
    int index,
    Conversation Function(Conversation) updateFn,
  ) {
    conversations[index] = updateFn(_conversations[index]);
  }

  void insertAtIndexInConversations(int index, Conversation value) {
    conversations.insert(index, value);
  }

  List<Message> _currentChatMessages = [];
  List<Message> get currentChatMessages => _currentChatMessages;
  set currentChatMessages(List<Message> value) {
    _currentChatMessages = value;
  }

  void addToCurrentChatMessages(Message value) {
    currentChatMessages.add(value);
  }

  void removeFromCurrentChatMessages(Message value) {
    currentChatMessages.remove(value);
  }

  void removeAtIndexFromCurrentChatMessages(int index) {
    currentChatMessages.removeAt(index);
  }

  void updateCurrentChatMessagesAtIndex(
    int index,
    Message Function(Message) updateFn,
  ) {
    currentChatMessages[index] = updateFn(_currentChatMessages[index]);
  }

  void insertAtIndexInCurrentChatMessages(int index, Message value) {
    currentChatMessages.insert(index, value);
  }

  Conversation _currentConversation = const Conversation();
  Conversation get currentConversation => _currentConversation;
  set currentConversation(Conversation value) {
    _currentConversation = value;
  }

  void updateCurrentConversationStruct(Conversation Function(Conversation) updateFn) {
    _currentConversation = updateFn(_currentConversation);
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

  List<Tag> _choosenTags = [];
  List<Tag> get choosenTags => _choosenTags;
  set choosenTags(List<Tag> value) {
    _choosenTags = value;
  }

  void addToChoosenTags(Tag value) {
    choosenTags.add(value);
  }

  void removeFromChoosenTags(Tag value) {
    choosenTags.remove(value);
  }

  void removeAtIndexFromChoosenTags(int index) {
    choosenTags.removeAt(index);
  }

  void updateChoosenTagsAtIndex(
    int index,
    Tag Function(Tag) updateFn,
  ) {
    choosenTags[index] = updateFn(_choosenTags[index]);
  }

  void insertAtIndexInChoosenTags(int index, Tag value) {
    choosenTags.insert(index, value);
  }

  PaymentMethod _choosenPaymentMethod = const PaymentMethod();
  PaymentMethod get choosenPaymentMethod => _choosenPaymentMethod;
  set choosenPaymentMethod(PaymentMethod value) {
    _choosenPaymentMethod = value;
  }

  void updateChoosenPaymentMethodStruct(
      PaymentMethod Function(PaymentMethod) updateFn) {
    _choosenPaymentMethod = updateFn(_choosenPaymentMethod);
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

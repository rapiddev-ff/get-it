// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ConversationStruct extends BaseStruct {
  ConversationStruct({
    String? id,
    String? buyerId,
    String? sellerId,
    String? productId,
    String? lastMessageText,
    DateTime? lastMessageAt,
    int? buyerUnreadCount,
    int? sellerUnreadCount,
    String? otherUserUsername,
    String? otherUserAvatar,
    String? otherUserId,
    String? productTitle,
    String? productImage,
    double? productPrice,
    DateTime? otherUserLastActive,
    String? productCondition,
    String? role,
  })  : _id = id,
        _buyerId = buyerId,
        _sellerId = sellerId,
        _productId = productId,
        _lastMessageText = lastMessageText,
        _lastMessageAt = lastMessageAt,
        _buyerUnreadCount = buyerUnreadCount,
        _sellerUnreadCount = sellerUnreadCount,
        _otherUserUsername = otherUserUsername,
        _otherUserAvatar = otherUserAvatar,
        _otherUserId = otherUserId,
        _productTitle = productTitle,
        _productImage = productImage,
        _productPrice = productPrice,
        _otherUserLastActive = otherUserLastActive,
        _productCondition = productCondition,
        _role = role;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "buyerId" field.
  String? _buyerId;
  String get buyerId => _buyerId ?? '';
  set buyerId(String? val) => _buyerId = val;

  bool hasBuyerId() => _buyerId != null;

  // "sellerId" field.
  String? _sellerId;
  String get sellerId => _sellerId ?? '';
  set sellerId(String? val) => _sellerId = val;

  bool hasSellerId() => _sellerId != null;

  // "productId" field.
  String? _productId;
  String get productId => _productId ?? '';
  set productId(String? val) => _productId = val;

  bool hasProductId() => _productId != null;

  // "lastMessageText" field.
  String? _lastMessageText;
  String get lastMessageText => _lastMessageText ?? '';
  set lastMessageText(String? val) => _lastMessageText = val;

  bool hasLastMessageText() => _lastMessageText != null;

  // "lastMessageAt" field.
  DateTime? _lastMessageAt;
  DateTime? get lastMessageAt => _lastMessageAt;
  set lastMessageAt(DateTime? val) => _lastMessageAt = val;

  bool hasLastMessageAt() => _lastMessageAt != null;

  // "buyerUnreadCount" field.
  int? _buyerUnreadCount;
  int get buyerUnreadCount => _buyerUnreadCount ?? 0;
  set buyerUnreadCount(int? val) => _buyerUnreadCount = val;

  void incrementBuyerUnreadCount(int amount) =>
      buyerUnreadCount = buyerUnreadCount + amount;

  bool hasBuyerUnreadCount() => _buyerUnreadCount != null;

  // "sellerUnreadCount" field.
  int? _sellerUnreadCount;
  int get sellerUnreadCount => _sellerUnreadCount ?? 0;
  set sellerUnreadCount(int? val) => _sellerUnreadCount = val;

  void incrementSellerUnreadCount(int amount) =>
      sellerUnreadCount = sellerUnreadCount + amount;

  bool hasSellerUnreadCount() => _sellerUnreadCount != null;

  // "otherUserUsername" field.
  String? _otherUserUsername;
  String get otherUserUsername => _otherUserUsername ?? '';
  set otherUserUsername(String? val) => _otherUserUsername = val;

  bool hasOtherUserUsername() => _otherUserUsername != null;

  // "otherUserAvatar" field.
  String? _otherUserAvatar;
  String get otherUserAvatar => _otherUserAvatar ?? '';
  set otherUserAvatar(String? val) => _otherUserAvatar = val;

  bool hasOtherUserAvatar() => _otherUserAvatar != null;

  // "otherUserId" field.
  String? _otherUserId;
  String get otherUserId => _otherUserId ?? '';
  set otherUserId(String? val) => _otherUserId = val;

  bool hasOtherUserId() => _otherUserId != null;

  // "productTitle" field.
  String? _productTitle;
  String get productTitle => _productTitle ?? '';
  set productTitle(String? val) => _productTitle = val;

  bool hasProductTitle() => _productTitle != null;

  // "productImage" field.
  String? _productImage;
  String get productImage => _productImage ?? '';
  set productImage(String? val) => _productImage = val;

  bool hasProductImage() => _productImage != null;

  // "productPrice" field.
  double? _productPrice;
  double get productPrice => _productPrice ?? 0.0;
  set productPrice(double? val) => _productPrice = val;

  void incrementProductPrice(double amount) =>
      productPrice = productPrice + amount;

  bool hasProductPrice() => _productPrice != null;

  // "otherUserLastActive" field.
  DateTime? _otherUserLastActive;
  DateTime? get otherUserLastActive => _otherUserLastActive;
  set otherUserLastActive(DateTime? val) => _otherUserLastActive = val;

  bool hasOtherUserLastActive() => _otherUserLastActive != null;

  // "productCondition" field.
  String? _productCondition;
  String get productCondition => _productCondition ?? '';
  set productCondition(String? val) => _productCondition = val;

  bool hasProductCondition() => _productCondition != null;

  // "role" field.
  String? _role;
  String get role => _role ?? '';
  set role(String? val) => _role = val;

  bool hasRole() => _role != null;

  static ConversationStruct fromMap(Map<String, dynamic> data) =>
      ConversationStruct(
        id: data['id'] as String?,
        buyerId: data['buyerId'] as String?,
        sellerId: data['sellerId'] as String?,
        productId: data['productId'] as String?,
        lastMessageText: data['lastMessageText'] as String?,
        lastMessageAt: data['lastMessageAt'] as DateTime?,
        buyerUnreadCount: castToType<int>(data['buyerUnreadCount']),
        sellerUnreadCount: castToType<int>(data['sellerUnreadCount']),
        otherUserUsername: data['otherUserUsername'] as String?,
        otherUserAvatar: data['otherUserAvatar'] as String?,
        otherUserId: data['otherUserId'] as String?,
        productTitle: data['productTitle'] as String?,
        productImage: data['productImage'] as String?,
        productPrice: castToType<double>(data['productPrice']),
        otherUserLastActive: data['otherUserLastActive'] as DateTime?,
        productCondition: data['productCondition'] as String?,
        role: data['role'] as String?,
      );

  static ConversationStruct? maybeFromMap(dynamic data) => data is Map
      ? ConversationStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'buyerId': _buyerId,
        'sellerId': _sellerId,
        'productId': _productId,
        'lastMessageText': _lastMessageText,
        'lastMessageAt': _lastMessageAt,
        'buyerUnreadCount': _buyerUnreadCount,
        'sellerUnreadCount': _sellerUnreadCount,
        'otherUserUsername': _otherUserUsername,
        'otherUserAvatar': _otherUserAvatar,
        'otherUserId': _otherUserId,
        'productTitle': _productTitle,
        'productImage': _productImage,
        'productPrice': _productPrice,
        'otherUserLastActive': _otherUserLastActive,
        'productCondition': _productCondition,
        'role': _role,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'buyerId': serializeParam(
          _buyerId,
          ParamType.String,
        ),
        'sellerId': serializeParam(
          _sellerId,
          ParamType.String,
        ),
        'productId': serializeParam(
          _productId,
          ParamType.String,
        ),
        'lastMessageText': serializeParam(
          _lastMessageText,
          ParamType.String,
        ),
        'lastMessageAt': serializeParam(
          _lastMessageAt,
          ParamType.DateTime,
        ),
        'buyerUnreadCount': serializeParam(
          _buyerUnreadCount,
          ParamType.int,
        ),
        'sellerUnreadCount': serializeParam(
          _sellerUnreadCount,
          ParamType.int,
        ),
        'otherUserUsername': serializeParam(
          _otherUserUsername,
          ParamType.String,
        ),
        'otherUserAvatar': serializeParam(
          _otherUserAvatar,
          ParamType.String,
        ),
        'otherUserId': serializeParam(
          _otherUserId,
          ParamType.String,
        ),
        'productTitle': serializeParam(
          _productTitle,
          ParamType.String,
        ),
        'productImage': serializeParam(
          _productImage,
          ParamType.String,
        ),
        'productPrice': serializeParam(
          _productPrice,
          ParamType.double,
        ),
        'otherUserLastActive': serializeParam(
          _otherUserLastActive,
          ParamType.DateTime,
        ),
        'productCondition': serializeParam(
          _productCondition,
          ParamType.String,
        ),
        'role': serializeParam(
          _role,
          ParamType.String,
        ),
      }.withoutNulls;

  static ConversationStruct fromSerializableMap(Map<String, dynamic> data) =>
      ConversationStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        buyerId: deserializeParam(
          data['buyerId'],
          ParamType.String,
          false,
        ),
        sellerId: deserializeParam(
          data['sellerId'],
          ParamType.String,
          false,
        ),
        productId: deserializeParam(
          data['productId'],
          ParamType.String,
          false,
        ),
        lastMessageText: deserializeParam(
          data['lastMessageText'],
          ParamType.String,
          false,
        ),
        lastMessageAt: deserializeParam(
          data['lastMessageAt'],
          ParamType.DateTime,
          false,
        ),
        buyerUnreadCount: deserializeParam(
          data['buyerUnreadCount'],
          ParamType.int,
          false,
        ),
        sellerUnreadCount: deserializeParam(
          data['sellerUnreadCount'],
          ParamType.int,
          false,
        ),
        otherUserUsername: deserializeParam(
          data['otherUserUsername'],
          ParamType.String,
          false,
        ),
        otherUserAvatar: deserializeParam(
          data['otherUserAvatar'],
          ParamType.String,
          false,
        ),
        otherUserId: deserializeParam(
          data['otherUserId'],
          ParamType.String,
          false,
        ),
        productTitle: deserializeParam(
          data['productTitle'],
          ParamType.String,
          false,
        ),
        productImage: deserializeParam(
          data['productImage'],
          ParamType.String,
          false,
        ),
        productPrice: deserializeParam(
          data['productPrice'],
          ParamType.double,
          false,
        ),
        otherUserLastActive: deserializeParam(
          data['otherUserLastActive'],
          ParamType.DateTime,
          false,
        ),
        productCondition: deserializeParam(
          data['productCondition'],
          ParamType.String,
          false,
        ),
        role: deserializeParam(
          data['role'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ConversationStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ConversationStruct &&
        id == other.id &&
        buyerId == other.buyerId &&
        sellerId == other.sellerId &&
        productId == other.productId &&
        lastMessageText == other.lastMessageText &&
        lastMessageAt == other.lastMessageAt &&
        buyerUnreadCount == other.buyerUnreadCount &&
        sellerUnreadCount == other.sellerUnreadCount &&
        otherUserUsername == other.otherUserUsername &&
        otherUserAvatar == other.otherUserAvatar &&
        otherUserId == other.otherUserId &&
        productTitle == other.productTitle &&
        productImage == other.productImage &&
        productPrice == other.productPrice &&
        otherUserLastActive == other.otherUserLastActive &&
        productCondition == other.productCondition &&
        role == other.role;
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        buyerId,
        sellerId,
        productId,
        lastMessageText,
        lastMessageAt,
        buyerUnreadCount,
        sellerUnreadCount,
        otherUserUsername,
        otherUserAvatar,
        otherUserId,
        productTitle,
        productImage,
        productPrice,
        otherUserLastActive,
        productCondition,
        role
      ]);
}

ConversationStruct createConversationStruct({
  String? id,
  String? buyerId,
  String? sellerId,
  String? productId,
  String? lastMessageText,
  DateTime? lastMessageAt,
  int? buyerUnreadCount,
  int? sellerUnreadCount,
  String? otherUserUsername,
  String? otherUserAvatar,
  String? otherUserId,
  String? productTitle,
  String? productImage,
  double? productPrice,
  DateTime? otherUserLastActive,
  String? productCondition,
  String? role,
}) =>
    ConversationStruct(
      id: id,
      buyerId: buyerId,
      sellerId: sellerId,
      productId: productId,
      lastMessageText: lastMessageText,
      lastMessageAt: lastMessageAt,
      buyerUnreadCount: buyerUnreadCount,
      sellerUnreadCount: sellerUnreadCount,
      otherUserUsername: otherUserUsername,
      otherUserAvatar: otherUserAvatar,
      otherUserId: otherUserId,
      productTitle: productTitle,
      productImage: productImage,
      productPrice: productPrice,
      otherUserLastActive: otherUserLastActive,
      productCondition: productCondition,
      role: role,
    );

// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReviewProductStruct extends BaseStruct {
  ReviewProductStruct({
    String? id,
    String? title,
    double? price,
    String? mainImageUrl,
  })  : _id = id,
        _title = title,
        _price = price,
        _mainImageUrl = mainImageUrl;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "price" field.
  double? _price;
  double get price => _price ?? 0.0;
  set price(double? val) => _price = val;

  void incrementPrice(double amount) => price = price + amount;

  bool hasPrice() => _price != null;

  // "mainImageUrl" field.
  String? _mainImageUrl;
  String get mainImageUrl => _mainImageUrl ?? '';
  set mainImageUrl(String? val) => _mainImageUrl = val;

  bool hasMainImageUrl() => _mainImageUrl != null;

  static ReviewProductStruct fromMap(Map<String, dynamic> data) =>
      ReviewProductStruct(
        id: data['id'] as String?,
        title: data['title'] as String?,
        price: castToType<double>(data['price']),
        mainImageUrl: data['mainImageUrl'] as String?,
      );

  static ReviewProductStruct? maybeFromMap(dynamic data) => data is Map
      ? ReviewProductStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': _title,
        'price': _price,
        'mainImageUrl': _mainImageUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'price': serializeParam(
          _price,
          ParamType.double,
        ),
        'mainImageUrl': serializeParam(
          _mainImageUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static ReviewProductStruct fromSerializableMap(Map<String, dynamic> data) =>
      ReviewProductStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        price: deserializeParam(
          data['price'],
          ParamType.double,
          false,
        ),
        mainImageUrl: deserializeParam(
          data['mainImageUrl'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ReviewProductStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ReviewProductStruct &&
        id == other.id &&
        title == other.title &&
        price == other.price &&
        mainImageUrl == other.mainImageUrl;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([id, title, price, mainImageUrl]);
}

ReviewProductStruct createReviewProductStruct({
  String? id,
  String? title,
  double? price,
  String? mainImageUrl,
}) =>
    ReviewProductStruct(
      id: id,
      title: title,
      price: price,
      mainImageUrl: mainImageUrl,
    );

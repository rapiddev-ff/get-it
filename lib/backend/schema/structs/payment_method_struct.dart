// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PaymentMethodStruct extends BaseStruct {
  PaymentMethodStruct({
    String? id,
    String? type,
    PaymentCardStruct? card,
    BillingDetailsStruct? billingDetails,
    bool? isDefault,
    int? created,
  })  : _id = id,
        _type = type,
        _card = card,
        _billingDetails = billingDetails,
        _isDefault = isDefault,
        _created = created;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  // "card" field.
  PaymentCardStruct? _card;
  PaymentCardStruct get card => _card ?? PaymentCardStruct();
  set card(PaymentCardStruct? val) => _card = val;

  void updateCard(Function(PaymentCardStruct) updateFn) {
    updateFn(_card ??= PaymentCardStruct());
  }

  bool hasCard() => _card != null;

  // "billingDetails" field.
  BillingDetailsStruct? _billingDetails;
  BillingDetailsStruct get billingDetails =>
      _billingDetails ?? BillingDetailsStruct();
  set billingDetails(BillingDetailsStruct? val) => _billingDetails = val;

  void updateBillingDetails(Function(BillingDetailsStruct) updateFn) {
    updateFn(_billingDetails ??= BillingDetailsStruct());
  }

  bool hasBillingDetails() => _billingDetails != null;

  // "isDefault" field.
  bool? _isDefault;
  bool get isDefault => _isDefault ?? false;
  set isDefault(bool? val) => _isDefault = val;

  bool hasIsDefault() => _isDefault != null;

  // "created" field.
  int? _created;
  int get created => _created ?? 0;
  set created(int? val) => _created = val;

  void incrementCreated(int amount) => created = created + amount;

  bool hasCreated() => _created != null;

  static PaymentMethodStruct fromMap(Map<String, dynamic> data) =>
      PaymentMethodStruct(
        id: data['id'] as String?,
        type: data['type'] as String?,
        card: data['card'] is PaymentCardStruct
            ? data['card']
            : PaymentCardStruct.maybeFromMap(data['card']),
        billingDetails: data['billingDetails'] is BillingDetailsStruct
            ? data['billingDetails']
            : BillingDetailsStruct.maybeFromMap(data['billingDetails']),
        isDefault: data['isDefault'] as bool?,
        created: castToType<int>(data['created']),
      );

  static PaymentMethodStruct? maybeFromMap(dynamic data) => data is Map
      ? PaymentMethodStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'type': _type,
        'card': _card?.toMap(),
        'billingDetails': _billingDetails?.toMap(),
        'isDefault': _isDefault,
        'created': _created,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
        'card': serializeParam(
          _card,
          ParamType.DataStruct,
        ),
        'billingDetails': serializeParam(
          _billingDetails,
          ParamType.DataStruct,
        ),
        'isDefault': serializeParam(
          _isDefault,
          ParamType.bool,
        ),
        'created': serializeParam(
          _created,
          ParamType.int,
        ),
      }.withoutNulls;

  static PaymentMethodStruct fromSerializableMap(Map<String, dynamic> data) =>
      PaymentMethodStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
        card: deserializeStructParam(
          data['card'],
          ParamType.DataStruct,
          false,
          structBuilder: PaymentCardStruct.fromSerializableMap,
        ),
        billingDetails: deserializeStructParam(
          data['billingDetails'],
          ParamType.DataStruct,
          false,
          structBuilder: BillingDetailsStruct.fromSerializableMap,
        ),
        isDefault: deserializeParam(
          data['isDefault'],
          ParamType.bool,
          false,
        ),
        created: deserializeParam(
          data['created'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'PaymentMethodStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PaymentMethodStruct &&
        id == other.id &&
        type == other.type &&
        card == other.card &&
        billingDetails == other.billingDetails &&
        isDefault == other.isDefault &&
        created == other.created;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, type, card, billingDetails, isDefault, created]);
}

PaymentMethodStruct createPaymentMethodStruct({
  String? id,
  String? type,
  PaymentCardStruct? card,
  BillingDetailsStruct? billingDetails,
  bool? isDefault,
  int? created,
}) =>
    PaymentMethodStruct(
      id: id,
      type: type,
      card: card ?? PaymentCardStruct(),
      billingDetails: billingDetails ?? BillingDetailsStruct(),
      isDefault: isDefault,
      created: created,
    );

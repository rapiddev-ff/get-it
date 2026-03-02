// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SellerShortlistStruct extends BaseStruct {
  SellerShortlistStruct({
    String? id,
    String? name,
    String? description,
    int? totalItems,
    double? discountPercentage,
    String? eventName,
    String? shareCode,
    String? status,
    bool? isPublic,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    List<ShortlistCoverImageStruct>? coverImages,
    List<String>? tags,
  })  : _id = id,
        _name = name,
        _description = description,
        _totalItems = totalItems,
        _discountPercentage = discountPercentage,
        _eventName = eventName,
        _shareCode = shareCode,
        _status = status,
        _isPublic = isPublic,
        _startDate = startDate,
        _endDate = endDate,
        _createdAt = createdAt,
        _coverImages = coverImages,
        _tags = tags;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "totalItems" field.
  int? _totalItems;
  int get totalItems => _totalItems ?? 0;
  set totalItems(int? val) => _totalItems = val;

  void incrementTotalItems(int amount) => totalItems = totalItems + amount;

  bool hasTotalItems() => _totalItems != null;

  // "discountPercentage" field.
  double? _discountPercentage;
  double get discountPercentage => _discountPercentage ?? 0.0;
  set discountPercentage(double? val) => _discountPercentage = val;

  void incrementDiscountPercentage(double amount) =>
      discountPercentage = discountPercentage + amount;

  bool hasDiscountPercentage() => _discountPercentage != null;

  // "eventName" field.
  String? _eventName;
  String get eventName => _eventName ?? '';
  set eventName(String? val) => _eventName = val;

  bool hasEventName() => _eventName != null;

  // "shareCode" field.
  String? _shareCode;
  String get shareCode => _shareCode ?? '';
  set shareCode(String? val) => _shareCode = val;

  bool hasShareCode() => _shareCode != null;

  // "status" field.
  String? _status;
  String get status => _status ?? '';
  set status(String? val) => _status = val;

  bool hasStatus() => _status != null;

  // "isPublic" field.
  bool? _isPublic;
  bool get isPublic => _isPublic ?? false;
  set isPublic(bool? val) => _isPublic = val;

  bool hasIsPublic() => _isPublic != null;

  // "startDate" field.
  DateTime? _startDate;
  DateTime? get startDate => _startDate;
  set startDate(DateTime? val) => _startDate = val;

  bool hasStartDate() => _startDate != null;

  // "endDate" field.
  DateTime? _endDate;
  DateTime? get endDate => _endDate;
  set endDate(DateTime? val) => _endDate = val;

  bool hasEndDate() => _endDate != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "coverImages" field.
  List<ShortlistCoverImageStruct>? _coverImages;
  List<ShortlistCoverImageStruct> get coverImages => _coverImages ?? const [];
  set coverImages(List<ShortlistCoverImageStruct>? val) => _coverImages = val;

  void updateCoverImages(Function(List<ShortlistCoverImageStruct>) updateFn) {
    updateFn(_coverImages ??= []);
  }

  bool hasCoverImages() => _coverImages != null;

  // "tags" field.
  List<String>? _tags;
  List<String> get tags => _tags ?? const [];
  set tags(List<String>? val) => _tags = val;

  void updateTags(Function(List<String>) updateFn) {
    updateFn(_tags ??= []);
  }

  bool hasTags() => _tags != null;

  static SellerShortlistStruct fromMap(Map<String, dynamic> data) =>
      SellerShortlistStruct(
        id: data['id'] as String?,
        name: data['name'] as String?,
        description: data['description'] as String?,
        totalItems: castToType<int>(data['totalItems']),
        discountPercentage: castToType<double>(data['discountPercentage']),
        eventName: data['eventName'] as String?,
        shareCode: data['shareCode'] as String?,
        status: data['status'] as String?,
        isPublic: data['isPublic'] as bool?,
        startDate: data['startDate'] as DateTime?,
        endDate: data['endDate'] as DateTime?,
        createdAt: data['createdAt'] as DateTime?,
        coverImages: getStructList(
          data['coverImages'],
          ShortlistCoverImageStruct.fromMap,
        ),
        tags: getDataList(data['tags']),
      );

  static SellerShortlistStruct? maybeFromMap(dynamic data) => data is Map
      ? SellerShortlistStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'name': _name,
        'description': _description,
        'totalItems': _totalItems,
        'discountPercentage': _discountPercentage,
        'eventName': _eventName,
        'shareCode': _shareCode,
        'status': _status,
        'isPublic': _isPublic,
        'startDate': _startDate,
        'endDate': _endDate,
        'createdAt': _createdAt,
        'coverImages': _coverImages?.map((e) => e.toMap()).toList(),
        'tags': _tags,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'totalItems': serializeParam(
          _totalItems,
          ParamType.int,
        ),
        'discountPercentage': serializeParam(
          _discountPercentage,
          ParamType.double,
        ),
        'eventName': serializeParam(
          _eventName,
          ParamType.String,
        ),
        'shareCode': serializeParam(
          _shareCode,
          ParamType.String,
        ),
        'status': serializeParam(
          _status,
          ParamType.String,
        ),
        'isPublic': serializeParam(
          _isPublic,
          ParamType.bool,
        ),
        'startDate': serializeParam(
          _startDate,
          ParamType.DateTime,
        ),
        'endDate': serializeParam(
          _endDate,
          ParamType.DateTime,
        ),
        'createdAt': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
        'coverImages': serializeParam(
          _coverImages,
          ParamType.DataStruct,
          isList: true,
        ),
        'tags': serializeParam(
          _tags,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static SellerShortlistStruct fromSerializableMap(Map<String, dynamic> data) =>
      SellerShortlistStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        totalItems: deserializeParam(
          data['totalItems'],
          ParamType.int,
          false,
        ),
        discountPercentage: deserializeParam(
          data['discountPercentage'],
          ParamType.double,
          false,
        ),
        eventName: deserializeParam(
          data['eventName'],
          ParamType.String,
          false,
        ),
        shareCode: deserializeParam(
          data['shareCode'],
          ParamType.String,
          false,
        ),
        status: deserializeParam(
          data['status'],
          ParamType.String,
          false,
        ),
        isPublic: deserializeParam(
          data['isPublic'],
          ParamType.bool,
          false,
        ),
        startDate: deserializeParam(
          data['startDate'],
          ParamType.DateTime,
          false,
        ),
        endDate: deserializeParam(
          data['endDate'],
          ParamType.DateTime,
          false,
        ),
        createdAt: deserializeParam(
          data['createdAt'],
          ParamType.DateTime,
          false,
        ),
        coverImages: deserializeStructParam<ShortlistCoverImageStruct>(
          data['coverImages'],
          ParamType.DataStruct,
          true,
          structBuilder: ShortlistCoverImageStruct.fromSerializableMap,
        ),
        tags: deserializeParam<String>(
          data['tags'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'SellerShortlistStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SellerShortlistStruct &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        totalItems == other.totalItems &&
        discountPercentage == other.discountPercentage &&
        eventName == other.eventName &&
        shareCode == other.shareCode &&
        status == other.status &&
        isPublic == other.isPublic &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        createdAt == other.createdAt &&
        listEquality.equals(coverImages, other.coverImages) &&
        listEquality.equals(tags, other.tags);
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        name,
        description,
        totalItems,
        discountPercentage,
        eventName,
        shareCode,
        status,
        isPublic,
        startDate,
        endDate,
        createdAt,
        coverImages,
        tags
      ]);
}

SellerShortlistStruct createSellerShortlistStruct({
  String? id,
  String? name,
  String? description,
  int? totalItems,
  double? discountPercentage,
  String? eventName,
  String? shareCode,
  String? status,
  bool? isPublic,
  DateTime? startDate,
  DateTime? endDate,
  DateTime? createdAt,
}) =>
    SellerShortlistStruct(
      id: id,
      name: name,
      description: description,
      totalItems: totalItems,
      discountPercentage: discountPercentage,
      eventName: eventName,
      shareCode: shareCode,
      status: status,
      isPublic: isPublic,
      startDate: startDate,
      endDate: endDate,
      createdAt: createdAt,
    );

// ignore_for_file: unnecessary_getters_setters


import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReviewStruct extends BaseStruct {
  ReviewStruct({
    String? id,
    int? rating,
    String? title,
    String? content,
    bool? wouldRecommend,
    DateTime? createdAt,
    ReviewerStruct? reviewer,
    ReviewProductStruct? product,
    List<ReviewImageStruct>? images,
  })  : _id = id,
        _rating = rating,
        _title = title,
        _content = content,
        _wouldRecommend = wouldRecommend,
        _createdAt = createdAt,
        _reviewer = reviewer,
        _product = product,
        _images = images;

  // "id" field.
  String? _id;
  String get id => _id ?? '';
  set id(String? val) => _id = val;

  bool hasId() => _id != null;

  // "rating" field.
  int? _rating;
  int get rating => _rating ?? 0;
  set rating(int? val) => _rating = val;

  void incrementRating(int amount) => rating = rating + amount;

  bool hasRating() => _rating != null;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  set content(String? val) => _content = val;

  bool hasContent() => _content != null;

  // "wouldRecommend" field.
  bool? _wouldRecommend;
  bool get wouldRecommend => _wouldRecommend ?? false;
  set wouldRecommend(bool? val) => _wouldRecommend = val;

  bool hasWouldRecommend() => _wouldRecommend != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "reviewer" field.
  ReviewerStruct? _reviewer;
  ReviewerStruct get reviewer => _reviewer ?? ReviewerStruct();
  set reviewer(ReviewerStruct? val) => _reviewer = val;

  void updateReviewer(Function(ReviewerStruct) updateFn) {
    updateFn(_reviewer ??= ReviewerStruct());
  }

  bool hasReviewer() => _reviewer != null;

  // "product" field.
  ReviewProductStruct? _product;
  ReviewProductStruct get product => _product ?? ReviewProductStruct();
  set product(ReviewProductStruct? val) => _product = val;

  void updateProduct(Function(ReviewProductStruct) updateFn) {
    updateFn(_product ??= ReviewProductStruct());
  }

  bool hasProduct() => _product != null;

  // "images" field.
  List<ReviewImageStruct>? _images;
  List<ReviewImageStruct> get images => _images ?? const [];
  set images(List<ReviewImageStruct>? val) => _images = val;

  void updateImages(Function(List<ReviewImageStruct>) updateFn) {
    updateFn(_images ??= []);
  }

  bool hasImages() => _images != null;

  static ReviewStruct fromMap(Map<String, dynamic> data) => ReviewStruct(
        id: data['id'] as String?,
        rating: castToType<int>(data['rating']),
        title: data['title'] as String?,
        content: data['content'] as String?,
        wouldRecommend: data['wouldRecommend'] as bool?,
        createdAt: data['createdAt'] as DateTime?,
        reviewer: data['reviewer'] is ReviewerStruct
            ? data['reviewer']
            : ReviewerStruct.maybeFromMap(data['reviewer']),
        product: data['product'] is ReviewProductStruct
            ? data['product']
            : ReviewProductStruct.maybeFromMap(data['product']),
        images: getStructList(
          data['images'],
          ReviewImageStruct.fromMap,
        ),
      );

  static ReviewStruct? maybeFromMap(dynamic data) =>
      data is Map ? ReviewStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'rating': _rating,
        'title': _title,
        'content': _content,
        'wouldRecommend': _wouldRecommend,
        'createdAt': _createdAt,
        'reviewer': _reviewer?.toMap(),
        'product': _product?.toMap(),
        'images': _images?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.String,
        ),
        'rating': serializeParam(
          _rating,
          ParamType.int,
        ),
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'content': serializeParam(
          _content,
          ParamType.String,
        ),
        'wouldRecommend': serializeParam(
          _wouldRecommend,
          ParamType.bool,
        ),
        'createdAt': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
        'reviewer': serializeParam(
          _reviewer,
          ParamType.DataStruct,
        ),
        'product': serializeParam(
          _product,
          ParamType.DataStruct,
        ),
        'images': serializeParam(
          _images,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static ReviewStruct fromSerializableMap(Map<String, dynamic> data) =>
      ReviewStruct(
        id: deserializeParam(
          data['id'],
          ParamType.String,
          false,
        ),
        rating: deserializeParam(
          data['rating'],
          ParamType.int,
          false,
        ),
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        content: deserializeParam(
          data['content'],
          ParamType.String,
          false,
        ),
        wouldRecommend: deserializeParam(
          data['wouldRecommend'],
          ParamType.bool,
          false,
        ),
        createdAt: deserializeParam(
          data['createdAt'],
          ParamType.DateTime,
          false,
        ),
        reviewer: deserializeStructParam(
          data['reviewer'],
          ParamType.DataStruct,
          false,
          structBuilder: ReviewerStruct.fromSerializableMap,
        ),
        product: deserializeStructParam(
          data['product'],
          ParamType.DataStruct,
          false,
          structBuilder: ReviewProductStruct.fromSerializableMap,
        ),
        images: deserializeStructParam<ReviewImageStruct>(
          data['images'],
          ParamType.DataStruct,
          true,
          structBuilder: ReviewImageStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'ReviewStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ReviewStruct &&
        id == other.id &&
        rating == other.rating &&
        title == other.title &&
        content == other.content &&
        wouldRecommend == other.wouldRecommend &&
        createdAt == other.createdAt &&
        reviewer == other.reviewer &&
        product == other.product &&
        listEquality.equals(images, other.images);
  }

  @override
  int get hashCode => const ListEquality().hash([
        id,
        rating,
        title,
        content,
        wouldRecommend,
        createdAt,
        reviewer,
        product,
        images
      ]);
}

ReviewStruct createReviewStruct({
  String? id,
  int? rating,
  String? title,
  String? content,
  bool? wouldRecommend,
  DateTime? createdAt,
  ReviewerStruct? reviewer,
  ReviewProductStruct? product,
}) =>
    ReviewStruct(
      id: id,
      rating: rating,
      title: title,
      content: content,
      wouldRecommend: wouldRecommend,
      createdAt: createdAt,
      reviewer: reviewer ?? ReviewerStruct(),
      product: product ?? ReviewProductStruct(),
    );

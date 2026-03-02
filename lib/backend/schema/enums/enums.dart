import 'package:collection/collection.dart';

enum ProductStatus {
  active,
  sold,
  draft,
  archived,
}

enum OrderStatus {
  pending,
  paid,
  shipped,
  delivered,
  refunded,
  cancelled,
}

enum MessageType {
  text,
  image,
  counter_offer,
  system,
}

enum CounterOfferStatus {
  pending,
  accepted,
  rejected,
  expired,
}

extension FFEnumExtensions<T extends Enum> on T {
  String serialize() => name;
}

extension FFEnumListExtensions<T extends Enum> on Iterable<T> {
  T? deserialize(String? value) =>
      firstWhereOrNull((e) => e.serialize() == value);
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (ProductStatus):
      return ProductStatus.values.deserialize(value) as T?;
    case (OrderStatus):
      return OrderStatus.values.deserialize(value) as T?;
    case (MessageType):
      return MessageType.values.deserialize(value) as T?;
    case (CounterOfferStatus):
      return CounterOfferStatus.values.deserialize(value) as T?;
    default:
      return null;
  }
}

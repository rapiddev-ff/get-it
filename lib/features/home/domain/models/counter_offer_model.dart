import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

import '/core/utils/json_converters.dart';

part 'counter_offer_model.freezed.dart';
part 'counter_offer_model.g.dart';

@freezed
class CounterOffer with _$CounterOffer {
  const CounterOffer._();
  const factory CounterOffer({
    @Default('') String id,
    @Default('') String productId,
    @Default(0.0) double originalPrice,
    @Default(0.0) double offeredPrice,
    String? status,
    @Default('') String fromUserId,
    @Default('') String toUserId,
    @DateTimeConverter() DateTime? createdAt,
    @DateTimeConverter() DateTime? expiresAt,
  }) = _CounterOffer;

  factory CounterOffer.fromJson(Map<String, dynamic> json) =>
      _$CounterOfferFromJson(json);

  String serialize() => jsonEncode(toJson());
  static CounterOffer fromSerializableMap(Map<String, dynamic> data) =>
      CounterOffer.fromJson(data);
}

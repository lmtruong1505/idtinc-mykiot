import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_info_payload_entity.freezed.dart';
part 'order_info_payload_entity.g.dart';

@freezed
class OrderInfoPayloadEntity with _$OrderInfoPayloadEntity {
  const OrderInfoPayloadEntity._();

  const factory OrderInfoPayloadEntity({
    double? totalPrice,
    String? description,
    double? vat,
    String? discount,
    @JsonKey(name: 'service_price')
    double? servicePrice,
    @JsonKey(name: 'must_paid')
    double? mustPaid,
    int? customer,
    @JsonKey(name: 'customer_phone')
    String? customerPhone,
    @JsonKey(name: 'customer_name')
    String? customerName,
    @Default('DRAFT') String status,
    @Default('SELL') String type,
    int? company,
  }) = _OrderInfoPayloadEntity;

  factory OrderInfoPayloadEntity.fromJson(Map<String, dynamic> json) => _$OrderInfoPayloadEntityFromJson(json);
}
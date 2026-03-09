// To parse this JSON data, do
//
//     final OrderWmPayloadModel = OrderWmPayloadModelFromJson(jsonString);

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_wm_payload_model.freezed.dart';
part 'order_wm_payload_model.g.dart';

OrderWmPayloadModel orderWmPayloadModelFromJson(String str) =>
    OrderWmPayloadModel.fromJson(json.decode(str));

String orderWmPayloadModelToJson(OrderWmPayloadModel data) =>
    json.encode(data.toJson());

class OrderWmPayloadModel {
  final Order? order;
  final List<Orderitem>? orderitem;

  OrderWmPayloadModel({
    this.order,
    this.orderitem,
  });

  OrderWmPayloadModel copyWith({
    Order? order,
    List<Orderitem>? orderitem,
  }) =>
      OrderWmPayloadModel(
        order: order ?? this.order,
        orderitem: orderitem ?? this.orderitem,
      );

  factory OrderWmPayloadModel.fromJson(Map<String, dynamic> json) =>
      OrderWmPayloadModel(
        order: json['order'] == null ? null : Order.fromJson(json['order']),
        orderitem: json['orderitem'] == null
            ? []
            : List<Orderitem>.from(
                json['orderitem']!.map((x) => Orderitem.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        'order': order?.toJson(),
        'orderitem': orderitem == null
            ? []
            : List<dynamic>.from(orderitem!.map((x) => x.toJson())),
      };
}

@freezed
class Order with _$Order {
  const Order._();

  const factory Order({
    String? title,
    double? discount,
    // dynamic customer,
    @JsonKey(name: 'orderis_online_red') bool? isOnline,
    String? note,
    int? total,
    // int? account,
    @JsonKey(name: 'order_red') bool? orderRed,
    @JsonKey(name: 'tag_systems') String? tagSystem,
    @Default('0829116362') @JsonKey(name: 'user_system') String userPhone,
    @Default(1) @JsonKey(name: 'user_system_id') int userId,
    @JsonKey(name: 'discount_order') List<Orderitem>? discountOrder,
    List<int>? promotions,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@freezed
class Orderitem with _$Orderitem {
  const Orderitem._();

  const factory Orderitem({
    int? quantity,
    double? discount,
    int? variant,
    int? type,
    @JsonKey(name: 'variant_promotion') int? variantPromotion,
    // @JsonKey(name: 'price_list') List<PriceListModel>? priceList,
    List<int>? promotions,
    @JsonKey(name: 'promotion_item') int? promotionItem,
    @JsonKey(name: 'times_apply_promotion') int? timesApplyPromotion,
    @JsonKey(name: 'promotion_order') int? promotionOrder,
  }) = _Orderitem;

  factory Orderitem.fromJson(Map<String, dynamic> json) => _$OrderitemFromJson(json);
}

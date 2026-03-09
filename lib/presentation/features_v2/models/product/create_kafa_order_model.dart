import 'package:freezed_annotation/freezed_annotation.dart';
part 'create_kafa_order_model.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class CreateOrderKafaModel {
  final OrderKafaModel? order;
  final List<KafaPrdModel>? items;

  CreateOrderKafaModel({
    required this.order,
    required this.items,
  });
  factory CreateOrderKafaModel.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderKafaModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderKafaModelToJson(this);
}

@JsonSerializable(includeIfNull: false)
class OrderKafaModel {
  final num? total;
  final num? discount;
  final num? costs;
  @JsonKey(name: 'red_invoice')
  @Default(false)
  final bool? redInvoice;
  final List<int>? promotions;
  final int? company;

  OrderKafaModel({
    required this.total,
    required this.discount,
    required this.costs,
    required this.redInvoice,
    required this.promotions,
    required this.company,
  });
  factory OrderKafaModel.fromJson(Map<String, dynamic> json) =>
      _$OrderKafaModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderKafaModelToJson(this);
}

@JsonSerializable(includeIfNull: false)
class KafaPrdModel {
  final num? type;
  final num? quantity;
  final num? variant;
  final List<int>? promotions;

  @JsonKey(name: 'variant_promotion')
  final num? variantPromotionId;
  @JsonKey(name: 'promotion_item')
  final num? promotionItemId;
  @JsonKey(name: 'times_apply_promotion')
  final int? timesApplyPromotion;
  final num? price;
  final num? discount;

  KafaPrdModel({
    required this.type,
    required this.variant,
    required this.quantity,
    this.price,
    this.discount,
    this.variantPromotionId,
    this.promotions,
    this.promotionItemId,
    this.timesApplyPromotion,
  });
  factory KafaPrdModel.fromJson(Map<String, dynamic> json) =>
      _$KafaPrdModelFromJson(json);
  Map<String, dynamic> toJson() => _$KafaPrdModelToJson(this);
}

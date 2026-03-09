// To parse this JSON data, do
//
//     final orderWmDetailModel = orderWmDetailModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';

import 'variant_wm_model.dart';


part 'order_wm_model.g.dart';

@JsonSerializable()
class OrderWmDetailModel {
  final int? id;
  @JsonKey(name: 'dlo_id') final int? dloId;
  final String? title;
  final String? code;
  final double? total;
  final double? discount;
  @JsonKey(name: 'is_online')
  final bool? isOnline;
  @JsonKey(name: 'order_red')
  final bool? orderRed;
  final String? note;
  // final StatusPWmaymentModel? settings;
  final int? status;
  @JsonKey(name: 'status_order_data')
  final StatusOrderData? statusOrderData;
  @JsonKey(name: 'status_data')
  final StatusOrderData? statusData;
  final dynamic customer;
  // @JsonKey(name: 'customer_data')
  // final CuWmstomerModel? customerData;
  // @JsonKey(name: 'account_data')
  // final CuWmstomerModel? senderData;
  final int? shop;
  // @JsonKey(name: 'shop_data')
  // final ShopData? shopData;
  @JsonKey(name: 'discount_order')
  final List<DiscounWmOrderModel>? discountOrder;
  final List<OrderItemModel>? orderitems;
  final List<OrderItemModel>? orderitemsystem;
  @JsonKey(name: 'updated_at')
  final DateTime? createdAt;
  @JsonKey(name: 'created_at')
  final DateTime? updatedAt;
  @JsonKey(name: 'cancel_reason_data')
  final CancelReasonData? cancelReasonData;

  OrderWmDetailModel({
    this.id,
    this.dloId,
    this.title,
    this.code,
    this.total,
    this.discount,
    this.isOnline,
    this.orderRed,
    this.note,
    // this.settings,
    this.status,
    this.statusOrderData,
    this.statusData,
    this.customer,
    // this.customerData,
    // this.senderData,
    this.shop,
    // this.shopData,
    this.orderitems,
    this.orderitemsystem,
    this.createdAt,
    this.updatedAt,
    this.cancelReasonData,
    this.discountOrder,
  });

  OrderWmDetailModel copyWith({
    int? id,
    String? title,
    String? code,
    double? total,
    double? discount,
    bool? isOnline,
    bool? orderRed,
    String? note,
    // StatusPWmaymentModel? settings,
    int? status,
    StatusOrderData? statusOrderData,
    StatusOrderData? statusData,
    dynamic customer,
    dynamic customerData,
    int? shop,
    // ShopData? shopData,
    List<OrderItemModel>? orderitems,
    List<OrderItemModel>? orderitemsystem,
    DateTime? createdAt,
    DateTime? updatedAt,
    CancelReasonData? cancelReasonData,
    List<DiscounWmOrderModel>? discountOrder,
  }) =>
      OrderWmDetailModel(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
        total: total ?? this.total,
        discount: discount ?? this.discount,
        isOnline: isOnline ?? this.isOnline,
        orderRed: orderRed ?? this.orderRed,
        note: note ?? this.note,
        // settings: settings ?? this.settings,
        status: status ?? this.status,
        statusOrderData: statusOrderData ?? this.statusOrderData,
        statusData: statusData ?? this.statusData,
        customer: customer ?? this.customer,
        // customerData: customerData ?? this.customerData,
        shop: shop ?? this.shop,
        // shopData: shopData ?? this.shopData,
        orderitems: orderitems ?? this.orderitems,
        orderitemsystem: orderitemsystem ?? this.orderitemsystem,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        cancelReasonData: cancelReasonData ?? this.cancelReasonData,
        discountOrder: discountOrder ?? this.discountOrder,
      );

  factory OrderWmDetailModel.fromJson(Map<String, dynamic> json) =>
      _$OrderWmDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderWmDetailModelToJson(this);
}

@JsonSerializable()
class DiscounWmOrderModel {
  final int? id;
  @JsonKey(name: 'promotion_title')
  final String? title;
  @JsonKey(name: 'times_apply_promotion')
  final int? timesApplyPromotion;
  @JsonKey(name: 'discount_value')
  final double? discountValue;
  @JsonKey(name: 'type_discount')
  final String? typeDiscount;
  @JsonKey(name: 'value_min')
  final double? valueMin;

  DiscounWmOrderModel({
    this.id,
    this.title,
    this.timesApplyPromotion,
    this.discountValue,
    this.typeDiscount,
    this.valueMin,
  });

  factory DiscounWmOrderModel.fromJson(Map<String, dynamic> json) =>
      _$DiscounWmOrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$DiscounWmOrderModelToJson(this);
}

@JsonSerializable()
class CancelReasonData {
  final int? id;
  @JsonKey(name: 'reason_data')
  final ReasonData? reasonData;

  CancelReasonData({
    this.id,
    this.reasonData,
  });

  factory CancelReasonData.fromJson(Map<String, dynamic> json) =>
      _$CancelReasonDataFromJson(json);

  Map<String, dynamic> toJson() => _$CancelReasonDataToJson(this);
}

@JsonSerializable()
class ReasonData {
  final int? id;
  final String? title;
  final int? account;
  final int? system;

  ReasonData({
    this.id,
    this.title,
    this.account,
    this.system,
  });

  factory ReasonData.fromJson(Map<String, dynamic> json) =>
      _$ReasonDataFromJson(json);

  Map<String, dynamic> toJson() => _$ReasonDataToJson(this);
}

@JsonSerializable()
class OrderItemModel {
  final int? id;
  final double? quantity;
  final double? price;
  final double? discount;
  final int? variant;
  final int? type;
  @JsonKey(name: 'variant_promotion')
  final int? variantPromotion;
  @JsonKey(name: 'variant_data')
  final VariantWmModel? variantData;
  final DateTime? createdAt;
  @JsonKey(name: 'promotions_dict')
  final Map? promotions;

  OrderItemModel({
    this.id,
    this.quantity,
    this.price,
    this.discount,
    this.variant,
    this.variantPromotion,
    this.type,
    this.variantData,
    this.createdAt,
    this.promotions,
  });

  OrderItemModel copyWith({
    int? id,
    double? quantity,
    double? price,
    double? discount,
    int? variant,
    int? type,
    int? variantPromotion,
    VariantWmModel? variantData,
    DateTime? createdAt,
  }) =>
      OrderItemModel(
        id: id ?? this.id,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        discount: discount ?? this.discount,
        variant: variant ?? this.variant,
        type: type ?? this.type,
        variantPromotion: variantPromotion ?? this.variantPromotion,
        variantData: variantData ?? this.variantData,
        createdAt: createdAt ?? this.createdAt,
      );

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
}

class StatusOrderData {
  final int? id;
  final String? title;
  final String? code;

  StatusOrderData({
    this.id,
    this.title,
    this.code,
  });

  StatusOrderData copyWith({
    int? id,
    String? title,
    String? code,
  }) =>
      StatusOrderData(
        id: id ?? this.id,
        title: title ?? this.title,
        code: code ?? this.code,
      );

  factory StatusOrderData.fromJson(Map<String, dynamic> json) =>
      StatusOrderData(
        id: json['id'],
        title: json['title'],
        code: json['code'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'code': code,
      };
}

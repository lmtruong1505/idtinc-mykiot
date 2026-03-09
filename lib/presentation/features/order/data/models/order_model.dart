import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features/product/data/models/basic_model.dart';
import 'package:pharmago/presentation/features/product/data/models/service_model.dart';
import 'package:pharmago/presentation/features/product/data/models/variant_model.dart';

import 'payment_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class OrderModel with _$OrderModel {
  const OrderModel._();

  const factory OrderModel({
    int? id,
    String? code,
    @JsonKey(name: 'total_price')
    double? totalPrice,
    String? description,
    double? vat,
    @JsonKey(name: 'service_price')
    double? servicePrice,
    String? discount,
    CustomerModel? customer,
    BasicModel? type,
    BasicModel? status,
    String? qr,
    @JsonKey(name: 'user_created')
    String? userCreated,
    @JsonKey(name: 'user_updated')
    String? userUpdated,
    @JsonKey(name: 'created_at')
    DateTime? createdAt,
    @JsonKey(name: 'updated_at')
    DateTime? updatedAt,
    PaymentModel? payment,
    List<OrderItemModel>? items,
    @JsonKey(name: 'service_items')
    List<ServiceItemModel>? services,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
}

@freezed
class OrderItemModel with _$OrderItemModel {
  const OrderItemModel._();

  const factory OrderItemModel({
    int? id,
    VariantModel? variant,
    @Default(0) int value,    
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => _$OrderItemModelFromJson(json);
}

@freezed
class ServiceItemModel with _$ServiceItemModel {
  const ServiceItemModel._();

  const factory ServiceItemModel({
    int? id,
    ServiceModel? service,
    @JsonKey(name: 'unit_price')
    @Default(0) num unitPrice,
    @JsonKey(name: 'total_price')
    @Default(0) num totalPrice,
    @Default(0) num discount,
    @Default(0) int quantity,
  }) = _ServiceItemModel;

  factory ServiceItemModel.fromJson(Map<String, dynamic> json) => _$ServiceItemModelFromJson(json);
}
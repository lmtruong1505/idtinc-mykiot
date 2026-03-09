

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../customer/domain/entities/customer_entity.dart';
import '../../../product/domain/entities/basic_entity.dart';
import '../../../product/domain/entities/service_entity.dart';
import '../../../product/domain/entities/variant_entity.dart';
import 'payment_entity.dart';

part 'order_entity.freezed.dart';

@freezed
class OrderEntity with _$OrderEntity {
  const OrderEntity._();

  const factory OrderEntity({
    int? id,
    String? code,
    @JsonKey(name: 'total_price')
    double? totalPrice,
    String? description,
    double? vat,
    @JsonKey(name: 'service_price')
    double? servicePrice,
    String? discount,
    CustomerEntity? customer,
    BasicEntity? type,
    BasicEntity? status,
    String? qr,
    @JsonKey(name: 'user_created')
    String? userCreated,
    @JsonKey(name: 'user_updated')
    String? userUpdated,
    @JsonKey(name: 'created_at')
    DateTime? createdAt,
    @JsonKey(name: 'updated_at')
    DateTime? updatedAt,
    PaymentEntity? payment,
    List<OrderItemEntity>? items,
    List<ServiceItemEntity>? services,
  }) = _OrderEntity;
}

@freezed
class OrderItemEntity with _$OrderItemEntity {
  const OrderItemEntity._();

  const factory OrderItemEntity({
    int? id,
    VariantEntity? variant,
    @Default(0) int value,
  }) = _OrderItemEntity;
}

@freezed
class ServiceItemEntity with _$ServiceItemEntity {
  const ServiceItemEntity._();

  const factory ServiceItemEntity({
    int? id,
    ServiceEntity? service,
    @Default(0) num unitPrice,
    @Default(0) num totalPrice,
    @Default(0) num discount,
    @Default(0) int quantity,
  }) = _ServiceItemEntity;
}
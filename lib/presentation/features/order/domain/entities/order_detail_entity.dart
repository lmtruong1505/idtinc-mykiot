import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_entity.dart';
import 'package:pharmago/presentation/features/order/domain/entities/payment_v2_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/unit_entity.dart';

part 'order_detail_entity.freezed.dart';

@freezed
class OrderDetailEntity with _$OrderDetailEntity {
  const OrderDetailEntity._();

  const factory OrderDetailEntity({
    int? id,
    String? code,
    DateTime? createdAt,
    String? roleName,
    double? totalPaid,
    String? type,
    bool? redInvoice,
    String? description,
    String? userCreated,
    CustomerEntity? customer,
    @Default([]) List<ItemOrderDetail> items,
    double? totalPrice,
    String? qrCode,
    @Default([]) List<PaymentV2Entity> payments,
  }) = _OrderDetailEntity;
}

@freezed
class ItemOrderDetail with _$ItemOrderDetail {
  const ItemOrderDetail._();

  const factory ItemOrderDetail({
    String? title,
    String? name,
    double? totalPrice,
    double? discount,
    double? unitPrice,
    int? quantity,
    int? itemId,
    @Default([]) List<UnitEntity> units,
  }) = _ItemOrderDetail;
}

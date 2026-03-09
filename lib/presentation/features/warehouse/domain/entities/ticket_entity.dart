import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/variant_warehouse_entity.dart';

import '../../../product/domain/entities/basic_entity.dart';

part 'ticket_entity.freezed.dart';

@freezed
class TicketEntity with _$TicketEntity {
  const TicketEntity._();

  const factory TicketEntity({
    int? id,
    String? code,
    BasicEntity? type,
    BasicEntity? status,
    String? note,
    String? qr,
    @JsonKey(name: 'total_price') double? totalPrice,
    @JsonKey(name: 'warehouse_name') String? warehouseName,
    @JsonKey(name: 'user_created') String? userCreated,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'totalItems') int? totalItems,
    BasicEntity? warehouse,
    List<VariantWarehouseEntity>? variants,
  }) = _TicketEntity;
}

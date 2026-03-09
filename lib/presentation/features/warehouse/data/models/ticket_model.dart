
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../product/data/models/basic_model.dart';

part 'ticket_model.freezed.dart';
part 'ticket_model.g.dart';

@freezed
class TicketModel with _$TicketModel {
  const TicketModel._();

  const factory TicketModel({
    int? id,
    String? code,
    BasicModel? type,
    BasicModel? status,
    String? note,
    String? qr,
    @JsonKey(name: 'total_price')
    double? totalPrice,
    @JsonKey(name: 'warehouse_name')
    String? warehouseName,
    @JsonKey(name: 'user_created')
    String? userCreated,
    @JsonKey(name: 'created_at')
    DateTime? createdAt,
    @JsonKey(name: 'totalItems')
    int? totalItems,
  }) = _TicketModel;

  factory TicketModel.fromJson(Map<String, dynamic> json) => _$TicketModelFromJson(json);
}
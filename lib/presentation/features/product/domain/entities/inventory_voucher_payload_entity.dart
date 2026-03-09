import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_voucher_payload_entity.freezed.dart';

enum TypeInventoryVoucher {
  export('Export'),
  import('Import');

  final String code;

  const TypeInventoryVoucher(this.code);
}

enum StatusInventoryVoucher {
  complete('Hoàn thành'),
  inprocess('Đang tiến hành');

  final String code;

  const StatusInventoryVoucher(this.code);
}

@freezed
class InventoryVoucherPayloadEntity with _$InventoryVoucherPayloadEntity {
  const InventoryVoucherPayloadEntity._();

  const factory InventoryVoucherPayloadEntity({
    @Required() TypeInventoryVoucher? type,
    @Required() StatusInventoryVoucher? status,
    int? account,
    int? warehouse,
    int? partner,
    String? reason,
    String? note,
    @Default(0) int amount,
    @Default([]) List<InventoryItemPayloadEntity> inventoryVoucherItems,
  }) = _InventoryVoucherPayloadEntity;

  Map<String, dynamic> toPayload() {
    final payload = {
      "inventory_voucher": {
        "type": type?.code,
        "status": status?.code,
        "account": account,
        "warehouse": warehouse,
        "partner": partner,
        "reason": reason,
        "note": note,
        "amount": amount,
      },
      "inventory_voucher_items": inventoryVoucherItems
          .map((e) => {
                "variant": e.variant,
                "quantity": e.quantity,
                "unit": e.unit,
                "price": e.price,
              })
          .toList()
    };
    return payload;
  }
}

@freezed
class InventoryItemPayloadEntity
    with _$InventoryItemPayloadEntity {
  const InventoryItemPayloadEntity._();

  const factory InventoryItemPayloadEntity({
    @Required() int? variant,
    @Required() int? unit,
    @Default(0) int quantity,
    @Default(0) int price,
  }) = _InventoryItemPayloadEntity;
}

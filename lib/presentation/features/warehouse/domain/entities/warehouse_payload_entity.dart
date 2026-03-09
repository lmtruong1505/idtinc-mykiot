import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../address/domain/entities/address_entity.dart';

part 'warehouse_payload_entity.freezed.dart';

@freezed
class WarehousePayloadEntity with _$WarehousePayloadEntity {
  const WarehousePayloadEntity._();

  const factory WarehousePayloadEntity({
    String? code,
    String? name,
    int? company,
    int? typeWarehouse,
    List<int>? warehouseStaff,
    int? warehouseManger,
    AddressEntity? addressEntity,
  }) = _WarehousePayloadEntity;

  Map<String, dynamic> toJson() {
    return {
      'title': name,
      'code': code,
      'company': company,
      'type_warehouse': typeWarehouse,
      'warehouse_staff': warehouseStaff,
      'user_manage': warehouseManger,
      'system_input': 'PHARMAGO',
      // 'address': {
      //   'lat': addressEntity?.lat,
      //   'lng': addressEntity?.lng,
      //   'province': addressEntity?.province?.code,
      //   'district': addressEntity?.district?.code,
      //   'ward': addressEntity?.ward?.code,
      //   'title': addressEntity?.detail,
      // },
    };
  }
}

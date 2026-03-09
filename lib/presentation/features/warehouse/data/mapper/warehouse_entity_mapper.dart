import 'package:injectable/injectable.dart';
import 'package:pharmago/data/mapper/base/data_mapper.dart';
import 'package:pharmago/presentation/base/date.dart';
import 'package:pharmago/presentation/features/address/data/mapper/address_mapper.dart';
import 'package:pharmago/presentation/features/product/domain/entities/basic_entity.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/variant_warehouse_model.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/batch_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/ticket_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/variant_warehouse_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/warehouse_entity.dart';
import 'package:pharmago/shared/constants/pref_key.dart';

import '../models/warehouse_model.dart';

@injectable
class WarehouseEntityMapper
    extends BaseDataMapper<WarehouseModel, WarehouseEntity> {
  WarehouseEntityMapper(this._addressMapper);

  final AddressMapper _addressMapper;

  @override
  WarehouseEntity mapToEntity(WarehouseModel? data) => WarehouseEntity(
        id: data?.id ?? 0,
        title: data?.title ?? '',
        code: data?.code ?? '',
        isActive: data?.isActive ?? true,
        statusCheck: data?.statusCheck ?? false,
        settings: data?.settings ?? {},
        regionPickup: data?.regionPickup ?? [],
        warehouseStaff: data?.warehouseStaff ?? [],
        company: data?.company,
        system: data?.system,
        warehouseChildData: data?.warehouseChildData ?? [],
        connectSystem: data?.connectSystem,
        typeWarehouse: data?.typeWarehouse,
        typeWarehouseData: data?.typeWarehouseData,
        accountPeriod: data?.accountPeriod,
        parent: data?.parent,
        userManage: data?.userManage,
        userCreated: data?.userCreated,
        userUpdated: data?.userUpdated,
        createdAt: data?.createdAt,
        updatedAt: data?.updatedAt,
        userCreatedData: data?.userCreatedData,
        userUpdatedData: data?.userUpdatedData,
        userManageData: data?.userManageData,
        address: data?.addressData != null
            ? _addressMapper.mapToEntity(data!.addressData)
            : null,
        warehouseStaffData: data?.warehouseStaffData ?? [],
      );

  VariantWarehouseEntity mapToEntity2(VariantWarehouseModel? data) =>
      VariantWarehouseEntity(
        id: data?.id ?? 0,
        code: data?.code ?? '',
        name: data?.name ?? '',
        image: data?.media ?? PrefKeys.imgProductDefault,
        amount: data?.amount ?? 0,
        priceImport: data?.priceImport ?? 0,
      );

  TicketEntity? mapTicketEntity(dynamic data) {
    var tiket = data.data['details'];
    if (tiket == null) return null;
    List<int> variantIds = [];
    Map<int, VariantWarehouseEntity> variants = {};
    if (tiket?['consignments'] != null) {
      for (final item in tiket?['consignments']) {
        var variantId = item['variant']['id'];
        var variant = VariantWarehouseEntity(
          id: variantId,
          code: item['variant']['code'],
          name: item['variant']['name'],
          image: item['variant']['media'] ?? '',
          amount: item['inventory'],
          // priceImport: int.parse(item['variant']['register_number']),
          batchs: [],
        );
        if (variantIds.contains(variantId)) {
          variant = variants[variantId]!;
        } else {
          variantIds.add(variantId);
        }

        List<BatchEntity> batchs = [];
        batchs.addAll(variant.batchs);
        var batch = BatchEntity(
            id: item['id'],
            code: item['code'],
            expiry: Date.parseDate(item['expired_at']),
            productionDate: Date.parseDate(item['produced_at']),
            amount: item['quantity'].toString(),
            variantId: item['variant']['id']);
        batchs.add(batch);
        variant = variant.copyWith(batchs: batchs);
        variants[variantId] = variant;
      }
    }
    return TicketEntity(
        id: tiket?['id'] ?? 0,
        code: tiket?['code'] ?? '',
        note: tiket?['note'] ?? '',
        status: BasicEntity(
            id: tiket?['status']['id'],
            code: tiket?['status']['code'],
            name: tiket?['status']['name']),
        warehouse: BasicEntity(
            id: tiket?['warehouse']['id'],
            code: tiket?['warehouse']['code'],
            name: tiket?['warehouse']['name']),
        variants: variants.values.toList());
  }
}

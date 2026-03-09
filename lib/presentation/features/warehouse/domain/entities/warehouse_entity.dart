import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';
import 'package:pharmago/shared/constants/pref_key.dart';

import '../../../../features_v2/models/employee/user_data_model.dart';

part 'warehouse_entity.freezed.dart';

@freezed
class WarehouseEntity with _$WarehouseEntity {
  const WarehouseEntity._();

  const factory WarehouseEntity({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String code,
    @Default(true) bool isActive,
    @Default(false) bool statusCheck,
    @Default({}) Map<String, dynamic> settings,
    @Default([]) List<int> regionPickup,
    @Default([]) List<int> warehouseStaff,
    int? company,
    int? system,
    @Default([]) List<Map<String, dynamic>> warehouseChildData,
    int? connectSystem,
    int? typeWarehouse,
    Map<String, dynamic>? typeWarehouseData,
    int? accountPeriod,
    int? parent,
    int? userManage,
    int? userCreated,
    int? userUpdated,
    String? createdAt,
    String? updatedAt,
    UserDataModel? userCreatedData,
    UserDataModel? userUpdatedData,
    UserDataModel? userManageData,
    AddressEntity? address,
    @Default([]) List<UserDataModel> warehouseStaffData,
  }) = _WarehouseEntity;
}

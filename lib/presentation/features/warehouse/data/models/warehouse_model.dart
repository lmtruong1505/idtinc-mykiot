import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features_v2/models/employee/user_data_model.dart';

import '../../../address/data/models/address_model.dart';

part 'warehouse_model.freezed.dart';
part 'warehouse_model.g.dart';

@freezed
class WarehouseModel with _$WarehouseModel {
  const WarehouseModel._();

  const factory WarehouseModel({
    @Default(0) int id,
    @Default('') String title,
    @Default('') String code,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'status_check') @Default(false) bool statusCheck,
    @Default({}) Map<String, dynamic> settings,
    int? address,
    @JsonKey(name: 'region_pickup') @Default([]) List<int> regionPickup,
    @JsonKey(name: 'warehouse_staff') @Default([]) List<int> warehouseStaff,
    int? company,
    int? system,
    @JsonKey(name: 'warehouse_child_data') @Default([]) List<Map<String, dynamic>> warehouseChildData,
    @JsonKey(name: 'connect_system') int? connectSystem,
    @JsonKey(name: 'type_warehouse') int? typeWarehouse,
    @JsonKey(name: 'type_warehouse_data') Map<String, dynamic>? typeWarehouseData,
    @JsonKey(name: 'account_period') int? accountPeriod,
    int? parent,
    @JsonKey(name: 'user_manage') int? userManage,
    @JsonKey(name: 'user_created') int? userCreated,
    @JsonKey(name: 'user_updated') int? userUpdated,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'user_created_data') UserDataModel? userCreatedData,
    @JsonKey(name: 'user_updated_data') UserDataModel? userUpdatedData,
    @JsonKey(name: 'user_manage_data') UserDataModel? userManageData,
    @JsonKey(name: 'address_data') AddressModel? addressData,
    @JsonKey(name: 'warehouse_staff_data') @Default([]) List<UserDataModel> warehouseStaffData,
  }) = _WarehouseModel;

  factory WarehouseModel.fromJson(Map<String, dynamic> json) =>
      _$WarehouseModelFromJson(json);
}

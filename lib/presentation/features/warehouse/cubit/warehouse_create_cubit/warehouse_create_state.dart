import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/warehouse_payload_entity.dart';

import '../../../../features_v2/models/employee/user_data_model.dart';
import '../../../address/domain/entities/address_entity.dart';
import '../../screens/warehouse_create_page.dart';

part 'warehouse_create_state.freezed.dart';

@freezed
class WarehouseCreateState with _$WarehouseCreateState {
  const factory WarehouseCreateState({
    @Default(AddressEntity()) AddressEntity addressEntity,
    @Default(WarehousePayloadEntity()) WarehousePayloadEntity payload,
    @Default([]) List<UserDataModel> listUser,
    @Default([]) List<UserDataModel> listEmployee,
    UserDataModel? manager,
    TypeWarehouse? typeWarehouse,
  }) = _WarehouseCreateState;
}

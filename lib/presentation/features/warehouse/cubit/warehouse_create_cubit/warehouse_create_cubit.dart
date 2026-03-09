import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/warehouse_create_use_case.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';
import 'package:pharmago/shared/ext/ext_date_time.dart';

import '../../../../../data/local/get_data.dart';
import '../../../../features_v2/models/employee/user_data_model.dart';
import '../../../address/domain/entities/address_item_entity.dart';
import '../../domain/usecase/list_user_warehouse_use_case.dart';
import '../../domain/usecase/warehouse_update_use_case.dart';
import '../../screens/warehouse_create_page.dart';
import 'warehouse_create_state.dart';

@injectable
class WarehouseCreateCubit extends Cubit<WarehouseCreateState> {
  WarehouseCreateCubit(
    this._warehouseCreateUsecase,
    this._listUseWareHouseUseCase,
    this._warehouseUpdateUsecase,
  ) : super(const WarehouseCreateState()) {
    _getListUserWareHouse();
    final now = DateTime.now().fomatCustom(fomat: 'ddMy');
    infoChange(
      code: 'KH-$now',
      typeWarehouse: state.typeWarehouse ?? TypeWarehouse.kgd,
    );
  }

  final ListUseWareHouseUseCase _listUseWareHouseUseCase;
  final WarehouseCreateUsecase _warehouseCreateUsecase;
  final WarehouseUpdateUseCase _warehouseUpdateUsecase;

  void _getListUserWareHouse() async {
    final res = await _listUseWareHouseUseCase.getListUserWarehouse(
      getCompanyId ?? 0,
    );
    UserDataModel? manager;
    if (state.manager != null) {
      manager = res.firstWhere((e) => e.id == state.manager?.id); 
    }
    emit(state.copyWith(listUser: res, manager: manager));
  }

  void updateAddress({
    String? detail,
    AddressItemEntity? district,
    AddressItemEntity? province,
    AddressItemEntity? ward,
  }) {
    emit(
      state.copyWith(
        addressEntity: state.addressEntity.copyWith(
          detail: detail ?? state.addressEntity.detail,
          district: district ?? state.addressEntity.district,
          province: province ?? state.addressEntity.province,
          ward: ward ?? state.addressEntity.ward,
        ),
      ),
    );
  }

  void infoChange({
    String? code,
    String? name,
    UserDataModel? manager,
    List<UserDataModel>? listEmployee,
    TypeWarehouse? typeWarehouse,
  }) {
    emit(
      state.copyWith(
        payload: state.payload.copyWith(
          name: name ?? state.payload.name,
          code: code ?? state.payload.code,
        ),
        manager: manager ?? state.manager,
        listEmployee: listEmployee ?? state.listEmployee,
        typeWarehouse: typeWarehouse ?? state.typeWarehouse,
      ),
    );
  }

  Future<BaseResponseModel<int>> createWarehouse() async {
    final address = state.addressEntity;
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final input = WarehouseCreateInput(
      payload: state.payload.copyWith(
        addressEntity: address,
        company: company,
        warehouseStaff: state.listEmployee.map((e) => e.id!).toList(),
        warehouseManger: state.manager?.id,
        typeWarehouse: state.typeWarehouse?.codePayload,
      ),
    );
    final res = await _warehouseCreateUsecase.execute(input);
    return res.response;
  }

  Future<BaseResponseModel<int>> updateWarehouse(int id) async {
    final address = state.addressEntity;
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final input = WarehouseUpdateInput(
      id: id,
      payload: state.payload.copyWith(
        addressEntity: address,
        company: company,
        warehouseStaff: state.listEmployee.map((e) => e.id!).toList(),
        warehouseManger: state.manager?.id,
        typeWarehouse: state.typeWarehouse?.codePayload,
      ),
    );
    final res = await _warehouseUpdateUsecase.execute(input);
    return res.response;
  }
}

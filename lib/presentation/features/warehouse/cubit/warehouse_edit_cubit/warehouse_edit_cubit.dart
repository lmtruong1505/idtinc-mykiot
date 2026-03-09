import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/constants/storage/shared_preference.dart';

import '../../../address/domain/entities/address_item_entity.dart';
import '../../domain/entities/warehouse_payload_entity.dart';
import '../../domain/usecase/warehouse_detail_use_case.dart';
import '../../domain/usecase/warehouse_update_use_case.dart';
import 'warehouse_edit_state.dart';

@injectable
class WarehouseEditCubit extends Cubit<WarehouseEditState> {
  WarehouseEditCubit(
    this._warehouseDetailUseCase,
    this._warehouseUpdateUseCase,
  ) : super(const WarehouseEditState());

  final WarehouseDetailUseCase _warehouseDetailUseCase;
  final WarehouseUpdateUseCase _warehouseUpdateUseCase;

  void infoChange({
    String? code,
    String? name,
  }) {
    emit(
      state.copyWith(
        warehouseEntity: state.warehouseEntity?.copyWith(
          title: name ?? state.warehouseEntity?.title ?? '',
          code: code ?? state.warehouseEntity?.code ?? '',
        ),
      ),
    );
  }

  void updateAddress({
    String? detail,
    AddressItemEntity? district,
    AddressItemEntity? province,
    AddressItemEntity? ward,
  }) {
    emit(
      state.copyWith(
        warehouseEntity: state.warehouseEntity?.copyWith(
          address: state.warehouseEntity?.address?.copyWith(
            detail: detail ?? state.warehouseEntity?.address?.detail,
            district: district ?? state.warehouseEntity?.address?.district,
            province: province ?? state.warehouseEntity?.address?.province,
            ward: ward ?? state.warehouseEntity?.address?.ward,
          ),
        ),
      ),
    );
  }

  Future<void> getDetail(int? id) async {
    if (id == null) {
      return;
    }
    emit(state.copyWith(isLoading: true));
    final input = WarehouseDetailInput(id: id);
    final res = await _warehouseDetailUseCase.execute(input);
    emit(
      state.copyWith(
        warehouseEntity: res.response.data,
        isLoading: false,
      ),
    );
  }

  Future<BaseResponseModel?> update() async {
    if (state.warehouseEntity?.id == null) {
      return null;
    }
    final company =
        AppSharedPreference.instance.getValue(PrefKeys.company) as int?;
    final input = WarehouseUpdateInput(
      id: state.warehouseEntity!.id,
      payload: WarehousePayloadEntity(
        addressEntity: state.warehouseEntity?.address,
        code: state.warehouseEntity?.code,
        name: state.warehouseEntity?.title,
        company: company,
      ),
    );
    final res = await _warehouseUpdateUseCase.execute(input);
    if (res.response.code == 200) {
      getDetail(state.warehouseEntity?.id);
    }
    return res.response;
  }
}

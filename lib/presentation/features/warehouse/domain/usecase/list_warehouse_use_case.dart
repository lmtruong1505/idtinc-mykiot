import 'package:injectable/injectable.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/company/cubit/auth_ws_manager_cubit/auth_ws_manager_cubit.dart';
import 'package:pharmago/presentation/features/company/cubit/auth_ws_manager_cubit/auth_ws_manager_state.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/warehouse_model.dart';
import 'package:pharmago/presentation/features/warehouse/domain/repositories/warehouse_repository.dart';

@injectable
class GetListWareHouseUseCase {
  final WarehouseRepository _repository;
  GetListWareHouseUseCase(
    this._repository,
  );

  Future<List<WarehouseModel>> getListV2(ListWarehouseInput input) async {
    final res = await _repository.getListWareHouse(input);
    return res.data == null ? List.empty() : res.data!;
  }
}

class ListWarehouseInput extends BaseInput {
  final int? workspace;
  final int? expired;
  final String? typeCode = getIt.get<AuthWsManagerCubit>().state.typeCodeWarehouse;

  ListWarehouseInput({
    this.workspace,
    this.expired,
  });
}

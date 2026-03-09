import 'package:injectable/injectable.dart';
import 'package:pharmago/presentation/features/warehouse/domain/repositories/warehouse_repository.dart';
import 'package:pharmago/presentation/features_v2/models/employee/user_data_model.dart';

@injectable
class ListUseWareHouseUseCase {
  final WarehouseRepository _repository;
  ListUseWareHouseUseCase(
    this._repository,
  );

  Future<List<UserDataModel>> getListUserWarehouse(int workspace) async {
    final res = await _repository.getListUserWarehouse(workspace);
    return res.data == null ? List.empty() : res.data!;
  }
}

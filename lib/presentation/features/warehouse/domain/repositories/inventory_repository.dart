import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/presentation/features/warehouse/data/models/inventory_model.dart';
import 'package:pharmago/presentation/features/warehouse/domain/usecase/inventory_use_case.dart';

abstract class InventoryRepository {
  Future<BaseResponseModel<List<InventoryModel>>> getList(InventoryInput input);
}

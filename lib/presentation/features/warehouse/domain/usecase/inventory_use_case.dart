import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/warehouse/data/mapper/inventory_entity_mapper.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/inventory_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/repositories/inventory_repository.dart';

@injectable
class InventoryUseCase
    extends BaseFutureUseCase<InventoryInput, InventoryOutput> {
  InventoryUseCase(this._repository, this._mapper);
  final InventoryRepository _repository;
  final InventoryEntityMapper _mapper;
  @override
  Future<InventoryOutput> buildUseCase(InventoryInput input) async {
    return InventoryOutput(response: BaseResponseModel());
  }

  Future<List<InventoryEntity>> getList(InventoryInput input) async {
    final res = await _repository.getList(input);
    return res.data == null
        ? []
        : res.data!.map((data) => _mapper.mapToEntity(data)).toList();
  }
}

class InventoryInput extends BaseInput {
  final String search;
  final int limit;
  final int page;
  final int company;
  final int warehouseId;

  InventoryInput(
      this.warehouseId, this.search, this.limit, this.page, this.company);
}

class InventoryOutput extends BaseOutput {
  final BaseResponseModel<List<InventoryEntity>> response;
  InventoryOutput({required this.response});
}

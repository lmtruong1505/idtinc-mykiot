import 'package:injectable/injectable.dart';
import 'package:pharmago/data/models/base/response.dart';
import 'package:pharmago/domain/usecase/base/future_use_case.dart';
import 'package:pharmago/domain/usecase/base/io/input.dart';
import 'package:pharmago/domain/usecase/base/io/output.dart';
import 'package:pharmago/presentation/features/warehouse/data/mapper/warehouse_entity_mapper.dart';
import 'package:pharmago/presentation/features/warehouse/domain/entities/warehouse_entity.dart';
import 'package:pharmago/presentation/features/warehouse/domain/repositories/warehouse_repository.dart';

@injectable
class WarehouseDetailUseCase
    extends BaseFutureUseCase<WarehouseDetailInput, WarehouseDetailOutput> {
  WarehouseDetailUseCase(
    this._warehouseRepository,
    this._warehouseEntityMapper,
  );

  final WarehouseRepository _warehouseRepository;
  final WarehouseEntityMapper _warehouseEntityMapper;

  @override
  Future<WarehouseDetailOutput> buildUseCase(WarehouseDetailInput input) async {
    final res = await _warehouseRepository.detail(id: input.id);
    final dataEnity = _warehouseEntityMapper.mapToEntity(res.data);
    final output = WarehouseDetailOutput(
      response: BaseResponseModel(
        code: res.code,
        message: res.message,
        data: dataEnity,
      ),
    );
    return output;
  }
}

class WarehouseDetailInput extends BaseInput {
  final int id;
  WarehouseDetailInput({required this.id});
}

class WarehouseDetailOutput extends BaseOutput {
  final BaseResponseModel<WarehouseEntity> response;
  WarehouseDetailOutput({required this.response});
}
